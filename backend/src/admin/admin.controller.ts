import {
  Body, Controller, Delete, Get, NotFoundException, Param, ParseUUIDPipe, Patch,
  Post, Query, Req, UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminRole } from '@prisma/client';
import type { Request } from 'express';
import { AdminService } from './admin.service';
import { NotificationsService } from '../notifications/notifications.service';
import { BroadcastNotificationDto } from '../notifications/dto/notification.dto';
import { NotificationAudience } from '@prisma/client';
import { AdminGuard, RequireAdminRole } from './admin.guard';
import type { AdminContext } from './admin.guard';
import { CurrentAdmin } from './admin.decorators';
import { IpBlockService } from '../common/security/ip-block.service';
import {
  AccountStatusDto,
  AddAdminStaffDto,
  AdminLookupDto,
  ListLogsDto,
  ListTicketsDto,
  ResolveTicketDto,
  UpdateAdminStaffDto,
} from './dto/admin.dto';

const meta = (req: Request) => ({
  ip: req.ip ?? null,
  userAgent: req.get('user-agent') ?? null,
});

/**
 * The internal console.
 *
 * These are the only endpoints in the system that read across gyms, so the
 * whole controller sits behind AdminGuard: a valid app session is not
 * enough, there has to be an active AdminStaff record behind it.
 */
@ApiTags('admin')
@ApiBearerAuth()
@UseGuards(AdminGuard)
@Controller('admin')
export class AdminController {
  constructor(
    private readonly admin: AdminService,
    private readonly notifications: NotificationsService,
    private readonly ipBlocks: IpBlockService,
  ) {}

  @Get('me')
  @ApiOperation({
    summary: 'Who this admin is and what their role covers',
    description: 'The console asks this first; a 403 here means "not staff".',
  })
  me(@CurrentAdmin() admin: AdminContext) {
    return this.admin.whoami(admin);
  }

  @Get('dashboard')
  @ApiOperation({ summary: 'Platform numbers' })
  dashboard() {
    return this.admin.dashboard();
  }

  // ── Staff ──────────────────────────────────────────────────────────

