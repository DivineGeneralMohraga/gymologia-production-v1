import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { normalizeLocale } from '../common/utils/locale';
import { ReferralsService } from './referrals.service';
import { WithdrawalsService } from './withdrawals.service';
import {
  EarningsQueryDto,
  SetPanDto,
  SetPayoutMethodDto,
} from './dto/referrals.dto';

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
  constructor(
    private readonly referrals: ReferralsService,
    private readonly withdrawals: WithdrawalsService,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Your referral code and earnings, created on first ask',
  })
  mine(
    @CurrentUser() user: AuthUser,
    // The share sentence comes back in this language. It is the one string
    // here whose reader is somebody else -- it gets forwarded to a gym
    // owner -- so it is worth the header rather than shipping English to
    // everybody.
    @Headers('accept-language') locale?: string,
  ) {
    return this.referrals.mine(user.userId, normalizeLocale(locale));
  }

  @Get('earnings')
  @ApiOperation({ summary: 'The individual rewards behind the totals' })
  earnings(@CurrentUser() user: AuthUser, @Query() query: EarningsQueryDto) {
    return this.referrals.earnings(user.userId, query.limit ?? 50);
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

  @Post('withdraw')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Send the cleared rewards to the UPI ID on record',
    description:
      'Ten rupees is deducted once, to cover checking the address is really ' +
      'yours. Nothing else is deducted -- no tax is withheld at these amounts.',
  })
  async withdraw(@CurrentUser() user: AuthUser, @Req() req: Request) {
    const account = await this.referrals.accountForWithdrawal(user.userId);
    return this.withdrawals.withdraw(user.userId, account, meta(req));
  }

  @Get('withdrawals')
  @ApiOperation({ summary: 'What has been withdrawn, and what happened to it' })
  async withdrawals_(@CurrentUser() user: AuthUser) {
    const account = await this.referrals.accountForWithdrawal(user.userId);
    return this.withdrawals.history(account.id);
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
