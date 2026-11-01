# What Bats Is

You have a Bash script — a backup job, a
converter, a small installer — and you
want to know whether it still does what
it did the day you wrote it. The usual
way to find out is to run it, watch the
output, and nod. That works until the
day it doesn't: the script changed, the
machine changed, and nobody remembers
which of its behaviours were promises
and which were accidents.

**Bats is a test framework for Bash.**
You write a second file, the test file,
that states the promises as a list of
named claims: *boiling point of water in
Fahrenheit*, *an empty prefix is
refused*. Each claim is an ordinary
piece of Bash — run the script with
these arguments, then check what it
printed and how it ended. The `bats`
program runs every claim in the file,
and prints a report: one line per claim,
**ok** or **not ok**, in a format called
**TAP** (the Test Anything Protocol), a
plain-text convention older than most of
the tools that speak it. If anything
failed, bats itself exits with code 1;
if everything passed, it exits 0. That
single number is the point: a person can
read the report, and a build server can
act on the number without reading
anything.

The idea worth keeping is how little
machinery a claim needs. A test passes
if every command inside it ends with
exit code 0, and fails at the first one
that doesn't. Bash's own test command is
therefore a complete assertion kit:

```bash
[ "$output" = "212.0 F" ]
```

That line succeeds or fails, and bats
takes the hint. Chapter 6 meets `run`,
the one piece of real apparatus — it
runs your script and catches its exit
code and output into variables for those
checks — and chapter 8 shows helper
libraries that phrase the same checks in
words. But nothing in this guide ever
needs more than the line above and its
friends.

## A first taste

After installing (chapter 3), a test
file looks like this — this is a real
file from this guide's lab, testing a
temperature converter:

```bash
#!/usr/bin/env bats

@test "boiling point of water in Fahrenheit" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 100 C
  [ "$status" -eq 0 ]
  [ "$output" = "212.0 F" ]
}
```

and running the folder of them looks
like this (transcript
`bats-lab/transcripts/t01-first-suite.txt`):

```text
$ bats tests/
1..23
ok 1 a fixed stamp gives an exact name
ok 2 the prefix is kept whole, spaces and all
...
ok 23 bats-assert reads the answer line by line
[exit 0]
```

Twenty-three claims, twenty-three ok
lines, and the plan line `1..23` up top
saying how many to expect. Chapter 4
builds this suite properly; chapter 5
breaks one on purpose so you can watch
the other kind of report.

## What it is not

Bats is not a linter: it does not read
your script looking for suspicious
shapes — that is ShellCheck, this
series' neighbouring guide, and the two
are complements, one reading the text
and the other running it. It is not a
build server: it produces the verdict
and the exit code, and chapter 11 shows
the hand-off, but scheduling and
publishing belong to the server. It is
not a straitjacket for how scripts must
be written: the script under test is run
as an ordinary command and never knows
it is being tested. And it is not
mocking or simulation: bats runs the
real script, with real files, which is
why chapters 7's temporary folders
matter.

## The trust line, up front

A test file is a Bash program, and
`bats` runs it with your permissions —
every command in every `@test`, every
setup, every helper. That is not a flaw;
it is what testing a script means. But
it does mean a test suite deserves the
same trust decision as any other code
you download: read a stranger's suite
before you run it, exactly as you would
read their script, because running it
*is* running their script, with extra
steps. Bats itself makes no network
calls and phones nothing home; the
risk, such as it is, is entirely in the
code you point it at. This guide's lab
only ever runs code written for it,
against invented data, on its own
machine.

## Who it is for

Anyone whose Bash scripts have started
to matter: the home-lab keeper with a
backup job that must not quietly change
its mind, the maker whose install script
other people run, the developer whose
project's glue is shell and whose build
server already knows how to ask "did
the tests pass?" The common thread is a
script with promises worth writing down.
