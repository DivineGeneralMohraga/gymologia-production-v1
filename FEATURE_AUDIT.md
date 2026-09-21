# Feature Completeness Audit — Gymologia vs. Original Spec
**Audit Date:** 2026-09-21
**Auditor:** Claude (four parallel agents, one per app/module, evidence-based — read actual code, not inferred from file/folder names)
**Scope:** Feature completeness only. DPDP Act 2023 privacy/consent compliance is tracked separately in `DPDP_AUDIT.md` and intentionally excluded here.

---

## How to read this report

Every finding cites the actual file and line the agent read. Status:
- ✅ **Done** — matches spec, verified in code
- ⚠️ **Partial** — real gap, wrong wiring, or a permission/field that exists but does nothing
- ❌ **Missing** — not implemented

This report covers four areas, audited independently and in parallel: the **member app**, the **owner/staff CRM** (the largest part of the spec), the **referral app**, and the **admin app**.

**Overall impression:** this is a notably mature, largely spec-complete codebase. Most sections came back fully ✅. The gaps that exist are specific and mostly well-isolated — not signs of a half-built product, but real bugs and dead code worth fixing before they surprise someone.

---

## Top gaps across the whole product, ranked by impact

### Critical / High

1. **No referral payout can ever complete.** `PayoutRunnerService.run()` refuses to send a transfer unless `account.upiVerified === true` (`backend/src/payments/payout-runner.service.ts:100-106`), but nothing in the codebase ever sets that flag to `true` — the Cashfree Verification Suite integration that would do it doesn't exist. Every referral withdrawal sits `QUEUED` forever. This breaks the entire "earn ₹50 per referral" promise end-to-end, even with live Cashfree credentials configured.

2. **The `ADMINISTRATIVE` permission grants nothing.** It's presented in the roles UI as "Everything above, including anything added later" (`backend/src/roles/roles.service.ts:520,558`), but `PermissionService.has()`/`assert()` only check literal set membership — there's no code path that expands `ADMINISTRATIVE` into the rest of the permission set (`backend/src/rbac/permission.service.ts:95-113`). A gym owner who creates a custom role and grants only "Everything" gets a role that can do nothing. The UI actively promises the opposite of what happens.

3. **Admin login doesn't reject non-staff phone numbers at verification.** `assertClientAllowed()` (`backend/src/auth/auth.service.ts:427-449`) only special-cases the `REFERRAL` client — for `ADMIN` it's a no-op. Any existing Gymologia account (a member, gym staff, a referrer) can complete OTP verification against the admin app and receive real access/refresh tokens scoped `client: ADMIN`, and is only turned away one step later by `AdminGuard` on the first admin-only call. The admin app's own code comment claims rejection happens at verification — it doesn't. No data is exposed (AdminGuard does catch it before any admin route responds), but it contradicts the spec ("only those added as staff can login") and mints real sessions for accounts that shouldn't have any.

4. **Referral refund/chargeback reversal is unreachable.** The 7-day hold and `REVERSED` redemption status exist, but no webhook handles a Cashfree refund/chargeback event, and `SubscriptionStatus` has no `REFUNDED` value to transition into (`backend/src/payments/webhooks.controller.ts`, `backend/prisma/schema.prisma:408-414`). If a gym owner's payment is charged back after a referral reward has gone `ELIGIBLE` or been paid, nothing claws it back. Direct financial exposure once gap #1 is fixed and money starts moving.

5. **`MANAGE_CHAT_GROUPS` is a permission that nothing checks.** It's in the grantable permission catalogue, but `ChatService.createGroup()` (`backend/src/chat/chat.service.ts:245-278`) performs no permission check at all, and the Flutter group-creation screen shows the action to everyone. Any member or staff member, any role, can create unlimited custom chat groups — the permission toggle that's supposed to control this does nothing.

### Medium

