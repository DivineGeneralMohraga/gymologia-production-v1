# -*- coding: utf-8 -*-
"""End-to-end check that the directory answers in the language asked for.

    npm run build && node dist/main.js      # in one shell
    python test/exercise-locales.py         # in another

Goes through the HTTP endpoint rather than the database, so the header
parsing, the locale fallback and the seeded rows are all exercised
together -- the three places this can go wrong.

Not in run-all.sh: that runner is bash and paces itself around the OTP
rate limit, and this needs neither. It is also Python rather than shell
because the assertions are Devanagari and Tamil, which Git Bash on
Windows mangles.

Two fields answer two different questions, and conflating them is how the
first draft of this file got its own expectations wrong:

  locale      the language the content actually is
  translated  whether the *resolved* locale had rows of its own

`Accept-Language: fr` resolves to English and serves English, so
translated is true -- English is not a fallback from English. It is
`locale` that tells the caller they did not get French.

NOTE (5 Sep 2026): this file used to assert `mr -> locale=en,
translated=false` as its example of "a language we support but have not
written yet". All ten interface languages now have exercise content, so
that pair is no longer reachable through any real locale and the case has
become `mr -> locale=mr, translated=true` along with the four other
languages finished at the same time. The false path still exists in the
code, for a language added to the interface before its content, and
test/exercise-translations.spec.ts is what guards the gap directly now --
it fails if any locale stops covering the directory, which is the event
that would bring this pair back.
"""
import io, json, os, subprocess, sys, tempfile

API = "http://localhost:3000/api/v1/exercises/deadlift"
OUT = os.path.join(tempfile.gettempdir(), "gymologia-locale-check.json")

# header sent -> (locale expected to be served, translated flag expected)
CASES = [
    ("en", "en", True),
    ("hi", "hi", True),
    ("ta", "ta", True),
    ("bn", "bn", True),
    ("te", "te", True),
    ("mr", "mr", True),
    ("ml", "ml", True),
    ("kn", "kn", True),
    ("gu", "gu", True),
    ("pa", "pa", True),
    ("hi-IN,hi;q=0.9,en;q=0.8", "hi", True),
    ("en;q=0.4,ta;q=0.9", "ta", True),   # weights, not order
    # Unsupported: resolves to English and serves English, which is not a
    # fallback -- so `translated` is true, and it is `locale` that tells
    # the caller they did not get French.
    ("fr", "en", True),
]

# The name is the cheapest proof of which row was served -- except for
# Hindi and Marathi, which transliterate "deadlift" identically because
# both are written in Devanagari. Serving Hindi content to a Marathi
# request would sail past a name check, so the summaries are compared for
# distinctness afterwards; that is what actually proves the right row came
# back rather than a plausible-looking neighbour.
NAMES = {
    "en": "Deadlift",
    "hi": "डेडलिफ्ट",
    "ta": "டெட்லிஃப்ட்",
    "bn": "ডেডলিফট",
    "te": "డెడ్‌లిఫ్ట్",
    "mr": "डेडलिफ्ट",
    "ml": "ഡെഡ്ലിഫ്റ്റ്",
    "kn": "ಡೆಡ್‌ಲಿಫ್ಟ್",
    "gu": "ડેડલિફ્ટ",
    "pa": "ਡੈੱਡਲਿਫਟ",
}

report = io.open(OUT + ".txt", "w", encoding="utf-8")
bad = 0
summaries = {}
for header, want_locale, want_flag in CASES:
    subprocess.run(["curl", "-s", API, "-H", "Accept-Language: " + header,
                    "-o", OUT], check=True)
    d = json.load(io.open(OUT, encoding="utf-8"))
    name, flag, served = d.get("name"), d.get("translated"), d.get("locale")
    want_name = NAMES.get(want_locale, NAMES["en"])
    ok = name == want_name and flag == want_flag and served == want_locale
    if not ok:
        bad += 1
    # Keep one summary per locale actually served, for the collision check.
    if served and served not in summaries:
        summaries[served] = d.get("summary")
    report.write("%s  %-26s -> locale=%-3s translated=%-5s %s%s\n" % (
        "PASS" if ok else "FAIL", header, served, flag, name,
        "" if ok else "   (expected %s / %s / %s)"
        % (want_locale, want_flag, want_name)))

# No two languages may return the same summary. A duplicate means one
# locale is being served another's rows -- the failure the identical
# Hindi and Marathi names would otherwise hide.
seen = {}
for loc, text in sorted(summaries.items()):
    if text is None:
        continue
    if text in seen:
        bad += 1
        report.write("FAIL  %s and %s returned the SAME summary\n"
                     % (seen[text], loc))
    else:
        seen[text] = loc
if bad == 0:
    report.write("PASS  all %d languages returned distinct content\n"
                 % len(seen))

report.write("%s\n" % (("%d FAILED" % bad) if bad else
                       "all %d cases pass" % len(CASES)))
report.close()
sys.stdout.write(io.open(OUT + ".txt", encoding="utf-8").read()
                 .encode("ascii", "backslashreplace").decode("ascii"))
sys.exit(1 if bad else 0)
