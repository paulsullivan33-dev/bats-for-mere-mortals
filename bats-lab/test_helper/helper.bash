# helper.bash — small assertions of this guide's own, loaded by
# tests/with-helpers.bats with `load`. An assertion is an
# ordinary Bash function: return 0 to pass, anything else to
# fail, and say why on stderr — bats shows that text when the
# test fails.

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
