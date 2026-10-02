import { Body, Controller, ForbiddenException, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import { StorageService } from './storage.service';
import { SignUploadDto } from './dto/upload.dto';
import { Actor, RequirePermissions, WorksWithoutPlan } from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';

/**
 * Permission to write one file.
 *
 * Mounted under a gym rather than standing on its own, because every file
 * the app accepts belongs to a gym, and the gym is what decides who may
 * write it. Anything not scoped to a gym has no business here.
 *
 * The route only hands out a signed URL. The upload itself goes straight
 * from the phone to Supabase Storage, so nothing large passes through this
 * process.
 */
@ApiTags('uploads')
@ApiBearerAuth()
@WorksWithoutPlan()
@Controller('gyms/:gymId/uploads')
export class UploadsController {
  constructor(private readonly storage: StorageService) {}

  // OR, per the decorator's contract: holding any one of these is enough to
  // reach the handler, which then narrows by the kind of file being asked
  // for. Photos and banners follow the permission that governs the thing
  // they belong to.
  @Post('sign')
  @RequirePermissions(
    Permission.EDIT_GYM_PROFILE,
    Permission.HOST_EVENTS,
    Permission.MANAGE_EVENTS,
  )
  @ApiOperation({ summary: 'Get a single-use URL to upload one file' })
  async sign(@Actor() actor: ActorContext, @Body() dto: SignUploadDto) {
    if (dto.kind === 'KYC_DOCUMENT' && !actor.isGymOwner) {
      // Verification papers are the owner's own identity documents. A
      // manager can run the gym day to day without being able to put an
      // Aadhaar card on the record in someone else's name.
      throw new ForbiddenException(
        'Only the gym owner can upload verification documents',
      );
    }

    if (
      dto.kind === 'GYM_IMAGE' &&
      !actor.permissions.has(Permission.EDIT_GYM_PROFILE)
    ) {
      // An events host reached the handler on their own permission; that
      // does not extend to replacing the gym's photographs.
      throw new ForbiddenException('You cannot change this gym\'s photos');
    }

    // The gym comes from the resolved actor, never from the path, so a
    // caller cannot aim a write at a gym they merely named in the URL.
    return this.storage.signUpload(dto.kind, actor.gymId, dto.contentType);
  }
}
