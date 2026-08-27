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

/** MSG91 wants the number without the leading plus. */
export function toMsg91Format(e164: string): string {
  return e164.replace(/^\+/, '');
}
