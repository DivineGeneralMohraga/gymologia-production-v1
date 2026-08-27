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

    if (process.env.NODE_ENV !== 'production') {
      this.$on('query', (e) => {
        if (e.duration > 200) {
          this.logger.debug(`slow query ${e.duration}ms: ${e.query}`);
        }
      });
    }
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
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
