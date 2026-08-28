import { Body, Controller, Delete, Get, Param, ParseUUIDPipe, Post, Query, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { LeaveService } from './leave.service';
import { Actor, CurrentUser, RequirePermissions, AuthUser } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { DecideLeaveDto, ListLeaveDto, RequestLeaveDto } from './dto/leave.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('leave')
@ApiBearerAuth()
@Controller('gyms/:gymId/leave')
export class LeaveController {
  constructor(private readonly leave: LeaveService) {}

  /**
   * Requesting leave for yourself needs no permission — a member or a
   * junior staff member must be able to ask.
   */
  @Post('request')
  @ApiOperation({
    summary: 'Request leave for yourself',
    description:
      'Member leave within both the gym monthly ceiling and the membership ceiling auto-approves and pauses the subscription clock. Anything above either goes PENDING.',
  })
  request(
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @CurrentUser() user: AuthUser,
    @Body() dto: RequestLeaveDto,
    @Req() req: Request,
  ) {
    return this.leave.request(gymId, user.userId, dto, meta(req));
  }

  @Get('mine')
  @ApiOperation({ summary: 'My leave at this gym' })
  mine(@Param('gymId', ParseUUIDPipe) gymId: string, @CurrentUser() user: AuthUser) {
    return this.leave.mine(user.userId, gymId);
  }

  @Delete('mine/:leaveId')
  @ApiOperation({ summary: 'Cancel my leave before it starts' })
  cancel(@CurrentUser() user: AuthUser, @Param('leaveId', ParseUUIDPipe) leaveId: string) {
    return this.leave.cancel(user.userId, leaveId);
  }

  @Get()
  @RequirePermissions(Permission.VIEW_LEAVE_MEMBER, Permission.VIEW_LEAVE_STAFF)
  @ApiOperation({ summary: 'Leave requests at this gym' })
  list(@Actor() actor: ActorContext, @Query() dto: ListLeaveDto) {
    return this.leave.list(actor, dto);
  }

  @Post(':leaveId/decision')
  @RequirePermissions(Permission.APPROVE_LEAVE_MEMBER, Permission.APPROVE_LEAVE_STAFF)
  @ApiOperation({ summary: 'Approve or decline, or reverse an earlier decision' })
  decide(
    @Actor() actor: ActorContext,
    @Param('leaveId', ParseUUIDPipe) leaveId: string,
    @Body() dto: DecideLeaveDto,
    @Req() req: Request,
  ) {
    return this.leave.decide(actor, leaveId, dto, meta(req));
  }
}
