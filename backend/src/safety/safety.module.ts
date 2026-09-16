import { Module } from '@nestjs/common';
import { SafetyController } from './safety.controller';
import { SafetyService } from './safety.service';
import { SafetyReviewController } from './safety-review.controller';
import { SafetyReviewService } from './safety-review.service';
import { AdminModule } from '../admin/admin.module';

/**
 * Blocking and reporting, plus the desk that reads the reports.
 *
 * SafetyService is exported because the chat has to consult it on every
 * read and every send -- a block the chat does not know about is a button
 * that does nothing.
 *
 * AdminModule is imported for AdminGuard alone, the same way the KYC
 * review desk does it.
 */
@Module({
  imports: [AdminModule],
  controllers: [SafetyController, SafetyReviewController],
  providers: [SafetyService, SafetyReviewService],
  exports: [SafetyService],
})
export class SafetyModule {}
