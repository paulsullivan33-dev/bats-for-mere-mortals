#!/usr/bin/env bats
# failing-example.bats — a teaching exhibit, kept OUTSIDE the
# tests/ folder on purpose. Two of its three tests fail, and
# they are meant to: the guide runs this file so the reader can
# see a real failure report before one surprises them in their
# own work. The third test is skipped, which is the third thing
# a bats report can say about a test.

@test "zero Celsius is thirty Fahrenheit (wrong on purpose)" {
  run "$BATS_TEST_DIRNAME/temp-convert.sh" 0 C
  [ "$status" -eq 0 ]
  [ "$output" = "30.0 F" ]
}

@test "a bad scale still exits zero (wrong on purpose)" {
  run "$BATS_TEST_DIRNAME/temp-convert.sh" 100 K
  [ "$status" -eq 0 ]
}

@test "kelvin support (not yet, so skipped)" {
  skip "temp-convert.sh speaks only C and F for now"
  run "$BATS_TEST_DIRNAME/temp-convert.sh" 0 K
  [ "$output" = "273.15 C" ]
}
