import { HttpStatus } from '@nestjs/common';
import { Prisma } from '@prisma/client';

/**
 * Turning a Prisma failure into an HTTP answer.
 *
 * Pulled out of AllExceptionsFilter so it can be tested directly, and
 * because getting it wrong is quiet: every unmapped code lands on a 500
 * saying "quote the reference id to support", which is the wrong thing to
 * tell somebody about a condition that fixes itself.
 *
 * THE PART THAT IS EASY TO GET WRONG. Prisma reports connection failures
 * through TWO different classes, and only one of them was being inspected:
 *
 *   P2024  pool timeout          -> PrismaClientKnownRequestError
 *   P1001  can't reach server    -> PrismaClientInitializationError
 *   P1002  server timed out      -> PrismaClientInitializationError
 *   P1017  server closed it      -> PrismaClientInitializationError
 *
 * A filter that only handles the first class maps the pool timeout to 503
 * and lets every genuine "the database is gone" fall through to a 500 --
 * which is the exact case the mapping exists for, and it would have looked
 * correct in review. That was confirmed by watching a boot against a dead
 * host: `PrismaClientInitializationError ... errorCode: 'P1001'`.
 */

/**
 * Codes meaning the database was unreachable rather than the request being
 * wrong. The correct answer is 503: the caller is fine, we are not, and
 * trying again shortly is the right response.
 *
 * The distinction matters beyond wording. A 500 tells a load balancer, a
 * mobile client and a retrying job that the request itself is bad; a 503
 * tells all three the service is briefly unavailable. Only one is true.
 */
export const TRANSIENT_DB_CODES: ReadonlySet<string> = new Set([
  'P1001', // can't reach database server
  'P1002', // database server timed out
  'P1008', // operation timed out
  'P1017', // server has closed the connection
  'P2024', // timed out fetching a connection from the pool
]);

/** The Prisma error code, whichever class carried it, or null. */
export function prismaErrorCode(error: unknown): string | null {
  if (error instanceof Prisma.PrismaClientKnownRequestError) return error.code;
  if (error instanceof Prisma.PrismaClientInitializationError) {
    return error.errorCode ?? null;
  }
  return null;
}

export function isTransientDbError(error: unknown): boolean {
  const code = prismaErrorCode(error);
  return code !== null && TRANSIENT_DB_CODES.has(code);
}

export interface HttpAnswer {
  status: number;
  message: string;
  error: string;
}

/**
 * The HTTP answer for a Prisma error, or null when it is not one we have a
 * specific answer for and the caller should fall through to its default.
 */
export function httpForPrisma(error: unknown): HttpAnswer | null {
  const code = prismaErrorCode(error);
  if (code === null) return null;

  if (TRANSIENT_DB_CODES.has(code)) {
    return {
      status: HttpStatus.SERVICE_UNAVAILABLE,
      message: 'The service is briefly unavailable. Please try again.',
      error: 'Service Unavailable',
    };
  }

  switch (code) {
    case 'P2002':
      return {
        status: HttpStatus.CONFLICT,
        message: 'This record already exists',
        error: 'Conflict',
      };
    case 'P2003':
      return {
        status: HttpStatus.BAD_REQUEST,
        message: 'Referenced record does not exist',
        error: 'Bad Request',
      };
    case 'P2025':
      return {
        status: HttpStatus.NOT_FOUND,
        message: 'Record not found',
        error: 'Not Found',
      };
    case 'P2014':
      return {
        status: HttpStatus.BAD_REQUEST,
        message: 'This change would break a required relation',
        error: 'Bad Request',
      };
    default:
      return null;
  }
}
