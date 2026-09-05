/**
 * `npm run prisma:migrate` used to run `prisma migrate dev`. It must not.
 *
 * This database holds the legacy v1 tables alongside the current ones --
 * 66 tables in total, of which only a subset are in schema.prisma. Prisma's
 * dev migration flow diffs the schema against the database and writes SQL to
 * make the database match. Everything it does not know about reads as drift,
 * so it proposes DROPPING every legacy table, and it will offer to reset the
 * database to resolve it. That is not a hypothetical: it is the first thing
 * it does on a schema that does not describe the whole database.
 *
 * So every migration here is written by hand under prisma/migrations/ and
 * applied with `prisma migrate deploy`, which only runs the SQL that is
 * there and never diffs anything.
 *
 * This file exists because the shortest path to the destructive command was
 * a script in package.json that looked like the obvious thing to run.
 */
const RED = '\x1b[31m';
const BOLD = '\x1b[1m';
const OFF = '\x1b[0m';

process.stderr.write(
  `\n${RED}${BOLD}Refused: do not run prisma migrate dev on this database.${OFF}\n\n` +
    'It holds the legacy v1 tables as well as the current ones. Prisma would\n' +
    'diff the schema against them, read them as drift, and propose dropping\n' +
    'all of them -- offering to reset the database to get there.\n\n' +
    `${BOLD}What to do instead${OFF}\n` +
    '  1. Write the SQL by hand:  prisma/migrations/<timestamp>_<name>/migration.sql\n' +
    '  2. Apply it:               npm run prisma:deploy\n' +
    '  3. Regenerate the client:  npm run prisma:generate\n\n' +
    'To inspect what changed without touching anything, prisma migrate diff\n' +
    'is read-only -- but read its output rather than piping it anywhere.\n\n',
);

process.exit(1);
