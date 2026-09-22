import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  Logger,
} from '@nestjs/common';
import {
  MembershipStatus,
  NotificationAudience,
  NotificationSource,
  Permission,
  StaffStatus,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import type { RequestMeta } from '../gyms/gyms.service';
import { BroadcastNotificationDto, SendNotificationDto } from './dto/notification.dto';

/**
 * The deep links on the two onboarding messages.
 *
 * These are the identifier, not the copy. The app matches on the link and
 * renders its own translated text, so changing the English below is safe
 * and changing these strings is not -- a message already sitting in
 * somebody's inbox carries the old one.
 */
export const ONBOARDING_LINKS = {
  becomeOwnerOrStaff: 'gymologia://settings/mode',
  referral: 'gymologia://referral',
} as const;

/** Fan-out is chunked so one announcement cannot build a 10k-row insert. */
const FANOUT_CHUNK = 500;

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  /**
   * A gym announcing something to its own people.
   *
   * Recipients are resolved and written at send time rather than at read
   * time. It costs more to send, but it means someone who joins tomorrow
   * does not retroactively receive today's announcement, and a member who
   * leaves keeps the ones they were actually sent.
   */
  async sendFromGym(
    actor: ActorContext,
    dto: SendNotificationDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.SEND_NOTIFICATIONS);

    const audience = dto.audience ?? NotificationAudience.GYM_EVERYONE;
    const recipients = await this.resolveGymAudience(actor.gymId, audience);

    if (recipients.length === 0) {
      throw new ForbiddenException('There is nobody in that audience yet.');
    }

    const notification = await this.prisma.notification.create({
      data: {
        gymId: actor.gymId,
        source: NotificationSource.GYM,
        audience,
        title: dto.title,
        body: dto.body,
        deepLink: dto.deepLink ?? null,
        senderId: actor.userId,
      },
    });

    for (let i = 0; i < recipients.length; i += FANOUT_CHUNK) {
      await this.prisma.notificationRecipient.createMany({
        data: recipients.slice(i, i + FANOUT_CHUNK).map((userId) => ({
          notificationId: notification.id,
          userId,
        })),
        skipDuplicates: true,
      });
    }

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'notification.send',
      entityType: 'Notification',
      entityId: notification.id,
      after: { audience, title: dto.title, recipients: recipients.length },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    this.logger.log(
      `Gym ${actor.gymId} notified ${recipients.length} people: ${dto.title}`,
    );

    return {
      id: notification.id,
      title: notification.title,
      audience,
      sentTo: recipients.length,
      sentAt: notification.sentAt,
    };
  }

  /**
   * Told to everyone in the gym when the owner closes it on Gymologia
   * (GymsService.remove) or hands it to a new owner once that exists.
   *
   * Source is GYMOLOGIA, not GYM: the gym itself is the thing disappearing,
   * so this cannot read as an announcement from it. Fire-and-forget from
   * the caller's point of view, same as onboarding -- a closure a member
   * never learns about is worse than one whose notification failed to
   * send, but the failure must never block the gym actually closing.
   */
  async notifyGymClosing(
    gymId: string,
    gymName: string,
    reason: 'CLOSED' | 'TRANSFERRED',
  ): Promise<void> {
    try {
      const recipients = await this.resolveGymAudience(
        gymId,
        NotificationAudience.GYM_EVERYONE,
      );
      if (recipients.length === 0) return;

      const notification = await this.prisma.notification.create({
        data: {
          gymId,
          source: NotificationSource.GYMOLOGIA,
          audience: NotificationAudience.GYM_EVERYONE,
          title:
            reason === 'CLOSED'
              ? `${gymName} has closed on Gymologia`
              : `${gymName} has a new owner on Gymologia`,
          body:
            reason === 'CLOSED'
              ? "The owner has closed this gym's Gymologia listing. Your attendance and progress history is kept, and the gym itself — talk to them directly about your membership."
              : 'Ownership of this gym has been transferred. Nothing about your membership, attendance or progress history has changed.',
        },
      });

      for (let i = 0; i < recipients.length; i += FANOUT_CHUNK) {
        await this.prisma.notificationRecipient.createMany({
          data: recipients.slice(i, i + FANOUT_CHUNK).map((userId) => ({
            notificationId: notification.id,
            userId,
          })),
          skipDuplicates: true,
        });
      }

      this.logger.log(
        `Gym ${gymId} ${reason.toLowerCase()}: notified ${recipients.length} people`,
      );
    } catch (error) {
      this.logger.error(
        `Failed to notify gym ${gymId} ${reason.toLowerCase()}: ${(error as Error).message}`,
      );
    }
  }

  /**
   * The two messages the spec asks every new user to be sent.
   *
   * They existed as cards on the settings screen, which is not the same
   * thing: a card is found by somebody who goes looking, and the point of
   * these two is to tell a person something they do not yet know -- that
   * the app has an owner/staff side, and that referring earns money. So
   * they go to the inbox, where the header badge brings them to it.
   *
   * The stored text is English and the deep link is the real identifier.
   * The app matches on the link and renders its own translated copy, which
   * is how a message written once on the server can arrive in the reader's
   * language; the stored English is what shows if it ever meets a client
   * that does not recognise the link.
   *
   * Fire-and-forget from the caller's point of view. A welcome message
   * failing must never fail the registration it is welcoming.
   */
  async sendOnboarding(userId: string): Promise<void> {
    // The referral-app nudge that used to be the second message here was
    // removed 2026-09-22, along with its card in Settings and this pitch
    // no longer being sent to new members. ONBOARDING_LINKS.referral and
    // the deep-link renderer on the client are left in place so any
    // message already sitting in an inbox still displays correctly.
    const messages = [
      {
        deepLink: ONBOARDING_LINKS.becomeOwnerOrStaff,
        title: 'Do you run a gym, or work at one?',
        body:
          'Open Settings and switch to owner and staff mode. You can create a ' +
          'gym there, or appear in one you already work at.',
      },
    ];

    try {
      for (const m of messages) {
        await this.prisma.notification.create({
          data: {
            source: NotificationSource.GYMOLOGIA,
            audience: NotificationAudience.ALL_MEMBERS,
            title: m.title,
            body: m.body,
            deepLink: m.deepLink,
            recipients: { create: [{ userId, deliveredAt: new Date() }] },
          },
        });
      }
    } catch (error) {
      // Never let a welcome message break the account it is welcoming.
      this.logger.error(
        `Onboarding notifications failed for ${userId}: ${(error as Error).message}`,
      );
    }
  }

  /**
   * A platform-wide announcement from Gymologia itself.
   *
   * Deliberately separate from sendFromGym rather than a flag on it. A gym
   * announcement reaches that gym; this one can reach everybody who has the
   * app, and the two should not be one code path where a wrong parameter
   * turns the first into the second.
   */
  async broadcast(
    senderUserId: string,
    dto: BroadcastNotificationDto,
    meta: RequestMeta,
  ) {
    const recipients = await this.resolvePlatformAudience(dto.audience);

    if (recipients.length === 0) {
      throw new BadRequestException('There is nobody in that audience yet.');
    }

    // A send that cannot be taken back deserves one deliberate confirmation.
    // The count comes from a dry run, so the number the sender agreed to is
    // the number that actually goes out, not an estimate from a stale page.
    if (dto.expectedRecipients !== undefined && dto.expectedRecipients !== recipients.length) {
      throw new ConflictException(
        `This would reach ${recipients.length} people, not ${dto.expectedRecipients}. ` +
          'Check the audience and send again.',
      );
    }

    const notification = await this.prisma.notification.create({
      data: {
        gymId: null,
        source: NotificationSource.GYMOLOGIA,
        audience: dto.audience,
        title: dto.title,
        body: dto.body,
        deepLink: dto.deepLink ?? null,
        senderId: senderUserId,
      },
    });

    for (let i = 0; i < recipients.length; i += FANOUT_CHUNK) {
      await this.prisma.notificationRecipient.createMany({
        data: recipients.slice(i, i + FANOUT_CHUNK).map((userId) => ({
          notificationId: notification.id,
          userId,
        })),
        skipDuplicates: true,
      });
    }

    await this.audit.record({
      actorId: senderUserId,
      action: 'admin.notification.broadcast',
      entityType: 'Notification',
      entityId: notification.id,
      after: {
        audience: dto.audience,
        title: dto.title,
        recipients: recipients.length,
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    this.logger.warn(
      `Gymologia broadcast to ${recipients.length} people (${dto.audience}): ${dto.title}`,
    );

    return {
      id: notification.id,
      title: notification.title,
      audience: dto.audience,
      sentTo: recipients.length,
      sentAt: notification.sentAt,
    };
  }

  /**
   * How many people an audience currently covers, without sending anything.
   * The console shows this before the button, because "everyone" is a
   * number worth seeing first.
   */
  async audienceSize(audience: NotificationAudience) {
    const recipients = await this.resolvePlatformAudience(audience);
    return { audience, recipients: recipients.length };
  }

  /** What Gymologia itself has sent. */
  async broadcastHistory(limit = 50) {
    const rows = await this.prisma.notification.findMany({
      where: { source: NotificationSource.GYMOLOGIA },
      include: { _count: { select: { recipients: true } } },
      orderBy: { sentAt: 'desc' },
      take: Math.min(limit, 100),
    });

    return rows.map((n) => ({
      id: n.id,
      title: n.title,
      body: n.body,
      audience: n.audience,
      sentAt: n.sentAt,
      sentTo: n._count.recipients,
    }));
  }

  /** What a gym has sent, for the staff side. */
  async sentByGym(actor: ActorContext) {
    this.permissions.assert(actor, Permission.SEND_NOTIFICATIONS);

    const rows = await this.prisma.notification.findMany({
      where: { gymId: actor.gymId },
      include: {
        _count: { select: { recipients: true } },
      },
      orderBy: { sentAt: 'desc' },
      take: 50,
    });

    return rows.map((n) => ({
      id: n.id,
      title: n.title,
      body: n.body,
      audience: n.audience,
      sentAt: n.sentAt,
      sentTo: n._count.recipients,
    }));
  }

  // ── The recipient's inbox ──────────────────────────────────────────

  async inbox(userId: string, limit = 50) {
    const rows = await this.prisma.notificationRecipient.findMany({
      where: { userId },
      include: {
        notification: {
          include: { gym: { select: { name: true, district: true } } },
        },
      },
      orderBy: { notification: { sentAt: 'desc' } },
      take: limit,
    });

    return {
      unread: rows.filter((r) => r.readAt === null).length,
      items: rows.map((r) => ({
        id: r.id,
        title: r.notification.title,
        body: r.notification.body,
        deepLink: r.notification.deepLink,
        from: r.notification.gym
          ? `${r.notification.gym.name} - ${r.notification.gym.district}`
          : 'Gymologia',
        source: r.notification.source,
        sentAt: r.notification.sentAt,
        read: r.readAt !== null,
      })),
    };
  }

  /** Just the badge count, for the header. */
  async unreadCount(userId: string): Promise<{ unread: number }> {
    const unread = await this.prisma.notificationRecipient.count({
      where: { userId, readAt: null },
    });
    return { unread };
  }

  async markRead(userId: string, recipientId: string) {
    // Scoped by userId so one person cannot mark another's notification
    // read by guessing an id.
    await this.prisma.notificationRecipient.updateMany({
      where: { id: recipientId, userId, readAt: null },
      data: { readAt: new Date() },
    });
    return this.unreadCount(userId);
  }

  async markAllRead(userId: string) {
    await this.prisma.notificationRecipient.updateMany({
      where: { userId, readAt: null },
      data: { readAt: new Date() },
    });
    return { unread: 0 };
  }

  // ── Audience resolution ────────────────────────────────────────────

  private async resolveGymAudience(
    gymId: string,
    audience: NotificationAudience,
  ): Promise<string[]> {
    const wantsMembers =
      audience === NotificationAudience.GYM_MEMBERS ||
      audience === NotificationAudience.GYM_EVERYONE;
    const wantsStaff =
      audience === NotificationAudience.GYM_STAFF ||
      audience === NotificationAudience.GYM_EVERYONE;

    const ids = new Set<string>();

    if (wantsMembers) {
      const members = await this.prisma.membership.findMany({
        where: {
          gymId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        select: { userId: true },
      });
      for (const m of members) ids.add(m.userId);
    }

    if (wantsStaff) {
      const staff = await this.prisma.staffMember.findMany({
        where: { gymId, status: StaffStatus.ACTIVE },
        select: { userId: true },
      });
      for (const s of staff) ids.add(s.userId);
    }

    return [...ids];
  }

  /**
   * Platform-wide audiences. A person is counted once however many gyms
   * they belong to or work at.
   *
   * ALL_REFERRERS used to resolve to nobody, because nothing in the product
   * could create a referral account. That is no longer true: asking for
   * your own code creates one, so this audience is now the people who have
   * done that -- which is the right definition of a referrer, and a
   * different set from "everyone", so it is worth knowing it went from
   * always-empty to real without anyone changing this file.
   *
   * An empty audience is still refused by the caller rather than sent to
   * nobody silently.
   */
  private async resolvePlatformAudience(
    audience: NotificationAudience,
  ): Promise<string[]> {
    if (audience === NotificationAudience.EVERYONE) {
      const everyone = await this.prisma.user.findMany({
        where: { status: 'ACTIVE' },
        select: { id: true },
      });
      return everyone.map((u) => u.id);
    }

    const ids = new Set<string>();

    if (audience === NotificationAudience.ALL_MEMBERS) {
      const members = await this.prisma.membership.findMany({
        where: {
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        select: { userId: true },
        distinct: ['userId'],
      });
      for (const m of members) ids.add(m.userId);
    }

    if (audience === NotificationAudience.ALL_STAFF) {
      const staff = await this.prisma.staffMember.findMany({
        where: { status: StaffStatus.ACTIVE, gym: { deletedAt: null } },
        select: { userId: true },
        distinct: ['userId'],
      });
      for (const s of staff) ids.add(s.userId);
    }

    if (audience === NotificationAudience.ALL_OWNERS) {
      const owners = await this.prisma.gym.findMany({
        where: { deletedAt: null },
        select: { ownerId: true },
        distinct: ['ownerId'],
      });
      for (const o of owners) ids.add(o.ownerId);
    }

    if (audience === NotificationAudience.ALL_REFERRERS) {
      const referrers = await this.prisma.referralAccount.findMany({
        select: { userId: true },
      });
      for (const r of referrers) ids.add(r.userId);
    }

    return [...ids];
  }
}
