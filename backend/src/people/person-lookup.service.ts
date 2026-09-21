import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { OtpPurpose } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { OtpService } from '../auth/otp.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { normalizePhone } from '../common/utils/phone.util';

/**
 * Shared by the new-account check here and the existing-account check in
 * MembersService.add. The Flutter add-person sheet recognises this text
 * ("parent or guardian") to reveal its guardian-consent checkbox.
 */
export const MINOR_NEEDS_GUARDIAN_MESSAGE =
  "This person is under 18. A parent or guardian's verified consent is required " +
  'before they can be added as a member (DPDP Act 2023 s.9).';

export interface LookupResult {
  phone: string;
  phoneMasked: string;
  /** True when this number already has a Gymologia account. */
  exists: boolean;
  /** Only populated once the OTP is verified — never before. */
  challengeId: string;
  expiresAt: Date;
  resendAfterSeconds: number;
  devCode?: string;
}

export interface VerifiedPerson {
  userId: string;
  phone: string;
  name: string;
  email: string | null;
  age: number | null;
  /** True when this call created the account rather than finding it. */
  created: boolean;
}

/**
 * Adding someone to a gym — as staff or as a member — starts by proving
 * the number belongs to them.
 *
 * The spec is explicit that details may be pulled from an existing
 * Gymologia account, but only after OTP verification. That ordering
 * matters: without it, anyone with the add-member screen could type a
 * stranger's number and read back their name, email and age. So the
 * lookup deliberately returns nothing identifying — only whether an
 * account exists, which the operator needs to know what form to show.
 * The details arrive with `verify`, after the code is confirmed.
 */
@Injectable()
export class PersonLookupService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly otp: OtpService,
    private readonly crypto: CryptoService,
  ) {}

  /** Step 1: send a code to the number being added. */
  async startLookup(
    rawPhone: string,
    purpose: OtpPurpose,
    ip?: string | null,
  ): Promise<LookupResult> {
    const phone = normalizePhone(rawPhone);

    const existing = await this.prisma.user.findUnique({
      where: { phone },
      select: { id: true },
    });

    const challenge = await this.otp.issue(phone, purpose, { ip });

    return {
      phone,
      phoneMasked: this.crypto.maskPhone(phone),
      exists: existing !== null,
      challengeId: challenge.challengeId,
      expiresAt: challenge.expiresAt,
      resendAfterSeconds: challenge.resendAfterSeconds,
      devCode: challenge.devCode,
    };
  }

  /**
   * Step 2: confirm the code, then return the account — creating a
   * placeholder one when the number is new to Gymologia.
   *
   * A person added by a gym before they have installed the app gets a
   * real account with their phone number, so when they do sign in they
   * find their membership already waiting rather than starting over.
   */
  async verifyAndResolve(
    input: {
      challengeId: string;
      phone: string;
      code: string;
      name?: string;
      email?: string;
      age?: number;
    },
    purpose: OtpPurpose,
    ip?: string | null,
    opts: {
      requireAgeForNewAccount?: boolean;
      guardianConsentConfirmed?: boolean;
    } = {},
  ): Promise<VerifiedPerson> {
    const phone = normalizePhone(input.phone);

    await this.otp.verify(input.challengeId, phone, input.code, purpose, { ip });

    const existing = await this.prisma.user.findUnique({ where: { phone } });

    if (existing) {
      // Never overwrite what the person set themselves. Staff filling in a
      // form should not be able to rename an existing user.
      return {
        userId: existing.id,
        phone: existing.phone,
        name: existing.name,
        email: existing.email,
        age: existing.age,
        created: false,
      };
    }

    if (!input.name || input.name.trim().length < 2) {
      throw new NotFoundException(
        'This number has no Gymologia account yet — a name is required to create one.',
      );
    }

    // DPDP Act 2023 s.9: the under-18 guardian-consent gate keys off age, so
    // a new member account with no age on record would slip past it. The app
    // always sends one; this stops a direct API call from omitting it.
    if (opts.requireAgeForNewAccount && input.age == null) {
      throw new BadRequestException(
        'An age is required to create a new member account.',
      );
    }

    // ...and the consent check has to happen HERE, before the account
    // exists. Checked only afterwards (in MembersService.add), a rejected
    // enrolment would still have stored a minor's name, phone and age with
    // no consent behind them.
    if (
      opts.requireAgeForNewAccount &&
      input.age != null &&
      input.age < 18 &&
      !opts.guardianConsentConfirmed
    ) {
      throw new BadRequestException(MINOR_NEEDS_GUARDIAN_MESSAGE);
    }

    const created = await this.prisma.user.create({
      data: {
        phone,
        name: input.name.trim(),
        email: input.email?.toLowerCase() ?? null,
        age: input.age ?? null,
        // The number was just OTP-verified, so this is true in the strong
        // sense: someone holding that handset entered the code.
        phoneVerified: true,
      },
    });

    return {
      userId: created.id,
      phone: created.phone,
      name: created.name,
      email: created.email,
      age: created.age,
      created: true,
    };
  }
}
