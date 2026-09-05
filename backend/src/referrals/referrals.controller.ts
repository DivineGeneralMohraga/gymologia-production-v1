import { Body, Controller, Get, Put, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { ReferralsService } from './referrals.service';
import { SetPanDto, SetPayoutMethodDto } from './dto/referrals.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * The referrer's own code, payout details, and what it has earned.
 *
 * Under /me rather than a top-level /referrals: there is exactly one of
 * these per person and it is always their own, so an id in the path would
 * only be something to check permissions against.
 *
 * PUT rather than POST for both setters, because each one replaces the
 * single value on record rather than adding to a collection -- sending the
 * same UPI ID twice has to leave the account in the state it was already
 * in, and PUT is the method that says so.
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

  @Put('payout-method')
  @ApiOperation({ summary: 'Set the UPI ID your rewards should be sent to' })
  setPayoutMethod(
    @CurrentUser() user: AuthUser,
    @Body() dto: SetPayoutMethodDto,
    @Req() req: Request,
  ) {
    return this.referrals.setPayoutMethod(user.userId, dto, meta(req));
  }

  @Put('pan')
  @ApiOperation({ summary: 'Set the PAN tax is withheld against' })
  setPan(
    @CurrentUser() user: AuthUser,
    @Body() dto: SetPanDto,
    @Req() req: Request,
  ) {
    return this.referrals.setPan(user.userId, dto, meta(req));
  }
}
