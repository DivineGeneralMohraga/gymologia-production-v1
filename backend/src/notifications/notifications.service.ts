import { ForbiddenException, Injectable, Logger } from '@nestjs/common';
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
import { SendNotificationDto } from './dto/notification.dto';

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
}
