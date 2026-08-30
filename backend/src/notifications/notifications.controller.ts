import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { NotificationsService } from './notifications.service';
import {
  Actor,
  CurrentUser,
  RequirePermissions,
  AuthUser,
} from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { SendNotificationDto } from './dto/notification.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/** Announcing, from inside a gym. */
@ApiTags('notifications')
@ApiBearerAuth()
@Controller('gyms/:gymId/notifications')
export class GymNotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Get()
  @RequirePermissions(Permission.SEND_NOTIFICATIONS)
  @ApiOperation({ summary: 'What this gym has sent' })
  sent(@Actor() actor: ActorContext) {
    return this.notifications.sentByGym(actor);
  }

  @Post()
  @RequirePermissions(Permission.SEND_NOTIFICATIONS)
  @ApiOperation({
    summary: 'Send an announcement',
    description:
      'Recipients are resolved at send time, so someone joining tomorrow does not retroactively receive it.',
  })
  send(
    @Actor() actor: ActorContext,
    @Body() dto: SendNotificationDto,
    @Req() req: Request,
  ) {
    return this.notifications.sendFromGym(actor, dto, meta(req));
  }
}

/** The recipient's own inbox, across every gym they belong to. */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/notifications')
export class MyNotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Get()
  @ApiOperation({ summary: 'My notifications' })
  inbox(@CurrentUser() user: AuthUser) {
    return this.notifications.inbox(user.userId);
  }

  @Get('unread')
  @ApiOperation({ summary: 'Unread count for the header badge' })
  unread(@CurrentUser() user: AuthUser) {
    return this.notifications.unreadCount(user.userId);
  }

  @Patch('read-all')
  @ApiOperation({ summary: 'Mark everything read' })
  readAll(@CurrentUser() user: AuthUser) {
    return this.notifications.markAllRead(user.userId);
  }

  @Patch(':recipientId/read')
  @ApiOperation({ summary: 'Mark one read' })
  read(
    @CurrentUser() user: AuthUser,
    @Param('recipientId', ParseUUIDPipe) recipientId: string,
  ) {
    return this.notifications.markRead(user.userId, recipientId);
  }
}
