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

async function main(): Promise<void> {
  await seedExercises();
}

main()
  .catch((error) => {
    process.stderr.write(`Seed failed: ${(error as Error).message}\n`);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
