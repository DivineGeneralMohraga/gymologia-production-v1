/**
 * Boot-time environment check.
 *
 * A backend that handles OTP, KYC documents and outbound money must not
 * start in a half-configured state. Anything missing or obviously wrong
 * throws here, before Nest wires a single module.
 */

interface Rule {
  key: string;
  /** Required in every environment. */
  required?: boolean;
  /** Required only when NODE_ENV=production. */
  requiredInProd?: boolean;
  /** Extra shape check; return an error string, or null when fine. */
  check?: (value: string) => string | null;
}

const hexOfLength =
  (bytes: number) =>
  (value: string): string | null =>
    new RegExp(`^[0-9a-fA-F]{${bytes * 2}}$`).test(value)
      ? null
      : `must be ${bytes * 2} hex characters (${bytes} bytes)`;

const minLength =
  (n: number) =>
  (value: string): string | null =>
    value.length >= n ? null : `must be at least ${n} characters`;

const isPostgresUrl = (value: string): string | null =>
  /^postgres(ql)?:\/\//.test(value) ? null : 'must be a postgres:// URL';

const RULES: Rule[] = [
  { key: 'DATABASE_URL', required: true, check: isPostgresUrl },
  { key: 'DIRECT_URL', required: true, check: isPostgresUrl },

  { key: 'JWT_ACCESS_SECRET', required: true, check: minLength(32) },
  { key: 'JWT_REFRESH_SECRET', required: true, check: minLength(32) },
  { key: 'ENCRYPTION_KEY', required: true, check: hexOfLength(32) },
  { key: 'OTP_PEPPER', required: true, check: minLength(32) },

  { key: 'MSG91_AUTH_KEY', required: true },
  { key: 'MSG91_WIDGET_ID', required: true },

  { key: 'CASHFREE_CLIENT_ID', required: true },
  { key: 'CASHFREE_CLIENT_SECRET', required: true },
  // Without this, webhook signatures cannot be verified and anyone who
  // guesses the URL can mark a subscription paid.
  { key: 'CASHFREE_WEBHOOK_SECRET', requiredInProd: true },
  { key: 'CASHFREE_PAYOUT_CLIENT_ID', requiredInProd: true },
  { key: 'CASHFREE_PAYOUT_CLIENT_SECRET', requiredInProd: true },

  { key: 'SUPABASE_URL', requiredInProd: true },
  { key: 'SUPABASE_SERVICE_ROLE_KEY', requiredInProd: true },
];

/**
 * How strictly to police the configuration.
 *
 * NODE_ENV=production alone is not enough to decide: a staging box runs
 * production builds against sandbox payment credentials on purpose. So the
 * strict rules key off APP_STAGE, which defaults to `production` whenever
 * NODE_ENV says production — fail closed. A test deployment opts out
 * explicitly with APP_STAGE=staging, and is told so on every boot.
 */
export type AppStage = 'staging' | 'production';

export function resolveStage(raw: Record<string, unknown>): AppStage {
  if (raw.APP_STAGE === 'staging') return 'staging';
  if (raw.APP_STAGE === 'production') return 'production';
  return raw.NODE_ENV === 'production' ? 'production' : 'staging';
}

export function validateEnv(
  raw: Record<string, unknown>,
): Record<string, unknown> {
  const isProd = resolveStage(raw) === 'production';
  const problems: string[] = [];

  for (const rule of RULES) {
    const value = raw[rule.key];
    const missing =
      value === undefined || value === null || String(value).trim() === '';

    if (missing) {
      if (rule.required || (rule.requiredInProd && isProd)) {
        problems.push(`${rule.key} is required${isProd ? '' : ''}`);
      }
      continue;
    }

    if (rule.check) {
      const problem = rule.check(String(value));
      if (problem) problems.push(`${rule.key} ${problem}`);
    }
  }

  // Refuse the two mistakes that hurt most in production.
  if (isProd) {
    if (raw.CASHFREE_ENV !== 'production') {
      problems.push(
        'CASHFREE_ENV must be "production" at APP_STAGE=production. ' +
          'For a test deployment set APP_STAGE=staging instead.',
      );
    }
    const dbUrl = String(raw.DATABASE_URL ?? '');
    if (dbUrl.includes('localhost') || dbUrl.includes('127.0.0.1')) {
      problems.push('DATABASE_URL points at localhost in production');
    }
  }

  if (problems.length > 0) {
    throw new Error(
      `Invalid environment configuration:\n  - ${problems.join('\n  - ')}\n\n` +
        `Copy backend/.env.example to backend/.env and fill in the values.`,
    );
  }

  return raw;
}
