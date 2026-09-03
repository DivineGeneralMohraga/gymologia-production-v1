#!/usr/bin/env python3
"""Count the user-facing strings still hardcoded in English.

    python tool/untranslated.py            # summary per file
    python tool/untranslated.py --list     # every string, with its file

This exists because counting them by eye got the number wrong twice. A
first pass looked only for `Text('` followed by a capital letter, which
missed every lowercase string, every `title:`/`label:` parameter, and --
worst -- the multi-line explanatory sentences, which are the strings that
matter most to someone reading the app in a language they actually think in.
That undercount was reported as "member mode is fully localised" when it
was not.

What counts as translatable here: a single-quoted literal handed to a
text-bearing parameter, containing at least one run of two letters, and not
consisting only of interpolation and punctuation. `'#$position'` and
`'${i + 1}'` are formatting, not language, and are excluded.
"""

import glob
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
APP = os.path.dirname(HERE)

# Parameters whose value is read by a person.
CARRIERS = (
    r"Text\(",
    r"labelText:\s*",
    r"hintText:\s*",
    r"helperText:\s*",
    r"errorText:\s*",
    r"tooltip:\s*",
    r"semanticLabel:\s*",
    r"title:\s*(?:const\s*)?Text\(",
    r"subtitle:\s*(?:const\s*)?Text\(",
    r"label:\s*(?:const\s*)?Text\(",
    r"content:\s*(?:const\s*)?Text\(",
)
PATTERN = re.compile(
    r"(?:%s)\s*'((?:[^'\\]|\\.){2,})'" % "|".join(CARRIERS)
)

# Screens that are not shipped to users in the ordinary sense.
SKIP_FILES = {"diagnostics_screen.dart"}


def translatable(text: str) -> bool:
    """True when a string is language rather than formatting."""
    # Strip interpolations before judging: '#$position' is not a sentence.
    bare = re.sub(r"\$\{[^}]*\}|\$\w+", "", text)
    return re.search(r"[A-Za-z]{2,}", bare) is not None


def main() -> int:
    show_all = "--list" in sys.argv
    total = 0
    rows = []

    for path in sorted(glob.glob(os.path.join(APP, "lib", "**", "*.dart"),
                                 recursive=True)):
        name = os.path.basename(path)
        parts = path.replace(chr(92), "/").split("/")
        if "l10n" in parts or name in SKIP_FILES:
            continue

        found = [m for m in PATTERN.findall(io.open(path, encoding="utf-8").read())
                 if translatable(m)]
        if not found:
            continue
        total += len(found)
        rows.append((len(found), name, found))

    rows.sort(reverse=True)
    for count, name, found in rows:
        print("%-46s %3d" % (name, count))
        if show_all:
            for text in found:
                print("      %s" % text[:90])

    print("-" * 52)
    print("%d strings still hardcoded across %d files" % (total, len(rows)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
