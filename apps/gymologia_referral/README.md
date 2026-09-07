# Gymologia Referral

Share a code, earn when a gym subscribes. Android and iOS, ten languages.

Four screens: the code and what it has earned, the individual rewards
behind those totals, where the money should be sent, and settings.

## Running it

The base URL is a compile-time constant, so one codebase points at the EC2
box, a laptop on the LAN, or an emulator loopback without editing a line:

```
flutter run --dart-define=API_BASE_URL=http://65.0.75.45:3000/api/v1
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1   # Android emulator -> host
```

`10.0.2.2` is how the Android emulator reaches the host machine's
localhost. A physical device on the same wifi needs the laptop's LAN IP.

While the API has no certificate, every screen carries a banner saying the
connection is plain http. It disappears by itself when `API_BASE_URL`
becomes `https://` — there is no flag to silence it.

## Tests

```
bash ../run-tests.sh          # this app and the member app
flutter test                  # just this one
```

Three files, and each covers something that cannot be caught by reading:

- **`money_test.dart`** — every amount arrives as an integer number of
  paise. Reading `rewardPaise` as rupees shows ₹5,000 for a ₹50 reward and
  looks entirely plausible. Also pins Indian grouping: ₹1,00,000, not
  ₹100,000, whatever language the interface is in.
- **`validation_test.dart`** — the UPI and PAN patterns are copies of the
  server's. The test imports the app's copies rather than retyping them,
  and then reads the server's own source to check the two still agree. A
  client stricter than the server refuses an address that would have
  worked; a looser one produces a 400 the user cannot act on.
- **`translations_test.dart`** — Flutter silently falls back to English for
  a missing key, which is right at runtime and an excellent way never to
  notice that a language is half English. Checks all ten files have the
  same keys, the same placeholders, and are not simply English copied
  across.

## Two things worth knowing before changing anything

**The share sentence is built on the server, not here.** It is the only
string in the product whose reader is not the person holding the phone —
it gets forwarded to a gym owner — so it comes back from `GET /me/referral`
in the language this app is being read in. Building it locally would mean
ten copies drifting from the ten on the server.

**Gym owners are excluded, and this app does not decide that.** It cannot:
somebody can register a gym on the other app an hour after signing in here.
The server refuses, with a code, and this app has that one sentence in ten
languages. See `lib/core/api/error_text.dart` — there are two such codes and
the list is meant to stay short.
