# Troubleshooting

**Outcome: the failures a bats user
actually meets — most of them before a
single test runs — each with its exact
words and its way out.** Everything in
this chapter is in transcript
`bats-lab/transcripts/t08-when-bats-complains.txt`
unless a line says otherwise.

## "Test file … does not exist"

```text
$ bats tests/nope.bats
ERROR: Test file "/home/…/bats-lab/tests/nope.bats" does not exist.
1..1
not ok 1 bats-gather-tests
[exit 1]
```

A misspelled path, or a suite moved
without its runner. Bats reports it as
a failed pseudo-test, `bats-gather-tests`,
so even this failure arrives in TAP
shape and the exit code stays an honest
1. Check the path first; it is nearly
always the path.

## "Found no tests"

```text
$ bats /home/…/bats-labwork/empty/
ERROR: Found no tests. (Try `--allow-empty-suite`?)
[exit 1]
```

An existing folder with no `.bats`
files in it — wrong folder, wrong
extension (`.sh` does not count), or
tests hiding in subfolders, which need
`-r`. The default is a failure *on
purpose*: a suite that gathers nothing
must not be able to impersonate a pass
(chapter 11's canary makes the same
point). If an empty suite is genuinely
what a pipeline step means — a project
whose tests have not landed yet —
`--allow-empty-suite` makes it exit 0,
as the transcript's very next run shows.

## A syntax error stops the whole file

```text
$ bats /home/…/bats-labwork/broken.bats
1..1
not ok 1 bats-gather-tests
# /home/…/bats-labwork/broken.bats: line 5: syntax error near unexpected token `}'
[exit 1]
```

The message is Bash's own, with the
file and line, and no test in the file
runs: gathering parses everything
before anything executes. A missing
`fi`, an unclosed quote or brace in one
test therefore silences its innocent
neighbours. Open the file at the named
line; if the line looks innocent, the
unclosed thing usually began earlier —
read upward for the quote or block that
never closed.

## A helper that cannot be found

```text
not ok 1 bats-gather-tests
# bats_load_safe: Could not find '/home/…/no-such-helper'[.bash]
[exit 1]
```

Same stage, different door: a `load`
whose path does not resolve. Remember
that relative loads are relative to the
**test file**, not to the folder you ran
`bats` from — the suite in chapter 8
works from any working directory for
exactly this reason. The `[.bash]` in
the message is bats telling you it
tried the name with the ending added.

## The BW02 warning

A suite that uses flags on `run` (such
as `--separate-stderr`) without
declaring its minimum version still
passes — and is then told, in a
warnings block after the report, that
it assumed more than it declared
(transcript t08 runs chapter 6's suite
with its declaration removed, to show
the warning). The fix is the line
itself, near the top of the file:

```bash
bats_require_minimum_version 1.5.0
```

Name the oldest bats the file truly
needs. The warning is bats being a good
citizen; treat its appearance as a
small review comment on your suite.

## "parallel: command not found", zero tests run

```text
$ bats --jobs 2 tests/temp-convert.bats
1..5
…/bats-exec-suite: line 323: parallel: command not found
# bats warning: Executed 0 instead of expected 5 tests
[exit 1]
```

`--jobs` needs GNU parallel (or rush)
installed, and without it the plan line
says five while nothing executes — the
warning is the only thing standing
between you and believing a fast green
run. Either install the partner tool or
drop `--jobs`; chapter 13 counts this
as a limit, not a bug.

## The pretty formatter dies without TERM

```text
$ env -u TERM bats --formatter pretty tests/temp-convert.bats
tput: No value for $TERM and no -T specified
[exit 2]
```

Pretty decorates with the terminal's
own capabilities, looked up through the
`TERM` variable; a stripped environment
(some CI runners, some cron and SSH
setups) leaves it nothing to look up,
and the run ends at exit 2 with no
report at all. Set `TERM` (to `xterm`,
say) in that environment, or let the
run use TAP, which needs nothing. The
lab met this by accident before it met
it on purpose: the first pretty run in
chapter 5 was attempted in exactly such
an environment.

## A test fails and the report won't say with what

Chapter 5's triple — file, line,
command — is all a bare `[ ... ]` check
can tell you. When you need the values,
that is the helpers' job (chapter 8):
rewrite the check with bats-assert's
`assert_output`, or your own function
that prints expected and actual before
returning 1. Temporarily,
`--print-output-on-failure` shows
`$output` for failing tests without
changing the suite.
