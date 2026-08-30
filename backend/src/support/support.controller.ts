import { Body, Controller, Get, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AppClient } from '@prisma/client';
import { SupportService } from './support.service';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { CreateTicketDto, UpdateProfileDto } from './dto/support.dto';

@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class SupportController {
  constructor(private readonly support: SupportService) {}

  @Patch('profile')
  @ApiOperation({
    summary: 'Update your own profile',
    description:
      'Name, email, age and language. Not the phone number: it is the login identity, and changing it needs an OTP on the new number first.',
  })
  updateProfile(
    @CurrentUser() user: AuthUser,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.support.updateProfile(user.userId, dto);
  }

  @Post('support')
  @ApiOperation({
    summary: 'Ask support for help',
    description:
      'Stored as a ticket rather than only emailed, so a request cannot go missing in an inbox.',
  })
  createTicket(@CurrentUser() user: AuthUser, @Body() dto: CreateTicketDto) {
    const appClient =
      user.appClient in AppClient
        ? (user.appClient as AppClient)
        : AppClient.MEMBER;
    return this.support.createTicket(user.userId, dto, appClient);
  }

  @Get('support')
  @ApiOperation({ summary: 'What I have already asked' })
  myTickets(@CurrentUser() user: AuthUser) {
    return this.support.myTickets(user.userId);
  }
}
