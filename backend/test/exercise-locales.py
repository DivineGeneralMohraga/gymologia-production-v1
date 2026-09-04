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
`locale` that tells the caller they did not get French. A language we
support but have not written yet returns locale=en with translated=false,
which is the honest pair: request understood, content missing.
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
    # Supported by the interface but with no exercise rows yet. The pair
    # locale=en + translated=false is the honest signal: we understood the
    # request and do not have the content.
    ("te", "en", False),
    ("hi-IN,hi;q=0.9,en;q=0.8", "hi", True),
    ("en;q=0.4,ta;q=0.9", "ta", True),   # weights, not order
    # Unsupported: resolves to English and serves English, which is not a
    # fallback -- so `translated` is true, and it is `locale` that tells
    # the caller they did not get French.
    ("fr", "en", True),
]

# The name is the cheapest proof of which row was served.
NAMES = {
    "en": "Deadlift",
    "hi": "डेडलिफ्ट",
    "ta": "டெட்லிஃப்ட்",
    "bn": "ডেডলিফট",
}

report = io.open(OUT + ".txt", "w", encoding="utf-8")
bad = 0
for header, want_locale, want_flag in CASES:
    subprocess.run(["curl", "-s", API, "-H", "Accept-Language: " + header,
                    "-o", OUT], check=True)
    d = json.load(io.open(OUT, encoding="utf-8"))
    name, flag, served = d.get("name"), d.get("translated"), d.get("locale")
    want_name = NAMES.get(want_locale, NAMES["en"])
    ok = name == want_name and flag == want_flag and served == want_locale
    if not ok:
        bad += 1
    report.write("%s  %-26s -> locale=%-3s translated=%-5s %s%s\n" % (
        "PASS" if ok else "FAIL", header, served, flag, name,
        "" if ok else "   (expected %s / %s / %s)"
        % (want_locale, want_flag, want_name)))
report.write("%s\n" % (("%d FAILED" % bad) if bad else
                       "all %d cases pass" % len(CASES)))
report.close()
sys.stdout.write(io.open(OUT + ".txt", encoding="utf-8").read()
                 .encode("ascii", "backslashreplace").decode("ascii"))
sys.exit(1 if bad else 0)
