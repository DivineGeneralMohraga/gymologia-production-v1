import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppClient, TicketPriority, TicketStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { normalizePhone } from '../common/utils/phone.util';
import { CreateTicketDto, UpdateProfileDto } from './dto/support.dto';

/**
 * Support requests, and the small amount of profile a person can change
 * about themselves.
 *
 * The ticket is written to the database rather than only emailed. Email
 * can bounce, get filtered, or arrive at an inbox nobody reads on a
 * Sunday; a row cannot go missing, and the admin app already has a queue
 * waiting to read it.
 */
@Injectable()
export class SupportService {
  private readonly logger = new Logger(SupportService.name);
  private readonly supportEmail: string;

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    config: ConfigService,
  ) {
    this.supportEmail = config.get<string>(
      'support.email',
      'support@gymologia.com',
    );
  }

  async createTicket(
    userId: string | null,
    dto: CreateTicketDto,
    appClient: AppClient,
  ) {
    const contactPhone = normalizePhone(dto.contactPhone);

    const ticket = await this.prisma.supportTicket.create({
      data: {
        userId,
        appClient,
        contactPhone,
        contactEmail: dto.contactEmail?.toLowerCase() ?? null,
        subject: dto.subject,
        message: dto.message,
        status: TicketStatus.OPEN,
        priority: dto.urgent ? TicketPriority.HIGH : TicketPriority.NORMAL,
      },
      select: { id: true, createdAt: true, priority: true },
    });

    // No mailer is wired yet. Logging it means a support request is never
    // silently lost while that is true, and the row is the real record.
    this.logger.log(
      `Support ticket ${ticket.id} from ${this.crypto.maskPhone(contactPhone)} ` +
        `(${ticket.priority}): ${dto.subject}`,
    );

    return {
      id: ticket.id,
      createdAt: ticket.createdAt,
      supportEmail: this.supportEmail,
      message:
        'We have your request. Someone will reply on the number you gave us.',
    };
  }

  /** Someone's own tickets, so they can see what they have already asked. */
  async myTickets(userId: string) {
    const tickets = await this.prisma.supportTicket.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 20,
      select: {
        id: true,
        subject: true,
        status: true,
        priority: true,
        createdAt: true,
        resolutionNote: true,
        resolvedAt: true,
      },
    });
    return tickets;
  }

  /**
   * The profile fields a person owns.
   *
   * Phone is absent on purpose: it is the login identity, and changing it
   * needs an OTP on the new number before anything moves. That flow does
   * not exist yet, so offering the field would be a lie.
   */
  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const user = await this.prisma.user.update({
      where: { id: userId },
      data: {
        ...(dto.name !== undefined ? { name: dto.name } : {}),
        ...(dto.email !== undefined
          ? { email: dto.email === '' ? null : dto.email.toLowerCase() }
          : {}),
        ...(dto.age !== undefined ? { age: dto.age } : {}),
        ...(dto.locale !== undefined ? { locale: dto.locale } : {}),
      },
      select: {
        id: true,
        phone: true,
        name: true,
        email: true,
        age: true,
        locale: true,
        avatarUrl: true,
        createdAt: true,
      },
    });

    return user;
  }
}
