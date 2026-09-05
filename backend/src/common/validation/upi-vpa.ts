import { registerDecorator, ValidationOptions } from 'class-validator';

/**
 * A UPI virtual payment address -- `sarthak@okhdfcbank`.
 *
 * WHY THIS IS DELIBERATELY PERMISSIVE, unlike the checks in `india-ids.ts`.
 * Aadhaar carries a Verhoeff check digit, so strictness there is free: the
 * check never rejects a real number. A VPA has no checksum at all. The only
 * thing a format rule can do is catch a shape that could not be an address;
 * it cannot tell `sarthak@okhdfcbank` from `sarthaq@okhdfcbank`, and the
 * second one is somebody else's account.
 *
 * That makes the cost of the two mistakes wildly asymmetric. Being too
 * loose lets a typo through, and the ₹10 name-verification drop that runs
 * before the first payout is what catches it -- that penny drop exists
 * precisely because format checking cannot do this job. Being too strict
 * rejects a real referrer's real address because we guessed at NPCI's
 * handle registry, and the failure is that they cannot be paid. So the
 * handle after the @ is allowed letters and digits rather than pinned to
 * the list of PSPs that happen to exist today.
 *
 * Case is not significant in a VPA, so values are lowercased before they
 * are stored. Otherwise `Sarthak@OKHDFCBANK` and `sarthak@okhdfcbank` are
 * two different rows for one address, and the masked handle shown back to
 * the user changes depending on how they typed it.
 */

/** The identifier part allows dots, hyphens and underscores; the PSP does not. */
const VPA = /^[a-z0-9](?:[a-z0-9._-]{0,48}[a-z0-9])?@[a-z0-9]{2,64}$/;

export function normaliseVpa(value: string): string {
  return value.trim().toLowerCase();
}

export function isUpiVpa(value: unknown): boolean {
  if (typeof value !== 'string') return false;
  const vpa = normaliseVpa(value);

  // Exactly one @. `a@b@c` would otherwise slip through a looser pattern
  // and be stored as an address that can never resolve.
  if ((vpa.match(/@/g) ?? []).length !== 1) return false;

  return VPA.test(vpa);
}

export const IsUpiVpa =
  (options?: ValidationOptions) =>
  function (object: object, propertyName: string): void {
    registerDecorator({
      name: 'isUpiVpa',
      target: object.constructor,
      propertyName,
      options,
      validator: {
        validate: (value: unknown) => isUpiVpa(value),
        defaultMessage: () =>
          `${propertyName} must be a UPI ID like name@bank`,
      },
    });
  };
