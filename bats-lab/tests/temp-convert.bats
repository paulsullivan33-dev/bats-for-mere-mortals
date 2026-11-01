#!/usr/bin/env bats
# Tests for ../temp-convert.sh — the guide's first suite.
# BATS_TEST_DIRNAME is the folder this file lives in, so the
# script under test is always one level up, wherever the
# repository itself happens to sit.

@test "boiling point of water in Fahrenheit" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 100 C
  [ "$status" -eq 0 ]
  [ "$output" = "212.0 F" ]
}

@test "freezing point of water in Celsius" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 32 F
  [ "$status" -eq 0 ]
  [ "$output" = "0.0 C" ]
}

@test "minus forty is the same in both scales" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" -40 C
  [ "$status" -eq 0 ]
  [ "$output" = "-40.0 F" ]
}

@test "a value that is not a number is refused" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" warm C
  [ "$status" -eq 2 ]
}

@test "an unknown scale is refused" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" 100 K
  [ "$status" -eq 2 ]
}
