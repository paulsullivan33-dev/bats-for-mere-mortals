#!/usr/bin/env bats
# Tests for ../backup-name.sh.
# Passing a fixed stamp makes the expected name exact; the one
# test that uses the real clock can only check the name's shape,
# and is tagged "clock" so it can be selected or excluded.

# bats test_tags=core
@test "a fixed stamp gives an exact name" {
  run "$BATS_TEST_DIRNAME/../backup-name.sh" photos 20261031-093000
  [ "$status" -eq 0 ]
  [ "$output" = "photos-20261031-093000.tar.gz" ]
}

# bats test_tags=core
@test "the prefix is kept whole, spaces and all" {
  run "$BATS_TEST_DIRNAME/../backup-name.sh" "my photos" 20261031-093000
  [ "$status" -eq 0 ]
  [ "$output" = "my photos-20261031-093000.tar.gz" ]
}

# bats test_tags=clock
@test "the default stamp is the current time, in shape at least" {
  run "$BATS_TEST_DIRNAME/../backup-name.sh" photos
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^photos-[0-9]{8}-[0-9]{6}\.tar\.gz$ ]]
}

# bats test_tags=core
@test "an empty prefix is refused" {
  run "$BATS_TEST_DIRNAME/../backup-name.sh" ""
  [ "$status" -eq 2 ]
  [[ "$output" == *"a prefix is required"* ]]
}
