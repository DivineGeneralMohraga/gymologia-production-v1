import {
  Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Query, Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { MembersService } from './members.service';
import { Actor, CurrentUser, RequirePermissions, AuthUser } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { LookupPersonDto } from '../staff/dto/staff.dto';
import {
  AddMemberDto, ExtendMembershipDto, ListMembersDto, UpdateMemberDto,
} from './dto/member.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('members')
@ApiBearerAuth()
@Controller('gyms/:gymId/members')
export class MembersController {
  constructor(private readonly members: MembersService) {}

  @Get()
  @RequirePermissions(
    Permission.MANAGE_MEMBER,
    Permission.ADD_MEMBER,
    Permission.REMOVE_MEMBER,
    Permission.MARK_ATTENDANCE_MEMBER,
    Permission.VIEW_ATTENDANCE_MEMBER,
  )
  @ApiOperation({ summary: 'List members' })
  list(@Actor() actor: ActorContext, @Query() dto: ListMembersDto) {
    return this.members.list(actor, dto);
  }

  @Post('lookup')
  @RequirePermissions(Permission.ADD_MEMBER)
  @ApiOperation({ summary: 'Send a verification code before adding a member' })
  lookup(@Actor() actor: ActorContext, @Body() dto: LookupPersonDto, @Req() req: Request) {
    return this.members.startLookup(actor, dto.phone, req.ip);
  }

  @Post()
  @RequirePermissions(Permission.ADD_MEMBER)
  @ApiOperation({ summary: 'Add a member after OTP verification' })
  add(@Actor() actor: ActorContext, @Body() dto: AddMemberDto, @Req() req: Request) {
    return this.members.add(actor, dto, meta(req));
  }

  @Get(':membershipId')
  @RequirePermissions(
    Permission.MANAGE_MEMBER,
    Permission.ADD_MEMBER,
    Permission.VIEW_ATTENDANCE_MEMBER,
  )
  @ApiOperation({ summary: 'One member' })
  findOne(
    @Actor() actor: ActorContext,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
  ) {
    return this.members.findOne(actor, membershipId);
  }

  @Get(':membershipId/progress')
  @RequirePermissions(Permission.VIEW_PROGRESS)
  @ApiOperation({
    summary: 'A member\u2019s progress',
    description:
      'Refused when the member has turned off monitoring \u2014 no role overrides that, because the member owns the decision.',
  })
  progress(
    @Actor() actor: ActorContext,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
  ) {
    return this.members.progress(actor, membershipId);
  }

  @Patch(':membershipId')
  @RequirePermissions(Permission.MANAGE_MEMBER)
  @ApiOperation({ summary: 'Update trainer, goal, leave allowance or address proof' })
  update(
    @Actor() actor: ActorContext,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
    @Body() dto: UpdateMemberDto,
    @Req() req: Request,
  ) {
    return this.members.update(actor, membershipId, dto, meta(req));
  }

  @Post(':membershipId/extend')
  @RequirePermissions(Permission.MANAGE_MEMBER)
  @ApiOperation({ summary: 'Extend a membership' })
  extend(
    @Actor() actor: ActorContext,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
    @Body() dto: ExtendMembershipDto,
    @Req() req: Request,
  ) {
    return this.members.extend(actor, membershipId, dto, meta(req));
  }

  @Delete(':membershipId')
  @RequirePermissions(Permission.REMOVE_MEMBER)
  @ApiOperation({ summary: 'Remove a member' })
  remove(
    @Actor() actor: ActorContext,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
    @Req() req: Request,
  ) {
    return this.members.remove(actor, membershipId, meta(req));
  }
}

/** The member's own view of their memberships — no gym scope, no permissions. */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class MyMembershipController {
  constructor(private readonly members: MembersService) {}

  @Get('memberships')
  @ApiOperation({
    summary: 'My memberships',
    description:
      'Empty means the member app shows the gym browser; non-empty means it shows the membership dashboard.',
  })
  mine(@CurrentUser() user: AuthUser) {
    return this.members.myMemberships(user.userId);
  }

  @Get('attendance')
  @ApiOperation({
    summary: 'My own attendance record',
    description:
      'One entry per gym the member belongs to. Needs no permission: every other attendance route is gym-scoped and gated, which left the person it is about unable to see it.',
  })
  myAttendance(@CurrentUser() user: AuthUser, @Query('days') days?: string) {
    const parsed = Number(days);
    return this.members.myAttendance(
      user.userId,
      Number.isFinite(parsed) && parsed > 0 ? Math.floor(parsed) : 90,
    );
  }

  @Patch('memberships/:membershipId/monitoring')
  @ApiOperation({ summary: 'Turn staff progress monitoring on or off' })
  consent(
    @CurrentUser() user: AuthUser,
    @Param('membershipId', ParseUUIDPipe) membershipId: string,
    @Body() body: { allow: boolean },
  ) {
    return this.members.setMonitoringConsent(user.userId, membershipId, body.allow);
  }
}
