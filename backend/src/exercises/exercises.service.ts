import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ListExercisesDto } from './dto/exercise.dto';

/**
 * The exercise directory.
 *
 * Content is seeded rather than user-generated, so this is read-only from
 * the API's point of view. Text comes from ExerciseTranslation, which
 * falls back to English when a locale has not been translated yet —
 * showing an English name beats showing an empty screen.
 */
@Injectable()
export class ExercisesService {
  constructor(private readonly prisma: PrismaService) {}

  async list(dto: ListExercisesDto, locale = 'en') {
    const where: Prisma.ExerciseWhereInput = {
      isPublished: true,
      ...(dto.discipline ? { discipline: dto.discipline } : {}),
      ...(dto.muscle ? { primaryMuscle: dto.muscle } : {}),
      ...(dto.goal ? { goals: { has: dto.goal } } : {}),
      ...(dto.difficulty ? { difficulty: dto.difficulty } : {}),
      ...(dto.query
        ? {
            translations: {
              some: {
                name: { contains: dto.query, mode: 'insensitive' },
              },
            },
          }
        : {}),
    };

    const exercises = await this.prisma.exercise.findMany({
      where,
      include: {
        translations: {
          where: { locale: { in: [locale, 'en'] } },
        },
      },
      orderBy: [{ primaryMuscle: 'asc' }, { difficulty: 'asc' }],
    });

    return exercises.map((e) => this.shape(e, locale, false));
  }

  async findOne(slug: string, locale = 'en') {
    const exercise = await this.prisma.exercise.findFirst({
      where: { slug, isPublished: true },
      include: {
        translations: { where: { locale: { in: [locale, 'en'] } } },
      },
    });
    if (!exercise) throw new NotFoundException('Exercise not found');

    return this.shape(exercise, locale, true);
  }

  /**
   * The filter options, counted from what is actually in the directory.
   * Derived rather than hardcoded so a filter never offers a category with
   * nothing behind it.
   */
  async filters() {
    const [byMuscle, byDiscipline, byDifficulty] = await Promise.all([
      this.prisma.exercise.groupBy({
        by: ['primaryMuscle'],
        where: { isPublished: true },
        _count: { _all: true },
      }),
      this.prisma.exercise.groupBy({
        by: ['discipline'],
        where: { isPublished: true },
        _count: { _all: true },
      }),
      this.prisma.exercise.groupBy({
        by: ['difficulty'],
        where: { isPublished: true },
        _count: { _all: true },
      }),
    ]);

    const total = await this.prisma.exercise.count({ where: { isPublished: true } });

    return {
      total,
      muscles: byMuscle
        .map((m) => ({ value: m.primaryMuscle, count: m._count._all }))
        .sort((a, b) => b.count - a.count),
      disciplines: byDiscipline
        .map((d) => ({ value: d.discipline, count: d._count._all }))
        .sort((a, b) => b.count - a.count),
      difficulties: byDifficulty.map((d) => ({
        value: d.difficulty,
        count: d._count._all,
      })),
    };
  }

  private shape(
    exercise: Prisma.ExerciseGetPayload<{ include: { translations: true } }>,
    locale: string,
    full: boolean,
  ) {
    // Prefer the requested locale, fall back to English.
    const text =
      exercise.translations.find((t) => t.locale === locale) ??
      exercise.translations.find((t) => t.locale === 'en');

    return {
      slug: exercise.slug,
      name: text?.name ?? exercise.slug,
      summary: text?.summary ?? null,
      discipline: exercise.discipline,
      primaryMuscle: exercise.primaryMuscle,
      goals: exercise.goals,
      difficulty: exercise.difficulty,
      equipment: exercise.equipment,
      imageUrl: exercise.imageUrl,
      videoUrl: exercise.videoUrl,
      /** Only the detail view carries the steps; the list would be huge. */
      ...(full
        ? {
            steps: text?.steps ?? [],
            cautions: text?.cautions ?? [],
            translated: text?.locale === locale,
          }
        : { stepCount: text?.steps.length ?? 0 }),
    };
  }
}
