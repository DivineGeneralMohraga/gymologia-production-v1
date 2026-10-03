import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';

import { SafetyService } from './safety.service';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { BlockUserDto, CreateReportDto, ReportListingDto } from './dto/safety.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * Blocking and reporting, from the perspective of the person doing it.
 *
 * Deliberately NOT under `/gyms/:gymId/...` even though the chat is. A
 * block belongs to the person, not the gym: somebody who leaves a gym and
 * joins another should not find the person they escaped visible again.
 */
@ApiTags('safety')
@ApiBearerAuth()
@Controller('me')
export class SafetyController {
  constructor(private readonly safety: SafetyService) {}

  @Post('blocks')
  @ApiOperation({
    summary: 'Block someone',
    description:
      'Takes effect immediately and in both directions: neither of you sees the other’s messages, and neither can open a new conversation with the other. They are not told.',
  })
  block(
    @CurrentUser() user: AuthUser,
    @Body() dto: BlockUserDto,
    @Req() req: Request,
  ) {
    return this.safety.block(user.userId, dto.userId, dto.reason, meta(req));
  }

  @Delete('blocks/:userId')
  @ApiOperation({
    summary: 'Unblock someone',
    description:
      'Succeeds whether or not they were blocked, because the caller’s intent is the end state.',
  })
  unblock(
    @CurrentUser() user: AuthUser,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Req() req: Request,
  ) {
    return this.safety.unblock(user.userId, userId, meta(req));
  }

  @Get('blocks')
  @ApiOperation({
    summary: 'Who I have blocked',
    description:
      'Only people you blocked. Who has blocked you is never disclosed — that is the whole point of a silent block.',
  })
  blocks(@CurrentUser() user: AuthUser) {
    return this.safety.listBlocks(user.userId);
  }

  @Post('reports')
  @ApiOperation({
    summary: 'Report someone',
    description:
      'Goes to a human review queue. Reporting does not block — the response says so, because expecting a report to stop something immediately is the commonest way people are let down by one.',
  })
  report(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateReportDto,
    @Req() req: Request,
  ) {
    return this.safety.report(user.userId, dto, meta(req));
  }

  @Post('reports/gyms/:gymId')
  @ApiOperation({
    summary: 'Report a gym',
    description:
      'For a gym name, photos, description or perks. Filed against the owner; details are optional because the reviewer can see the same listing.',
  })
  reportGym(
    @CurrentUser() user: AuthUser,
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @Body() dto: ReportListingDto,
    @Req() req: Request,
  ) {
    return this.safety.reportGym(user.userId, gymId, dto, meta(req));
  }

  @Post('reports/events/:eventId')
  @ApiOperation({
    summary: 'Report an event',
    description:
      'For an event title, banner, description or prize. Filed against whoever created it.',
  })
  reportEvent(
    @CurrentUser() user: AuthUser,
    @Param('eventId', ParseUUIDPipe) eventId: string,
    @Body() dto: ReportListingDto,
    @Req() req: Request,
  ) {
    return this.safety.reportEvent(user.userId, eventId, dto, meta(req));
  }

  @Get('reports')
  @ApiOperation({ summary: 'What I have reported, and where it got to' })
  myReports(@CurrentUser() user: AuthUser) {
    return this.safety.myReports(user.userId);
  }
}
