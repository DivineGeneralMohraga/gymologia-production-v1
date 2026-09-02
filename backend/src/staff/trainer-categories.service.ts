import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { MembershipStatus, Permission } from "@prisma/client";
import { PrismaService } from "../prisma/prisma.service";
import { AuditService } from "../common/audit/audit.service";
import { PermissionService, ActorContext } from "../rbac/permission.service";
import type { RequestMeta } from "../gyms/gyms.service";
import {
  CreateTrainerCategoryDto,
  ReorderTrainerCategoriesDto,
  UpdateTrainerCategoryDto,
} from "./dto/trainer-category.dto";

/**
 * Trainer categories: "General", "Personal", and whatever else a gym invents.
 *
 * Every gym is seeded with the first two when it is created, so this exists
 * to change them afterwards rather than to make the first one.
 */
@Injectable()
export class TrainerCategoriesService {
  /** Enough for any real gym; a guard against a runaway loop filling the table. */
  private static readonly MAX_PER_GYM = 25;

  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  /**
   * Categories with a live count of trainers in each, because the count is
   * what decides whether one can be deleted.
   */
  async list(actor: ActorContext) {
    const rows = await this.prisma.trainerCategory.findMany({
      where: { gymId: actor.gymId },
      orderBy: [{ sortOrder: "asc" }, { name: "asc" }],
      include: {
        _count: { select: { staff: true } },
      },
    });

    return rows.map((row) => ({
      id: row.id,
      name: row.name,
      allowsMultipleMembers: row.allowsMultipleMembers,
      sortOrder: row.sortOrder,
      trainerCount: row._count.staff,
      // Deleting a category that trainers still sit in would orphan them.
      canDelete: row._count.staff === 0,
    }));
  }

  async create(
    actor: ActorContext,
    dto: CreateTrainerCategoryDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_TRAINERS);

    const name = dto.name.trim();
    if (!name) throw new BadRequestException("Give the category a name");

    const total = await this.prisma.trainerCategory.count({
      where: { gymId: actor.gymId },
    });
    if (total >= TrainerCategoriesService.MAX_PER_GYM) {
      throw new BadRequestException(
        `A gym can have at most ${TrainerCategoriesService.MAX_PER_GYM} trainer categories`,
      );
    }

    await this.assertNameFree(actor.gymId, name);

