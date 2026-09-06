# -*- coding: utf-8 -*-
"""Find checks whose evidence is an ABSENCE, with nothing proving anything
was looked at.

The shape:

    echo "$B" | grep -q SOMETHING && bad "..." || ok "it is not there"

If $B is empty, grep fails and the check reports PASS having examined
nothing. That has bitten this project repeatedly -- the events feed, the
chat encryption check, the Aadhaar privacy checks -- and the last sweep was
done by eye, point in time, which is why the referral suite shipped four
fresh ones a week later.

A gated one looks like this instead, and is fine:

    [ "$M" = "$MASK" ] \\
      && { echo "$B" | grep -q SECRET && bad ... || ok ...; } \\
      || bad "..." "nothing to inspect"

Works on LOGICAL lines: backslash continuations are joined first, so one
check is one record and a match cannot run from one check's grep into a
later check's ok. The first version of this did exactly that and reported
twelve findings it could not even name.

Reported as CANDIDATES. A grep over source is a guess about structure; the
point is to make the guess cheap to repeat, not to trust it.

NOTE ON FALSE POSITIVES, which are the point rather than a defect.

This only recognises the INLINE gate. A check gated by a surrounding
`case` or `if [ -n "$X" ]` block is reported anyway -- five of the current
candidates are exactly that. It is advisory and deliberately NOT wired into
run-all.sh: a checker that fails the build on cases a human has already
judged fine teaches people to silence it, which is how the thing it looks
for got there in the first place.

Run it by hand after adding checks to a suite:

    python test/tools/find-vacuous-checks.py test

Then READ each candidate. Every one it has ever found was decided by
opening the file, not by the tool's verdict.
"""
import io
import os
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")

TESTDIR = sys.argv[1] if len(sys.argv) > 1 else "test"


def logical_lines(text):
    """Yield (first_line_number, joined_text), joining backslash continuations."""
    out, buf, start = [], "", None
    for i, raw in enumerate(text.splitlines(), 1):
        if start is None:
            start = i
        stripped = raw.rstrip()
        if stripped.endswith("\\"):
            buf += stripped[:-1] + " "
            continue
        buf += stripped
        out.append((start, buf))
        buf, start = "", None
    if buf:
        out.append((start or 1, buf))
    return out


# Runs grep, calls bad when it matches, ok when it does not: the ok branch
# is reached precisely when nothing was found.
NEG = re.compile(r"grep\s+-\w*q\w*\b[^|]*&&\s*bad\b.*?\|\|\s*ok\b")
# The gated form wraps that in { } behind a positive test, with a || bad.
GATED = re.compile(r"&&\s*\{.*grep.*&&\s*bad\b.*\|\|\s*ok\b.*\}\s*\|\|\s*bad")
OKMSG = re.compile(r"\|\|\s*ok\s+\"([^\"]{0,80})")

rows = []
for fn in sorted(os.listdir(TESTDIR)):
    if not fn.endswith(".sh"):
        continue
    text = io.open(os.path.join(TESTDIR, fn), encoding="utf-8", errors="replace").read()
    for line_no, stmt in logical_lines(text):
        if stmt.lstrip().startswith("#"):
            continue
        if not NEG.search(stmt):
            continue
        gated = bool(GATED.search(stmt))
        m = OKMSG.search(stmt)
        rows.append((fn, line_no, gated, m.group(1) if m else stmt.strip()[:70]))

ungated = [r for r in rows if not r[2]]
print("%d negative check(s); %d gated, %d NOT gated\n"
      % (len(rows), len(rows) - len(ungated), len(ungated)))

if ungated:
    print("Candidates -- each needs reading, not believing:")
    cur = None
    for fn, line, _, msg in ungated:
        if fn != cur:
            print("\n  %s" % fn)
            cur = fn
        print("    line %-5d %s" % (line, msg))
else:
    print("No ungated negative checks found.")
