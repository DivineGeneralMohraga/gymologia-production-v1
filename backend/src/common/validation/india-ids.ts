import { registerDecorator, ValidationOptions } from 'class-validator';

/**
 * Format checks for the three identity numbers gym verification collects.
 *
 * None of these prove a number is real -- only the issuing authority can do
 * that, and Cashfree's Verification Suite is what asks them. What they do
 * is catch a typo before it becomes a rejected verification, an angry
 * owner, and a support ticket. A twelve-digit Aadhaar with two digits
 * transposed passes a length check and fails at the registry days later;
 * the checksum below catches it while the keyboard is still open.
 */

/** Aadhaar's check digit uses the Verhoeff scheme. */
const D = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
  [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
  [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
  [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
  [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
  [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
  [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
  [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
  [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
];

const P = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
  [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
  [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
  [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
  [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
  [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
  [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
];

export function isAadhaar(value: unknown): boolean {
  if (typeof value !== 'string') return false;
  const digits = value.replace(/[\s-]/g, '');
  if (!/^\d{12}$/.test(digits)) return false;

  // A real Aadhaar never starts 0 or 1: the range is reserved.
  if (digits[0] === '0' || digits[0] === '1') return false;

  let c = 0;
  const reversed = digits.split('').reverse().map(Number);
  for (let i = 0; i < reversed.length; i += 1) {
    c = D[c][P[i % 8][reversed[i]]];
  }
  return c === 0;
}

/** Five letters, four digits, one letter. The fourth letter is the holder type. */
export function isPan(value: unknown): boolean {
  return typeof value === 'string' && /^[A-Z]{5}\d{4}[A-Z]$/.test(value.trim().toUpperCase());
}

/**
 * GSTIN: two state digits, the holder's PAN, an entity code, a literal Z,
 * and a check character. The embedded PAN is the useful part -- it has to
 * agree with the PAN submitted alongside it, which the service checks.
 */
export function isGstin(value: unknown): boolean {
  return (
    typeof value === 'string' &&
    /^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$/.test(value.trim().toUpperCase())
  );
}

/** The PAN embedded in a GSTIN, for cross-checking against the PAN given. */
export function panInGstin(gstin: string): string {
  return gstin.trim().toUpperCase().slice(2, 12);
}

function build(name: string, check: (v: unknown) => boolean, message: string) {
  return (options?: ValidationOptions) =>
    function (object: object, propertyName: string): void {
      registerDecorator({
        name,
        target: object.constructor,
        propertyName,
        options,
        validator: {
          validate: (value: unknown) => check(value),
          defaultMessage: () => message,
        },
      });
    };
}

export const IsAadhaar = build(
  'isAadhaar',
  isAadhaar,
  'aadhaar must be a valid 12-digit Aadhaar number',
);
export const IsPan = build(
  'isPan',
  isPan,
  'pan must look like ABCDE1234F',
);
export const IsGstin = build(
  'isGstin',
  isGstin,
  'gstin must be a valid 15-character GSTIN',
);
