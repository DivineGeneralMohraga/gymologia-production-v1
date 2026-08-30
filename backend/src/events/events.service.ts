import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  EventStatus,
  MembershipStatus,
  ParticipationStatus,
  Permission,
  Plan,
  Prisma,
  SubscriptionStatus,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import type { RequestMeta } from '../gyms/gyms.service';
import { CreateEventDto, ListEventsDto, UpdateEventDto } from './dto/event.dto';

@Injectable()
export class EventsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  // ── Hosting ────────────────────────────────────────────────────────

  async create(actor: ActorContext, dto: CreateEventDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.HOST_EVENTS);

    const registrationLastDate = new Date(dto.registrationLastDate);
    const startsAt = new Date(dto.startsAt);
    const endsAt = new Date(dto.endsAt);

    if (endsAt < startsAt) {
      throw new BadRequestException('The event cannot end before it starts');
    }
    if (registrationLastDate > startsAt) {
      throw new BadRequestException(
        'Registration must close on or before the event starts',
      );
    }

    // Public listing is what the Pro plan buys. Asking for it on Basic is
    // not an error — the event is simply kept to the gym's own members,
    // and the response says so rather than silently dropping the flag.
    const isPro = await this.isProGym(actor.gymId);
    const publicListing = (dto.publicListing ?? true) && isPro;

    const event = await this.prisma.event.create({
      data: {
        gymId: actor.gymId,
        title: dto.title,
        bannerUrl: dto.bannerUrl ?? null,
        description: dto.description,
        howToParticipate: dto.howToParticipate,
        prize: dto.prize ?? null,
        prizeDescription: dto.prizeDescription ?? null,
        registrationLastDate,
        startsAt,
        endsAt,
        membersCanParticipate: dto.membersCanParticipate ?? true,
        publicListing,
        allowNonMembers: publicListing ? (dto.allowNonMembers ?? false) : false,
        createdById: actor.userId,
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'event.create',
      entityType: 'Event',
      entityId: event.id,
      after: { title: event.title, publicListing },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return {
      ...this.shape(event),
      listingNote: !isPro && dto.publicListing !== false
        ? 'Only Pro gyms appear in the public events feed, so this event is visible to your members only.'
        : null,
    };
  }

  /**
   * Editing.
   *
   * The spec limits what can change after an event is announced: title,
   * banner, description, how to participate, the registration deadline and
   * the end date. The start date is deliberately not in that list — people
   * plan around it, and moving it silently is how someone turns up to an
   * empty gym.
   */
  async update(
    actor: ActorContext,
    eventId: string,
    dto: UpdateEventDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_EVENTS);

    const event = await this.prisma.event.findFirst({
      where: { id: eventId, gymId: actor.gymId },
    });
    if (!event) throw new NotFoundException('Event not found at this gym');

    if (dto.registrationLastDate) {
      const closes = new Date(dto.registrationLastDate);
      if (closes > event.startsAt) {
        throw new BadRequestException(
          'Registration must close on or before the event starts',
        );
      }
    }

    const updated = await this.prisma.event.update({
      where: { id: eventId },
      data: {
        ...(dto.title !== undefined ? { title: dto.title } : {}),
        ...(dto.bannerUrl !== undefined ? { bannerUrl: dto.bannerUrl } : {}),
        ...(dto.description !== undefined ? { description: dto.description } : {}),
        ...(dto.howToParticipate !== undefined
          ? { howToParticipate: dto.howToParticipate }
          : {}),
        ...(dto.prize !== undefined ? { prize: dto.prize } : {}),
        ...(dto.prizeDescription !== undefined
          ? { prizeDescription: dto.prizeDescription }
          : {}),
        ...(dto.registrationLastDate
          ? { registrationLastDate: new Date(dto.registrationLastDate) }
          : {}),
        ...(dto.endsAt ? { endsAt: new Date(dto.endsAt) } : {}),
        ...(dto.status ? { status: dto.status } : {}),
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'event.update',
      entityType: 'Event',
      entityId: eventId,
      before: { title: event.title, status: event.status },
      after: dto,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.shape(updated);
  }

  /** Events this gym hosts, for the staff side. */
  async listForGym(actor: ActorContext) {
    this.permissions.assertAny(actor, [
      Permission.HOST_EVENTS,
      Permission.MANAGE_EVENTS,
    ]);

    const events = await this.prisma.event.findMany({
      where: { gymId: actor.gymId },
      include: {
        _count: {
          select: {
            participations: { where: { status: ParticipationStatus.REGISTERED } },
          },
        },
      },
      orderBy: { startsAt: 'desc' },
    });

    return events.map((e) => ({
      ...this.shape(e),
      participantCount: e._count.participations,
    }));
  }

  async participants(actor: ActorContext, eventId: string) {
    this.permissions.assertAny(actor, [
      Permission.HOST_EVENTS,
      Permission.MANAGE_EVENTS,
    ]);

    const event = await this.prisma.event.findFirst({
      where: { id: eventId, gymId: actor.gymId },
      select: { id: true, title: true },
    });
    if (!event) throw new NotFoundException('Event not found at this gym');

    const rows = await this.prisma.eventParticipation.findMany({
      where: { eventId, status: ParticipationStatus.REGISTERED },
      include: { user: { select: { id: true, name: true, phone: true } } },
      orderBy: { registeredAt: 'asc' },
    });

    return {
      event,
      participants: rows.map((r) => ({
        userId: r.user.id,
        name: r.user.name,
        phone: r.user.phone,
        registeredAt: r.registeredAt,
      })),
    };
  }

  // ── The member-facing feed ─────────────────────────────────────────

  /**
   * The events page.
   *
   * Ordered the way the spec asks: everything from gyms this person
   * belongs to comes first — including gyms on Basic, which are not
   * publicly listed but whose own members should still see their events —
   * then a divider, then everything listed nationally.
   */
  async feed(userId: string, dto: ListEventsDto) {
    const now = new Date();

    const memberships = await this.prisma.membership.findMany({
      where: {
        userId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      select: { gymId: true },
    });
    const myGymIds = memberships.map((m) => m.gymId);

    const upcoming: Prisma.EventWhereInput = {
      status: EventStatus.PUBLISHED,
      endsAt: { gte: now },
    };

    const locality: Prisma.EventWhereInput = {
      ...(dto.state ? { gym: { state: { equals: dto.state, mode: 'insensitive' } } } : {}),
      ...(dto.district
        ? { gym: { district: { equals: dto.district, mode: 'insensitive' } } }
        : {}),
    };

    const [mine, global] = await Promise.all([
      myGymIds.length > 0
        ? this.prisma.event.findMany({
            where: { ...upcoming, gymId: { in: myGymIds } },
            include: this.feedInclude(userId),
            orderBy: { startsAt: 'asc' },
          })
        : Promise.resolve([]),
      this.prisma.event.findMany({
        where: {
          ...upcoming,
          ...locality,
          publicListing: true,
          gymId: { notIn: myGymIds.length > 0 ? myGymIds : [''] },
          // Only Pro gyms reach the national feed.
          gym: {
            ...(locality.gym as object),
            subscriptions: {
              some: {
                status: SubscriptionStatus.ACTIVE,
                plan: Plan.PRO,
                endsAt: { gt: now },
              },
            },
          },
        },
        include: this.feedInclude(userId),
        orderBy: { startsAt: 'asc' },
        take: dto.limit ?? 50,
      }),
    ]);

    return {
      myGyms: mine.map((e) => this.shapeForMember(e, true)),
      global: global.map((e) => this.shapeForMember(e, false)),
    };
  }

  async findOneForMember(userId: string, eventId: string) {
    const event = await this.prisma.event.findFirst({
      where: { id: eventId, status: EventStatus.PUBLISHED },
      include: this.feedInclude(userId),
    });
    if (!event) throw new NotFoundException('Event not found');

    const isMember = await this.isMemberOf(userId, event.gymId);
    return this.shapeForMember(event, isMember);
  }

  /**
   * Registering for an event.
   *
   * Three gates, in the order the spec describes them: the event must
   * still be open, the person must be allowed to enter at all, and — for
   * members — the host must have left participation switched on.
   */
  async participate(userId: string, eventId: string) {
    const event = await this.prisma.event.findFirst({
      where: { id: eventId, status: EventStatus.PUBLISHED },
      include: { gym: { select: { id: true, name: true } } },
    });
    if (!event) throw new NotFoundException('Event not found');

    if (event.registrationLastDate < new Date()) {
      throw new BadRequestException('Registration for this event has closed.');
    }

    const isMember = await this.isMemberOf(userId, event.gymId);

    if (isMember) {
      if (!event.membersCanParticipate) {
        throw new ForbiddenException(
          'This event does not take sign-ups through the app. See how to participate.',
        );
      }
    } else if (!(event.publicListing && event.allowNonMembers)) {
      throw new ForbiddenException(
        `Only members of ${event.gym.name} can enter this event.`,
      );
    }

    await this.prisma.eventParticipation.upsert({
      where: { eventId_userId: { eventId, userId } },
      create: { eventId, userId, status: ParticipationStatus.REGISTERED },
      update: { status: ParticipationStatus.REGISTERED, withdrawnAt: null },
    });

    return this.findOneForMember(userId, eventId);
  }

  async withdraw(userId: string, eventId: string) {
    const existing = await this.prisma.eventParticipation.findUnique({
      where: { eventId_userId: { eventId, userId } },
    });
    if (!existing) throw new NotFoundException('You are not registered for this event');

    await this.prisma.eventParticipation.update({
      where: { id: existing.id },
      data: {
        status: ParticipationStatus.WITHDRAWN,
        withdrawnAt: new Date(),
      },
    });

    return this.findOneForMember(userId, eventId);
  }

  // ── Shaping ────────────────────────────────────────────────────────

  private feedInclude(userId: string) {
    return {
      gym: { select: { id: true, name: true, district: true, state: true, city: true } },
      participations: {
        where: { userId },
        select: { status: true },
      },
      _count: {
        select: {
          participations: { where: { status: ParticipationStatus.REGISTERED } },
        },
      },
    } satisfies Prisma.EventInclude;
  }

  private shape(e: {
    id: string;
    title: string;
    bannerUrl: string | null;
    description: string;
    howToParticipate: string;
    prize: string | null;
    prizeDescription: string | null;
    registrationLastDate: Date;
    startsAt: Date;
    endsAt: Date;
    membersCanParticipate: boolean;
    publicListing: boolean;
    allowNonMembers: boolean;
    status: EventStatus;
  }) {
    return {
      id: e.id,
      title: e.title,
      bannerUrl: e.bannerUrl,
      description: e.description,
      howToParticipate: e.howToParticipate,
      prize: e.prize,
      prizeDescription: e.prizeDescription,
      registrationLastDate: e.registrationLastDate,
      startsAt: e.startsAt,
      endsAt: e.endsAt,
      membersCanParticipate: e.membersCanParticipate,
      publicListing: e.publicListing,
      allowNonMembers: e.allowNonMembers,
      status: e.status,
      registrationOpen: e.registrationLastDate >= new Date(),
    };
  }

  private shapeForMember(
    e: Prisma.EventGetPayload<{ include: ReturnType<EventsService['feedInclude']> }>,
    isMember: boolean,
  ) {
    const mine = e.participations[0];
    const registered = mine?.status === ParticipationStatus.REGISTERED;
    const open = e.registrationLastDate >= new Date();

    // Whether a button appears at all, and why not when it does not. The
    // spec is specific that when the host turns sign-ups off the
    // requirements are shown as emphasised text instead of a button.
    const canParticipate = isMember
      ? e.membersCanParticipate
      : e.publicListing && e.allowNonMembers;

    return {
      ...this.shape(e),
      displayName: `${e.title} - ${e.gym.district}, ${e.gym.state}`,
      gym: {
        id: e.gym.id,
        displayName: `${e.gym.name} - ${e.gym.district}`,
        city: e.gym.city,
      },
      isMyGym: isMember,
      registered,
      participantCount: e._count.participations,
      canParticipate: canParticipate && open,
      // Null when a button is shown; otherwise why it is not.
      blockedReason: !open
        ? 'Registration has closed'
        : canParticipate
          ? null
          : isMember
            ? 'Sign-ups are not taken through the app for this event'
            : 'Members of the hosting gym only',
    };
  }

  private async isMemberOf(userId: string, gymId: string): Promise<boolean> {
    const membership = await this.prisma.membership.findFirst({
      where: {
        userId,
        gymId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      select: { id: true },
    });
    return membership !== null;
  }

  private async isProGym(gymId: string): Promise<boolean> {
    const sub = await this.prisma.gymSubscription.findFirst({
      where: {
        gymId,
        status: SubscriptionStatus.ACTIVE,
        plan: Plan.PRO,
        endsAt: { gt: new Date() },
      },
      select: { id: true },
    });
    return sub !== null;
  }
}
