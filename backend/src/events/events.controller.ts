import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import type { Request } from 'express';
import { EventsService } from './events.service';
import {
  Actor,
  CurrentUser,
  RequirePermissions,
  AuthUser,
} from '../rbac/rbac.decorators';
import type { ActorContext } from '../rbac/permission.service';
import { CreateEventDto, ListEventsDto, UpdateEventDto } from './dto/event.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/** Hosting, from inside a gym. */
@ApiTags('events')
@ApiBearerAuth()
@Controller('gyms/:gymId/events')
export class GymEventsController {
  constructor(private readonly events: EventsService) {}

  @Get()
  @RequirePermissions(Permission.HOST_EVENTS, Permission.MANAGE_EVENTS)
  @ApiOperation({ summary: 'Events this gym hosts' })
  list(@Actor() actor: ActorContext) {
    return this.events.listForGym(actor);
  }

  @Post()
  @RequirePermissions(Permission.HOST_EVENTS)
  @ApiOperation({
    summary: 'Host an event',
    description:
      'Public listing needs the Pro plan. Asking for it on Basic is not an error: the event stays members-only and the response explains why.',
  })
  create(
    @Actor() actor: ActorContext,
    @Body() dto: CreateEventDto,
    @Req() req: Request,
  ) {
    return this.events.create(actor, dto, meta(req));
  }

  @Get(':eventId/participants')
  @RequirePermissions(Permission.HOST_EVENTS, Permission.MANAGE_EVENTS)
  @ApiOperation({ summary: 'Who has signed up' })
  participants(
    @Actor() actor: ActorContext,
    @Param('eventId', ParseUUIDPipe) eventId: string,
  ) {
    return this.events.participants(actor, eventId);
  }

  @Patch(':eventId')
  @RequirePermissions(Permission.MANAGE_EVENTS)
  @ApiOperation({
    summary: 'Edit an event',
    description: 'The start time cannot be changed, because people plan around it.',
  })
  update(
    @Actor() actor: ActorContext,
    @Param('eventId', ParseUUIDPipe) eventId: string,
    @Body() dto: UpdateEventDto,
    @Req() req: Request,
  ) {
    return this.events.update(actor, eventId, dto, meta(req));
  }
}

/** The member-facing feed. */
@ApiTags('events')
@ApiBearerAuth()
@Controller('events')
export class EventsFeedController {
  constructor(private readonly events: EventsService) {}

  @Get()
  @ApiOperation({
    summary: 'Events for me',
    description:
      'Events from gyms you belong to come first, including Basic gyms whose events are not listed nationally but should still reach their own members. Everything listed publicly follows.',
  })
  feed(@CurrentUser() user: AuthUser, @Query() dto: ListEventsDto) {
    return this.events.feed(user.userId, dto);
  }

  @Get(':eventId')
  @ApiOperation({ summary: 'One event' })
  findOne(
    @CurrentUser() user: AuthUser,
    @Param('eventId', ParseUUIDPipe) eventId: string,
  ) {
    return this.events.findOneForMember(user.userId, eventId);
  }

  @Post(':eventId/participate')
  @ApiOperation({ summary: 'Sign up' })
  participate(
    @CurrentUser() user: AuthUser,
    @Param('eventId', ParseUUIDPipe) eventId: string,
  ) {
    return this.events.participate(user.userId, eventId);
  }

  @Delete(':eventId/participate')
  @ApiOperation({ summary: 'Withdraw' })
  withdraw(
    @CurrentUser() user: AuthUser,
    @Param('eventId', ParseUUIDPipe) eventId: string,
  ) {
    return this.events.withdraw(user.userId, eventId);
  }
}
