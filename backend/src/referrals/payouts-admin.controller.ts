import {
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminRole, PayoutStatus } from '@prisma/client';

import { AdminGuard, RequireAdminRole } from '../admin/admin.guard';
import { CashfreeConfig } from '../config/configuration';
import { PrismaService } from '../prisma/prisma.service';
import { PayoutRunnerService } from './payout-runner.service';

/**
 * The payout desk.
 *
 * Withdrawals are raised by referrers and sent from here, by a person,
 * rather than by a schedule nobody is watching. That is deliberate while
 * the amounts are small and the integration is new: the first few transfers
 * out of a system that has never moved money should be watched by somebody
 * who can stop them.
 *
 * Owner and admin only. This is the one place in the product where a
 * request causes money to leave, so the narrowest role list in the codebase
 * is the right one.
 */
@ApiTags('admin')
@ApiBearerAuth()
@UseGuards(AdminGuard)
@Controller('admin/payouts')
export class PayoutsAdminController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly runner: PayoutRunnerService,
    private readonly config: ConfigService,
  ) {}

  /** Whether the Verification Suite keys exist. Never the keys themselves. */
  private get verifyConfigured(): boolean {
    const cfg = this.config.getOrThrow<CashfreeConfig>('cashfree');
    return Boolean(cfg.verifyClientId && cfg.verifyClientSecret);
  }

  @Get()
  @RequireAdminRole(AdminRole.OWNER, AdminRole.ADMIN)
  @ApiOperation({
    summary: 'Withdrawals waiting to be sent, and whether anything can be',
  })
  async queue() {
    const rows = await this.prisma.payout.findMany({
      where: {
        status: { in: [PayoutStatus.QUEUED, PayoutStatus.PROCESSING] },
      },
      orderBy: { createdAt: 'asc' },
      take: 100,
      include: {
        referralAccount: {
          select: {
            code: true,
            upiIdMasked: true,
            upiHolderName: true,
            upiVerified: true,
          },
        },
      },
    });

    return {
      // Said up front, because a queue of held payouts with no explanation
      // reads as a bug rather than a missing credential.
      blockedReason: this.runner.blockedReason(this.verifyConfigured),
      total: rows.length,
      items: rows.map((p) => ({
        id: p.id,
        status: p.status,
        grossPaise: p.grossPaise,
        verifyFeePaise: p.verifyFeePaise,
        netPaise: p.netPaise,
        requestedAt: p.createdAt,
        referralCode: p.referralAccount.code,
        // Masked only. This screen is opened by staff, and the full address
        // is not theirs to read.
        upiIdMasked: p.referralAccount.upiIdMasked,
        upiHolderName: p.referralAccount.upiHolderName,
        upiVerified: p.referralAccount.upiVerified,
      })),
    };
  }

  @Post(':payoutId/run')
  @RequireAdminRole(AdminRole.OWNER, AdminRole.ADMIN)
  @ApiOperation({
    summary: 'Send one queued withdrawal',
    description:
      'Refuses, without changing anything, while the Cashfree Payouts or ' +
      'Verification credentials are missing or the address is unverified.',
  })
  run(@Param('payoutId', ParseUUIDPipe) payoutId: string) {
    return this.runner.run(payoutId, this.verifyConfigured);
  }
}
