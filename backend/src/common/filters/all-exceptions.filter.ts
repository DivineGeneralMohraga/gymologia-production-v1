import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { httpForPrisma } from './prisma-http';
import type { Request, Response } from 'express';
import { randomUUID } from 'node:crypto';

interface ErrorBody {
  statusCode: number;
  message: string | string[];
  error: string;
  /** Correlates what the user saw with what the logs recorded. */
  reference: string;
  timestamp: string;
  path: string;
}

/**
 * The single exit point for errors.
 *
 * Two jobs. First, translate Prisma's database errors into HTTP responses
 * that say something useful without describing the schema — a unique
 * constraint violation becomes "already exists", not the column name and
 * table it fired on. Second, make sure an unhandled exception never sends
 * a stack trace to a phone; the client gets a reference id, the log gets
 * the detail.
 */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger('ExceptionFilter');

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const reference = randomUUID();

    const { status, message, error, logLevel } = this.translate(exception);

    const body: ErrorBody = {
      statusCode: status,
      message,
      error,
      reference,
      timestamp: new Date().toISOString(),
      path: request.url,
    };

    const context = `${request.method} ${request.url} ref=${reference}`;
    if (logLevel === 'error') {
      this.logger.error(
        `${context} — ${this.describe(exception)}`,
        exception instanceof Error ? exception.stack : undefined,
      );
    } else {
      this.logger.warn(`${context} — ${this.describe(exception)}`);
    }

    response.status(status).json(body);
  }

  private translate(exception: unknown): {
    status: number;
    message: string | string[];
    error: string;
    logLevel: 'warn' | 'error';
  } {
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const payload = exception.getResponse();
      const message =
        typeof payload === 'string'
          ? payload
          : ((payload as { message?: string | string[] }).message ??
            exception.message);
      return {
        status,
        message,
        error: HttpStatus[status] ?? 'Error',
        logLevel: status >= 500 ? 'error' : 'warn',
      };
    }

    // Both Prisma error classes, not just the known-request one: a
    // database that has gone away arrives as a
    // PrismaClientInitializationError, and inspecting only the other class
    // sent exactly that case to the generic 500 below.
    const mapped = httpForPrisma(exception);
    if (mapped) {
      return {
        ...mapped,
        logLevel:
          mapped.status >= HttpStatus.INTERNAL_SERVER_ERROR ? 'error' : 'warn',
      };
    }

    if (exception instanceof Prisma.PrismaClientValidationError) {
      // A malformed query is our bug, not the caller's — but the shape of
      // the query is not something to hand back.
      return {
        status: HttpStatus.BAD_REQUEST,
        message: 'The request could not be processed',
        error: 'Bad Request',
        logLevel: 'error',
      };
    }

    return {
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      message: 'Something went wrong. Quote the reference id to support.',
      error: 'Internal Server Error',
      logLevel: 'error',
    };
  }

  private describe(exception: unknown): string {
    if (exception instanceof Prisma.PrismaClientKnownRequestError) {
      return `Prisma ${exception.code}: ${exception.message.split('\n').pop()}`;
    }
    if (exception instanceof Error) return exception.message;
    return String(exception);
  }
}
