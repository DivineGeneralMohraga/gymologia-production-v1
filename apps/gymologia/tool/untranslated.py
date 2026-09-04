#!/usr/bin/env python3
"""Count the user-facing strings still hardcoded in English.

    python tool/untranslated.py            # summary per file
    python tool/untranslated.py --list     # every string, with its file

This exists because counting them by eye got the number wrong three times.

A first pass looked only for `Text('` followed by a capital letter, which
missed every lowercase string, every `title:`/`label:` parameter, and --
worst -- the multi-line explanatory sentences, which are the strings that
matter most to someone reading the app in a language they actually think
in. That undercount was reported as "member mode is fully localised" when
it was not.

The second mistake was the opposite, an *over*count. A regex cannot find
the end of a Dart literal, because `${...}` may contain quotes of its own
-- `'${t.count((e['n'] as int?) ?? 0)}'` ends at the quote before `n`, as
far as a regex is concerned. Every such line was reported as untranslated
long after it had been localised. Literals are parsed properly now:
interpolations are skipped whole, braces and nested quotes included.

The third mistake was scope. Only literals handed straight to a
text-bearing parameter were counted, so the tool reported zero while every
network error in `api_client.dart`, every form message in
`validators.dart` and a handful of chat subtitles were still English --
strings that reach the user through a variable rather than a widget
argument. It reads every literal in `lib/` now and judges it on shape.

What counts as translatable: a literal with at least two words of two or
more letters once interpolation is stripped, that is not a SCREAMING_CASE
enum value, a path, or a URL. `'#$position'` and `'${i + 1}'` are
formatting, not language. `'GYM_MEMBERS'` is a wire value. Comments are
skipped, so prose in a doc comment does not count as a string.
"""

import glob
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
APP = os.path.dirname(HERE)

# Literals that are machinery, not language: enum names the server
# understands, keys, paths, package imports.
NOT_LANGUAGE = (
    re.compile(r"^[A-Z0-9_]+$"),                 # GYM_MEMBERS, OPEN
    re.compile(r"^(?:https?://|/|\.{0,2}/|[a-z]+:)"),  # urls, paths, packages
    re.compile(r"\.dart$"),                      # imports
    re.compile(r"^[a-z0-9]+(?:_[a-z0-9]+)+$"),   # access_token, app_locale
    re.compile(r"^[A-Z][a-z]+(?:-[A-Z][a-z]+)+$"),  # Content-Type headers
    re.compile(r"^[a-z]+/[a-z.+-]+$"),           # application/json
    re.compile(r"^\S+@\S+\.\S+$"),              # email addresses
    re.compile(r"^[EyMdHhmsaSzZGkK.,:/'\- ]+$"),  # date format patterns
)

# Words that look like labels but are not language:
#   Authorization, Bearer -- HTTP, not a sentence anyone reads
#   Gymologia            -- the product name, the same in every language
#   English              -- a language's own name in the picker, which is
#                           deliberately never translated
NOT_LANGUAGE_WORDS = {"Authorization", "Bearer", "Gymologia", "English"}

# Screens that are not shipped to users in the ordinary sense.
SKIP_FILES = {"diagnostics_screen.dart"}


def read_literal(src, i):
    """Read the Dart single-quoted literal that starts at src[i].

    Returns (text, index just past the closing quote). An interpolation is
    copied through whole -- including any quotes inside it, which is the
    part a regex cannot do.
    """
    i += 1  # past the opening quote
    out = []
    while i < len(src):
        c = src[i]
        if c == "\\":
            out.append(src[i:i + 2])
            i += 2
            continue
        if c == "'":
            return "".join(out), i + 1
        if c == "$" and i + 1 < len(src) and src[i + 1] == "{":
            j, depth = i + 1, 0
            while j < len(src):
                if src[j] == "{":
                    depth += 1
                elif src[j] == "}":
                    depth -= 1
                    if depth == 0:
                        j += 1
                        break
                elif src[j] == "'":
                    _, j = read_literal(src, j)
                    continue
                j += 1
            out.append(src[i:j])
            i = j
            continue
        out.append(c)
        i += 1
    # Unterminated: treat the rest as the literal rather than crashing.
    return "".join(out), i


def translatable(text):
    """True when a literal is language a person reads, not machinery."""
    if any(p.search(text) for p in NOT_LANGUAGE):
        return False
    # Strip interpolations before judging: '#$position' is not a sentence.
    bare = re.sub(r"\$\{.*\}|\$\w+", "", text, flags=re.S)
    if bare.strip() in NOT_LANGUAGE_WORDS:
        return False
    words = re.findall(r"[A-Za-z]{2,}", bare)
    if len(words) >= 2:
        return True
    # A lone capitalised word is a label -- 'Approved', 'Rehab'. A wire
    # value is SCREAMING_CASE and a menu value is lowercase, so neither is
    # swept up by this.
    return re.fullmatch(r"[A-Z][a-z]{2,}", bare.strip()) is not None


def strings_in(src):
    """Every translatable literal in a file, comments excluded."""
    found = []
    i = 0
    while i < len(src):
        two = src[i:i + 2]
        if two == "//":
            end = src.find("\n", i)
            i = len(src) if end < 0 else end + 1
            continue
        if two == "/*":
            end = src.find("*/", i)
            i = len(src) if end < 0 else end + 2
            continue
        if src[i] == "'":
            text, end = read_literal(src, i)
            if translatable(text):
                found.append(text)
            i = end
            continue
        i += 1
    return found


def main():
    show_all = "--list" in sys.argv
    total = 0
    rows = []

    for path in sorted(glob.glob(os.path.join(APP, "lib", "**", "*.dart"),
                                 recursive=True)):
        name = os.path.basename(path)
        parts = path.replace(chr(92), "/").split("/")
        if "l10n" in parts or name in SKIP_FILES:
            continue

        found = strings_in(io.open(path, encoding="utf-8").read())
        if not found:
            continue
        total += len(found)
        rows.append((len(found), name, found))

    rows.sort(reverse=True)
    out = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    for count, name, found in rows:
        out.write("%-46s %3d\n" % (name, count))
        if show_all:
            for text in found:
                out.write("      %s\n" % text.replace("\n", " ")[:90])

    out.write("-" * 52 + "\n")
    out.write("%d strings still hardcoded across %d files\n" % (total, len(rows)))
    out.flush()
    return 0


if __name__ == "__main__":
    sys.exit(main())
