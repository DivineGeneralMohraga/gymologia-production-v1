import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_FILTER, APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';

import configuration from './config/configuration';
import { validateEnv } from './config/env.validation';
import { PrismaModule } from './prisma/prisma.module';
import { CommonModule } from './common/common.module';
import { AuthModule } from './auth/auth.module';
import { JwtAuthGuard } from './auth/jwt-auth.guard';
import { RbacModule } from './rbac/rbac.module';
import { GymsModule } from './gyms/gyms.module';
import { StaffModule } from './staff/staff.module';
import { MembersModule } from './members/members.module';
import { AttendanceModule } from './attendance/attendance.module';
import { LeaveModule } from './leave/leave.module';
import { PaymentsModule } from './payments/payments.module';
import { MaintenanceModule } from './maintenance/maintenance.module';
import { EventsModule } from './events/events.module';
import { UploadsModule } from './uploads/uploads.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ExercisesModule } from './exercises/exercises.module';
import { SupportModule } from './support/support.module';
import { LegalModule } from './legal/legal.module';
import { RolesModule } from './roles/roles.module';
import { AdminModule } from './admin/admin.module';
import { ChatModule } from './chat/chat.module';
import { PeopleModule } from './people/people.module';
import { PermissionsGuard } from './rbac/permissions.guard';
import { HealthController } from './health/health.controller';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { InputSanitizerInterceptor } from './common/interceptors/input-sanitizer.interceptor';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validate: validateEnv,
      envFilePath: ['.env'],
      cache: true,
    }),

    // Baseline rate limit for every route. Individual endpoints tighten it
    // with @Throttle — auth and payouts are far stricter than this.
    ThrottlerModule.forRoot([
      { name: 'default', ttl: 60_000, limit: 120 },
    ]),

    ScheduleModule.forRoot(),

    PrismaModule,
    CommonModule,
    RbacModule,
    AuthModule,
    PeopleModule,
    GymsModule,
    StaffModule,
    MembersModule,
    AttendanceModule,
    LeaveModule,
    PaymentsModule,
    MaintenanceModule,
    EventsModule,
    UploadsModule,
    NotificationsModule,
    ExercisesModule,
    SupportModule,
    LegalModule,
    RolesModule,
    AdminModule,
    ChatModule,
  ],
  controllers: [HealthController],
  providers: [
    // Order matters: throttle, then authenticate, then authorize.
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: PermissionsGuard },
    { provide: APP_FILTER, useClass: AllExceptionsFilter },
    { provide: APP_INTERCEPTOR, useClass: InputSanitizerInterceptor },
  ],
})
export class AppModule {}
