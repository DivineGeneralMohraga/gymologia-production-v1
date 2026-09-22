import { Controller, Get, Res } from '@nestjs/common';
import { ApiExcludeController } from '@nestjs/swagger';
import { randomBytes } from 'node:crypto';
import type { Response } from 'express';

import { Public } from '../rbac/rbac.decorators';
import { brandFooter, brandPage } from '../common/web/brand-page';

/**
 * The web page Play requires.
 *
 * "Account deletion must be available from a web link that does not require
 * installing the app" is not a suggestion -- the Data safety form has a field
 * for the URL and it cannot be left empty. This is that URL.
 *
 * Deliberately outside the API prefix, so it reads as
 * `https://gymologia.com/delete-account` rather than something with `/api/v1`
 * in the middle of it. A person who has uninstalled the app and is trying to
 * get their data removed should not be looking at a route that sounds like it
 * was meant for a machine.
 *
 * It is one self-contained file with no build step and no framework, because
 * the one page that must work when everything else has gone wrong should not
 * depend on anything. It drives the ordinary public auth endpoints -- the same
 * OTP the app uses -- and then the same deletion endpoint, so there is no
 * second code path with its own idea of who may delete what.
 *
 * The inline script runs under a per-request nonce rather than relaxing the
 * Content-Security-Policy. Helmet turns CSP on in production and an
 * `unsafe-inline` exemption carved out here would apply to every response
 * this controller ever grows.
 */
@ApiExcludeController()
// Public by necessity, not by oversight. Play requires this page to work for
// somebody who has uninstalled the app, which means before any token exists.
// The page itself proves nothing -- it collects a number and then drives the
// ordinary OTP endpoints, so the only thing reachable without authentication
// is the form.
@Public()
@Controller('delete-account')
export class AccountDeletionPageController {
  @Get()
  page(@Res() res: Response): void {
    const nonce = randomBytes(16).toString('base64');

    res.setHeader(
      'Content-Security-Policy',
      [
        "default-src 'none'",
        `script-src 'nonce-${nonce}'`,
        "style-src 'unsafe-inline'",
        "connect-src 'self'",
        "base-uri 'none'",
        "form-action 'none'",
      ].join('; '),
    );
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.send(html(nonce));
  }
}

