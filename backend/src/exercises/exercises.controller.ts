import { Controller, Get, Headers, Param, Query } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ExercisesService } from './exercises.service';
import { normalizeLocale } from '../common/utils/locale';
import { ListExercisesDto } from './dto/exercise.dto';
import { Public } from '../rbac/rbac.decorators';

/**
 * The exercise directory.
 *
 * Public: it is reference content, and letting someone browse it before
 * they have an account is a reason to download the app rather than a leak.
 */
@ApiTags('exercises')
@Controller('exercises')
export class ExercisesController {
  constructor(private readonly exercises: ExercisesService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Browse the directory' })
  list(
    @Query() dto: ListExercisesDto,
    @Headers('accept-language') locale?: string,
  ) {
    return this.exercises.list(dto, normalizeLocale(locale));
  }

  @Public()
  @Get('filters')
  @ApiOperation({
    summary: 'Filter options with counts',
    description: 'Derived from what is in the directory, so no filter is ever empty.',
  })
  filters() {
    return this.exercises.filters();
  }

  @Public()
  @Get(':slug')
  @ApiOperation({ summary: 'One exercise, with its steps' })
  findOne(
    @Param('slug') slug: string,
    @Headers('accept-language') locale?: string,
  ) {
    return this.exercises.findOne(slug, normalizeLocale(locale));
  }
}
