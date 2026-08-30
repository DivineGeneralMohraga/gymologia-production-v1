import { Module } from '@nestjs/common';
import { LegalAcceptanceController, LegalController } from './legal.controller';

@Module({
  controllers: [LegalController, LegalAcceptanceController],
})
export class LegalModule {}
