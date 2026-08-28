import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { MembersService } from './members.service';
import { CurrentUser, AuthUser } from '../rbac/rbac.decorators';
import { RecordMetricDto } from './dto/member.dto';

/**
 * The monthly weight and height check-in.
 *
 * Separate from memberships on purpose: a person's body metrics belong to
 * them, not to a gym. They survive leaving one gym and joining another.
 */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/metrics')
export class MetricsController {
  constructor(private readonly members: MembersService) {}

  @Get()
  @ApiOperation({
    summary: 'My weight and height history',
    description: 'checkInDue is true when the last entry is over a month old, or there is none.',
  })
  mine(@CurrentUser() user: AuthUser) {
    return this.members.myMetrics(user.userId);
  }

  @Post()
  @ApiOperation({ summary: 'Record this month\u2019s weight and height' })
  record(@CurrentUser() user: AuthUser, @Body() dto: RecordMetricDto) {
    return this.members.recordMetric(user.userId, dto);
  }
}
