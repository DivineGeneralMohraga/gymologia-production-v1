/**
 * Terms of Use and Privacy Policy.
 *
 * These live in source rather than a database so that a change is a reviewed,
 * versioned commit — which is also what you need if you are ever asked to
 * show which text a particular user agreed to.
 *
 * IMPORTANT: this is a working draft written to describe what the software
 * actually does. It is not legal advice and has not been reviewed by a
 * lawyer. Before launch it must be checked against the Digital Personal Data
 * Protection Act 2023, the IT Rules, and the Consumer Protection
 * (E-Commerce) Rules by someone qualified to do that.
 *
 * Bump `LEGAL_VERSION` whenever the wording changes materially. Users are
 * re-prompted when the version they accepted is older than this one.
 */
export const LEGAL_VERSION = '2026-08-30.1';

export const SUPPORT_EMAIL = 'support@gymologia.com';

export interface LegalDocument {
  slug: string;
  title: string;
  version: string;
  updatedAt: string;
  /** Plain text with blank-line paragraphs; headings are ALL CAPS lines. */
  body: string;
}

const TERMS: LegalDocument = {
  slug: 'terms',
  title: 'Terms of Use',
  version: LEGAL_VERSION,
  updatedAt: '2026-08-30',
  body: `
Gymologia is operated in India. By creating an account you agree to these
terms. If you do not agree, do not use the app.

WHO CAN USE GYMOLOGIA
You must be at least 13 years old to hold an account. If you are under 18,
a parent or guardian must agree to these terms on your behalf. You must give
a phone number you control, because it is how you sign in and how we reach
you about your account.

THE TWO SIDES OF THE APP
Gymologia has a member side and a gym owner/staff side. Switching modes in
settings changes what you see; it does not by itself give you any authority
at a gym. Access to a gym's records comes only from that gym adding you as
staff and giving your role permissions.

YOUR ACCOUNT
Keep your phone number secure. Anyone who can receive your SMS can sign in
as you. Tell us at ${SUPPORT_EMAIL} immediately if you lose control of your
number, and we will suspend the account.

WHAT GYMS ARE RESPONSIBLE FOR
A gym listed on Gymologia is an independent business. We are not that gym's
agent and we do not run it. Your membership, its price, its rules, the
condition of the equipment and the conduct of the staff are matters between
you and the gym. Ratings and perks shown on a gym's profile are supplied by
that gym or its members, not verified by us.

Gym owners and staff are responsible for the accuracy of what they enter
about their members, for having a lawful basis to enter it, and for telling
their members what they record. If you are a gym, you also confirm that the
KYC documents you upload are genuine and yours to submit.

SUBSCRIPTIONS AND PAYMENT
Gyms subscribe to Gymologia on a plan. Prices shown include GST. New gym
accounts get one free trial, once per person — not once per gym. Payment is
taken by Cashfree; we do not store your card details.

A subscription runs to the end of the period you paid for. If it lapses,
your gym stops appearing in member search and your gym's public listing is
withdrawn. Your data is not deleted and you keep access to your own member
and staff records, so that a billing lapse never locks you out of your own
business records.

REFUNDS
If a payment is taken and the plan is not activated, tell us within 7 days
at ${SUPPORT_EMAIL} and we will refund it. Beyond that, subscription fees
for a period already served are not refundable. Nothing here limits rights
you have under the Consumer Protection Act 2019.

REFERRALS
Referral rewards are paid to the referrer's UPI ID. A gym owner cannot hold
a referral account and earn on their own gym's subscription. Rewards are
held for a short period before release so that they can be reversed if the
underlying payment is refunded or found to be fraudulent. A verification
amount is deducted once, on the first payout, to confirm the UPI ID. Tax is
deducted where the law requires it.

WHAT YOU MAY NOT DO
Do not upload anyone else's identity documents. Do not enter a member into a
gym without their verified consent through the OTP step. Do not use the chat
to harass anyone. Do not attempt to access records belonging to gyms or
people you have no relationship with, or to probe, scan or interfere with
the service. We log security-relevant events and act on them.

CHAT
Messages are encrypted while stored, but they are not end-to-end encrypted:
Gymologia can read message content where it is necessary to investigate
abuse, respond to a support request, or comply with a lawful order. Do not
send anything through chat that you would not want us to be able to read.

ENDING YOUR ACCOUNT
You can ask us to close your account at any time at ${SUPPORT_EMAIL}. We may
suspend or close an account that breaks these terms, or that we reasonably
believe is being used fraudulently. Some records are kept after closure
where the law requires it — see the Privacy Policy.

AVAILABILITY AND LIABILITY
We work to keep Gymologia running but do not promise it will be
uninterrupted or error-free. To the extent the law allows, our liability to
you for any claim connected with the service is limited to the subscription
fees you paid us in the twelve months before the claim. Nothing excludes
liability that cannot lawfully be excluded.

CHANGES
We may change these terms. If a change is material we will tell you in the
app and ask you to accept the new version. Continuing to use Gymologia after
that means you accept it.

GOVERNING LAW
These terms are governed by the laws of India, and the courts of India have
jurisdiction.

CONTACT
${SUPPORT_EMAIL}
`.trim(),
};

