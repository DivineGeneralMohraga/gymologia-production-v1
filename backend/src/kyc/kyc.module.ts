import { Module } from '@nestjs/common';
import { KycController } from './kyc.controller';
import { KycService } from './kyc.service';
import { KycReviewController } from './kyc-review.controller';
import { KycReviewService } from './kyc-review.service';
import { UploadsModule } from '../uploads/uploads.module';
import { AdminModule } from '../admin/admin.module';

// UploadsModule supplies StorageService, which mints the short-lived links
// a reviewer opens documents with.
@Module({
  imports: [UploadsModule, AdminModule],
  controllers: [KycController, KycReviewController],
  providers: [KycService, KycReviewService],
  exports: [KycService],
})
export class KycModule {}