6. **Location-based gym ranking is unwired on the client.** The backend fully implements distance-sorted search (`backend/src/gyms/gyms.service.ts:271-359`), but `apps/gymologia/lib/features/member/gym_browser_page.dart` never requests device location or passes coordinates — acknowledged directly in a code comment as deferred. Every user gets locality-text search only; the spec's "ranked by locally/nearby" never fires for anyone, regardless of whether they'd grant permission.

7. **No referral-specific fraud/velocity detection.** `SecurityEventType.PAYOUT_VELOCITY` and `REFERRAL_FRAUD` exist as enum values (`backend/prisma/schema.prisma:1441-1442`) but nothing writes them — confirmed by the service's own doc comment. Nothing throttles how many rewards one account can generate, nothing flags a burst of signups on one code or a code redeemed suspiciously fast after creation.

8. **TDS/tax withholding on referral payouts is unconditionally zero**, not threshold-gated. `WithdrawalsService` hardcodes `tdsPaise: 0, tdsRateBps: 0` everywhere; there is no threshold-detection logic anywhere in the referrals module. The top-level spec instruction ("Referral payouts with tax collection thing") is anticipated in the schema (a `financialYear` field, PAN columns) but not implemented.

9. **`Gym.publicListing` can't be set by anyone.** It defaults `true` and is referenced by the ranking explanation text as a possible reason a gym isn't listed (`backend/src/gyms/ranking.service.ts:64-65`), but `UpdateGymDto` never exposes it and no other endpoint sets it either. Fails safe (always listed when otherwise eligible) but it's dead logic that will confuse whoever debugs "why am I not listed" later.

10. **Admin dashboard has no internal-staff-count-by-role breakdown**, which the spec explicitly asks for ("how many internal staff came with and without owner roles"). Only reachable today by manually counting rows on the Staff screen.

### Low / cosmetic

11. A stale "coming next: progress charts" placeholder card in `member_home_page.dart:244-247` — the feature it describes as unbuilt is already fully implemented in `progress_page.dart`. Confusing, one-line fix.
12. Locale coverage is 10 major Indian languages, fully translated with no missing keys — solid, but not literally "almost all languages" if international expansion is intended.
13. `ADD_STAFF` permission can be granted by any super role (Owner or Manager), not strictly owner-only per the spec's literal wording — defensible given the spec also says "Manager also has all permissions," but worth confirming intent.
14. Attendance "search by name, get a no-permission message" is handled by routing through the members/staff list search first rather than a single dedicated in-screen search — functionally equivalent (the correct 403 does fire), weaker UX than the spec describes.
15. `WithdrawalsService.VERIFY_FEE_PAISE` is hardcoded to 1000 rather than read from the `UPI_VERIFY_DEDUCTION_PAISE` env var — values happen to match today, but changing the env var would silently do nothing.
16. First-admin-owner bootstrap (`ADMIN_BOOTSTRAP_PHONE` env var) is undocumented outside the code itself — worth a deployment-checklist entry confirming it's actually set for the real deployment.
17. Admin app has a fifth role, `KYC_AGENT`, beyond the spec's four — a reasonable, correctly-implemented addition, just not mentioned in the original spec text.

---

## Section 1 — Member App

