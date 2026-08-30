import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Post, Query, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission, SubjectType } from '@prisma/client';
import type { Request } from 'express';
import { AttendanceService } from './attendance.service';
import { Actor, RequirePermissions } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import {
  AttendanceWindowDto, EditAttendanceDto, GrowthQueryDto, ListAttendanceDto,
  MarkAttendanceDto,
} from './dto/attendance.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('attendance')
@ApiBearerAuth()
@Controller('gyms/:gymId/attendance')
export class AttendanceController {
  constructor(private readonly attendance: AttendanceService) {}

  @Post()
  @RequirePermissions(
    Permission.MARK_ATTENDANCE_MEMBER,
    Permission.MARK_ATTENDANCE_STAFF,
  )
  @ApiOperation({
    summary: 'Mark attendance',
    description:
      'The specific permission is checked against subjectType inside. Marking a member present during their leave closes that leave and returns the unused days.',
  })
  mark(@Actor() actor: ActorContext, @Body() dto: MarkAttendanceDto, @Req() req: Request) {
    return this.attendance.mark(actor, dto, meta(req));
  }

  @Get()
  @RequirePermissions(
    Permission.VIEW_ATTENDANCE_MEMBER,
    Permission.VIEW_ATTENDANCE_STAFF,
    Permission.MARK_ATTENDANCE_MEMBER,
    Permission.MARK_ATTENDANCE_STAFF,
  )
  @ApiOperation({ summary: 'Attendance over a date range' })
  list(@Actor() actor: ActorContext, @Query() dto: ListAttendanceDto) {
    return this.attendance.list(actor, dto);
  }

  @Get('analytics')
  @RequirePermissions(Permission.VIEW_ANALYTICS)
  @ApiOperation({ summary: 'Joins and engagement over a window' })
  summary(@Actor() actor: ActorContext, @Query() dto: AttendanceWindowDto) {
    return this.attendance.summary(actor, dto.days ?? 30);
  }

  @Get('analytics/growth')
  @RequirePermissions(Permission.VIEW_ANALYTICS)
  @ApiOperation({
    summary: 'Joins and departures grouped by day, month or year',
    description: 'Empty periods are included, so a quiet month is visible rather than skipped.',
  })
  growth(@Actor() actor: ActorContext, @Query() dto: GrowthQueryDto) {
    return this.attendance.growth(actor, dto.unit ?? 'month', dto.periods ?? 12);
  }

  @Get('subject/:subjectType/:userId')
  @RequirePermissions(
    Permission.VIEW_ATTENDANCE_MEMBER,
    Permission.VIEW_ATTENDANCE_STAFF,
    Permission.MARK_ATTENDANCE_MEMBER,
    Permission.MARK_ATTENDANCE_STAFF,
  )
  @ApiOperation({ summary: 'One person\u2019s attendance record' })
  forSubject(
    @Actor() actor: ActorContext,
    @Param('subjectType') subjectType: SubjectType,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Query() dto: AttendanceWindowDto,
  ) {
    return this.attendance.forSubject(actor, subjectType, userId, dto.days ?? 60);
  }

  @Patch(':recordId')
  @RequirePermissions(
    Permission.EDIT_ATTENDANCE_MEMBER,
    Permission.EDIT_ATTENDANCE_STAFF,
  )
  @ApiOperation({ summary: 'Correct an attendance record' })
  edit(
    @Actor() actor: ActorContext,
    @Param('recordId', ParseUUIDPipe) recordId: string,
    @Body() dto: EditAttendanceDto,
    @Req() req: Request,
  ) {
    return this.attendance.edit(actor, recordId, dto, meta(req));
  }
}
