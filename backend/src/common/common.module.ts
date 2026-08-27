import { Global, Module } from '@nestjs/common';
import { CryptoService } from './crypto/crypto.service';
import { SecurityEventService } from './security/security-event.service';
import { AuditService } from './audit/audit.service';

/**
 * Cross-cutting services every feature module leans on. Global so they do
 * not have to be re-imported in a dozen places.
 */
@Global()
@Module({
  providers: [CryptoService, SecurityEventService, AuditService],
  exports: [CryptoService, SecurityEventService, AuditService],
})
export class CommonModule {}
