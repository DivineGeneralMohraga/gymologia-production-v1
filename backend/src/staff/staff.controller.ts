import {
  Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post, Query, Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { StaffService } from './staff.service';
import { Actor, RequirePermissions } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { AddStaffDto, LookupPersonDto, UpdateStaffDto } from './dto/staff.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('staff')
@ApiBearerAuth()
@Controller('gyms/:gymId/staff')
export class StaffController {
  constructor(private readonly staff: StaffService) {}

  @Get()
  @RequirePermissions(
    Permission.MANAGE_STAFF,
    Permission.ADD_STAFF,
    Permission.REMOVE_STAFF,
    Permission.MARK_ATTENDANCE_STAFF,
    Permission.VIEW_ATTENDANCE_STAFF,
  )
  @ApiOperation({ summary: 'List staff' })
  list(@Actor() actor: ActorContext, @Query('includeRemoved') includeRemoved?: string) {
    return this.staff.list(actor, includeRemoved === 'true');
  }

  @Get('trainers')
  @RequirePermissions(
    Permission.ADD_MEMBER,
    Permission.MANAGE_MEMBER,
    Permission.MANAGE_TRAINERS,
    Permission.ADD_TRAINER,
  )
  @ApiOperation({ summary: 'Trainers, for the add-member picker' })
  listTrainers(
    @Actor() actor: ActorContext,
    @Query('categoryId', new ParseUUIDPipe({ optional: true })) categoryId?: string,
  ) {
    return this.staff.listTrainers(actor, categoryId);
  }

  @Post('lookup')
  @RequirePermissions(Permission.ADD_STAFF)
  @ApiOperation({
    summary: 'Send a verification code to a number before adding them',
    description:
      'Returns only whether an account exists. Names and emails arrive after the code is verified, so this cannot be used to read a stranger\u2019s details.',
  })
  lookup(@Actor() actor: ActorContext, @Body() dto: LookupPersonDto, @Req() req: Request) {
    return this.staff.startLookup(actor, dto.phone, req.ip);
  }

  @Post()
  @RequirePermissions(Permission.ADD_STAFF)
  @ApiOperation({ summary: 'Add a staff member after OTP verification' })
  add(@Actor() actor: ActorContext, @Body() dto: AddStaffDto, @Req() req: Request) {
    return this.staff.add(actor, dto, meta(req));
  }

  @Patch(':staffMemberId')
  @RequirePermissions(Permission.MANAGE_STAFF)
  @ApiOperation({ summary: 'Change role, trainer category or address proof' })
  update(
    @Actor() actor: ActorContext,
    @Param('staffMemberId', ParseUUIDPipe) staffMemberId: string,
    @Body() dto: UpdateStaffDto,
    @Req() req: Request,
  ) {
    return this.staff.update(actor, staffMemberId, dto, meta(req));
  }

  @Delete(':staffMemberId')
  @RequirePermissions(Permission.REMOVE_STAFF)
  @ApiOperation({ summary: 'Remove a staff member' })
  remove(
    @Actor() actor: ActorContext,
    @Param('staffMemberId', ParseUUIDPipe) staffMemberId: string,
    @Req() req: Request,
  ) {
    return this.staff.remove(actor, staffMemberId, meta(req));
  }
}
