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
import { isBlockedName, isBlockedText } from '../src/common/validation/clean-name';

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

console.log('\nLoud but honest gym and event names (kept lenient on purpose)');
for (const name of [
  'Unisex Gym', 'Unisex Fitness Studio', 'Middlesex Fitness', 'Essex Barbell',
  'Sexton Gym', 'Bad Ass Fitness', 'Badass Gym', 'Kick Ass Bootcamp',
  'Sexy Abs Challenge', 'Tit Bits Gym', 'Moby Dick Fitness', 'Dick Gym',
  'Pussycat Dance Studio', 'Hot Yoga Studio', 'Hardcore Gym', 'Beast Mode Gym',
  'Kill Zone Fitness', 'Booty Camp', 'Six Pack Factory', 'Hot Body Gym',
  'Titan Gym', 'Cockpit Gym', 'Peacock Fitness', 'Hornbill Fitness',
  'Rapeseed Gym', 'Therapist Gym', 'Phuket Fitness', 'Fitness 365',
  'Power House 24x7', 'F45 Training', "Gold's Gym", 'Shiv Shakti Gym',
  'Jai Hanuman Vyayamshala', 'Summer Deadlift Meet', 'Mass Monster Gym',
]) {
  accepts(name, 'a real-world style gym or event name');
}

console.log('\nWhat it is for');
refuses('Sex Bot', 'the account that prompted this');
refuses('SexBot', 'run together');
refuses('S3x Bot', 'digit for a letter');
refuses('$ex Queen', 'symbol for a letter');
refuses('Sexgym', 'prefix, not one of the safe words');
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

// ── Free text: event descriptions, prizes, gym descriptions ────────────

function textAccepts(text: string, why: string) {
  checks += 1;
  if (isBlockedText(text)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  refused text "${text}" -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  accepts text "${text}"\n`);
  }
}

function textRefuses(text: string, why: string) {
  checks += 1;
  if (!isBlockedText(text)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  let through text "${text}" -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  refuses text "${text}"\n`);
  }
}

console.log('\nEvent and gym text that must go through');
textAccepts('Mixed-sex teams of four. Unisex changing rooms.', '"sex" in ordinary use');
textAccepts('Anti-rape self defence workshop for women, free entry.', 'a real workshop');
textAccepts('Upload max videos of your lifts before 5 pm.', '"max videos" is not "xvideos"');
textAccepts('Batch @5:55 am, fee Rs 499, prize Rs 5,000 + 1 year free.', 'prices and times, not look-alikes');
textAccepts('Kick ass bootcamp. Bring water and a towel.', 'loud, not abusive');
textAccepts('Nude-colour kit is fine. Sexy abs in 30 days!', 'marketing');
textAccepts('Gandhinagar district open meet. Contact the admin desk.', 'place name; "admin" is fine in text');
textAccepts('Shital, Dikshit and Randip are the judges.', 'real names');
textAccepts('पुरुष और महिला दोनों भाग ले सकते हैं। सेक्स अनुपात बराबर रहेगा।', 'Hindi; सेक्स alone is allowed in text');
textAccepts('', 'empty');

console.log('\nEvent and gym text that must not');
textRefuses('Winner gets free porn subscription', 'explicit');
textRefuses('Losers are bitches', 'abuse');
textRefuses('Fucking hard workout', 'profanity');
textRefuses('Bhenchod jo nahi aaya', 'Hindi compound');
textRefuses('Sab chutiya hai', 'Hindi');
textRefuses('मादरचोद', 'Devanagari');
textRefuses('Go to xvideos for the rules', 'explicit site');

console.log(`\n${checks} checks, ${failures} failed`);
if (failures) {
  console.log('\x1b[31mSOME CHECKS FAILED\x1b[0m');
  process.exit(1);
}
console.log('\x1b[32mALL CHECKS PASSED\x1b[0m');
