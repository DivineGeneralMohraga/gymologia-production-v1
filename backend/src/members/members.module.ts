import { Module } from '@nestjs/common';
import { MembersController, MyMembershipController } from './members.controller';
import { MetricsController } from './metrics.controller';
import { MembersService } from './members.service';

@Module({
  controllers: [MembersController, MyMembershipController, MetricsController],
  providers: [MembersService],
  exports: [MembersService],
})
export class MembersModule {}
