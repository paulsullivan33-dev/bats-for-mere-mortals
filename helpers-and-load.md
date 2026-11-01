# Helpers and load

**Outcome: checks you write once can
serve every test you own — first with a
helper file of your own, then with the
two libraries most of the bats world
uses — and a failing helper explains
itself in the report.** Chapter 4's
checks were written out in full each
time: `[ "$status" -eq 0 ]`,
`[ "$output" = "..." ]`. That is right
for five tests. By fifty, the same
phrases want names.

## load: how helpers arrive

A helper is an ordinary `.bash` file.
A test file pulls it in with `load`,
giving the path *relative to the test
file itself*, with the `.bash` ending
optional:

```bash
load '../test_helper/helper'
```

`load` is careful in a way plain
`sourcing` is not: a helper that cannot
be found stops the file at the gather
stage with a plain message — transcript
t08 shows `bats_load_safe: Could not
find '…' [.bash]` against a scratch
file — rather than letting tests run on
half-loaded definitions and fail
mysteriously later.

## Your own helper first

This guide's lab keeps its helper small
on purpose — `bats-lab/test_helper/helper.bash`,
two functions:

```bash
# assert_status EXPECTED — the last `run` ended with this code.
assert_status() {
  if [ "$status" -ne "$1" ]; then
    echo "expected status $1, got $status" >&2
    return 1
  fi
}

# assert_output_contains TEXT — the last `run` printed TEXT
# somewhere in its output.
assert_output_contains() {
  if [[ "$output" != *"$1"* ]]; then
    echo "expected output to contain: $1" >&2
    echo "actual output: $output" >&2
    return 1
  fi
}
```

An assertion, it turns out, is nothing
ceremonial: a function that returns 0
when the world is as expected, and
returns non-zero — after saying why, on
the error stream — when it is not.
Everything in the libraries below is
this idea, more thoroughly furnished.
The suite `tests/with-helpers.bats`
loads the helper and uses both
functions; and what a helper buys you
shows best when it *fails*, so the lab
ran a scratch test that demands the
converter's output contain `999.9 F`
(transcript
`bats-lab/transcripts/t05-helpers-and-load.txt`):

```text
not ok 1 a helper failing, on purpose
# (from function `assert_output_contains' in file test_helper/helper.bash, line 21,
#  in test file /home/hatch/workspace/bats-labwork/helper-failure.bats, line 5)
#   `assert_output_contains "999.9 F"' failed
# expected output to contain: 999.9 F
# actual output: 212.0 F
```

The report names the helper function and
its own line, the test and its line, and
then the helper's explanation: expected
999.9 F, actual 212.0 F. Compare chapter
5's bare failure — a quoted command and
nothing else — and the case for helpers
makes itself: they are how a failure
report learns to say *what the values
were*.

## The standard libraries: bats-support and bats-assert

Most real suites load two libraries from
the bats project itself. **bats-support**
(0.3.0) is the foundation — shared
plumbing, including the failure-message
machinery. **bats-assert** (2.2.4) builds
the vocabulary on it: `assert_success`
and `assert_failure` (optionally with
the exact code), `assert_output` (exact,
`--partial` for contains, `--regexp` for
a pattern), `assert_line` and
`refute_line` (by index or by content),
and their `refute_` counterparts for
insisting something is *not* there.
Loading is three lines — support before
assert, since assert stands on it:

```bash
load '../test_helper/helper'
load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'
```

and the same checks from chapter 4 come
back wearing words:

```bash
@test "bats-assert can insist a failure happened" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 100 K
  assert_failure 2
  assert_output --partial "scale must be C or F"
}

@test "bats-assert reads the answer line by line" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
  assert_success
  assert_line --index 0 "lines: 3"
  assert_line --index 1 "words: 9"
  refute_line --index 0 "lines: 4"
}
```

All five tests of `tests/with-helpers.bats`
pass in transcript t05. The lab
**vendored** the two libraries — copies
live in `bats-lab/test_helper/`, under
their own MIT licences — because suites
commonly do exactly that, so the tests
run identically on any machine with no
further downloading. The vendored copies
are trimmed to their loaders, sources
and licences; the libraries' own test
suites were left out, so a recursive
run from the lab's root never wanders
into them. If you fetch them yourself
(they live beside bats-core on GitHub,
at the versions named above), the
untrimmed releases are the same code
with their own tests included.

## Which to use

Your own helper for the checks only your
project makes ("the archive name carries
today's stamp"), the libraries for the
checks everyone makes, and plain
`[ ... ]` whenever a single check appears
once and words would be costume. The
three mix freely in one file — the lab's
suite does — because underneath, all of
them are the same thing: commands whose
exit codes a test believes.
