import { Body, Controller, Get, Param, ParseUUIDPipe, Post, Query, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { SubscriptionsService } from './subscriptions.service';
import { Actor, RequirePermissions, WorksWithoutPlan } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { CheckoutDto, QuoteDto } from './dto/subscription.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

@ApiTags('subscription')
@ApiBearerAuth()
@WorksWithoutPlan()
@Controller('gyms/:gymId/subscription')
export class SubscriptionsController {
  constructor(private readonly subscriptions: SubscriptionsService) {}

  @Get()
  @RequirePermissions(Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({ summary: 'Current plan and payment history' })
  current(@Actor() actor: ActorContext) {
    return this.subscriptions.current(actor);
  }

  @Get('quote')
  @RequirePermissions(Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({
    summary: 'Plans and prices',
    description:
      'Applies a referral discount when a valid code is supplied, and reports whether the free trial is still available.',
  })
  quote(@Actor() actor: ActorContext, @Query() dto: QuoteDto) {
    return this.subscriptions.quote(actor, dto.referralCode);
  }

  @Post('trial')
  @RequirePermissions(Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({
    summary: 'Start the free trial',
    description: 'Once per person, not per gym. Grants PRO for the trial window.',
  })
  trial(@Actor() actor: ActorContext, @Req() req: Request) {
    return this.subscriptions.startTrial(actor, meta(req));
  }

  @Post('checkout')
  @RequirePermissions(Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({
    summary: 'Start a payment',
    description:
      'Returns a Cashfree payment session. Nothing is activated until the money is confirmed.',
  })
  checkout(@Actor() actor: ActorContext, @Body() dto: CheckoutDto, @Req() req: Request) {
    return this.subscriptions.checkout(actor, dto, meta(req));
  }

  @Post(':subscriptionId/verify')
  @RequirePermissions(Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({
    summary: 'Confirm a payment',
    description:
      'Asks Cashfree what happened rather than believing the client. Idempotent, and shares its activation path with the webhook.',
  })
  verify(
    @Actor() actor: ActorContext,
    @Param('subscriptionId', ParseUUIDPipe) subscriptionId: string,
    @Req() req: Request,
  ) {
    return this.subscriptions.verify(actor, subscriptionId, meta(req));
  }
}