  @Get('staff')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'The internal team' })
  staff() {
    return this.admin.listStaff();
  }

  @Post('staff/lookup')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({
    summary: 'Send a verification code before adding someone',
    description:
      'A separate OTP purpose from gym staff, so a code issued for one can never be redeemed for the other.',
  })
  lookup(
    @CurrentAdmin() admin: AdminContext,
    @Body() dto: AdminLookupDto,
    @Req() req: Request,
  ) {
    return this.admin.startStaffLookup(admin, dto.phone, req.ip);
  }

  @Post('staff')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Add someone to the internal team' })
  addStaff(
    @CurrentAdmin() admin: AdminContext,
    @Body() dto: AddAdminStaffDto,
    @Req() req: Request,
  ) {
    return this.admin.addStaff(admin, dto, meta(req));
  }

  @Patch('staff/:staffId')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Change a role, or switch someone off' })
  updateStaff(
    @CurrentAdmin() admin: AdminContext,
    @Param('staffId', ParseUUIDPipe) staffId: string,
    @Body() dto: UpdateAdminStaffDto,
    @Req() req: Request,
  ) {
    return this.admin.updateStaff(admin, staffId, dto, meta(req));
  }

  // ── Accounts (ban / unban) ─────────────────────────────────────────

  @Get('accounts')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.CUSTOMER_SUPPORT)
  @ApiOperation({
    summary: 'Find an app account by phone number',
    description: 'Support can look; only admins and managers can ban.',
  })
  findAccount(@Query() dto: AdminLookupDto) {
    return this.admin.findAccount(dto.phone);
  }

  @Post('accounts/:userId/suspend')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER)
  @ApiOperation({
    summary: 'Ban an account',
    description:
      'Signs them out everywhere and refuses every future login. Their gyms and data stay.',
  })
  suspendAccount(
    @CurrentAdmin() admin: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Body() dto: AccountStatusDto,
    @Req() req: Request,
  ) {
    return this.admin.suspendAccount(admin, userId, dto, meta(req));
  }

  @Post('accounts/:userId/reactivate')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER)
  @ApiOperation({ summary: 'Lift a ban' })
  reactivateAccount(
    @CurrentAdmin() admin: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Body() dto: AccountStatusDto,
    @Req() req: Request,
  ) {
    return this.admin.reactivateAccount(admin, userId, dto, meta(req));
  }

  // ── Support ────────────────────────────────────────────────────────

  @Get('tickets')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.CUSTOMER_SUPPORT)
  @ApiOperation({
    summary: 'The support queue',
    description:
      'Urgent first, then oldest. Sorting purely by age buries the gym that cannot operate under a week of routine questions.',
  })
  tickets(@Query() dto: ListTicketsDto) {
    return this.admin.listTickets(dto);
  }

  @Post('tickets/:ticketId/claim')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.CUSTOMER_SUPPORT)
  @ApiOperation({ summary: 'Take a ticket' })
  claim(
    @CurrentAdmin() admin: AdminContext,
    @Param('ticketId', ParseUUIDPipe) ticketId: string,
    @Req() req: Request,
  ) {
    return this.admin.claimTicket(admin, ticketId, meta(req));
  }

  @Post('tickets/:ticketId/resolve')
  @RequireAdminRole(AdminRole.ADMIN, AdminRole.MANAGER, AdminRole.CUSTOMER_SUPPORT)
  @ApiOperation({ summary: 'Close a ticket with a note' })
  resolve(
    @CurrentAdmin() admin: AdminContext,
    @Param('ticketId', ParseUUIDPipe) ticketId: string,
    @Body() dto: ResolveTicketDto,
    @Req() req: Request,
  ) {
    return this.admin.resolveTicket(admin, ticketId, dto, meta(req));
  }

  // ── Announcements ──────────────────────────────────────────────────

  @Get('broadcast/audience')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({
    summary: 'How many people an audience covers, without sending',
    description: '"Everyone" is a number worth seeing before the button, not after.',
  })
  audienceSize(@Query('audience') audience: NotificationAudience) {
    return this.notifications.audienceSize(audience);
  }

  @Get('broadcast')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'What Gymologia has announced' })
  broadcastHistory() {
    return this.notifications.broadcastHistory();
  }

  @Post('broadcast')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({
    summary: 'Announce to everyone in an audience',
    description:
      'Send expectedRecipients from the dry run to be sure the number you agreed to is the number that goes out.',
  })
  broadcast(
    @CurrentAdmin() admin: AdminContext,
    @Body() dto: BroadcastNotificationDto,
    @Req() req: Request,
  ) {
    return this.notifications.broadcast(admin.userId, dto, meta(req));
  }

  // ── Logs ───────────────────────────────────────────────────────────

  @Get('logs/audit')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Who did what, across every gym' })
  auditLog(@Query() dto: ListLogsDto) {
    return this.admin.auditLog(dto);
  }

  @Get('logs/security')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Refused access, OTP abuse, bad signatures' })
  securityLog(@Query() dto: ListLogsDto) {
    return this.admin.securityLog(dto);
  }

  /**
   * Automatic blocks are still decisions made about real people, and an
   * automatic decision nobody can see or reverse is the wrong kind. These
   * two endpoints exist so an operator can answer "why can this gym not
   * reach the app?" and act on the answer.
   *
   * The block list lives in the process, not the database, so this reports
   * what *this* instance is refusing. Restarting clears it, which is also
   * the crudest way to lift every block at once.
   */
  @Get('security/blocks')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Addresses currently refused, and for how long' })
  blockedAddresses() {
    const blocks = this.ipBlocks.active();
    return { blocks, count: blocks.length };
  }

  @Delete('security/blocks/:ip')
  @RequireAdminRole(AdminRole.ADMIN)
  @ApiOperation({ summary: 'Lift a block early' })
  liftBlock(@Param('ip') ip: string) {
    // 404 rather than a cheerful 200: "already gone" and "never blocked"
    // look the same to the caller otherwise, and an operator who typed the
    // address wrong would believe they had fixed something.
    if (!this.ipBlocks.unblock(ip)) {
      throw new NotFoundException('That address is not currently blocked.');
    }
    return { lifted: ip };
  }
}
