import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { AdminContext } from './admin.guard';

/** The admin record resolved by AdminGuard. */
export const CurrentAdmin = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AdminContext => {
    const request = ctx.switchToHttp().getRequest<{ admin?: AdminContext }>();
    if (!request.admin) {
      throw new Error(
        'CurrentAdmin used on a route without AdminGuard — add @UseGuards(AdminGuard).',
      );
    }
    return request.admin;
  },
);
