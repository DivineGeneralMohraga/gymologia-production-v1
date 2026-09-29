/**
 * Which names are refused, and -- the half that matters more -- which are not.
 *
 *   npx ts-node --transpile-only test/clean-name.spec.ts
 *
 * A filter like this fails in two directions, and they are not equally
 * bad. Letting "Sex Bot" through puts one ugly name on some screens until
 * somebody reports it. Refusing "Dikshit" tells a real person their own
 * name is obscene, at sign-up, with no way round it -- and Indian names
 * contain these letter runs constantly. So the accepting list below is
 * long on purpose and built from the names most likely to trip a naive
 * filter, and any term added to the blocklist has to get past all of it.
 */
import { isBlockedName } from '../src/common/validation/clean-name';

let failures = 0;
let checks = 0;

function accepts(name: string, why: string) {
  checks += 1;
  if (isBlockedName(name)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  refused "${name}" -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  accepts "${name}"\n`);
  }
}

function refuses(name: string, why: string) {
  checks += 1;
  if (!isBlockedName(name)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  let through "${name}" -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  refuses "${name}"\n`);
  }
}

console.log('\nReal names that contain a blocked string');
accepts('Dikshit Sharma', 'contains "shit"');
accepts('Shital Patil', 'contains "shit"');
accepts('Shitij Verma', 'contains "shit"');
accepts('Randip Singh', 'contains "randi"');
accepts('Randhir Kapoor', 'starts like "rand"');
accepts('Mohandas Gandhi', 'contains "gand"');
accepts('Hassan Ali', 'contains "ass"');
accepts('Assam Fitness', 'contains "ass"');
accepts('Prasad Rao', 'a common name, near "ass"');
accepts('Bhaskar Reddy', 'a common name');
accepts('Anuj Saxena', 'Saxena is not "sex"');
accepts('Lakshmi Lodha', 'Lodha is not "lodu"');
accepts('Kamini Iyer', 'Kamini is a real name');
accepts('Ammu Kutti', 'Kutti is an everyday Tamil/Malayalam name');
accepts('Bob Mathew', '"boob" must not collapse into "bob"');
accepts('Pooja Chutia', 'Chutia is an Assamese community surname');
accepts('M C Mary Kom', 'initials M C');
accepts('B C Roy', 'initials B C');
accepts('S K Gupta', 'initials');
accepts('Mitali Das', 'contains "tit"');
accepts('Titiksha Rao', 'starts with "tit"');
accepts('Sussex Street Gym', 'contains "sex" mid-word');
accepts('Cumbum Fitness', 'Cumbum is a town in Tamil Nadu');
accepts('Scunthorpe', 'the classic false positive');
accepts('Gandiv', 'गांडीव in Latin script');
accepts('गांडीव शर्मा', 'contains गांड');
accepts('लंडन फिटनेस', 'contains लंड');
accepts('राहुल शर्मा', 'ordinary Devanagari name');
accepts('Ramesh Kumar', 'ordinary name');
accepts('Priya', 'single name');

console.log('\nThe gyms and test fixtures already in the database');
for (const name of [
  'Iron Pulse Fitness', 'PeakForm Gym', 'Capital Strength Club',
  'Marina Muscle Works', 'Nizam Fitness Hub', 'Howrah Iron Works',
  'Sabarmati Sculpt Studio', 'Pink City Powerhouse', 'Apex Fitness Pune - PRO',
  'Rank Owner One', 'Member Vikram', 'Curious Member', 'Support Person',
  'Support Agent', 'Platform Owner', 'KYC Reviewer', 'Safety Owner',
  'Expiry Test Gym', 'Review Test Gym 0977', 'BUGFIX-TEST-USER',
  'DEMO-SEED-OWNER', 'Play Reviewer', 'Ordinary Person',
]) {
  accepts(name, 'already in use');
}

console.log('\nWhat it is for');
refuses('Sex Bot', 'the account that prompted this');
refuses('SexBot', 'run together');
refuses('S3x Bot', 'digit for a letter');
refuses('$exy Queen', 'symbol for a letter');
refuses('Seeexxx', 'stretched letters');
refuses('S E X', 'spaced out');
refuses('s.e.x', 'dotted');
refuses('Fuck You', 'plain');
refuses('Motherfucker', 'compound');
refuses('Madarchod', 'Hindi compound');
refuses('BhenChod Singh', 'Hindi compound with a surname');
refuses('Bhosdike', 'Hindi');
refuses('Chutiya', 'Hindi insult spelling');
refuses('Gandu Gym', 'Hindi, whole word');
refuses('Randi', 'Hindi, whole word');
refuses('Lund Fitness', 'Hindi, whole word');
refuses('Harami', 'Hindi');
refuses('Bitch Please', 'English');
refuses('Porn Hub', 'split');
refuses('PornKing', 'prefix');
refuses('मादरचोद', 'Devanagari');
refuses('चूतिया इंसान', 'Devanagari');
refuses('Nigga', 'slur');

console.log('\nNames that pass for the platform');
refuses('Gymologia', 'the platform');
refuses('Gymologia Support', 'impersonation');
refuses('GYMOLOGIA', 'case');
refuses('Gym0logia', 'look-alike digit');
refuses('Admin', 'staff impersonation');
refuses('Customer Care', 'phrase');
refuses('Gymologia Help Desk', 'phrase');

console.log(`\n${checks} checks, ${failures} failed`);
if (failures) {
  console.log('\x1b[31mSOME CHECKS FAILED\x1b[0m');
  process.exit(1);
}
console.log('\x1b[32mALL CHECKS PASSED\x1b[0m');
