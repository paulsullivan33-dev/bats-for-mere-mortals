#!/usr/bin/env bats
# Helpers, loaded three ways: this guide's own helper.bash,
# then the bats-support and bats-assert libraries the wider
# bats world uses, vendored under ../test_helper/.

load '../test_helper/helper'
load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'

@test "our own helper checks the status in words" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 100 C
  assert_status 0
}

@test "our own helper finds text inside the output" {
  run "$BATS_TEST_DIRNAME/../backup-name.sh" photos 20261031-093000
  assert_output_contains "20261031-093000"
}

@test "bats-assert says the same things more formally" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 32 F
  assert_success
  assert_output "0.0 C"
}

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
