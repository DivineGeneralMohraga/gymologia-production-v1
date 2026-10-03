import { BadRequestException } from '@nestjs/common';

/**
 * Phone numbers are the primary key of a human across all four apps, so
 * they must normalise to exactly one canonical form. Everything is stored
 * and compared as E.164 (`+918178848820`).
 *
 * India is the default country because that is the launch market; the
 * parser still accepts an explicit `+<cc>` for anyone else, which matters
 * for the referral app ("anyone from world").
 */

const DEFAULT_COUNTRY_CODE = '91';

/** Digits only, no plus. */
const stripToDigits = (input: string): string => input.replace(/\D+/g, '');

export function normalizePhone(raw: string): string {
  if (typeof raw !== 'string') {
    throw new BadRequestException('Phone number is required');
  }

  const trimmed = raw.trim();
  const hadPlus = trimmed.startsWith('+');
  let digits = stripToDigits(trimmed);

  if (digits.length === 0) {
    throw new BadRequestException('Phone number is required');
  }

  if (!hadPlus) {
    // Common Indian input shapes: 8178848820, 08178848820, 918178848820.
    if (digits.length === 10) {
      digits = `${DEFAULT_COUNTRY_CODE}${digits}`;
    } else if (digits.length === 11 && digits.startsWith('0')) {
      digits = `${DEFAULT_COUNTRY_CODE}${digits.slice(1)}`;
    } else if (digits.length === 12 && digits.startsWith(DEFAULT_COUNTRY_CODE)) {
      // already country-coded
    } else if (digits.length < 8 || digits.length > 15) {
      throw new BadRequestException('Enter a valid phone number');
    }
  }

  // E.164 allows at most 15 digits.
  if (digits.length < 8 || digits.length > 15) {
    throw new BadRequestException('Enter a valid phone number');
  }

  const e164 = `+${digits}`;

  if (e164.startsWith(`+${DEFAULT_COUNTRY_CODE}`)) {
    const subscriber = digits.slice(DEFAULT_COUNTRY_CODE.length);
    // Indian mobile numbers are 10 digits starting 6-9.
    if (!/^[6-9]\d{9}$/.test(subscriber)) {
      throw new BadRequestException('Enter a valid Indian mobile number');
    }
  }

  return e164;
}

export function isValidPhone(raw: string): boolean {
  try {
    normalizePhone(raw);
    return true;
  } catch {
    return false;
  }
}

/**
 * Placeholder numbers people (and test robots) type instead of their own.
 *
 * Not a validity check -- several of these are dialable and belong to
 * somebody. The reason to refuse them is that thousands of apps send them
 * OTPs every day, so MSG91 treats a request for one as abuse. On
 * 2026-10-03 Play's pre-launch robots typed the login hint "98765 43210"
 * a few times and MSG91 blocked the server's IP: nobody could sign in
 * until it was unblocked by hand. Refusing them here costs a real owner
 * of 9999999999 the app; not refusing them can cost every user login.
 *
 * Indian numbers only, on the 10-digit subscriber part:
 *   - one digit repeated (9999999999)
 *   - a straight run up or down (9876543210, 1234567890 shapes, wrapping)
 *   - a few well-known others
 */
const KNOWN_DUMMY_IN = new Set([
  '9123456789',
  '9012345678',
  '9988776655',
  '9898989898',
  '9090909090',
  '9000000000',
  '9999999990',
  '9999900000',
]);

export function isDummyPhone(e164: string): boolean {
  if (!e164.startsWith(`+${DEFAULT_COUNTRY_CODE}`)) return false;
  const sub = e164.slice(1 + DEFAULT_COUNTRY_CODE.length);
  if (!/^\d{10}$/.test(sub)) return false;

  if (/^(\d)\1{9}$/.test(sub)) return true;
  if (KNOWN_DUMMY_IN.has(sub)) return true;

  const d = [...sub].map(Number);
  const steps = d.slice(1).map((v, i) => (v - d[i] + 10) % 10);
  if (steps.every((s) => s === 1) || steps.every((s) => s === 9)) return true;

  return false;
}

/** MSG91 wants the number without the leading plus. */
export function toMsg91Format(e164: string): string {
  return e164.replace(/^\+/, '');
}
