# The Moving Parts

**Outcome: you can name every piece a
bats run touches — the runner, the test
file, `run`, the hooks, the helpers, the
temporary folders — and say which piece
is misbehaving when a run surprises
you.** Six pieces, and each of them is
small.

## The runner: `bats`

One program, itself written in Bash,
installed as `bin/bats` with a library
and helper executables beside it
(chapter 3 shows the layout). You give
it test files, or folders containing
them. It first **gathers**: reads every
file, checks it parses, and collects the
tests — a surprising amount of trouble
(chapter 14) happens at this stage,
before a single test runs, and bats says
so by failing a special pseudo-test
named `bats-gather-tests`. Then it runs
the tests, one process each, in file
order, and hands the outcomes to a
**formatter** (chapter 10) that writes
the report.

## The test file

A file ending in `.bats` — Bash in a
thin costume. Bats rewrites each

```bash
@test "a name a person can read" {
  ...
}
```

into an ordinary Bash function before
running it, which is why everything else
in the file is plain Bash: variables,
functions, comments. The name in quotes
is the test's identity everywhere that
matters to a person: the report, the
name filter of chapter 9. A test
**passes** if every command in its body
exits 0 and **fails** at the first that
doesn't — the rest of the body is not
run. Files usually open with the
shebang `#!/usr/bin/env bats`, which
also lets a suite be run directly, and
may declare a minimum bats version with
`bats_require_minimum_version` (chapter 6
shows the warning that appears without
it).

## `run`

The one command bats adds that you will
use constantly. `run some-command args`
executes the command, swallows its exit
code so the test can continue, and
leaves three souvenirs: `$status` (the
code), `$output` (everything printed,
error stream included, trailing newline
removed), and `$lines` (the same output
as an array, one element per line).
Chapter 6 is devoted to it. Without
`run`, a script that exits 2 — as the
lab's scripts deliberately do when
refusing bad input — would end the test
on the spot, and there would be no way
to test that a refusal works.

## The hooks: setup and teardown

Four functions a test file may define,
run around the tests like stagehands:

- `setup_file` — once, before the file's
  first test
- `setup` — before every test
- `teardown` — after every test, pass
  or fail
- `teardown_file` — once, after the
  file's last test

Chapter 7 proves that order with a log
file the hooks write themselves. The
hooks are where fixtures are built and
where mess is cleaned up; a suite that
needs no preparation defines none of
them.

## Helpers and `load`

Code shared between tests — your own
check functions, or whole libraries —
lives in `.bash` files and is pulled in
with `load`, which finds them relative
to the test file. Chapter 8 loads three:
a two-function helper written for this
guide, and the standard **bats-support**
and **bats-assert** libraries, which
between them provide assertions phrased
as `assert_success`, `assert_output`,
`assert_line` and their `refute_`
opposites.

## The temporary folders

Bats keeps each run in a fresh temporary
folder and hands tests two variables for
their own scratch space: `$BATS_TEST_TMPDIR`,
emptied for every test, and
`$BATS_FILE_TMPDIR`, shared by one file's
tests and the natural home of fixtures
built by `setup_file`. Nothing in them
survives the run unless you ask
(`--no-tempdir-cleanup`), which is what
makes chapter 7's log available to read
afterwards. A check you can run after
any suite: follow a failing test by
looking for its folder — the run's
temporary home is named in bats'
warnings as `BATS_RUN_TMPDIR`.

## The report: TAP

Underneath every display sits TAP:
a plan line (`1..23`), one `ok` or
`not ok` line per test, and `#` comment
lines carrying the diagnostics — the
file, the line, the command that failed.
Formatters dress the same facts for
different audiences (chapter 10): pretty
for a person at a terminal, TAP for a
pipe or a file, TAP13 when a tool wants
the stricter dialect, and a report
formatter can write JUnit XML for a
build server while the terminal shows
something else. The facts never change;
only the clothes do.

With the pieces named, the next two
chapters install the runner and put the
first file through it.
