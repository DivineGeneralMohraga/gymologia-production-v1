/**
 * Which numbers never reach MSG91, and -- the half that matters more --
 * which real numbers still do.
 *
 *   npx ts-node --transpile-only test/dummy-phone.spec.ts
 *
 * On 2026-10-03 test robots typed the login hint 9876543210 a few times and
 * MSG91 blocked the server's IP, so nobody could sign in. Refusing the
 * placeholder numbers prevents that. Refusing a real person's number is
 * the expensive mistake here -- they could never sign up -- so the
 * accepting list is the longer one.
 */
import { isDummyPhone } from '../src/common/utils/phone.util';

let failures = 0;
let checks = 0;

function refuses(phone: string, why: string) {
  checks += 1;
  if (!isDummyPhone(phone)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  let through ${phone} -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  refuses ${phone}\n`);
  }
}

function accepts(phone: string, why: string) {
  checks += 1;
  if (isDummyPhone(phone)) {
    failures += 1;
    process.stdout.write(`  \x1b[31mFAIL\x1b[0m  refused ${phone} -- ${why}\n`);
  } else {
    process.stdout.write(`  \x1b[32mPASS\x1b[0m  accepts ${phone}\n`);
  }
}

console.log('\nPlaceholders');
refuses('+919876543210', 'the old login hint, the one that got the IP blocked');
refuses('+919999999999', 'one digit repeated');
refuses('+916666666666', 'one digit repeated');
refuses('+917777777777', 'one digit repeated');
refuses('+916789012345', 'a straight run up, wrapping past 9');
refuses('+918765432109', 'a straight run down, wrapping past 0');
refuses('+919123456789', 'well known');
refuses('+919988776655', 'well known');
refuses('+919898989898', 'well known');
refuses('+919000000000', 'well known');

console.log('\nReal-looking numbers that must still get a code');
for (const phone of [
  '+918178848820',
  '+918860267251',
  '+919812345670',
  '+917003456789',
  '+919876543211',
  '+919876500000',
  '+916123456780',
  '+919999999998',
  '+918888888889',
  '+919988776654',
  '+919090909091',
  '+919823456781',
]) {
  accepts(phone, 'an ordinary or near-miss number');
}

console.log('\nOutside India the rule does not apply');
accepts('+14155552671', 'a US number');
accepts('+447911123456', 'a UK number');
accepts('+11234567890', 'even a sequential one; MSG91 is India-only here');

console.log(`\n${checks} checks, ${failures} failed`);
if (failures) {
  console.log('\x1b[31mSOME CHECKS FAILED\x1b[0m');
  process.exit(1);
}
console.log('\x1b[32mALL CHECKS PASSED\x1b[0m');
