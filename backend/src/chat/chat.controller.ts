import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ChatService } from './chat.service';
import { ChatGateway } from './chat.gateway';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import {
  CreateGroupDto,
  MessageHistoryDto,
  OpenDirectDto,
  SendMessageDto,
} from './dto/chat.dto';

/**
 * Chat is scoped to a gym but not permission-gated: a member and a trainer
 * talk to each other as people, not as roles. The one rule that does apply
 * — nobody opens a conversation with the owner except a manager — lives in
 * the service, because it depends on who the other party is.
 */
@ApiTags('chat')
@ApiBearerAuth()
@Controller('gyms/:gymId/chat')
export class ChatController {
  constructor(
    private readonly chat: ChatService,
    private readonly gateway: ChatGateway,
  ) {}

  @Get('conversations')
  @ApiOperation({
    summary: 'My conversations at this gym',
    description:
      'Creates and reconciles the two standing groups on the way through, so a member who joined yesterday is in them today.',
  })
  conversations(
    @CurrentUser() user: AuthUser,
    @Param('gymId', ParseUUIDPipe) gymId: string,
  ) {
    return this.chat.conversations(user.userId, gymId);
  }

  @Get('directory')
  @ApiOperation({
    summary: 'Who I can message here',
    description:
      'Each person carries whether you may start a conversation with them, and why not when you cannot.',
  })
  directory(
    @CurrentUser() user: AuthUser,
    @Param('gymId', ParseUUIDPipe) gymId: string,
  ) {
    return this.chat.directory(user.userId, gymId);
  }

  @Post('direct')
  @ApiOperation({ summary: 'Open or find a one-to-one conversation' })
  openDirect(
    @CurrentUser() user: AuthUser,
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @Body() dto: OpenDirectDto,
  ) {
    return this.chat.openDirect(user.userId, gymId, dto.userId);
  }

  @Post('groups')
  @ApiOperation({ summary: 'Create a group' })
  createGroup(
    @CurrentUser() user: AuthUser,
    @Param('gymId', ParseUUIDPipe) gymId: string,
    @Body() dto: CreateGroupDto,
  ) {
    return this.chat.createGroup(user.userId, gymId, dto);
  }

  @Get('conversations/:conversationId/messages')
  @ApiOperation({
    summary: 'Message history',
    description: 'Newest 50, oldest first. Reading marks the conversation read.',
  })
  messages(
    @CurrentUser() user: AuthUser,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
    @Query() dto: MessageHistoryDto,
  ) {
    return this.chat.messages(user.userId, conversationId, dto.before);
  }

  @Get('conversations/:conversationId/participants')
  @ApiOperation({ summary: 'Who is in this conversation' })
  participants(
    @CurrentUser() user: AuthUser,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
  ) {
    return this.chat.participants(user.userId, conversationId);
  }

  @Post('conversations/:conversationId/messages')
  @ApiOperation({ summary: 'Send a message' })
  async send(
    @CurrentUser() user: AuthUser,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
    @Body() dto: SendMessageDto,
  ) {
    const message = await this.chat.send(user.userId, conversationId, dto);

    // Push to everyone else who is connected. Delivery is best-effort:
    // the REST history is the source of truth, so a dropped socket costs
    // immediacy rather than the message.
    const recipients = await this.chat.recipientsOf(conversationId);
    this.gateway.broadcast(
      recipients.filter((id) => id !== user.userId),
      { ...message, fromMe: false },
    );

    return message;
  }
}
