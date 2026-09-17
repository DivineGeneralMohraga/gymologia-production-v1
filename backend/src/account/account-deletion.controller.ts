import {
  Body,
  Controller,
  Delete,
  Get,
  Post,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import type { Request } from 'express';

import { AccountDeletionService } from './account-deletion.service';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { RequestDeletionDto } from './dto/account-deletion.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * Deleting your own account, from inside an app.
 *
 * The web route that Play also requires lives in
 * `AccountDeletionPageController`, and both end up in the same service, so
 * there is one set of rules about what deletion means rather than two that
 * drift.
 */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/deletion')
export class AccountDeletionController {
  constructor(private readonly deletion: AccountDeletionService) {}

  @Get()
  @ApiOperation({ summary: 'Is a deletion scheduled, and for when' })
  status(@CurrentUser() user: AuthUser) {
    return this.deletion.status(user.userId);
  }

  @Get('preview')
  @ApiOperation({
    summary: 'What deleting would do',
    description:
      'Asked before the button, so somebody who owns a gym or has unwithdrawn earnings finds out first rather than being refused afterwards.',
  })
  preview(@CurrentUser() user: AuthUser) {
    return this.deletion.preview(user.userId);
  }

  @Post()
  @ApiOperation({
    summary: 'Ask for your account to be deleted',
    description:
      'Schedules it 30 days out and keeps the account working meanwhile, so a decision made in a bad moment can be undone. Refused while you still own a gym.',
  })
  request(
    @CurrentUser() user: AuthUser,
    @Body() dto: RequestDeletionDto,
    @Req() req: Request,
  ) {
    return this.deletion.request(user.userId, dto.via ?? 'APP', meta(req));
  }

  @Delete()
  @ApiOperation({
    summary: 'Change your mind',
    description: 'Succeeds whether or not one was scheduled.',
  })
  cancel(@CurrentUser() user: AuthUser, @Req() req: Request) {
    return this.deletion.cancel(user.userId, meta(req));
  }
}
