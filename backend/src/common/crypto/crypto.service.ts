import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  createCipheriv,
  createDecipheriv,
  createHash,
  randomBytes,
  randomInt,
  scrypt,
  timingSafeEqual,
} from 'node:crypto';
import { promisify } from 'node:util';

const scryptAsync = promisify(scrypt) as (
  password: string | Buffer,
  salt: string | Buffer,
  keylen: number,
) => Promise<Buffer>;

const ALGORITHM = 'aes-256-gcm';
const IV_BYTES = 12; // 96-bit nonce, the GCM standard
const TAG_BYTES = 16;
const SCRYPT_KEYLEN = 64;

/**
 * Central cryptography. Two jobs:
 *
 *  1. Reversible field encryption (AES-256-GCM) for values we must be able
 *     to read back — Aadhaar, PAN, GSTIN, UPI handles. Authenticated, so
 *     tampering with a stored ciphertext is detected rather than silently
 *     decrypting to garbage.
 *
 *  2. One-way hashing (scrypt, peppered) for OTP codes and refresh tokens,
 *     which we only ever need to compare, never recover.
 *
 * No native dependencies — everything here is node:crypto, so the build
 * stays portable across Windows dev machines and Linux containers.
 */
@Injectable()
export class CryptoService {
  private readonly key: Buffer;
  private readonly pepper: string;

  constructor(private readonly config: ConfigService) {
    const hexKey = this.config.getOrThrow<string>('crypto.encryptionKey');
    this.key = Buffer.from(hexKey, 'hex');
    if (this.key.length !== 32) {
      throw new Error('ENCRYPTION_KEY must decode to exactly 32 bytes');
    }
    this.pepper = this.config.getOrThrow<string>('crypto.otpPepper');
  }

  // ── Reversible field encryption ────────────────────────────────────

  /**
   * Returns `v1.<iv>.<tag>.<ciphertext>`, all base64url. The version tag
   * is there so a future key rotation can identify old rows.
   */
  encrypt(plaintext: string): string {
    const iv = randomBytes(IV_BYTES);
    const cipher = createCipheriv(ALGORITHM, this.key, iv);
    const ciphertext = Buffer.concat([
      cipher.update(plaintext, 'utf8'),
      cipher.final(),
    ]);
    const tag = cipher.getAuthTag();
    return [
      'v1',
      iv.toString('base64url'),
      tag.toString('base64url'),
      ciphertext.toString('base64url'),
    ].join('.');
  }

  decrypt(payload: string): string {
    const [version, ivB64, tagB64, dataB64] = payload.split('.');
    if (version !== 'v1' || !ivB64 || !tagB64 || !dataB64) {
      throw new Error('Malformed ciphertext payload');
    }
    const iv = Buffer.from(ivB64, 'base64url');
    const tag = Buffer.from(tagB64, 'base64url');
    if (iv.length !== IV_BYTES || tag.length !== TAG_BYTES) {
      throw new Error('Malformed ciphertext payload');
    }
    const decipher = createDecipheriv(ALGORITHM, this.key, iv);
    decipher.setAuthTag(tag);
    return Buffer.concat([
      decipher.update(Buffer.from(dataB64, 'base64url')),
      decipher.final(),
    ]).toString('utf8');
  }

  // ── One-way hashing ────────────────────────────────────────────────

  /** Fresh per-row salt for scrypt hashes. */
  newSalt(): string {
    return randomBytes(16).toString('hex');
  }

  /**
   * Peppered scrypt. The pepper lives in the environment, not the database,
   * so a dump of `otp_challenges` on its own is not enough to replay codes.
   */
  async hashSecret(secret: string, salt: string): Promise<string> {
    const derived = await scryptAsync(
      `${secret}${this.pepper}`,
      salt,
      SCRYPT_KEYLEN,
    );
    return derived.toString('hex');
  }

  /** Constant-time verification — never a plain `===` on secrets. */
  async verifySecret(
    secret: string,
    salt: string,
    expectedHash: string,
  ): Promise<boolean> {
    const actual = Buffer.from(await this.hashSecret(secret, salt), 'hex');
    let expected: Buffer;
    try {
      expected = Buffer.from(expectedHash, 'hex');
    } catch {
      return false;
    }
    if (actual.length !== expected.length) return false;
    return timingSafeEqual(actual, expected);
  }

  /**
   * Fast deterministic hash for high-volume lookups (refresh tokens, KYC
   * join tokens) where the input is already 256 bits of entropy and does
   * not need the brute-force resistance of scrypt.
   */
  hashToken(token: string): string {
    return createHash('sha256')
      .update(`${token}${this.pepper}`)
      .digest('hex');
  }

  constantTimeEquals(a: string, b: string): boolean {
    const bufA = Buffer.from(a, 'utf8');
    const bufB = Buffer.from(b, 'utf8');
    if (bufA.length !== bufB.length) return false;
    return timingSafeEqual(bufA, bufB);
  }

  // ── Generators ─────────────────────────────────────────────────────

  /** Cryptographically random numeric OTP, zero-padded. */
  generateOtp(length: number): string {
    const max = 10 ** length;
    return randomInt(0, max).toString().padStart(length, '0');
  }

  /** URL-safe opaque token for refresh tokens and one-time links. */
  generateToken(bytes = 32): string {
    return randomBytes(bytes).toString('base64url');
  }

  /**
   * Human-friendly referral code. Excludes 0/O and 1/I/L so codes read
   * aloud over a phone do not come back wrong.
   */
  generateReferralCode(length = 8): string {
    const alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
    let out = '';
    for (let i = 0; i < length; i += 1) {
      out += alphabet[randomInt(0, alphabet.length)];
    }
    return out;
  }

  // ── Masking helpers ────────────────────────────────────────────────

  last4(value: string): string {
    return value.slice(-4);
  }

  /** `sarthak@okhdfcbank` → `sa*****@okhdfcbank` */
  maskUpi(vpa: string): string {
    const [handle, bank] = vpa.split('@');
    if (!handle || !bank) return '****';
    const head = handle.slice(0, 2);
    return `${head}${'*'.repeat(Math.max(handle.length - 2, 1))}@${bank}`;
  }

  /** `+918178848820` → `+91******8820` */
  maskPhone(phone: string): string {
    if (phone.length < 6) return '****';
    return `${phone.slice(0, 3)}${'*'.repeat(phone.length - 7)}${phone.slice(-4)}`;
  }
}