    const created = await this.prisma.trainerCategory.create({
      data: {
        gymId: actor.gymId,
        name,
        allowsMultipleMembers: dto.allowsMultipleMembers ?? true,
        sortOrder: dto.sortOrder ?? total,
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "trainerCategory.create",
      entityType: "TrainerCategory",
      entityId: created.id,
      after: {
        name: created.name,
        allowsMultipleMembers: created.allowsMultipleMembers,
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.list(actor);
  }

  async update(
    actor: ActorContext,
    categoryId: string,
    dto: UpdateTrainerCategoryDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_TRAINERS);

    const existing = await this.find(actor.gymId, categoryId);

    const name = dto.name?.trim();
    if (name !== undefined) {
      if (!name) throw new BadRequestException("Give the category a name");
      if (name.toLowerCase() !== existing.name.toLowerCase()) {
        await this.assertNameFree(actor.gymId, name);
      }
    }

    // Narrowing a category to one member each does not retroactively break
    // trainers who already hold several — it only stops the next assignment.
    // Say so plainly rather than silently changing what staff see.
    let note: string | null = null;
    if (dto.allowsMultipleMembers === false && existing.allowsMultipleMembers) {
      const overloaded = await this.trainersHoldingMultiple(categoryId);
      if (overloaded > 0) {
        note =
          `${overloaded} trainer${overloaded === 1 ? "" : "s"} in this category ` +
          "already hold more than one member. They keep them; only new " +
          "assignments are limited.";
      }
    }

    await this.prisma.trainerCategory.update({
      where: { id: categoryId },
      data: {
        ...(name !== undefined ? { name } : {}),
        ...(dto.allowsMultipleMembers !== undefined
          ? { allowsMultipleMembers: dto.allowsMultipleMembers }
          : {}),
        ...(dto.sortOrder !== undefined ? { sortOrder: dto.sortOrder } : {}),
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "trainerCategory.update",
      entityType: "TrainerCategory",
      entityId: categoryId,
      before: {
        name: existing.name,
        allowsMultipleMembers: existing.allowsMultipleMembers,
        sortOrder: existing.sortOrder,
      },
      after: dto as Record<string, unknown>,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { categories: await this.list(actor), note };
  }

  /**
   * Reorder in one call. The client sends the whole list, so a drag that
   * moves one row does not turn into a burst of individual writes.
   */
  async reorder(
    actor: ActorContext,
    dto: ReorderTrainerCategoriesDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_TRAINERS);

    const mine = await this.prisma.trainerCategory.findMany({
      where: { gymId: actor.gymId },
      select: { id: true },
    });
    const allowed = new Set(mine.map((c) => c.id));

    // Reject the whole call if any id is foreign: a partial reorder would
    // leave the list in a state nobody asked for.
    for (const id of dto.categoryIds) {
      if (!allowed.has(id)) {
        throw new NotFoundException("Trainer category not found at this gym");
      }
    }
    if (dto.categoryIds.length !== mine.length) {
      throw new BadRequestException(
        "Send every category, in the order you want them",
      );
    }

    await this.prisma.$transaction(
      dto.categoryIds.map((id, index) =>
        this.prisma.trainerCategory.update({
          where: { id },
          data: { sortOrder: index },
        }),
      ),
    );

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "trainerCategory.reorder",
      entityType: "TrainerCategory",
      entityId: actor.gymId,
      after: { order: dto.categoryIds },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.list(actor);
  }

  async remove(actor: ActorContext, categoryId: string, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.MANAGE_TRAINERS);

    const existing = await this.find(actor.gymId, categoryId);

    // A trainer with no category cannot be assigned to anyone, and members
    // already pointing at them would keep a trainer nobody can categorise.
    // Make the caller move the trainers first.
    const trainers = await this.prisma.staffMember.count({
      where: { trainerCategoryId: categoryId, status: "ACTIVE" },
    });
    if (trainers > 0) {
      throw new ConflictException(
        `${trainers} trainer${trainers === 1 ? " is" : "s are"} in this category. ` +
          "Move them to another category first.",
      );
    }

    await this.prisma.trainerCategory.delete({ where: { id: categoryId } });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "trainerCategory.delete",
      entityType: "TrainerCategory",
      entityId: categoryId,
      before: { name: existing.name },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.list(actor);
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private async find(gymId: string, categoryId: string) {
    const row = await this.prisma.trainerCategory.findFirst({
      where: { id: categoryId, gymId },
    });
    if (!row)
      throw new NotFoundException("Trainer category not found at this gym");
    return row;
  }

  /**
   * Names are compared case-insensitively. The database unique index is
   * case-sensitive, so without this a gym ends up with "Personal" and
   * "personal" side by side and nobody can tell them apart.
   */
  private async assertNameFree(gymId: string, name: string) {
    const clash = await this.prisma.trainerCategory.findFirst({
      where: { gymId, name: { equals: name, mode: "insensitive" } },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(`This gym already has a "${name}" category`);
    }
  }

  /** How many trainers in a category currently hold more than one member. */
  private async trainersHoldingMultiple(categoryId: string): Promise<number> {
    const trainers = await this.prisma.staffMember.findMany({
      where: { trainerCategoryId: categoryId, status: "ACTIVE" },
      select: {
        _count: {
          select: {
            // Expired and removed memberships are not a reason to warn.
            assignedMemberships: { where: { status: MembershipStatus.ACTIVE } },
          },
        },
      },
    });
    return trainers.filter((t) => t._count.assignedMemberships > 1).length;
  }
}
