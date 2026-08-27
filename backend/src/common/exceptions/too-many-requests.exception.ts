import { HttpException, HttpStatus } from '@nestjs/common';

/**
 * Nest ships no 429 exception of its own, and throttling shows up in
 * enough places here (OTP issuance, payout requests, login attempts) to
 * be worth a named type rather than a raw HttpException at each site.
 */
export class TooManyRequestsException extends HttpException {
  constructor(message = 'Too many requests. Please try again later.') {
    super(message, HttpStatus.TOO_MANY_REQUESTS);
  }
}
