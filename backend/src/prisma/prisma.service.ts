import {
  INestApplication,
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { Prisma, PrismaClient } from '@prisma/client';

/**
 * The only door to the database.
 *
 * Every query in the application goes through Prisma Client, which sends
 * parameterized statements over the wire — user input is never spliced
 * into SQL text. `$queryRawUnsafe` and `$executeRawUnsafe` are overridden
 * below to throw, so that door cannot be re-opened by accident later.
 */
@Injectable()
export class PrismaService
  extends PrismaClient<Prisma.PrismaClientOptions, 'query' | 'warn' | 'error'>
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger(PrismaService.name);

  constructor() {
    super({
      log: [
        { emit: 'event', level: 'query' },
        { emit: 'event', level: 'warn' },
        { emit: 'event', level: 'error' },
      ],
      errorFormat: 'minimal',
    });
  }

  async onModuleInit(): Promise<void> {
    await this.$connect();
    this.logger.log('Database connected');

    this.$on('warn', (e) => this.logger.warn(e.message));
    this.$on('error', (e) => this.logger.error(e.message));

    // Every query is counted; only the slow ones are printed.
    //
    // The threshold used to be a hardcoded 200ms, and against a hosted
    // pooler on the other side of the internet that is not a slow query,
    // it is the round trip. One test run produced 1,028 "slow query" lines
    // of which 990 were between 200 and 300ms and none were over a second.
    // A label that fires on everything is not a signal, and it is exactly
    // the noise a genuinely slow query would hide in. The default is a
    // second now, and PRISMA_SLOW_QUERY_MS moves it -- setting it to 0
    // prints every statement, which is how to count queries per request
    // and find an N+1.
    const slowMs = Number(process.env.PRISMA_SLOW_QUERY_MS ?? 1000);

    this.$on('query', (e) => {
      this.queryCount += 1;
      if (process.env.NODE_ENV !== 'production' && e.duration >= slowMs) {
        this.logger.debug(`slow query ${e.duration}ms: ${e.query}`);
      }
    });
  }

  private queryCount = 0;

  /** Statements issued since boot. Cheap, and the only way to see an N+1. */
  get queriesIssued(): number {
    return this.queryCount;
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
  }

  // ── Transient connection failures ──────────────────────────────────
  //
  // The hosted pooler goes away from time to time. Four separate outages
  // landed inside test runs in one day; the failing call is usually
  // `session.findUnique`, which every authenticated request makes, so the
  // user-visible version is that nobody can sign in and everybody signed
  // in is thrown out.
  //
  // WHY THIS IS A HELPER AND NOT A BLANKET WRAPPER. The obvious move is to
  // wrap every model delegate so all queries retry. That works -- the
  // delegates can be replaced on the instance -- and it silently breaks
  // the five call sites that use the ARRAY form of `$transaction`, which
  // requires real `PrismaPromise` objects rather than the plain promises a
  // wrapper returns. `token.service.ts` creating a session is one of them.
  // A retry that breaks session creation is not an improvement.
  //
  // WHAT IT DELIBERATELY DOES NOT DO. It does not try to ride out a long
  // outage. Two of the four were seconds and two were minutes; holding an
  // HTTP request open for minutes ties up a connection and makes an outage
  // worse rather than better. This covers the sub-second transient and the
  // connection-establishment race. The multi-minute case is a Supabase-side
  // problem and is written up as one.

  /** Codes that mean the statement never reached the server. Safe to repeat. */
  private static readonly NEVER_RAN = new Set(['P1001', 'P1002', 'P2024']);

  /**
   * The connection dropped and the statement may or may not have run.
   * Repeating this is safe for a read and NOT safe for a write.
   */
  private static readonly AMBIGUOUS = new Set(['P1017']);

  private retryCount = 0;

  /** How many times a query has been retried since boot, for the health probe. */
  get transientRetries(): number {
    return this.retryCount;
  }

  /**
   * Run a database call, repeating it if the connection failed.
   *
   * `safeToRepeat` must only be true when running the operation twice is
   * harmless -- a read, or a write that sets the same value again. It is
   * false by default so that the careless call is the conservative one:
   * with it false, only failures that prove the statement never executed
   * are retried.
   */
  async withRetry<T>(
    label: string,
    fn: () => Promise<T>,
    opts: { safeToRepeat?: boolean; attempts?: number } = {},
  ): Promise<T> {
    const attempts = opts.attempts ?? 3;
    const safeToRepeat = opts.safeToRepeat ?? false;

    for (let attempt = 1; ; attempt += 1) {
      try {
        const result = await fn();
        if (attempt > 1) {
          this.logger.warn(
            `${label} succeeded on attempt ${attempt} after a transient database failure`,
          );
        }
        return result;
      } catch (error) {
        const code =
          error instanceof Prisma.PrismaClientKnownRequestError
            ? error.code
            : error instanceof Prisma.PrismaClientInitializationError
              ? (error.errorCode ?? '')
              : '';

        const retryable =
          PrismaService.NEVER_RAN.has(code) ||
          (safeToRepeat && PrismaService.AMBIGUOUS.has(code));

        if (!retryable || attempt >= attempts) throw error;

        this.retryCount += 1;

        // Jittered, so that everything queued behind an outage does not
        // come back at the pooler in lockstep the instant it recovers.
        const base = 200 * 3 ** (attempt - 1);
        const delay = Math.round(base * (0.75 + Math.random() * 0.5));
        this.logger.warn(
          `${label} hit ${code}; retrying in ${delay}ms (attempt ${attempt} of ${attempts})`,
        );
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    }
  }

  async enableShutdownHooks(app: INestApplication): Promise<void> {
    process.on('beforeExit', () => {
      void app.close();
    });
  }

  /**
   * Raw string SQL is disabled outright. If a future query genuinely needs
   * raw SQL, use the tagged-template forms (`$queryRaw` / `$executeRaw`),
   * which parameterize interpolated values instead of concatenating them.
   */
  override $queryRawUnsafe<T = unknown>(
    _query: string,
    ..._values: unknown[]
  ): Prisma.PrismaPromise<T> {
    throw new Error(
      'queryRawUnsafe is disabled. Use $queryRaw`...` tagged templates.',
    );
  }

  override $executeRawUnsafe(
    _query: string,
    ..._values: unknown[]
  ): Prisma.PrismaPromise<number> {
    throw new Error(
      'executeRawUnsafe is disabled. Use $executeRaw`...` tagged templates.',
    );
  }

  /** Wipes every table. Guarded so it can never fire outside tests. */
  async truncateAllForTests(): Promise<void> {
    if (process.env.NODE_ENV !== 'test') {
      throw new Error('truncateAllForTests is only available in NODE_ENV=test');
    }
    const tables = await this.$queryRaw<Array<{ tablename: string }>>`
      SELECT tablename FROM pg_tables
      WHERE schemaname = 'public' AND tablename NOT LIKE '_prisma%'
    `;
    for (const { tablename } of tables) {
      await this.$executeRaw(
        Prisma.sql`TRUNCATE TABLE ${Prisma.raw(`"public"."${tablename}"`)} CASCADE`,
      );
    }
  }
}
