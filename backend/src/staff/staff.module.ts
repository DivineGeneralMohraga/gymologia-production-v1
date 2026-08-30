import { Module } from '@nestjs/common';
import { StaffController } from './staff.controller';
import { StaffService } from './staff.service';
import { TrainerCategoriesController } from './trainer-categories.controller';
import { TrainerCategoriesService } from './trainer-categories.service';

@Module({
  controllers: [StaffController, TrainerCategoriesController],
  providers: [StaffService, TrainerCategoriesService],
  exports: [StaffService],
})
export class StaffModule {}
