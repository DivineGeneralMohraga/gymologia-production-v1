/**
 * Does every language actually cover the directory?
 *
 *   npx ts-node --transpile-only test/exercise-translations.spec.ts
 *
 * This exists because nothing was checking, and the gap it found was not
 * small. English has 27 exercises. Hindi, Tamil, Bengali and Telugu each
 * had 24, and all four were missing the same three -- deadlift, plank and
 * balasana. The translation tables had been built from a list that was
 * short, and every language inherited the same hole.
 *
 * A missing entry does not fail. It falls back to English, quietly, which
 * is the worst way for this to go wrong: the member sees a screen that
 * works, in a language they may not read, and nobody is told. The one that
 * mattered was the deadlift -- the most injury-prone lift in the set, whose
 * cautions are the exact text you want a member reading in their own
 * language before they round their back under a heavy bar.
 *
 * So this checks three things, in the order they cost a member something:
 *
 *   1. every English slug exists in every locale
 *   2. no locale invents a slug English does not have (a typo'd key is a
 *      silent fallback that looks like a translation)
 *   3. no entry drops a caution, or ships an empty string
 *
 * Point 3 is not pedantry. Translating four steps as three loses a set.
 * Translating two cautions as one loses the half of the warning the
 * translator found hard to phrase, which is reliably the half that matters.
 */
import { EXERCISES } from '../prisma/exercises.seed';
import { EXERCISE_TRANSLATIONS, ExerciseText } from '../prisma/exercise-translations';

let failures = 0;
let checks = 0;

function ok(what: string) {
  checks += 1;
  process.stdout.write(`  \x1b[32mPASS\x1b[0m  ${what}\n`);
}
function bad(what: string, detail: string) {
  checks += 1;
  failures += 1;
  process.stdout.write(`  \x1b[31mFAIL\x1b[0m  ${what} -- ${detail}\n`);
}
function hdr(what: string) {
  process.stdout.write(`\n\x1b[1m${what}\x1b[0m\n`);
}

const english = new Map(EXERCISES.map((e) => [e.slug, e]));
const locales = Object.keys(EXERCISE_TRANSLATIONS).sort();

hdr('Coverage');
if (locales.length === 0) bad('some locale is translated', 'the table is empty');

for (const locale of locales) {
  const entries = EXERCISE_TRANSLATIONS[locale];
  const missing = [...english.keys()].filter((slug) => !(slug in entries));
  if (missing.length === 0) {
    ok(`${locale} covers all ${english.size} exercises`);
  } else {
    bad(
      `${locale} covers all ${english.size} exercises`,
      `${missing.length} missing: ${missing.join(', ')}`,
    );
  }

  const unknown = Object.keys(entries).filter((slug) => !english.has(slug));
  if (unknown.length === 0) {
    ok(`${locale} has no slug English does not`);
  } else {
    bad(
      `${locale} has no slug English does not`,
      `${unknown.join(', ')} -- a key that matches nothing falls back silently`,
    );
  }
}

hdr('Nothing empty, nothing dropped');
for (const locale of locales) {
  const entries = EXERCISE_TRANSLATIONS[locale];
  const empty: string[] = [];
  const shortSteps: string[] = [];
  const shortCautions: string[] = [];

  for (const [slug, text] of Object.entries(entries) as [string, ExerciseText][]) {
    const source = english.get(slug);
    if (!source) continue;

    const blank =
      !text.name?.trim() ||
      !text.summary?.trim() ||
      text.steps.some((s) => !s.trim()) ||
      text.cautions.some((c) => !c.trim());
    if (blank) empty.push(slug);

    if (text.steps.length !== source.steps.length) {
      shortSteps.push(`${slug} (${text.steps.length} vs ${source.steps.length})`);
    }
    if (text.cautions.length !== source.cautions.length) {
      shortCautions.push(
        `${slug} (${text.cautions.length} vs ${source.cautions.length})`,
      );
    }
  }

  if (empty.length === 0) ok(`${locale} has no blank field`);
  else bad(`${locale} has no blank field`, empty.join(', '));

  if (shortSteps.length === 0) ok(`${locale} keeps every step`);
  else bad(`${locale} keeps every step`, shortSteps.join(', '));

  if (shortCautions.length === 0) ok(`${locale} keeps every caution`);
  else bad(`${locale} keeps every caution`, shortCautions.join(', '));
}

hdr('Which languages are done');
// English is not in this table -- it is the source, in exercises.seed.ts --
// so counting only the table understates the coverage by one. The app ships
// ten languages; the honest figure is English plus however many are here.
const APP_LOCALES = 10;
const done = locales.filter(
  (l) => [...english.keys()].every((s) => s in EXERCISE_TRANSLATIONS[l]),
);
const covered = done.length + 1;
process.stdout.write(
  `  ${covered} of ${APP_LOCALES} app languages have the full directory:\n`,
);
process.stdout.write(
  `  en (the source) plus ${done.join(', ') || 'none'}\n`,
);
if (covered < APP_LOCALES) {
  process.stdout.write(
    `  the rest fall back to English, and the API says so per entry\n`,
  );
}

process.stdout.write('\n');
if (failures > 0) {
  process.stdout.write(`\x1b[31m${failures} of ${checks} checks FAILED\x1b[0m\n`);
  process.exit(1);
}
process.stdout.write(`\x1b[32mALL ${checks} CHECKS PASSED\x1b[0m\n`);
