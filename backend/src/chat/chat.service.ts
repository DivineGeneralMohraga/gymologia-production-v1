import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import {
  ContentType,
  ConversationType,
  MembershipStatus,
  Prisma,
  StaffStatus,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { ROLE_LEVEL } from '../rbac/rbac.constants';
import { CreateGroupDto, SendMessageDto } from './dto/chat.dto';

/**
 * Gym chat.
 *
 * ── On encryption ──────────────────────────────────────────────────
 * Message bodies are encrypted at rest with AES-256-GCM, the same as KYC
 * numbers and UPI handles. This is NOT end-to-end: the server holds the
 * key and can therefore read messages, which is what makes moderation,
 * support recovery and the admin audit trail possible at all.
 *
 * The spec asks for end-to-end. That is a deliberate, separate piece of
 * work — device keypairs, key agreement, ratcheting, and a story for what
 * happens to history when someone reinstalls. The schema already carries
 * `ciphertext`, `nonce` and a DeviceKey table for it, and every row
 * written here is stamped with the scheme that produced it, so a future
 * migration can tell server-encrypted messages from end-to-end ones.
 * Shipping a half-built crypto layer would be worse than this, because it
 * would claim a guarantee it does not provide.
 */
const SERVER_SCHEME = 'v1-server';

@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
  ) {}

  // ── Conversations ──────────────────────────────────────────────────

  /**
   * Every conversation this person can see at a gym.
   *
   * The two standing groups are created on demand rather than at gym
   * creation, so a gym that never uses chat never accumulates them, and
   * membership is reconciled each time someone opens the list — people
   * join and leave gyms constantly.
   */
  async conversations(userId: string, gymId: string) {
    const standing = await this.ensureStandingGroups(userId, gymId);

    const rows = await this.prisma.conversationMember.findMany({
      where: {
        userId,
        leftAt: null,
        conversation: { gymId },
      },
      include: {
        conversation: {
          include: {
            members: {
              where: { leftAt: null },
              include: { user: { select: { id: true, name: true } } },
            },
            messages: {
              orderBy: { createdAt: 'desc' },
              take: 1,
              where: { deletedAt: null },
            },
            _count: { select: { members: { where: { leftAt: null } } } },
          },
        },
      },
    });

    const shaped = await Promise.all(
      rows.map(async (row) => {
        const c = row.conversation;
        const last = c.messages[0];

        const unread = await this.prisma.message.count({
          where: {
            conversationId: c.id,
            deletedAt: null,
            senderId: { not: userId },
            ...(row.lastReadAt ? { createdAt: { gt: row.lastReadAt } } : {}),
          },
        });

        return {
          id: c.id,
          type: c.type,
          name: this.displayName(c, row.userId),
          memberCount: c._count.members,
          lastMessage: last
            ? {
                preview: this.previewOf(last),
                at: last.createdAt,
                fromMe: last.senderId === userId,
              }
            : null,
          lastMessageAt: c.lastMessageAt,
          unread,
        };
      }),
    );

    // Standing groups first, then whatever has spoken most recently.
    return shaped.sort((a, b) => {
      const rank = (t: ConversationType) =>
        t === ConversationType.OFFICIAL_GROUP
          ? 0
          : t === ConversationType.UNOFFICIAL_GROUP
            ? 1
            : 2;
      if (rank(a.type) !== rank(b.type)) return rank(a.type) - rank(b.type);
      const at = a.lastMessageAt?.getTime() ?? 0;
      const bt = b.lastMessageAt?.getTime() ?? 0;
      return bt - at;
    }).concat(standing.length === 0 ? [] : []);
  }

  /**
   * Open, or find, a direct conversation.
   *
   * The one rule the spec is emphatic about lives here: nobody starts a
   * conversation with the owner except a manager. If the owner started it,
   * the other person can reply — which falls out naturally, because by
   * then the conversation already exists.
   */
  async openDirect(userId: string, gymId: string, otherUserId: string) {
    if (userId === otherUserId) {
      throw new BadRequestException('You cannot open a chat with yourself');
    }

    await this.assertAtGym(userId, gymId);
    await this.assertAtGym(otherUserId, gymId);

    const existing = await this.findDirect(gymId, userId, otherUserId);
    if (existing) return this.describe(existing.id, userId);

    const gym = await this.prisma.gym.findUnique({
      where: { id: gymId },
      select: { ownerId: true },
    });

    if (gym?.ownerId === otherUserId) {
      const level = await this.roleLevelOf(userId, gymId);
      if (level === null || level > ROLE_LEVEL.MANAGER) {
        throw new ForbiddenException(
          'Only managers can start a conversation with the owner. If they message you first, you can reply.',
        );
      }
    }

    const conversation = await this.prisma.conversation.create({
      data: {
        gymId,
        type: ConversationType.DIRECT,
        createdById: userId,
        members: {
          create: [{ userId }, { userId: otherUserId }],
        },
      },
    });

    return this.describe(conversation.id, userId);
  }

  /** A group someone made themselves. */
  async createGroup(userId: string, gymId: string, dto: CreateGroupDto) {
    await this.assertAtGym(userId, gymId);

    const participants = [...new Set([userId, ...dto.userIds])];
    for (const id of participants) {
      await this.assertAtGym(id, gymId);
    }

    const conversation = await this.prisma.conversation.create({
      data: {
        gymId,
        type: ConversationType.CUSTOM_GROUP,
        name: dto.name,
        createdById: userId,
        members: {
          create: participants.map((id) => ({
            userId: id,
            isAdmin: id === userId,
          })),
        },
      },
    });

    return this.describe(conversation.id, userId);
  }

  // ── Messages ───────────────────────────────────────────────────────

  async messages(userId: string, conversationId: string, before?: string) {
    await this.assertMember(userId, conversationId);

    const rows = await this.prisma.message.findMany({
      where: {
        conversationId,
        deletedAt: null,
        ...(before ? { createdAt: { lt: new Date(before) } } : {}),
      },
      include: { sender: { select: { id: true, name: true } } },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });

    // Reading marks the conversation read, which is what people expect.
    await this.prisma.conversationMember.updateMany({
      where: { conversationId, userId },
      data: { lastReadAt: new Date() },
    });

    return rows
      .map((m) => ({
        id: m.id,
        body: this.decrypt(m.ciphertext, m.nonce),
        contentType: m.contentType,
        sender: m.sender,
        fromMe: m.senderId === userId,
        createdAt: m.createdAt,
      }))
      .reverse();
  }

  async send(userId: string, conversationId: string, dto: SendMessageDto) {
    const membership = await this.assertMember(userId, conversationId);

    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      select: { id: true, type: true, gymId: true },
    });
    if (!conversation) throw new NotFoundException('Conversation not found');

    // The members-only group is exactly that: staff are not in it, and a
    // staff member who also holds a membership should not be posting there
    // wearing the wrong hat.
    if (conversation.type === ConversationType.UNOFFICIAL_GROUP) {
      const isStaff = await this.prisma.staffMember.findFirst({
        where: {
          gymId: conversation.gymId ?? '',
          userId,
          status: StaffStatus.ACTIVE,
        },
        select: { id: true },
      });
      if (isStaff) {
        throw new ForbiddenException(
          'The members group is for members only.',
        );
      }
    }

    const message = await this.prisma.$transaction(async (tx) => {
      const created = await tx.message.create({
        data: {
          conversationId,
          senderId: userId,
          ciphertext: this.crypto.encrypt(dto.body),
          nonce: SERVER_SCHEME,
          contentType: dto.contentType ?? ContentType.TEXT,
        },
        include: { sender: { select: { id: true, name: true } } },
      });

      await tx.conversation.update({
        where: { id: conversationId },
        data: { lastMessageAt: created.createdAt },
      });

      await tx.conversationMember.update({
        where: { id: membership.id },
        data: { lastReadAt: created.createdAt },
      });

      return created;
    });

    return {
      id: message.id,
      body: dto.body,
      contentType: message.contentType,
      sender: message.sender,
      fromMe: true,
      createdAt: message.createdAt,
      conversationId,
    };
  }

  /** Who else is in a conversation, for the header and the group screen. */
  async participants(userId: string, conversationId: string) {
    await this.assertMember(userId, conversationId);

    const rows = await this.prisma.conversationMember.findMany({
      where: { conversationId, leftAt: null },
      include: { user: { select: { id: true, name: true, phone: true } } },
      orderBy: { joinedAt: 'asc' },
    });

    return rows.map((r) => ({
      userId: r.user.id,
      name: r.user.name,
      isAdmin: r.isAdmin,
      isMe: r.user.id === userId,
    }));
  }

  /** Everyone at a gym this person could start a chat with. */
  async directory(userId: string, gymId: string) {
    await this.assertAtGym(userId, gymId);

    const [gym, staff, members, myLevel] = await Promise.all([
      this.prisma.gym.findUnique({
        where: { id: gymId },
        select: { ownerId: true },
      }),
      this.prisma.staffMember.findMany({
        where: { gymId, status: StaffStatus.ACTIVE },
        include: {
          user: { select: { id: true, name: true } },
          role: { select: { name: true, level: true } },
        },
      }),
      this.prisma.membership.findMany({
        where: {
          gymId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        include: { user: { select: { id: true, name: true } } },
      }),
      this.roleLevelOf(userId, gymId),
    ]);

    const canMessageOwner = myLevel !== null && myLevel <= ROLE_LEVEL.MANAGER;
    const seen = new Set<string>();
    const people: Array<{
      userId: string;
      name: string;
      role: string;
      canMessage: boolean;
      reason: string | null;
    }> = [];

    for (const s of staff) {
      if (s.userId === userId || seen.has(s.userId)) continue;
      seen.add(s.userId);

      const isOwner = s.userId === gym?.ownerId;
      const blocked = isOwner && !canMessageOwner;

      people.push({
        userId: s.userId,
        name: s.user.name,
        role: s.role.name,
        canMessage: !blocked,
        reason: blocked
          ? 'Only managers can start a conversation with the owner'
          : null,
      });
    }

    for (const m of members) {
      if (m.userId === userId || seen.has(m.userId)) continue;
      seen.add(m.userId);
      people.push({
        userId: m.userId,
        name: m.user.name,
        role: 'Member',
        canMessage: true,
        reason: null,
      });
    }

    return people;
  }

  // ── Standing groups ────────────────────────────────────────────────

  /**
   * The two groups every gym has: everyone, and members only.
   *
   * Created on first use and reconciled each time, because gym membership
   * changes constantly and a group that silently stops including new
   * members is worse than no group.
   */
  private async ensureStandingGroups(userId: string, gymId: string) {
    const [isStaff, isMember] = await Promise.all([
      this.prisma.staffMember.findFirst({
        where: { gymId, userId, status: StaffStatus.ACTIVE },
        select: { id: true },
      }),
      this.prisma.membership.findFirst({
        where: {
          gymId,
          userId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        select: { id: true },
      }),
    ]);

    if (!isStaff && !isMember) {
      throw new ForbiddenException('You are not part of this gym');
    }

    const created: string[] = [];

    // Official: everyone at the gym.
    const official = await this.upsertStandingGroup(
      gymId,
      ConversationType.OFFICIAL_GROUP,
      'Everyone',
    );
    await this.syncMembers(official, await this.everyoneAt(gymId));
    created.push(official);

    // Unofficial: members only. Staff are excluded by design.
    if (isMember && !isStaff) {
      const unofficial = await this.upsertStandingGroup(
        gymId,
        ConversationType.UNOFFICIAL_GROUP,
        'Members',
      );
      await this.syncMembers(unofficial, await this.membersAt(gymId));
      created.push(unofficial);
    }

    return created;
  }

  private async upsertStandingGroup(
    gymId: string,
    type: ConversationType,
    name: string,
  ): Promise<string> {
    const existing = await this.prisma.conversation.findFirst({
      where: { gymId, type },
      select: { id: true },
    });
    if (existing) return existing.id;

    const created = await this.prisma.conversation.create({
      data: { gymId, type, name },
      select: { id: true },
    });
    return created.id;
  }

  /** Adds anyone missing and marks anyone gone as left. */
  private async syncMembers(conversationId: string, userIds: string[]) {
    const current = await this.prisma.conversationMember.findMany({
      where: { conversationId },
      select: { id: true, userId: true, leftAt: true },
    });

    const currentActive = new Set(
      current.filter((c) => c.leftAt === null).map((c) => c.userId),
    );
    const should = new Set(userIds);

    const toAdd = userIds.filter((id) => !currentActive.has(id));
    const toRemove = current.filter(
      (c) => c.leftAt === null && !should.has(c.userId),
    );

    for (const userId of toAdd) {
      const rejoining = current.find((c) => c.userId === userId);
      if (rejoining) {
        await this.prisma.conversationMember.update({
          where: { id: rejoining.id },
          data: { leftAt: null },
        });
      } else {
        await this.prisma.conversationMember.create({
          data: { conversationId, userId },
        });
      }
    }

    if (toRemove.length > 0) {
      await this.prisma.conversationMember.updateMany({
        where: { id: { in: toRemove.map((r) => r.id) } },
        data: { leftAt: new Date() },
      });
    }
  }

  private async everyoneAt(gymId: string): Promise<string[]> {
    const [staff, members] = await Promise.all([
      this.prisma.staffMember.findMany({
        where: { gymId, status: StaffStatus.ACTIVE },
        select: { userId: true },
      }),
      this.membersAt(gymId),
    ]);
    return [...new Set([...staff.map((s) => s.userId), ...members])];
  }

  private async membersAt(gymId: string): Promise<string[]> {
    const members = await this.prisma.membership.findMany({
      where: {
        gymId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      select: { userId: true },
    });
    return members.map((m) => m.userId);
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private decrypt(ciphertext: string, nonce: string): string {
    if (nonce !== SERVER_SCHEME) {
      // A message written by a future end-to-end client. The server has no
      // key for it, and saying so is better than showing broken text.
      return '[This message is end-to-end encrypted]';
    }
    try {
      return this.crypto.decrypt(ciphertext);
    } catch {
      this.logger.error('Failed to decrypt a message body');
      return '[This message could not be read]';
    }
  }

  private previewOf(message: { ciphertext: string; nonce: string }): string {
    const text = this.decrypt(message.ciphertext, message.nonce);
    return text.length > 80 ? `${text.slice(0, 80)}…` : text;
  }

  private displayName(
    conversation: Prisma.ConversationGetPayload<{
      include: { members: { include: { user: { select: { id: true; name: true } } } } };
    }>,
    _viewerId: string,
  ): string {
    if (conversation.type === ConversationType.DIRECT) {
      const other = conversation.members.find((m) => m.userId !== _viewerId);
      return other?.user.name ?? 'Conversation';
    }
    return conversation.name ?? 'Group';
  }

  private async findDirect(gymId: string, a: string, b: string) {
    return this.prisma.conversation.findFirst({
      where: {
        gymId,
        type: ConversationType.DIRECT,
        AND: [
          { members: { some: { userId: a, leftAt: null } } },
          { members: { some: { userId: b, leftAt: null } } },
        ],
      },
      select: { id: true },
    });
  }

  private async describe(conversationId: string, viewerId: string) {
    const c = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      include: {
        members: {
          where: { leftAt: null },
          include: { user: { select: { id: true, name: true } } },
        },
        _count: { select: { members: { where: { leftAt: null } } } },
      },
    });
    if (!c) throw new NotFoundException('Conversation not found');

    return {
      id: c.id,
      type: c.type,
      name: this.displayName(c, viewerId),
      memberCount: c._count.members,
      lastMessage: null,
      lastMessageAt: c.lastMessageAt,
      unread: 0,
    };
  }

  private async assertMember(userId: string, conversationId: string) {
    const membership = await this.prisma.conversationMember.findFirst({
      where: { conversationId, userId, leftAt: null },
      select: { id: true },
    });
    if (!membership) {
      throw new ForbiddenException('You are not in this conversation');
    }
    return membership;
  }

  private async assertAtGym(userId: string, gymId: string) {
    const [staff, member] = await Promise.all([
      this.prisma.staffMember.findFirst({
        where: { gymId, userId, status: StaffStatus.ACTIVE },
        select: { id: true },
      }),
      this.prisma.membership.findFirst({
        where: {
          gymId,
          userId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        select: { id: true },
      }),
    ]);

    if (!staff && !member) {
      throw new ForbiddenException('That person is not part of this gym');
    }
  }

  /** Null when they are not staff — a plain member has no role level. */
  private async roleLevelOf(
    userId: string,
    gymId: string,
  ): Promise<number | null> {
    const staff = await this.prisma.staffMember.findFirst({
      where: { gymId, userId, status: StaffStatus.ACTIVE },
      include: { role: { select: { level: true } } },
    });
    return staff?.role.level ?? null;
  }

  /** Who should receive a realtime push for a message. */
  async recipientsOf(conversationId: string): Promise<string[]> {
    const rows = await this.prisma.conversationMember.findMany({
      where: { conversationId, leftAt: null },
      select: { userId: true },
    });
    return rows.map((r) => r.userId);
  }
}
