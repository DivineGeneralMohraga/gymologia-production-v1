import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { ReferralsService } from './referrals.service';

/**
 * The referrer's own code and what it has earned.
 *
 * Under /me rather than a top-level /referrals: there is exactly one of
 * these per person and it is always their own, so an id in the path would
 * only be something to check permissions against.
 */
@ApiTags('referrals')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('me/referral')
export class ReferralsController {
  constructor(private readonly referrals: ReferralsService) {}

  @Get()
  @ApiOperation({
    summary: 'Your referral code and earnings, created on first ask',
  })
  mine(@CurrentUser() user: AuthUser) {
    return this.referrals.mine(user.userId);
  }
}
