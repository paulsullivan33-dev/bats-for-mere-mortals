# Setup and Teardown

**Outcome: you can prepare ground before
tests and clear it away after them, at
two scales — once per file, and once per
test — and you have seen the order those
preparations run in proved, not merely
asserted.** Tests that build their own
fixtures are tests a stranger can run;
tests that depend on yesterday's files
are archaeology. The hooks of chapter 2
are how a suite builds its ground.

## The exhibit: a suite that logs itself

`bats-lab/tests/setup-teardown.bats`
defines all four hooks, and every stage
writes one line to a log in the
file-wide temporary folder:

```bash
setup_file() {
  printf 'setup_file\n' >> "$BATS_FILE_TMPDIR/lifecycle.log"
  printf '%s\n' 20261031-093000 20261101-120000 20261102-173015 \
    > "$BATS_FILE_TMPDIR/stamps.txt"
}

setup() {
  printf 'setup: test %s\n' "$BATS_TEST_NUMBER" >> "$BATS_FILE_TMPDIR/lifecycle.log"
  mkdir -p "$BATS_TEST_TMPDIR/work"
}

teardown() {
  printf 'teardown: test %s\n' "$BATS_TEST_NUMBER" >> "$BATS_FILE_TMPDIR/lifecycle.log"
}

teardown_file() {
  printf 'teardown_file\n' >> "$BATS_FILE_TMPDIR/lifecycle.log"
}
```

`setup_file` also prepares a file of
three fixed stamps that the file's tests
share. The tests then read the log to
check the stagehands did their work —
the second test, for instance, asserts
that its own `setup` line is already in
the log and that the work folder exists;
the third asserts that the *first* test's
teardown line is there, which can only
be true if teardown follows each test
rather than trailing at the end.

## The proof

Run with `--no-tempdir-cleanup` so the
temporary folder survives, the finished
log (transcript
`bats-lab/transcripts/t04-setup-and-teardown.txt`)
reads exactly as the model promises:

```text
setup_file
setup: test 1
teardown: test 1
setup: test 2
teardown: test 2
setup: test 3
teardown: test 3
teardown_file
```

Once per file at each end; a setup and a
teardown wrapped around every test, in
order. And teardown's "pass or fail"
clause is not a rumour either: the same
transcript runs a scratch file of three
tests whose middle one deliberately
fails, and its log shows `teardown:
test 2` present and correct between the
failure and test 3 — the cleanup you
rely on most is the cleanup after a
failure, and it runs.

## Two lessons the lab learned writing it

**Log the number, not the name.** The
suite's first draft recorded
`$BATS_TEST_NAME`, expecting the test's
description in a tidy form. What it got
was bats' *internal* name for the test:
prefixed with `test_`, with punctuation
encoded (`setup_file` inside a
description came back as
`setup-2d5ffile`). The internal name is
an implementation detail, not an
interface, and the lab's fix — record
`$BATS_TEST_NUMBER`, the stable fact —
is the general rule: in tests, lean on
what bats promises (numbers, folders,
statuses), not on how it spells things
internally.

**Output from `teardown_file` goes
nowhere.** The first draft also had
`teardown_file` print the finished log,
expecting the report to show it. No
formatter displays it. Evidence that
must outlive a run belongs in a *file* —
as here, read afterwards because the
run's folder was kept — not in a print
statement at the file's edge. (Output
from a *test*, by contrast, bats does
keep: failing tests show theirs, and
`--show-output-of-passing-tests` shows
the rest.)

## Which scale for which job

Per-file preparation (`setup_file`) is
for the expensive and the shared: a
fixture tree every test reads, a sample
database, generated inputs like the
stamps file. Per-test preparation
(`setup`) is for what must be fresh: a
clean work folder, a configuration
pointed at this test's temporary folder.
The mirror rule for teardown: per-test
teardown removes what a test made even
when it failed — the next test's clean
start depends on it — and
`teardown_file` retires the shared
things. And a mercy built into the
variables themselves: folders under
`$BATS_TEST_TMPDIR` and `$BATS_FILE_TMPDIR`
are removed by bats when the run ends,
so a suite whose teardown does nothing
still leaves no litter behind it. The
hooks are for *meaning* — state the next
test must or must not see — more than
for tidiness.
