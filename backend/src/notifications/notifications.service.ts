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
   * ALL_REFERRERS resolves to nobody today because referral accounts do not
   * exist yet; that is deliberate rather than an oversight, and the empty
   * result is refused above rather than sending to nobody silently.
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