| Area | Status |
|---|---|
| Sign in/sign up (phone+OTP, new-vs-existing, age not DOB) | ✅ Done |
| Gym browser + profile (no membership) | ⚠️ Partial — location search never wired client-side (gap #6) |
| Membership home (weight/height, exercise directory, progress, chat) | ✅ Done |
| Events page (local/global barrier, participate flow) | ✅ Done |
| Settings (profile, mode switch, referral/gym pitch, support) | ✅ Done |
| Header/footer shell | ✅ Done |
| Notifications inbox | ✅ Done |
| Multi-language | ✅ Done (10 languages, fully translated — see gap #12) |

Chat specifically stands out as thoroughly built: member-to-member, member-to-staff, custom groups, the official all-hands group, the unofficial members-only group, and the "can't DM the owner directly unless they message first" rule are all implemented with clear UI messaging, not just backend enforcement.

---

## Section 2 — Owner/Staff CRM (the largest spec section)

| Area | Status |
|---|---|
| Gym creation + KYC | ✅ Done |
| Subscription plans (₹599/₹1199, 7-day trial, referral discount) | ✅ Done |
| Roles & permissions engine (HOLD/OUTRANK/NO-ESCALATION) | ⚠️ Partial — `ADMINISTRATIVE` and `MANAGE_CHAT_GROUPS` gaps (#2, #5) |
| Attendance (role-scoped marking/editing) | ✅ Done |
| Leave requests (ceilings, auto-approval, early return) | ✅ Done |
| Add member flow (OTP-first, trainer assignment, goal capture) | ✅ Done |
| Add staff flow | ✅ Done |
| Chat (staff side, groups, owner-DM rule) | ⚠️ Partial — group creation unenforced (#5) |
| Gym profile management | ✅ Done — one dead field (#9) |
| Notification handler | ✅ Done |
| Analytics/ranking | ✅ Done |

This section is the CRM core of the product and came back the strongest overall — the permission engine's three stated rules (must hold it yourself, must outrank the target, no escalation on grant *or* revoke) are all correctly implemented and checked at `backend/src/rbac/permission.service.ts:184-212`. The two real bugs found (#2, #5) are exactly the "permission exists in the catalogue, nothing ever checks it" pattern that's easy to miss without a dedicated audit.

---

## Section 3 — Referral App

| Area | Status |
|---|---|
| Owner-exclusion eligibility rule | ✅ Done |
| Referral code generation | ✅ Done |
| 10% discount at checkout | ✅ Done |
| ₹50 payout with hold/reversal | ⚠️ Partial — reversal unreachable for real refunds (#4) |
| ₹10 first-payout-only UPI verification fee | ✅ Done (logic correct; constant not env-sourced, #15) |
| Cashfree Payouts integration | ⚠️ Partial — real API calls exist but gated shut (#1) |
| Tax collection (TDS) | ❌ Missing (#8) |
| Referral Flutter app itself | ✅ Done — fully wired, not a stub |
| Fraud/attack detection | ⚠️ Partial — general security good, referral-specific fraud detection absent (#7) |

This is the highest-financial-risk section of the audit. The engineering quality of what exists is good (idempotency keys, duplicate-transfer handling, correct hold windows) — the problem is that the one precondition for money actually moving (`upiVerified`) can never become true, which means the module is currently unable to fulfill its core promise despite looking complete from the outside.

---

## Section 4 — Admin App

| Area | Status |
|---|---|
| Admin login (OTP, staff-only) | ⚠️ Partial — doesn't reject at verification (#3) |
| Admin staff management + first-owner bootstrap | ✅ Done (bootstrap undocumented, #16) |
| Admin roles (5, one beyond spec) | ✅ Done |
| KYC document review (no video-KYC remnants) | ✅ Done |
| Customer support handling | ✅ Done |
| Logs viewer (audit/security/IP blocks) | ✅ Done |
| Dashboard | ✅ Done — missing staff-by-role breakdown (#10) |
| Notification pusher | ✅ Done |

The confirmed absence of any video-KYC remnants is worth noting explicitly: the only hits for video-call/meeting-link terminology anywhere in the repo are in the historical migration that removed it, exactly as expected — nothing live references it.

---

## What I'd fix first

If you want a short list to act on: **#1 and #4** (referral payouts) are the two that mean real money doesn't move correctly — worth prioritizing before this module handles real users. **#2 and #5** (the two dead permissions) are cheap, isolated fixes that close a trust gap between what the roles UI promises and what actually happens. **#3** (admin login) is a real inconsistency with the spec and the app's own documentation, though the actual security exposure is limited since `AdminGuard` does catch it before any data is returned.

Everything else is either cosmetic, a reasonable interpretation of ambiguous spec wording, or a known, disclosed scale-based deferral (like TDS at current referral volumes).

---

*This report reflects the state of the codebase on `main` at commit `3b4c815`, audited 2026-09-21. No code was changed during this audit.*
