import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { GymsService, RequestMeta } from './gyms.service';
import {
  Actor,
  CurrentUser,
  Public,
  RequirePermissions,
  AuthUser,
} from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import {
  CreateGymDto,
  RateGymDto,
  SearchGymsDto,
  UpdateGymDto,
} from './dto/gym.dto';

@ApiTags('gyms')
@ApiBearerAuth()
@Controller('gyms')
export class GymsController {
  constructor(private readonly gyms: GymsService) {}

  // ── Member-facing ──────────────────────────────────────────────────

  /**
   * The gym browser. Public because a prospective member browses before
   * they have any reason to be signed in.
   */
  @Public()
  @Get('search')
  @ApiOperation({
    summary: 'Search listed gyms',
    description:
      'Only PRO gyms with public listing enabled appear. Ranked by distance when coordinates are supplied, otherwise by rating.',
  })
  search(@Query() dto: SearchGymsDto) {
    return this.gyms.search(dto);
  }

  @Public()
  @Get(':gymId/public')
  @ApiOperation({ summary: 'Public gym profile' })
  findOnePublic(@Param('gymId', ParseUUIDPipe) gymId: string) {
    return this.gyms.findOnePublic(gymId);
  }

  @Post(':gymId/rating')
  @ApiOperation({
    summary: 'Rate a gym',
    description: 'Members only. One rating per person; submitting again replaces it.',
  })
  rate(
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @CurrentUser() user: AuthUser,
    @Body() dto: RateGymDto,
  ) {
    return this.gyms.rate(gymId, user.userId, dto);
  }

  // ── Owner / staff facing ───────────────────────────────────────────

  /** The staff app's first screen: gyms owned or worked at. */
  @Get('mine')
  @ApiOperation({ summary: 'Gyms this user owns or works at' })
  listMine(@CurrentUser() user: AuthUser) {
    return this.gyms.listMine(user.userId);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Create a gym',
    description:
      'Also seeds the five default roles, the trainer categories, and the creator as Owner.',
  })
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateGymDto,
    @Req() req: Request,
  ) {
    return this.gyms.create(user.userId, dto, meta(req));
  }

  /**
   * Full profile plus the caller's permission set for this gym. The staff
   * app calls this on entering a gym and uses `access.visibleScreens` to
   * decide which CRM tiles to render.
   */
  @Get(':gymId')
  @ApiOperation({ summary: 'Gym profile and my access within it' })
  findOne(
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @CurrentUser() user: AuthUser,
  ) {
    return this.gyms.findOneForStaff(gymId, user.userId);
  }

  @Patch(':gymId')
  @RequirePermissions(Permission.EDIT_GYM_PROFILE)
  @ApiOperation({ summary: 'Edit the gym profile' })
  update(
    @Actor() actor: ActorContext,
    @Body() dto: UpdateGymDto,
    @Req() req: Request,
  ) {
    return this.gyms.update(actor, dto, meta(req));
  }

  @Delete(':gymId')
  @RequirePermissions(Permission.DELETE_GYM)
  @ApiOperation({
    summary: 'Delete a gym',
    description: 'Owner only. DELETE_GYM tracks ownership and cannot be granted.',
  })
  remove(@Actor() actor: ActorContext, @Req() req: Request) {
    return this.gyms.remove(actor, meta(req));
  }
}

function meta(req: Request): RequestMeta {
  return { ip: req.ip ?? null, userAgent: req.get('user-agent') ?? null };
}
