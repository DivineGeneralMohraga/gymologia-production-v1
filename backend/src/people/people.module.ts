import { Global, Module } from '@nestjs/common';
import { PersonLookupService } from './person-lookup.service';

/**
 * Shared by the staff and member add flows, both of which must OTP-verify
 * a phone number before revealing or creating an account.
 */
@Global()
@Module({
  providers: [PersonLookupService],
  exports: [PersonLookupService],
})
export class PeopleModule {}
