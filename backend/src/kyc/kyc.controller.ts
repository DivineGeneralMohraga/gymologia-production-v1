import { Body, Controller, ForbiddenException, Get, Post, Req } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { KycService } from './kyc.service';
import { SubmitKycDto } from './dto/kyc.dto';
import { Actor, RequirePermissions, WorksWithoutPlan } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * Gym verification, from the owner's side.
 *
 * Reaching these routes needs a permission that says you help run the gym,
 * and submitting needs more than that: the documents are the owner's own
 * identity papers, so only the owner may put them on the record.
 */
@ApiTags('kyc')
@ApiBearerAuth()
@WorksWithoutPlan()
@Controller('gyms/:gymId/kyc')
export class KycController {
  constructor(private readonly kyc: KycService) {}

  @Get()
  @RequirePermissions(Permission.EDIT_GYM_PROFILE, Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({ summary: 'Verification progress for this gym' })
  status(@Actor() actor: ActorContext) {
    return this.kyc.forGym(actor.gymId);
  }

  @Post()
  @RequirePermissions(Permission.EDIT_GYM_PROFILE, Permission.MANAGE_SUBSCRIPTION)
  @ApiOperation({ summary: 'Submit documents for verification' })
  submit(
    @Actor() actor: ActorContext,
    @Body() dto: SubmitKycDto,
    @Req() req: Request,
  ) {
    if (!actor.isGymOwner) {
      throw new ForbiddenException(
        'Only the gym owner can submit verification documents',
      );
    }
    return this.kyc.submit(actor, dto, meta(req));
  }
}
