import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminRole } from '@prisma/client';
import type { Request } from 'express';

import { SafetyReviewService } from './safety-review.service';
import { AdminGuard, RequireAdminRole } from '../admin/admin.guard';
import type { AdminContext } from '../admin/admin.guard';
import { CurrentAdmin } from '../admin/admin.decorators';
import { ListReportsDto, ResolveReportDto } from './dto/safety.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * The report queue, for the internal console.
 *
 * Open to customer support as well as admins and managers: this is the
 * queue that most needs working promptly, and restricting it to the two
 * senior roles is how a report sits unread for a week.
 */
@ApiTags('admin')
@ApiBearerAuth()
@UseGuards(AdminGuard)
@Controller('admin/reports')
export class SafetyReviewController {
  constructor(private readonly review: SafetyReviewService) {}

  @Get()
  @RequireAdminRole(
    AdminRole.ADMIN,
    AdminRole.MANAGER,
    AdminRole.CUSTOMER_SUPPORT,
  )
  @ApiOperation({
    summary: 'The report queue',
    description: 'Open first, then oldest, so nothing sinks out of sight.',
  })
  list(@Query() dto: ListReportsDto) {
    return this.review.list(dto);
  }

  @Get(':reportId')
  @RequireAdminRole(
    AdminRole.ADMIN,
    AdminRole.MANAGER,
    AdminRole.CUSTOMER_SUPPORT,
  )
  @ApiOperation({
    summary: 'One report, with the history behind it',
    description:
      'Carries how many other people have reported and blocked the same account, which is what separates one argument from a pattern.',
  })
  detail(@Param('reportId', ParseUUIDPipe) reportId: string) {
    return this.review.detail(reportId);
  }

  @Post(':reportId/resolve')
  @RequireAdminRole(
    AdminRole.ADMIN,
    AdminRole.MANAGER,
    AdminRole.CUSTOMER_SUPPORT,
  )
  @ApiOperation({
    summary: 'Record a decision',
    description:
      'The note is required, including for a dismissal: the next person to see this account needs to know it was looked at and what was concluded.',
  })
  resolve(
    @CurrentAdmin() admin: AdminContext,
    @Param('reportId', ParseUUIDPipe) reportId: string,
    @Body() dto: ResolveReportDto,
    @Req() req: Request,
  ) {
    return this.review.resolve(admin, reportId, dto, meta(req));
  }
}
