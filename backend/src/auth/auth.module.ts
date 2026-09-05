import { forwardRef, Global, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { OtpService } from './otp.service';
import { Msg91Service } from './msg91.service';
import { TokenService } from './token.service';
import { JwtAuthGuard } from './jwt-auth.guard';
import { PaymentsModule } from '../payments/payments.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Global()
@Module({
  imports: [
    // Secrets are passed per-sign/verify call in TokenService so access and
    // refresh use different keys; nothing is registered globally here.
    JwtModule.register({}),
    // Only for CashfreeService, so /auth/config can tell the app which
    // Cashfree environment this server is pointed at.
    forwardRef(() => PaymentsModule),
    // The two onboarding messages the spec asks every new user to be
    // sent land in the inbox at registration.
    forwardRef(() => NotificationsModule),
  ],
  controllers: [AuthController],
  providers: [AuthService, OtpService, Msg91Service, TokenService, JwtAuthGuard],
  exports: [AuthService, OtpService, TokenService, JwtAuthGuard],
})
export class AuthModule {}
