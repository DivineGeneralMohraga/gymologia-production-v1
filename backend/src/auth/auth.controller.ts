import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AuthService } from './auth.service';
import { Msg91Service } from './msg91.service';
import { CurrentUser, Public, AuthUser } from '../rbac/rbac.decorators';
import {
  RefreshDto,
  RegisterDto,
  RequestOtpDto,
  VerifyOtpDto,
  VerifyWidgetTokenDto,
} from './dto/auth.dto';
import type { SessionMeta } from './token.service';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly auth: AuthService,
    private readonly msg91: Msg91Service,
  ) {}

  /** Client config the apps fetch before showing the login screen. */
  @Public()
  @Get('config')
  @ApiOperation({ summary: 'Public auth configuration' })
  config() {
    return {
      msg91WidgetId: this.msg91.widgetId,
      otpLength: 6,
      supportEmail: 'support@gymologia.com',
    };
  }

  @Public()
  @Post('otp/request')
  @HttpCode(HttpStatus.OK)
  // Tight limit on top of the per-number quota inside OtpService: this one
  // is per IP, and stops one host farming codes across many numbers.
  @Throttle({ default: { limit: 5, ttl: 60_000 } })
  @ApiOperation({ summary: 'Send a login OTP to a phone number' })
  requestOtp(@Body() dto: RequestOtpDto, @Req() req: Request) {
    return this.auth.requestOtp(dto, this.meta(req));
  }

  @Public()
  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({
    summary: 'Verify an OTP',
    description:
      'Returns AUTHENTICATED with tokens for a known number, or NEW_USER with a registration token for a number seen for the first time.',
  })
  verifyOtp(@Body() dto: VerifyOtpDto, @Req() req: Request) {
    return this.auth.verifyOtp(dto, this.meta(req));
  }

  @Public()
  @Post('otp/widget-verify')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({ summary: 'Verify an MSG91 widget access token' })
  verifyWidget(@Body() dto: VerifyWidgetTokenDto, @Req() req: Request) {
    return this.auth.verifyWidgetToken(dto, this.meta(req));
  }

  @Public()
  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @Throttle({ default: { limit: 5, ttl: 60_000 } })
  @ApiOperation({ summary: 'Create an account after OTP verification' })
  register(@Body() dto: RegisterDto, @Req() req: Request) {
    return this.auth.register(dto, this.meta(req));
  }

  @Public()
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 30, ttl: 60_000 } })
  @ApiOperation({ summary: 'Exchange a refresh token for a new token pair' })
  refresh(@Body() dto: RefreshDto, @Req() req: Request) {
    return this.auth.refresh(dto.refreshToken, this.meta(req));
  }

  @ApiBearerAuth()
  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'End the current session' })
  async logout(@CurrentUser() user: AuthUser) {
    await this.auth.logout(user.sessionId);
  }

  @ApiBearerAuth()
  @Post('logout-all')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'End every session for this account' })
  async logoutAll(@CurrentUser() user: AuthUser) {
    await this.auth.logoutEverywhere(user.userId);
  }

  @ApiBearerAuth()
  @Get('me')
  @ApiOperation({ summary: 'The signed-in user' })
  me(@CurrentUser() user: AuthUser) {
    return this.auth.me(user.userId);
  }

  private meta(req: Request): SessionMeta {
    return {
      ip: req.ip ?? null,
      userAgent: req.get('user-agent') ?? null,
    };
  }
}
