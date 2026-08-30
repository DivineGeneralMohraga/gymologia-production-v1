import {
  Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Put, Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { TrainerCategoriesService } from './trainer-categories.service';
import { Actor, RequirePermissions } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import {
  CreateTrainerCategoryDto,
  ReorderTrainerCategoriesDto,
  UpdateTrainerCategoryDto,
} from './dto/trainer-category.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('trainer-categories')
@ApiBearerAuth()
@Controller('gyms/:gymId/trainer-categories')
export class TrainerCategoriesController {
  constructor(private readonly categories: TrainerCategoriesService) {}

  @Get()
  // Reading is wider than writing: anyone who adds members or staff needs
  // the list to pick from, and none of them can change it.
  @RequirePermissions(
    Permission.MANAGE_TRAINERS,
    Permission.ADD_TRAINER,
    Permission.ADD_STAFF,
    Permission.MANAGE_STAFF,
    Permission.ADD_MEMBER,
    Permission.MANAGE_MEMBER,
  )
  @ApiOperation({ summary: 'Trainer categories, with how many trainers are in each' })
  list(@Actor() actor: ActorContext) {
    return this.categories.list(actor);
  }

  @Post()
  @RequirePermissions(Permission.MANAGE_TRAINERS)
  @ApiOperation({ summary: 'Create a trainer category' })
  create(
    @Actor() actor: ActorContext,
    @Body() dto: CreateTrainerCategoryDto,
    @Req() req: Request,
  ) {
    return this.categories.create(actor, dto, meta(req));
  }

  @Put('order')
  @RequirePermissions(Permission.MANAGE_TRAINERS)
  @ApiOperation({ summary: 'Set the order categories appear in' })
  reorder(
    @Actor() actor: ActorContext,
    @Body() dto: ReorderTrainerCategoriesDto,
    @Req() req: Request,
  ) {
    return this.categories.reorder(actor, dto, meta(req));
  }

  @Patch(':categoryId')
  @RequirePermissions(Permission.MANAGE_TRAINERS)
  @ApiOperation({
    summary: 'Rename a category or change whether it allows multiple members',
    description:
      'Returns a note when narrowing to one member leaves existing trainers holding several — they keep them.',
  })
  update(
    @Actor() actor: ActorContext,
    @Param('categoryId', ParseUUIDPipe) categoryId: string,
    @Body() dto: UpdateTrainerCategoryDto,
    @Req() req: Request,
  ) {
    return this.categories.update(actor, categoryId, dto, meta(req));
  }

  @Delete(':categoryId')
  @RequirePermissions(Permission.MANAGE_TRAINERS)
  @ApiOperation({
    summary: 'Delete a category',
    description: 'Refused while trainers are still in it, so nobody is left uncategorised.',
  })
  remove(
    @Actor() actor: ActorContext,
    @Param('categoryId', ParseUUIDPipe) categoryId: string,
    @Req() req: Request,
  ) {
    return this.categories.remove(actor, categoryId, meta(req));
  }
}