const PRIVACY: LegalDocument = {
  slug: 'privacy',
  title: 'Privacy Policy',
  version: LEGAL_VERSION,
  updatedAt: '2026-08-30',
  body: `
This policy explains what Gymologia collects, why, and what you can do about
it. It is written to match what the software actually does.

WHY WE ASK FOR YOUR AGE AND NOT YOUR DATE OF BIRTH
We store your age, never your date of birth. A date of birth is a key to the
rest of your life — banks, government records, and identity checks all use
it, and a leak of it is far more damaging than a leak of a number like "27".
Age is all a gym needs to train you safely, so age is all we keep.

WHAT WE COLLECT
Account: your phone number, name, age, and email if you give one. Email is
optional.

Body measurements: weight and height, when you enter them. You choose to
add these; they are yours and they follow you if you change gyms.

Membership and attendance: which gym you belong to, your plan dates, your
stated training goal, your assigned trainer, leave requests, and the days
staff marked you present or absent.

Payments: for gym owners, the subscription record and a reference from our
payment provider. We never see or store your full card number.

Identity documents: for gym owners only, the KYC details required to verify
a business. These are stored encrypted and are visible to the small number
of Gymologia staff who carry out verification.

Chat: messages you send through the app.

Technical: IP address, device and app version, and security-relevant events
such as repeated failed sign-in attempts.

Location: only if you grant it, and only to sort nearby gyms. Decline it and
you can search by locality name instead — the app works either way.

WHO CAN SEE WHAT
Your gym's staff can see your membership, attendance and leave. Your weight
and height history is visible to gym staff and your trainer only while you
leave progress monitoring switched on. It is on by default when a gym adds
you, you are told at that moment, and you can switch it off yourself at any
time in the app.

Other members see only what you send in a chat you are part of.

Gymologia staff can see your records where it is necessary to answer a
support request, verify a gym, or investigate abuse. Every such action is
written to an audit log.

CHAT IS NOT END-TO-END ENCRYPTED
Message content is encrypted at rest with a key we hold. That means we can
read messages when we have to — for abuse investigations, support, or a
lawful order. We are telling you this plainly rather than describing the
encryption in a way that implies more privacy than it gives.

WHO WE SHARE WITH
MSG91, to send your login code by SMS. Cashfree, to take subscription
payments and to make referral payouts. Our hosting and database providers,
which run on servers we control. We do not sell your data and we do not
share it for advertising.

We disclose data to a public authority only where a valid legal demand
requires it.

HOW LONG WE KEEP IT
Your account data stays while your account is open. Attendance and
membership records are kept by the gym that created them for as long as
their own obligations require. Payment and tax records are kept for the
period Indian tax law requires, which is longer than your account may last.
Security and audit logs are kept for a limited period and then deleted.
One-time codes are deleted shortly after they expire.

YOUR RIGHTS
You can ask us to show you the personal data we hold about you, correct
anything wrong, or delete your account. Write to ${SUPPORT_EMAIL} from the
number or email on the account and we will verify it is you before acting.
Where deletion conflicts with a record we are legally required to keep, we
will tell you which record and why.

You can withdraw consent for progress monitoring yourself, in the app, at
any time.

SECURITY
Sensitive fields, including identity documents and message bodies, are
encrypted before they are stored. Sign-in codes are hashed, never stored in
readable form. Access to data is checked on every request against the role
you hold at that gym. We keep an audit trail of administrative actions and
monitor for attacks against the service.

No system is perfectly secure. If a breach affects you, we will tell you and
the relevant authority as the law requires.

CHILDREN
Gymologia is not for children under 13. If you believe a child under 13 has
an account, write to ${SUPPORT_EMAIL} and we will remove it.

CHANGES
If we change this policy materially we will tell you in the app.

CONTACT
${SUPPORT_EMAIL}
`.trim(),
};

export const LEGAL_DOCUMENTS: Record<string, LegalDocument> = {
  terms: TERMS,
  privacy: PRIVACY,
};
