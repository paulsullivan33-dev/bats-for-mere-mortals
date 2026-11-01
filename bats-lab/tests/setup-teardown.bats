#!/usr/bin/env bats
# setup and teardown, watched as they work. Every stage writes
# one line to a log in the file-wide temporary folder; the tests
# read the log and so prove the order things ran in. The guide's
# transcript t04 shows the finished log itself: run with
# --no-tempdir-cleanup, the log survives in the run's temporary
# folder to be read afterwards. (Output printed by
# teardown_file itself goes nowhere a report shows — one of
# this file's lessons is that the log file is the evidence,
# not the printing.)

setup_file() {
  # Runs once, before the first test in this file. It prepares
  # a file every test in the file will share: three fixed stamps.
  printf 'setup_file\n' >> "$BATS_FILE_TMPDIR/lifecycle.log"
  printf '%s\n' 20261031-093000 20261101-120000 20261102-173015 \
    > "$BATS_FILE_TMPDIR/stamps.txt"
}

setup() {
  # Runs before every single test. The log records the test's
  # NUMBER, not its name: a test's internal name is its
  # description rewritten (prefixed, punctuation encoded), and
  # the number is the stable thing to check.
  printf 'setup: test %s\n' "$BATS_TEST_NUMBER" >> "$BATS_FILE_TMPDIR/lifecycle.log"
  mkdir -p "$BATS_TEST_TMPDIR/work"
}

teardown() {
  # Runs after every single test, pass or fail.
  printf 'teardown: test %s\n' "$BATS_TEST_NUMBER" >> "$BATS_FILE_TMPDIR/lifecycle.log"
}

teardown_file() {
  # Runs once, after the last test in the file.
  printf 'teardown_file\n' >> "$BATS_FILE_TMPDIR/lifecycle.log"
}

@test "the shared file from setup_file is there" {
  [ "$(head -n 1 "$BATS_FILE_TMPDIR/stamps.txt")" = "20261031-093000" ]
  [ "$(wc -l < "$BATS_FILE_TMPDIR/stamps.txt")" -eq 3 ]
}

@test "setup made the work folder for this test" {
  [ -d "$BATS_TEST_TMPDIR/work" ]
  grep -q "setup: test 2" "$BATS_FILE_TMPDIR/lifecycle.log"
}

@test "the first test's teardown already ran" {
  grep -q "teardown: test 1" "$BATS_FILE_TMPDIR/lifecycle.log"
}