const html = (nonce: string): string => brandPage({
  title: 'Delete your Gymologia account',
  bodyHtml: `
  <h1>Delete your Gymologia account</h1>
  <p class="sub">You can also do this in the app, under Settings.</p>

  <section id="step-phone">
    <p>Enter the mobile number your account uses. We will send a code to
       confirm it is yours.</p>
    <label for="phone">Mobile number</label>
    <input id="phone" type="tel" inputmode="numeric" autocomplete="tel"
           placeholder="9876543210" maxlength="10">
    <button id="send">Send code</button>
  </section>

  <section id="step-code" class="hidden">
    <label for="code">Enter the code we sent you</label>
    <input id="code" type="text" inputmode="numeric" autocomplete="one-time-code"
           maxlength="6">
    <button id="verify">Continue</button>
  </section>

  <section id="step-confirm" class="hidden">
    <div class="card warn">
      <strong>This cannot be undone after <span id="when"></span>.</strong>
      <div id="details"></div>
    </div>
    <div class="card">
      <strong>What is deleted</strong>
      <ul>
        <li>Your name, mobile number, email and age</li>
        <li>Your height, weight and any progress you recorded</li>
        <li>Your chat messages</li>
        <li>Any ID documents and UPI details you gave us</li>
      </ul>
      <strong>What is kept, with you removed from it</strong>
      <ul>
        <li>Payment and invoice records, because the law requires us to keep
            books of account</li>
        <li>The record of actions taken in a gym, so disputes can still be
            settled</li>
      </ul>
    </div>
    <button id="confirm" class="danger">Delete my account</button>
  </section>

  <p id="msg" class="msg"></p>

  ${brandFooter('/delete-account')}

<script nonce="${nonce}">
(function () {
  var API = '/api/v1';
  var challengeId = null, phone = null, token = null;

  function $(id) { return document.getElementById(id); }
  function show(id) { $(id).classList.remove('hidden'); }
  function hide(id) { $(id).classList.add('hidden'); }
  function say(text, kind) {
    var m = $('msg');
    m.textContent = text || '';
    m.className = 'msg' + (kind ? ' ' + kind : '');
  }
  function busy(id, on) { $(id).disabled = on; }

  function post(path, body, auth) {
    var headers = { 'Content-Type': 'application/json' };
    if (auth) headers['Authorization'] = 'Bearer ' + token;
    return fetch(API + path, {
      method: 'POST', headers: headers, body: JSON.stringify(body || {})
    }).then(read);
  }
  function get(path) {
    return fetch(API + path, {
      headers: { 'Authorization': 'Bearer ' + token }
    }).then(read);
  }
  function read(r) {
    return r.json().catch(function () { return {}; }).then(function (d) {
      if (!r.ok) throw new Error(d.message || 'Something went wrong. Please try again.');
      return d;
    });
  }

  $('send').addEventListener('click', function () {
    var digits = ($('phone').value || '').replace(/\\D/g, '');
    if (digits.length !== 10) { say('Enter your 10-digit mobile number.', 'err'); return; }
    phone = '+91' + digits;
    busy('send', true); say('Sending…');
    post('/auth/otp/request', { phone: phone, appClient: 'MEMBER' })
      .then(function (d) {
        challengeId = d.challengeId;
        hide('step-phone'); show('step-code'); say('');
        $('code').focus();
      })
      .catch(function (e) { say(e.message, 'err'); })
      .then(function () { busy('send', false); });
  });

  $('verify').addEventListener('click', function () {
    var code = ($('code').value || '').trim();
    if (!code) { say('Enter the code.', 'err'); return; }
    busy('verify', true); say('Checking…');
    post('/auth/otp/verify', {
      challengeId: challengeId, phone: phone, code: code, appClient: 'MEMBER'
    })
      .then(function (d) {
        // A number with no account has nothing to delete. Said plainly
        // rather than walking them through a confirmation that would fail.
        if (d.status === 'NEW_USER' || !d.tokens) {
          throw new Error('There is no Gymologia account on this number.');
        }
        token = d.tokens.accessToken;
        return get('/me/deletion/preview');
      })
      .then(function (p) {
        if (p.blockers && p.blockers.length) {
          throw new Error(
            'You still own ' + p.blockers.length + ' gym(s). Delete them or ' +
            'hand them to another owner in the app first — deleting your ' +
            'account would cut off every member and staff member in them.'
          );
        }
        var when = new Date(Date.now() + p.graceDays * 86400000);
        $('when').textContent = when.toLocaleDateString();
        var bits = [];
        bits.push('<p>Your account keeps working until then. Sign in to the ' +
                  'app any time before that date to stop it.</p>');
        if (p.willLose && p.willLose.unwithdrawnPaise > 0) {
          bits.push('<p><strong>You have ₹' +
            (p.willLose.unwithdrawnPaise / 100).toFixed(2) +
            ' in referral earnings you have not withdrawn.</strong> ' +
            'Withdraw it in the Gymologia Referral app before this date, or ' +
            'it will be lost.</p>');
        }
        if (p.willLose && p.willLose.memberships > 0) {
          bits.push('<p>You will be removed from ' + p.willLose.memberships +
                    ' gym membership(s).</p>');
        }
        $('details').innerHTML = bits.join('');
        hide('step-code'); show('step-confirm'); say('');
      })
      .catch(function (e) { say(e.message, 'err'); })
      .then(function () { busy('verify', false); });
  });

  $('confirm').addEventListener('click', function () {
    busy('confirm', true); say('Scheduling…');
    post('/me/deletion', { via: 'WEB' }, true)
      .then(function (d) {
        hide('step-confirm');
        say('Your account will be deleted on ' +
            new Date(d.scheduledFor).toLocaleDateString() +
            '. You can stop this by signing in to the app before then.', 'ok');
      })
      .catch(function (e) { say(e.message, 'err'); busy('confirm', false); });
  });
})();
</script>`,
});
