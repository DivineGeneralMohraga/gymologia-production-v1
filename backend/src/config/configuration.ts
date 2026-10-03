/**
 * Typed view over process.env.
 *
 * Nothing in the codebase reads process.env directly — everything goes
 * through ConfigService so that a missing or malformed variable fails at
 * boot (see env.validation.ts) rather than at 3am in a payment webhook.
 */
import { resolveStage } from './env.validation';

export interface AppConfig {
  nodeEnv: 'development' | 'test' | 'production';
  port: number;
  apiPrefix: string;
  isProduction: boolean;
  /** `staging` relaxes the payment-credential rules. See env.validation.ts. */
  stage: 'staging' | 'production';
}

export interface JwtConfig {
  accessSecret: string;
  refreshSecret: string;
  accessTtl: string;
  refreshTtl: string;
}

export interface CryptoConfig {
  /** 32-byte key, hex encoded, for AES-256-GCM field encryption. */
  encryptionKey: string;
  /** Mixed into OTP hashes so a DB leak alone cannot replay codes. */
  otpPepper: string;
}

export interface Msg91Config {
  authKey: string;
  widgetId: string;
  /// The widget's `tokenAuth`. Set together with widgetId, this switches OTP
  /// delivery to MSG91's server-side widget API, which carries its own
  /// DLT-approved template. Without it we fall back to the direct /v5/otp
  /// API, which India will not deliver without a template of our own.
  widgetToken: string;
  otpTtlSeconds: number;
  otpLength: number;

  /**
   * A single phone number that signs in with a fixed code instead of a
   * real SMS, for Play Store review and for handing to testers.
   *
   * Both must be set together or neither works -- see validateEnv. It is
   * ONE number, compared for exact equality, and it changes only how the
   * code is chosen: the challenge is stored, hashed, expired, attempt
   * counted and single-used exactly like any other, so nothing in the
   * verification path is bypassed. Empty by default, so a deployment that
   * does not configure it has no test account at all.
   */
  /**
   * Every number that may use the standing code. One entry in the
   * ordinary case; several while an app is in review, because
   * checking that two members can chat needs two members.
   */
  testAccountPhones: string[];
  testAccountOtp: string;
}

export interface CashfreeConfig {
  env: 'sandbox' | 'production';
  clientId: string;
  clientSecret: string;
  webhookSecret: string;
  payoutClientId: string;
  payoutClientSecret: string;
  verifyClientId: string;
  verifyClientSecret: string;
  /** Base URLs derive from env so nothing points at prod by accident. */
  pgBaseUrl: string;
  payoutBaseUrl: string;
  verifyBaseUrl: string;
}

export interface BusinessConfig {
  planBasicPaise: number;
  planProPaise: number;
  trialDays: number;
  referralRewardPaise: number;
  referralDiscountPercent: number;
  upiVerifyDeductionPaise: number;
  maxMemberLeaveDaysDefault: number;
}

const int = (value: string | undefined, fallback: number): number => {
  const parsed = Number.parseInt(value ?? '', 10);
  return Number.isFinite(parsed) ? parsed : fallback;
};

