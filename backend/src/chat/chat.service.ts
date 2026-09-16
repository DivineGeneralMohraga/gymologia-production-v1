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
import { SafetyService } from '../safety/safety.service';
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
 *
 * ── On blocking ────────────────────────────────────────────────────
 * Every read and write path below consults SafetyService. A block hides
 * both people from each other -- in the conversation list, in history, in
 * the directory, and over the socket -- and stops either of them opening a
 * new direct conversation with the other. It is never announced.
 *
 * The socket is the one to watch when changing any of this: it does not
 * pass through the REST reads, so a filter added there and not in
 * `recipientsOf` would deliver in realtime exactly what the history hides.
 */
const SERVER_SCHEME = 'v1-server';

@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly safety: SafetyService,
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

    // Everyone this person should not see, in either direction. Fetched
    // once and used three times below: to drop direct conversations, to
    // pick a last-message preview they are allowed to read, and to keep
    // unread badges from counting messages that are not shown.
    const invisible = await this.safety.invisibleTo(userId);
    const hidden = [...invisible];

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
              // The newest message this person may READ, which is not
              // always the newest message. A preview is the one part of a
              // blocked person's writing that would otherwise reach the
              // blocker without them opening anything.
              where: { deletedAt: null, senderId: { notIn: hidden } },
            },
            _count: { select: { members: { where: { leftAt: null } } } },
          },
        },
      },
    });

    // Unread counts for every conversation in ONE query.
    //
    // This used to be a `message.count` inside `rows.map`, which is one
    // round trip per conversation: the classic N+1. It is invisible on a
    // test account with two standing groups and it is the whole cost of
    // the screen for a member of a busy gym, who opens chat and waits for
    // one query per conversation they belong to, in sequence.
    //
    // The per-row `lastReadAt` is what makes this awkward to express in
    // Prisma -- each conversation has its own cutoff, so a single groupBy
    // cannot carry it. Joining conversation_members supplies each row's own
    // cutoff, which is exactly what the loop was doing one at a time.
    const conversationIds = rows.map((r) => r.conversation.id);
    const unreadRows =
      conversationIds.length === 0
        ? []
        : await this.prisma.$queryRaw<Array<{ conversationId: string; count: number }>>`
            SELECT m."conversationId", COUNT(*)::int AS count
            FROM messages m
            JOIN conversation_members cm
              ON cm."conversationId" = m."conversationId"
             AND cm."userId" = ${userId}::uuid
            WHERE m."deletedAt" IS NULL
              AND m."senderId" <> ${userId}::uuid
              AND NOT (m."senderId" = ANY(${hidden}::uuid[]))
              AND (cm."lastReadAt" IS NULL OR m."createdAt" > cm."lastReadAt")
              AND m."conversationId" = ANY(${conversationIds}::uuid[])
            GROUP BY m."conversationId"
          `;
    const unreadByConversation = new Map(
      unreadRows.map((u) => [u.conversationId, Number(u.count)]),
    );

    const visibleRows =
      invisible.size === 0
        ? rows
        : rows.filter((row) => {
            const c = row.conversation;
            if (c.type !== ConversationType.DIRECT) return true;
            // A direct conversation with someone blocked disappears
            // entirely. Leaving it in the list as an empty thread would
            // advertise the block every time either of them scrolled past
            // it, and it is the thread they wanted gone.
            return !c.members.some(
              (m) => m.userId !== userId && invisible.has(m.userId),
            );
          });

    const shaped = visibleRows.map((row) => {
      const c = row.conversation;
      const last = c.messages[0];
      // Absent from the result means none unread, not missing data: the
      // GROUP BY only returns conversations that have at least one.
      const unread = unreadByConversation.get(c.id) ?? 0;

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
    });

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
    await this.assertNotBlocked(userId, otherUserId);

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

    // Making a group is the obvious way around a block: the two of them
    // are in a room together again and nobody had to unblock anyone.
    const invisible = await this.safety.invisibleTo(userId);
    if (participants.some((id) => invisible.has(id))) {
      throw new ForbiddenException(
        'Somebody you selected cannot be added to a group with you.',
      );
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

    // Filtered in the query rather than after it, so a page of fifty does
    // not quietly become a page of three that the client reads as "no
    // more history" and stops paging.
    const hidden = [...(await this.safety.invisibleTo(userId))];

    const rows = await this.prisma.message.findMany({
      where: {
        conversationId,
        deletedAt: null,
        ...(hidden.length > 0 ? { senderId: { notIn: hidden } } : {}),
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

    // A direct conversation that predates the block still exists on both
    // sides of the database, so the send is where it has to be stopped.
    // Groups are not checked: blocking one person does not remove you from
    // a room the whole gym is in, it just means you do not see them.
    if (conversation.type === ConversationType.DIRECT) {
      const other = await this.prisma.conversationMember.findFirst({
        where: { conversationId, userId: { not: userId }, leftAt: null },
        select: { userId: true },
      });
      if (other) await this.assertNotBlocked(userId, other.userId);
    }

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

    const [rows, blockedByMe] = await Promise.all([
      this.prisma.conversationMember.findMany({
        where: { conversationId, leftAt: null },
        include: { user: { select: { id: true, name: true, phone: true } } },
        orderBy: { joinedAt: 'asc' },
      }),
      this.safety.blockedByMe(userId),
    ]);

    return rows.map((r) => ({
      userId: r.user.id,
      name: r.user.name,
      isAdmin: r.isAdmin,
      isMe: r.user.id === userId,
      // Only the blocks THIS person made. Someone who blocked them is an
      // ordinary name in the list, because the alternative is telling the
      // blocked party who blocked them.
      isBlocked: blockedByMe.has(r.user.id),
    }));
  }

  /** Everyone at a gym this person could start a chat with. */
  async directory(userId: string, gymId: string) {
    await this.assertAtGym(userId, gymId);

    const [gym, staff, members, myLevel, invisible] = await Promise.all([
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
      this.safety.invisibleTo(userId),
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

    // Blocked people are absent rather than greyed out, and absent in
    // BOTH directions. That symmetry is the point: the list looks the same
    // whichever way the block went, so nobody can work out from it that
    // they have been blocked. Whom you blocked is in your own settings.
    for (const s of staff) {
      if (s.userId === userId || seen.has(s.userId)) continue;
      if (invisible.has(s.userId)) continue;
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
      if (invisible.has(m.userId)) continue;
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

  /**
   * Who should receive a realtime push for a message.
   *
   * Takes the sender, because this is the one delivery path that does not
   * go through a REST read: whatever is pushed here lands on a screen
   * without any of the filtering in `messages()` running. Anyone who has
   * blocked the sender, or whom the sender has blocked, is dropped, and so
   * is the sender themselves -- they already have the message as their own
   * response.
   */
  async recipientsOf(
    conversationId: string,
    senderId: string,
  ): Promise<string[]> {
    const [rows, invisible] = await Promise.all([
      this.prisma.conversationMember.findMany({
        where: { conversationId, leftAt: null },
        select: { userId: true },
      }),
      this.safety.invisibleTo(senderId),
    ]);

    return rows
      .map((r) => r.userId)
      .filter((id) => id !== senderId && !invisible.has(id));
  }

  /**
   * Refuses when either of two people has blocked the other.
   *
   * The wording depends on which way it went, and that is deliberate. The
   * blocker is told plainly, because they need to know to undo it. The
   * blocked party gets a sentence that does not say a block exists -- a
   * silent block that announces itself on the first attempt to message is
   * not silent, and the retaliation it invites happens somewhere this app
   * cannot see.
   */
  private async assertNotBlocked(userId: string, otherUserId: string) {
    const blockedByMe = await this.safety.blockedByMe(userId);
    if (blockedByMe.has(otherUserId)) {
      throw new ForbiddenException(
        'You have blocked this person. Unblock them from Settings to message them again.',
      );
    }

    if (await this.safety.isBlockedBetween(userId, otherUserId)) {
      throw new ForbiddenException(
        'You cannot start a conversation with this person.',
      );
    }
  }
}
