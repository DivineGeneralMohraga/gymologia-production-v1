# -*- coding: utf-8 -*-
"""Every route, and what stands in front of it.

Authentication is global here -- JwtAuthGuard is an APP_GUARD -- so a route
is reachable without a token only if it is explicitly marked @Public. That
inverts the usual risk: the danger is not a forgotten guard but a @Public
nobody re-read, and a route whose authorisation is only "is signed in" when
it should be "holds this permission".

This was audited by hand once, at sixteen public endpoints. Routes have been
added since, and a hand audit is worth what it was worth on the day.

NOTE ON THE FIRST VERSION, which is why the decorator scan reads both ways:
it walked backwards from the @Get line only. @RequirePermissions
conventionally sits BELOW the verb decorator, so it saw none of them and
reported "0 authenticated with a permission, 108 with none" -- a confident,
completely wrong number, produced by the very sort of tool this file exists
to be.

WHAT IT CANNOT SEE, which is most of the authorisation in this codebase.
Many member-facing routes carry no permission decorator because they are
scoped to the caller rather than to a role, and the check lives in the
service: chat messages call assertMember, the chat directory calls
assertAtGym, the consent toggle queries `where: { id, userId }`. All 35
routes in the "authenticated only" list were read and every one of them
enforces something the tool cannot detect.

So that list is an inventory to review, not a list of holes. The genuinely
load-bearing output is the PUBLIC table: sixteen routes reachable with no
token, each of which has to be deliberate, and which nothing else in the
project enumerates.

    python test/tools/list-route-guards.py src

Deliberately not wired into run-all.sh, for the same reason as
find-vacuous-checks.py: it would fail on cases a human has already judged
fine, and a checker that cries wolf teaches people to silence it.
"""
import io
import os
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")

SRC = sys.argv[1] if len(sys.argv) > 1 else "src"

METHOD = re.compile(r"@(Get|Post|Put|Patch|Delete)\(\s*(?:'([^']*)'|\"([^\"]*)\")?")
CONTROLLER = re.compile(r"@Controller\(\s*(?:'([^']*)'|\"([^\"]*)\")?")
DECO_START = ("@", "*", "/*", "//")


def decorator_block(lines, i):
    """Every decorator and comment attached to the handler at line i.

    Tracks parenthesis balance rather than assuming one decorator per line.
    The second bug in this file was exactly that assumption: a multi-line

        @RequirePermissions(
          Permission.MARK_ATTENDANCE_MEMBER,
          Permission.MARK_ATTENDANCE_STAFF,
        )

    has continuation lines that do not begin with @, so the scan stopped at
    the first one and reported the single most sensitive route in the
    product -- marking attendance -- as having no permission at all.
    """
    block = []

    # Backwards: decorators above the verb.
    j = i - 1
    depth = 0
    while j >= 0:
        t = lines[j].strip()
        depth += t.count(")") - t.count("(")
        if t.startswith(DECO_START) or t == "" or depth > 0:
            block.append(t)
            j -= 1
            continue
        break

    # Forwards: decorators below the verb, up to the handler signature.
    j = i + 1
    depth = 0
    while j < len(lines):
        t = lines[j].strip()
        if depth > 0 or t.startswith(DECO_START) or t == "":
            block.append(t)
            depth += t.count("(") - t.count(")")
            if depth < 0:
                depth = 0
            j += 1
            continue
        break
    return " ".join(block)


rows = []
for dirpath, dirnames, filenames in os.walk(SRC):
    dirnames[:] = [d for d in dirnames if d not in ("node_modules", "dist")]
    for fn in filenames:
        if not fn.endswith(".controller.ts"):
            continue
        path = os.path.join(dirpath, fn)
        text = io.open(path, encoding="utf-8", errors="replace").read()

        cm = CONTROLLER.search(text)
        base = (cm.group(1) or cm.group(2) or "") if cm else ""
        class_head = text[: cm.start()] if cm else ""
        class_public = "@Public()" in class_head
        class_guard = re.findall(r"@UseGuards\(([^)]*)\)", class_head)

        lines = text.split("\n")
        for i, line in enumerate(lines):
            m = METHOD.search(line)
            if not m:
                continue
            verb = m.group(1).upper()
            sub = m.group(2) or m.group(3) or ""
            deco = decorator_block(lines, i)

            public = "@Public()" in deco or class_public
            perms = re.findall(r"@Require(?:All)?Permissions\(([^)]*)\)", deco)
            perms = [p.replace("Permission.", "").strip() for p in perms]
            guards = re.findall(r"@UseGuards\(([^)]*)\)", deco) + class_guard

            route = "/" + "/".join(x for x in [base, sub] if x)
            rows.append((route, verb, public, perms, guards, os.path.basename(path)))

public_routes = [r for r in rows if r[2]]
with_perm = [r for r in rows if not r[2] and r[3]]
with_guard = [r for r in rows if not r[2] and not r[3] and r[4]]
bare = [r for r in rows if not r[2] and not r[3] and not r[4]]

print("%d routes\n  %d public\n  %d authenticated + permission"
      "\n  %d authenticated + an explicit guard\n  %d authenticated only\n"
      % (len(rows), len(public_routes), len(with_perm), len(with_guard), len(bare)))

print("PUBLIC -- no token at all. Each must be deliberate:")
for route, verb, _, _, _, f in sorted(public_routes):
    print("  %-6s %-44s %s" % (verb, route, f))

print("\nAUTHENTICATED ONLY -- any signed-in user reaches these, with no")
print("permission and no extra guard. Correct for a route about the")
print("caller's own data; a hole for anything scoped to a gym or a stranger:")
for route, verb, _, _, _, f in sorted(bare):
    print("  %-6s %-44s %s" % (verb, route, f))