export default () => {
  const cashfreeEnv =
    process.env.CASHFREE_ENV === 'production' ? 'production' : 'sandbox';
  const sandbox = cashfreeEnv === 'sandbox';

  return {
    app: {
      nodeEnv: (process.env.NODE_ENV ?? 'development') as AppConfig['nodeEnv'],
      port: int(process.env.PORT, 3000),
      apiPrefix: process.env.API_PREFIX ?? 'api/v1',
      isProduction: process.env.NODE_ENV === 'production',
      stage: resolveStage(process.env as Record<string, unknown>),
    } satisfies AppConfig,

    database: {
      url: process.env.DATABASE_URL as string,
      directUrl: process.env.DIRECT_URL as string,
    },

    supabase: {
      url: process.env.SUPABASE_URL ?? '',
      serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY ?? '',
      anonKey: process.env.SUPABASE_ANON_KEY ?? '',
    },

    jwt: {
      accessSecret: process.env.JWT_ACCESS_SECRET as string,
      refreshSecret: process.env.JWT_REFRESH_SECRET as string,
      accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
      refreshTtl: process.env.JWT_REFRESH_TTL ?? '30d',
    } satisfies JwtConfig,

    crypto: {
      encryptionKey: process.env.ENCRYPTION_KEY as string,
      otpPepper: process.env.OTP_PEPPER as string,
    } satisfies CryptoConfig,

    msg91: {
      authKey: process.env.MSG91_AUTH_KEY as string,
      widgetId: process.env.MSG91_WIDGET_ID as string,
      widgetToken: process.env.MSG91_WIDGET_TOKEN ?? '',
      otpTtlSeconds: int(process.env.MSG91_OTP_TTL_SECONDS, 300),
      otpLength: int(process.env.MSG91_OTP_LENGTH, 6),
      // Comma-separated, and a single value still works unchanged.
      // Blank entries are dropped rather than becoming an empty
      // string that would match a caller who sent no phone at all.
      testAccountPhones: (process.env.TEST_ACCOUNT_PHONE ?? '')
        .split(',')
        .map((p) => p.trim())
        .filter((p) => p.length > 0),
      testAccountOtp: process.env.TEST_ACCOUNT_OTP ?? '',
    } satisfies Msg91Config,

    cashfree: {
      env: cashfreeEnv,
      clientId: process.env.CASHFREE_CLIENT_ID as string,
      clientSecret: process.env.CASHFREE_CLIENT_SECRET as string,
      webhookSecret: process.env.CASHFREE_WEBHOOK_SECRET ?? '',
      payoutClientId: process.env.CASHFREE_PAYOUT_CLIENT_ID ?? '',
      payoutClientSecret: process.env.CASHFREE_PAYOUT_CLIENT_SECRET ?? '',
      verifyClientId: process.env.CASHFREE_VERIFY_CLIENT_ID ?? '',
      verifyClientSecret: process.env.CASHFREE_VERIFY_CLIENT_SECRET ?? '',
      pgBaseUrl: sandbox
        ? 'https://sandbox.cashfree.com/pg'
        : 'https://api.cashfree.com/pg',
      payoutBaseUrl: sandbox
        ? 'https://sandbox.cashfree.com/payout'
        : 'https://api.cashfree.com/payout',
      verifyBaseUrl: sandbox
        ? 'https://sandbox.cashfree.com/verification'
        : 'https://api.cashfree.com/verification',
    } satisfies CashfreeConfig,

    redis: {
      url: process.env.REDIS_URL ?? 'redis://localhost:6379',
    },

    support: {
      email: process.env.SUPPORT_EMAIL ?? 'support@gymologia.com',
      smtpHost: process.env.SMTP_HOST ?? '',
      smtpPort: int(process.env.SMTP_PORT, 587),
      smtpUser: process.env.SMTP_USER ?? '',
      smtpPass: process.env.SMTP_PASS ?? '',
    },

    business: {
      planBasicPaise: int(process.env.PLAN_BASIC_PAISE, 59900),
      planProPaise: int(process.env.PLAN_PRO_PAISE, 89900),
      trialDays: int(process.env.TRIAL_DAYS, 7),
      referralRewardPaise: int(process.env.REFERRAL_REWARD_PAISE, 5000),
      referralDiscountPercent: int(process.env.REFERRAL_DISCOUNT_PERCENT, 10),
      upiVerifyDeductionPaise: int(process.env.UPI_VERIFY_DEDUCTION_PAISE, 1000),
      maxMemberLeaveDaysDefault: int(
        process.env.MAX_MEMBER_LEAVE_DAYS_DEFAULT,
        30,
      ),
    } satisfies BusinessConfig,
  };
};
