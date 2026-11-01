#!/usr/bin/env bats
# This file uses `run --separate-stderr`, a flag from bats 1.5;
# the line below declares that, and bats warns without it.
bats_require_minimum_version 1.5.0
# A closer look at `run`: the exit status, the whole output,
# the output as separate lines, and the error stream kept apart.
# The script under test here is ../word-count.sh, whose two-line
# answer is what makes $lines worth meeting.

@test "run records the exit status of a success" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
  [ "$status" -eq 0 ]
}

@test "the whole output is one string, newlines and all" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
  [ "$output" = "lines: 3
words: 9" ]
}

@test "the output is also there line by line" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
  [ "${lines[0]}" = "lines: 3" ]
  [ "${lines[1]}" = "words: 9" ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "a pattern can stand in for an exact match" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
  [[ "$output" =~ ^lines:\ [0-9]+ ]]
}

@test "with --separate-stderr the error stream stands alone" {
  run --separate-stderr "$BATS_TEST_DIRNAME/../word-count.sh" missing.txt
  [ "$status" -eq 2 ]
  [ -z "$output" ]
  [[ "$stderr" == *"no such file: missing.txt"* ]]
}

@test "without it, errors arrive mixed into the output" {
  run "$BATS_TEST_DIRNAME/../word-count.sh" missing.txt
  [ "$status" -eq 2 ]
  [[ "$output" == *"no such file: missing.txt"* ]]
}
