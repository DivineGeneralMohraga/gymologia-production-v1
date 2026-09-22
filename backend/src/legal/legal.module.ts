import { Module } from '@nestjs/common';
import { LegalAcceptanceController, LegalController } from './legal.controller';
import { LegalPageController } from './legal-page.controller';

@Module({
  controllers: [LegalController, LegalAcceptanceController, LegalPageController],
})
export class LegalModule {}
