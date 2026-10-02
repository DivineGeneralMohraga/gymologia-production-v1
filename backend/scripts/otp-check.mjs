#!/usr/bin/env node
// Checks that OTP login works end to end against a Gymologia server:
// asks the server to send a code, waits for you to type the code from the
// SMS, and has the server verify it.
//
//   node scripts/otp-check.mjs 8860267251
//   node scripts/otp-check.mjs 8860267251 http://localhost:3000   (local)
//
// It never creates an account: a number with no account stops at
// "new user". A number that has one is signed in and immediately signed
// out again, so no session is left behind. Needs Node 18+.
import readline from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';

const [, , rawPhone, rawBase] = process.argv;
const base = (rawBase || 'https://api.gymologia.com').replace(/\/+$/, '') + '/api/v1';

const digits = (rawPhone || '').replace(/\D/g, '').replace(/^91(?=\d{10}$)/, '');
if (!/^[6-9]\d{9}$/.test(digits)) {
  console.log('Usage: node scripts/otp-check.mjs <10-digit mobile number> [server]');
  process.exit(1);
}
const phone = `+91${digits}`;

async function call(method, path, body, token) {
  const res = await fetch(base + path, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  let json = null;
  try { json = await res.json(); } catch { /* no body */ }
  return { status: res.status, json };
}

const say = (ok, text) => console.log(`${ok ? '✅' : '❌'} ${text}`);
const message = (j) => (Array.isArray(j?.message) ? j.message.join('; ') : j?.message) ?? 'no details';

console.log(`\nServer : ${base}`);
console.log(`Number : ${phone}\n`);

// 1. Ask the server to send the code.
const sent = await call('POST', '/auth/otp/request', { phone, appClient: 'MEMBER' });
if (!sent.json?.challengeId) {
  say(false, `Server did not send a code (HTTP ${sent.status}): ${message(sent.json)}`);
  process.exit(1);
}
say(true, `Server accepted the request and asked MSG91 to send an SMS to ${sent.json.phoneMasked ?? phone}.`);
if (sent.json.devCode) {
  console.log(`   (dev server: the code is ${sent.json.devCode} -- no SMS is sent in this mode)`);
}

// 2. Wait for the person holding the phone.
const rl = readline.createInterface({ input, output });
const code = (await rl.question('\nType the code from the SMS (or press Enter if none came): ')).trim();
rl.close();
if (!code) {
  say(false, 'No SMS arrived. Check msg91.com -> OTP -> Logs for this number to see why.');
  process.exit(1);
}

// 3. Have the server check it.
const verified = await call('POST', '/auth/otp/verify', {
  phone, code, challengeId: sent.json.challengeId, appClient: 'MEMBER',
});
const outcome = verified.json?.status;

if (verified.status >= 300 || !outcome) {
  say(false, `Code rejected (HTTP ${verified.status}): ${message(verified.json)}`);
  process.exit(1);
}
if (outcome === 'NEW_USER') {
  say(true, 'Code verified. This number has no account yet -- sign-up would continue from here.');
} else if (outcome === 'AUTHENTICATED') {
  await call('POST', '/auth/logout', null, verified.json.tokens?.accessToken);
  say(true, `Code verified. Signed in as "${verified.json.user?.name ?? 'existing account'}", then signed out again.`);
} else {
  say(true, `Code verified (${outcome}).`);
}
console.log('\nOTP login works with this server. 🎉\n');
