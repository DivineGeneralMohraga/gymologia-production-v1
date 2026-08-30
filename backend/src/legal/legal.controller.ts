import { Controller, Get, NotFoundException, Param, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { PrismaService } from '../prisma/prisma.service';
import { CurrentUser, Public, AuthUser } from '../rbac/rbac.decorators';
import {
  LEGAL_DOCUMENTS,
  LEGAL_VERSION,
  SUPPORT_EMAIL,
} from './legal.content';

/**
 * Terms and Privacy, plus the record of who accepted which version.
 *
 * Public on purpose: an app store reviewer, and anyone deciding whether to
 * sign up, has to be able to read these without an account.
 */
@ApiTags('legal')
@Controller('legal')
export class LegalController {
  constructor(private readonly prisma: PrismaService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'The documents available, and the current version' })
  index() {
    return {
      version: LEGAL_VERSION,
      supportEmail: SUPPORT_EMAIL,
      documents: Object.values(LEGAL_DOCUMENTS).map((doc) => ({
        slug: doc.slug,
        title: doc.title,
        updatedAt: doc.updatedAt,
      })),
    };
  }

  @Public()
  @Get(':slug')
  @ApiOperation({ summary: 'One document in full' })
  document(@Param('slug') slug: string) {
    const doc = LEGAL_DOCUMENTS[slug];
    if (!doc) throw new NotFoundException('No such document');
    return doc;
  }
}

/**
 * Acceptance is recorded against the account so that, if it is ever
 * questioned, there is a record of which wording that person agreed to and
 * when — not just that they agreed to "the terms".
 */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/legal')
export class LegalAcceptanceController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  @ApiOperation({
    summary: 'Which version this account has accepted',
    description:
      'reacceptanceRequired is true when the accepted version is older than the current one, or there is none.',
  })
  async status(@CurrentUser() user: AuthUser) {
    const row = await this.prisma.user.findUnique({
      where: { id: user.userId },
      select: { termsVersion: true, termsAcceptedAt: true },
    });

    return {
      currentVersion: LEGAL_VERSION,
      acceptedVersion: row?.termsVersion ?? null,
      acceptedAt: row?.termsAcceptedAt ?? null,
      reacceptanceRequired: row?.termsVersion !== LEGAL_VERSION,
    };
  }

  @Post('accept')
  @ApiOperation({ summary: 'Accept the current Terms and Privacy Policy' })
  async accept(@CurrentUser() user: AuthUser) {
    // The version is taken from the server, never from the client: a client
    // that could name the version could claim to have accepted one it never
    // showed.
    await this.prisma.user.update({
      where: { id: user.userId },
      data: {
        termsVersion: LEGAL_VERSION,
        termsAcceptedAt: new Date(),
      },
    });

    return { acceptedVersion: LEGAL_VERSION, reacceptanceRequired: false };
  }
}
