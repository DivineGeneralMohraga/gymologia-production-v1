/**
 * Seeds the content the app ships with, as opposed to data users create.
 *
 * Idempotent: every entry is upserted by slug, so running it again after
 * editing the source updates rather than duplicates. Safe on a live
 * database.
 *
 *   npm run seed
 */
import { PrismaClient } from '@prisma/client';
import { EXERCISES } from './exercises.seed';
import { EXERCISE_TRANSLATIONS } from './exercise-translations';

const prisma = new PrismaClient();

async function seedExercises(): Promise<void> {
  let created = 0;
  let updated = 0;

  for (const entry of EXERCISES) {
    const existing = await prisma.exercise.findUnique({
      where: { slug: entry.slug },
      select: { id: true },
    });

    const exercise = await prisma.exercise.upsert({
      where: { slug: entry.slug },
      create: {
        slug: entry.slug,
        discipline: entry.discipline,
        primaryMuscle: entry.primaryMuscle,
        goals: entry.goals,
        difficulty: entry.difficulty,
        equipment: entry.equipment ?? null,
      },
      update: {
        discipline: entry.discipline,
        primaryMuscle: entry.primaryMuscle,
        goals: entry.goals,
        difficulty: entry.difficulty,
        equipment: entry.equipment ?? null,
      },
    });

    await prisma.exerciseTranslation.upsert({
      where: {
        exerciseId_locale: { exerciseId: exercise.id, locale: 'en' },
      },
      create: {
        exerciseId: exercise.id,
        locale: 'en',
        name: entry.name,
        summary: entry.summary,
        steps: entry.steps,
        cautions: entry.cautions,
      },
      update: {
        name: entry.name,
        summary: entry.summary,
        steps: entry.steps,
        cautions: entry.cautions,
      },
    });

    if (existing) updated += 1;
    else created += 1;
  }

  process.stdout.write(
    `Exercises: ${created} created, ${updated} updated (${EXERCISES.length} total)\n`,
  );
}

/**
 * The translated copies of that content.
 *
 * A slug that does not exist in the English seed would write a row no
 * query can reach -- the directory looks exercises up by slug and joins
 * translations by id -- so a typo would sit in the database looking
 * translated and render English forever. It is refused here instead.
 */
async function seedExerciseTranslations(): Promise<void> {
  const ids = new Map(
    (await prisma.exercise.findMany({ select: { id: true, slug: true } })).map(
      (e) => [e.slug, e.id],
    ),
  );

  for (const [locale, entries] of Object.entries(EXERCISE_TRANSLATIONS)) {
    const unknown = Object.keys(entries).filter((slug) => !ids.has(slug));
    if (unknown.length) {
      throw new Error(
        `${locale}: no exercise with slug ${unknown.join(', ')}. ` +
          'Fix the slug, or seed the English entry first.',
      );
    }

    for (const [slug, text] of Object.entries(entries)) {
      const exerciseId = ids.get(slug)!;
      await prisma.exerciseTranslation.upsert({
        where: { exerciseId_locale: { exerciseId, locale } },
        create: {
          exerciseId,
          locale,
          name: text.name,
          summary: text.summary,
          steps: text.steps,
          cautions: text.cautions,
        },
        update: {
          name: text.name,
          summary: text.summary,
          steps: text.steps,
          cautions: text.cautions,
        },
      });
    }

    const missing = EXERCISES.filter((e) => !entries[e.slug]).length;
    process.stdout.write(
      `Exercises [${locale}]: ${Object.keys(entries).length} translated` +
        (missing ? `, ${missing} still falling back to English` : '') +
        '\n',
    );
  }
}

async function main(): Promise<void> {
  await seedExercises();
  await seedExerciseTranslations();
}

main()
  .catch((error) => {
    process.stderr.write(`Seed failed: ${(error as Error).message}\n`);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
