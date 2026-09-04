#!/usr/bin/env python3
"""Check the translation files for the ways they quietly drift apart.

    python tool/check_arb.py

Four things go wrong when translations are maintained by hand, and none of
them fail the build:

  * a key defined in a translation but not in the template does nothing at
    all -- it looks translated and never renders;
  * a key missing from a translation silently falls back to English, which is
    correct behaviour but worth counting so nobody thinks a language is
    finished when it is not;
  * a key nothing references is either dead or waiting for a screen that has
    not been converted yet, and it is worth knowing which;
  * two keys holding the same English text will drift apart the moment one is
    edited, so they should be one key.

Exits non-zero only for the first case, which is unambiguously a mistake.
The rest are reported and left to a person to judge.
"""

import glob
import io
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
APP = os.path.dirname(HERE)
L10N = os.path.join(APP, "lib", "l10n")


def load(path):
    return json.load(io.open(path, encoding="utf-8"))


# ICU keywords that sit in braces but are not placeholders.
PLURAL_WORDS = {"plural", "other", "one", "zero", "two", "few", "many"}


def slots(text: str) -> set:
    """The placeholder names a message expects."""
    return set(re.findall(r"\{(\w+)[},]", text)) - PLURAL_WORDS


def main() -> int:
    template = load(os.path.join(L10N, "app_en.arb"))
    keys = {k for k in template if not k.startswith("@")}
    print("template: %d keys" % len(keys))

    problems = 0
    for path in sorted(glob.glob(os.path.join(L10N, "app_*.arb"))):
        locale = os.path.basename(path)[4:-4]
        if locale == "en":
            continue
        data = load(path)
        theirs = {k for k in data if not k.startswith("@")}

        orphans = sorted(theirs - keys)
        if orphans:
            problems += 1
            print("  %s: %d keys not in the template (these never render): %s"
                  % (locale, len(orphans), orphans))

        missing = sorted(keys - theirs)
        # appName is deliberately not translated.
        missing = [k for k in missing if k != "appName"]
        if missing:
            print("  %s: %d falling back to English" % (locale, len(missing)))

        # A translation that drops or renames a placeholder renders with a
        # hole in it -- "You have  leave days left." -- and nothing else
        # catches that, because the file is still valid JSON and still
        # compiles.
        for key in sorted(theirs & keys):
            value = data[key]
            if not isinstance(value, str):
                continue
            want, got = slots(template[key]), slots(value)
            if want != got:
                problems += 1
                print("  %s: %s expects %s but has %s"
                      % (locale, key, sorted(want), sorted(got)))

    source = ""
    for path in glob.glob(os.path.join(APP, "lib", "**", "*.dart"), recursive=True):
        parts = path.replace(chr(92), "/").split("/")
        if "l10n" in parts:
            continue
        source += io.open(path, encoding="utf-8").read()

    unused = sorted(k for k in keys
                    if k != "appName"
                    and not re.search(r"[.]%s\b" % re.escape(k), source))
    if unused:
        print("\n%d keys nothing references yet:" % len(unused))
        print("  " + ", ".join(unused))

    by_value = {}
    for key in keys:
        value = template[key]
        if isinstance(value, str):
            by_value.setdefault(value, []).append(key)
    duplicates = {v: sorted(ks) for v, ks in by_value.items() if len(ks) > 1}
    if duplicates:
        print("\nsame English text under more than one key:")
        for value, ks in duplicates.items():
            print("  %r -> %s" % (value, ks))

    if problems:
        print("\nFAIL: %d problem(s) above -- an orphan key, or a "
              "placeholder a translation does not carry." % problems)
        return 1
    print("\nOK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
