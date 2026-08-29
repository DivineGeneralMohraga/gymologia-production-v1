import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import {
  GymStatus,
  Permission,
  Plan,
  PaymentStatus,
  Prisma,
  RedemptionStatus,
  SubscriptionStatus,
} from '@prisma/client';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import { CashfreeService } from './cashfree.service';
import { BusinessConfig } from '../config/configuration';
import type { RequestMeta } from '../gyms/gyms.service';
import { CheckoutDto } from './dto/subscription.dto';

/** GST on SaaS in India. The listed price includes it. */
const GST_BPS = 1800;

@Injectable()
export class SubscriptionsService {
  private readonly logger = new Logger(SubscriptionsService.name);
  private readonly business: BusinessConfig;

  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly cashfree: CashfreeService,
    private readonly audit: AuditService,
    config: ConfigService,
  ) {
    this.business = config.getOrThrow<BusinessConfig>('business');
  }

  // ── Pricing ────────────────────────────────────────────────────────

  private listPrice(plan: Plan): number {
    return plan === Plan.PRO
      ? this.business.planProPaise
      : this.business.planBasicPaise;
  }

  /**
   * What this gym would pay, itemised.
   *
   * The listed price is what the owner pays — GST is inside it, not added
   * on top, which is how prices are quoted to Indian consumers. The tax
   * component is reverse-calculated and recorded for accounting.
   */
  private price(plan: Plan, discountPercent: number) {
    const base = this.listPrice(plan);
    const discount = Math.round((base * discountPercent) / 100);
    const payable = base - discount;
    const tax = Math.round((payable * GST_BPS) / (10_000 + GST_BPS));

    return {
      basePricePaise: base,
      discountPaise: discount,
      amountPayablePaise: payable,
      taxPaise: tax,
    };
  }

  /** Plans as the app's picker shows them, with any referral discount applied. */
  async quote(actor: ActorContext, referralCode?: string) {
    this.permissions.assert(actor, Permission.MANAGE_SUBSCRIPTION);

    const referral = referralCode
      ? await this.resolveReferral(referralCode, actor.userId)
      : null;
    const discountPercent = referral ? this.business.referralDiscountPercent : 0;

    const trialUsed = await this.hasUsedTrial(actor.userId);

    return {
      currency: 'INR',
      trialDays: this.business.trialDays,
      trialAvailable: !trialUsed,
      referral: referralCode
        ? {
            code: referralCode,
            valid: referral !== null,
            discountPercent,
            message: referral === null
              ? 'That referral code is not valid.'
              : `${discountPercent}% off applied.`,
          }
        : null,
      plans: [Plan.BASIC, Plan.PRO].map((plan) => ({
        plan,
        ...this.price(plan, discountPercent),
        features: plan === Plan.PRO
          ? [
              'Everything in Basic',
              'Listed in Gymologia search',
              'Public event listings',
              'Ranking against nearby gyms',
            ]
          : ['Full CRM: members, staff, attendance, leave', 'Not listed in search'],
      })),
    };
  }

  // ── Trial ──────────────────────────────────────────────────────────

  /**
   * The free trial the spec grants new gym owners.
   *
   * Once per person, not per gym — otherwise creating a second gym would
   * reset the clock and the trial would be unlimited.
   */
  async startTrial(actor: ActorContext, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.MANAGE_SUBSCRIPTION);

    if (await this.hasUsedTrial(actor.userId)) {
      throw new ConflictException(
        'You have already used your free trial. Choose a plan to continue.',
      );
    }

    const active = await this.currentSubscription(actor.gymId);
    if (active) {
      throw new ConflictException('This gym already has an active plan.');
    }

    const startsAt = new Date();
    const endsAt = new Date(startsAt);
    endsAt.setDate(endsAt.getDate() + this.business.trialDays);

    const subscription = await this.prisma.$transaction(async (tx) => {
      const created = await tx.gymSubscription.create({
        data: {
          gymId: actor.gymId,
          // The trial grants PRO so an owner can see what they are being
          // asked to pay for, including the search listing.
          plan: Plan.PRO,
          status: SubscriptionStatus.ACTIVE,
          startsAt,
          endsAt,
          isTrial: true,
          basePricePaise: 0,
          discountPaise: 0,
          taxPaise: 0,
          amountPayablePaise: 0,
        },
      });

      await tx.gym.update({
        where: { id: actor.gymId },
        data: { status: GymStatus.ACTIVE },
      });

      return created;
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'subscription.trial',
      entityType: 'GymSubscription',
      entityId: subscription.id,
      after: { plan: subscription.plan, endsAt },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.describe(subscription);
  }

  // ── Checkout ───────────────────────────────────────────────────────

  /**
   * Start a payment.
   *
   * Creates the subscription as PENDING with a Payment beside it, then
   * asks Cashfree for a session. Nothing is activated here — that happens
   * only once Cashfree confirms the money moved, either by webhook or by
   * the verify call below.
   */
  async checkout(actor: ActorContext, dto: CheckoutDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.MANAGE_SUBSCRIPTION);

    const gym = await this.prisma.gym.findFirst({
      where: { id: actor.gymId, deletedAt: null },
      select: { id: true, name: true, contactPhone: true },
    });
    if (!gym) throw new NotFoundException('Gym not found');

    const user = await this.prisma.user.findUnique({
      where: { id: actor.userId },
      select: { id: true, name: true, phone: true, email: true },
    });
    if (!user) throw new NotFoundException('Account not found');

    // A half-finished attempt should not block a new one, but two live
    // orders for one gym would let the same gym be paid for twice.
    await this.prisma.gymSubscription.updateMany({
      where: { gymId: actor.gymId, status: SubscriptionStatus.PENDING },
      data: { status: SubscriptionStatus.CANCELLED },
    });

    const referral = dto.referralCode
      ? await this.resolveReferral(dto.referralCode, actor.userId)
      : null;
    if (dto.referralCode && !referral) {
      throw new BadRequestException('That referral code is not valid.');
    }

    const discountPercent = referral ? this.business.referralDiscountPercent : 0;
    const amounts = this.price(dto.plan, discountPercent);

    const { startsAt, endsAt } = this.periodFrom(await this.currentSubscription(actor.gymId));

    const subscription = await this.prisma.gymSubscription.create({
      data: {
        gymId: actor.gymId,
        plan: dto.plan,
        status: SubscriptionStatus.PENDING,
        startsAt,
        endsAt,
        isTrial: false,
        ...amounts,
        referralCodeUsed: referral ? dto.referralCode : null,
      },
    });

    // Cashfree order ids must be unique forever, so the subscription id
    // carries it — a retry of the same subscription reuses nothing.
    const orderId = `gym_${subscription.id.replace(/-/g, '').slice(0, 24)}`;

    const order = await this.cashfree.createOrder({
      orderId,
      amountPaise: amounts.amountPayablePaise,
      customerId: user.id,
      customerPhone: user.phone,
      customerName: user.name,
      customerEmail: user.email ?? undefined,
      note: `${dto.plan} plan for ${gym.name}`,
    });

    await this.prisma.payment.create({
      data: {
        subscriptionId: subscription.id,
        cashfreeOrderId: order.orderId,
        amountPaise: amounts.amountPayablePaise,
        status: PaymentStatus.CREATED,
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'subscription.checkout',
      entityType: 'GymSubscription',
      entityId: subscription.id,
      after: {
        plan: dto.plan,
        amountPayablePaise: amounts.amountPayablePaise,
        referralCode: referral ? dto.referralCode : null,
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return {
      subscriptionId: subscription.id,
      orderId: order.orderId,
      paymentSessionId: order.paymentSessionId,
      ...amounts,
      plan: dto.plan,
    };
  }

  /**
   * Confirm a payment by asking Cashfree, not by believing the caller.
   *
   * The app calls this when the payment sheet closes. It is idempotent and
   * shares its activation path with the webhook, so whichever arrives
   * first wins and the second is a no-op.
   */
  async verify(actor: ActorContext, subscriptionId: string, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.MANAGE_SUBSCRIPTION);

    const subscription = await this.prisma.gymSubscription.findFirst({
      where: { id: subscriptionId, gymId: actor.gymId },
      include: { payment: true },
    });
    if (!subscription?.payment) {
      throw new NotFoundException('Payment not found');
    }

    if (subscription.status === SubscriptionStatus.ACTIVE) {
      return this.describe(subscription);
    }

    const order = await this.cashfree.fetchOrder(subscription.payment.cashfreeOrderId);

    if (order.status !== 'PAID') {
      return {
        ...this.describe(subscription),
        pending: true,
        message: 'Payment is not complete yet.',
      };
    }

    await this.activate(subscription.payment.cashfreeOrderId, {
      paymentId: order.paymentId,
      method: order.method,
      amountPaise: order.amountPaise,
      source: 'verify',
    });

    const refreshed = await this.prisma.gymSubscription.findUnique({
      where: { id: subscriptionId },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'subscription.activate',
      entityType: 'GymSubscription',
      entityId: subscriptionId,
      after: { via: 'verify', plan: refreshed?.plan },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.describe(refreshed!);
  }

  /**
   * The single activation path, shared by the webhook and the verify call.
   *
   * Idempotent by design: it only acts on a payment that is not already
   * SUCCESS, inside a transaction, so two concurrent confirmations cannot
   * both extend the subscription or both create a referral reward.
   */
  async activate(
    cashfreeOrderId: string,
    result: {
      paymentId?: string;
      method?: string;
      amountPaise: number;
      source: 'webhook' | 'verify';
      raw?: unknown;
    },
  ): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const payment = await tx.payment.findUnique({
        where: { cashfreeOrderId },
        include: { subscription: true },
      });

      if (!payment) {
        this.logger.warn(`Activation for unknown order ${cashfreeOrderId}`);
        return false;
      }
      if (payment.status === PaymentStatus.SUCCESS) {
        return false; // Already done; the other path got here first.
      }

      // Guard against an order whose amount does not match what we asked
      // for. Cashfree should never do this, but believing it blindly is
      // how a ₹1 payment activates a ₹1199 plan.
      if (result.amountPaise !== payment.amountPaise) {
        this.logger.error(
          `Amount mismatch on ${cashfreeOrderId}: expected ${payment.amountPaise}, got ${result.amountPaise}`,
        );
        await tx.payment.update({
          where: { id: payment.id },
          data: {
            status: PaymentStatus.FAILED,
            failureReason: 'Amount did not match the order',
          },
        });
        return false;
      }

      await tx.payment.update({
        where: { id: payment.id },
        data: {
          status: PaymentStatus.SUCCESS,
          cashfreePaymentId: result.paymentId ?? null,
          method: result.method ?? null,
          paidAt: new Date(),
          // Retained for dispute resolution. Cast through Prisma's JSON
          // input type rather than a plain object, which it will not accept.
          webhookPayload: result.raw
            ? (result.raw as Prisma.InputJsonValue)
            : undefined,
        },
      });

      await tx.gymSubscription.update({
        where: { id: payment.subscriptionId },
        data: { status: SubscriptionStatus.ACTIVE },
      });

      // A paid plan is what takes a gym out of DRAFT and makes it eligible
      // for public listing.
      await tx.gym.update({
        where: { id: payment.subscription.gymId },
        data: { status: GymStatus.ACTIVE },
      });

      await this.recordReferralReward(tx, payment.subscription);

      this.logger.log(
        `Activated ${payment.subscription.plan} for gym ${payment.subscription.gymId} via ${result.source}`,
      );
      return true;
    });
  }

  async markFailed(cashfreeOrderId: string, reason: string): Promise<void> {
    await this.prisma.payment.updateMany({
      where: { cashfreeOrderId, status: { not: PaymentStatus.SUCCESS } },
      data: { status: PaymentStatus.FAILED, failureReason: reason.slice(0, 500) },
    });
  }

  // ── Reading ────────────────────────────────────────────────────────

  async current(actor: ActorContext) {
    this.permissions.assert(actor, Permission.MANAGE_SUBSCRIPTION);

    const subscription = await this.currentSubscription(actor.gymId);
    const history = await this.prisma.gymSubscription.findMany({
      where: { gymId: actor.gymId, status: { not: SubscriptionStatus.PENDING } },
      orderBy: { createdAt: 'desc' },
      take: 12,
      include: { payment: { select: { status: true, paidAt: true, method: true } } },
    });

    return {
      current: subscription ? this.describe(subscription) : null,
      trialAvailable: !(await this.hasUsedTrial(actor.userId)),
      history: history.map((s) => ({
        id: s.id,
        plan: s.plan,
        status: s.status,
        isTrial: s.isTrial,
        startsAt: s.startsAt,
        endsAt: s.endsAt,
        amountPaidPaise: s.amountPayablePaise,
        paidAt: s.payment?.paidAt ?? null,
        method: s.payment?.method ?? null,
      })),
    };
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private async currentSubscription(gymId: string) {
    return this.prisma.gymSubscription.findFirst({
      where: {
        gymId,
        status: SubscriptionStatus.ACTIVE,
        endsAt: { gt: new Date() },
      },
      orderBy: { endsAt: 'desc' },
    });
  }

  /** A trial is once per person, across every gym they own. */
  private async hasUsedTrial(userId: string): Promise<boolean> {
    const used = await this.prisma.gymSubscription.findFirst({
      where: { isTrial: true, gym: { ownerId: userId } },
      select: { id: true },
    });
    return used !== null;
  }

  /**
   * A renewal starts when the current plan ends, not today — otherwise
   * paying early costs the owner the days they had left.
   */
  private periodFrom(current: { endsAt: Date } | null) {
    const startsAt =
      current && current.endsAt.getTime() > Date.now() ? current.endsAt : new Date();
    const endsAt = new Date(startsAt);
    endsAt.setMonth(endsAt.getMonth() + 1);
    return { startsAt, endsAt };
  }

  /**
   * A referral code is valid when it exists, is active, and does not
   * belong to the person spending it. Self-referral would otherwise be a
   * standing 10% discount plus ₹50 back on every renewal.
   */
  private async resolveReferral(code: string, spenderId: string) {
    const account = await this.prisma.referralAccount.findUnique({
      where: { code: code.trim().toUpperCase() },
      select: { id: true, userId: true, status: true },
    });

    if (!account || account.status !== 'ACTIVE') return null;
    if (account.userId === spenderId) return null;
    return account;
  }

  /**
   * Record what the referrer has earned.
   *
   * PENDING, not payable: the reward becomes eligible only after a hold,
   * so a refunded or charged-back subscription cannot leave a paid-out
   * reward behind. The payout job picks up what is eligible.
   */
  private async recordReferralReward(
    tx: Parameters<Parameters<PrismaService['$transaction']>[0]>[0],
    subscription: { id: string; gymId: string; referralCodeUsed: string | null; discountPaise: number },
  ): Promise<void> {
    if (!subscription.referralCodeUsed) return;

    const account = await tx.referralAccount.findUnique({
      where: { code: subscription.referralCodeUsed.toUpperCase() },
      select: { id: true, status: true, pendingPaise: true, totalEarnedPaise: true },
    });
    if (!account || account.status !== 'ACTIVE') return;

    const reward = this.business.referralRewardPaise;

    // Seven days matches a typical chargeback window on cards.
    const eligibleAt = new Date();
    eligibleAt.setDate(eligibleAt.getDate() + 7);

    await tx.referralRedemption.create({
      data: {
        referralAccountId: account.id,
        subscriptionId: subscription.id,
        gymId: subscription.gymId,
        discountPaise: subscription.discountPaise,
        rewardPaise: reward,
        status: RedemptionStatus.PENDING,
        eligibleAt,
      },
    });

    await tx.referralAccount.update({
      where: { id: account.id },
      data: {
        pendingPaise: account.pendingPaise + reward,
        totalEarnedPaise: account.totalEarnedPaise + reward,
      },
    });
  }

  private describe(s: {
    id: string;
    plan: Plan;
    status: SubscriptionStatus;
    isTrial: boolean;
    startsAt: Date;
    endsAt: Date;
    amountPayablePaise: number;
  }) {
    const daysRemaining = Math.ceil(
      (s.endsAt.getTime() - Date.now()) / 86_400_000,
    );
    return {
      id: s.id,
      plan: s.plan,
      status: s.status,
      isTrial: s.isTrial,
      startsAt: s.startsAt,
      endsAt: s.endsAt,
      daysRemaining,
      amountPaise: s.amountPayablePaise,
      /** PRO is what buys a listing in the member-facing gym browser. */
      listedInSearch: s.plan === Plan.PRO && s.status === SubscriptionStatus.ACTIVE,
    };
  }
}
