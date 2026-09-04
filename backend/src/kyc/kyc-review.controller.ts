import { Body, Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminRole } from '@prisma/client';
import { AdminGuard, RequireAdminRole } from '../admin/admin.guard';
import { CurrentAdmin } from '../admin/admin.decorators';
import type { AdminContext } from '../admin/admin.guard';
import { KycReviewService } from './kyc-review.service';
import { KycDecisionDto, KycQueueDto } from './dto/kyc-review.dto';

/**
 * The verification desk.
 *
 * Behind AdminGuard like everything else that reads across gyms, and
 * narrowed again per route: reviewing is the KYC agent's whole job, and
 * managers and admins can do it too, but customer support cannot -- they
 * have no business opening somebody's identity documents.
 */
@ApiTags('admin')
@ApiBearerAuth()
@UseGuards(AdminGuard)
@Controller('admin/kyc')
export class KycReviewController {
  constructor(private readonly review: KycReviewService) {}

  @Get()
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.KYC_AGENT)
  @ApiOperation({ summary: 'Submissions waiting on a reviewer' })
  queue(@Query() dto: KycQueueDto) {
    return this.review.queue(dto.take ?? 25, dto.skip ?? 0);
  }

  @Get(':gymId')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.KYC_AGENT)
  @ApiOperation({ summary: 'One submission, with short-lived document links' })
  detail(@Param('gymId') gymId: string) {
    return this.review.detail(gymId);
  }

  @Post(':gymId/decision')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.KYC_AGENT)
  @ApiOperation({ summary: 'Approve or reject a submission' })
  decide(
    @CurrentAdmin() admin: AdminContext,
    @Param('gymId') gymId: string,
    @Body() dto: KycDecisionDto,
  ) {
    return this.review.decide(admin, gymId, dto);
  }
}
