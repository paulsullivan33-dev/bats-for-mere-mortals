# Your First Tests

**Outcome: a five-test suite for a real
script, all passing, and a report you
can read line by line — the shape every
later chapter elaborates.** The script
under test is this guide's own
temperature converter, `bats-lab/temp-convert.sh`:

```bash
#!/usr/bin/env bash
# temp-convert.sh VALUE SCALE
#
# Converts a temperature to the other scale and prints the result.
#   temp-convert.sh 100 C   ->  212.0 F
#   temp-convert.sh 32 F    ->  0.0 C
# A value that is not a number, or a scale other than C or F,
# is an error: a message on stderr and exit code 2.
set -u

value=${1:-}
scale=${2:-}

if [[ ! $value =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
  echo "temp-convert: '$value' is not a number" >&2
  exit 2
fi

case $scale in
  C) awk -v c="$value" 'BEGIN { printf "%.1f F\n", c * 9 / 5 + 32 }' ;;
  F) awk -v f="$value" 'BEGIN { printf "%.1f C\n", (f - 32) * 5 / 9 }' ;;
  *)
    echo "temp-convert: scale must be C or F" >&2
    exit 2
    ;;
esac
```

It makes three kinds of promise: it
converts (100 °C is 212.0 °F; 32 °F is
0.0 °C; −40 is where the scales cross),
and it refuses — a non-number, or a
scale it does not speak, gets a message
and exit code 2. A good first suite
tests the refusals as seriously as the
conversions, because a script that
accepts everything has failed at its
main job.

## The suite

`bats-lab/tests/temp-convert.bats`, in
full:

```bash
#!/usr/bin/env bats

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
```

Four habits are already visible, and the
guide will keep all four. The script is
found as `$BATS_TEST_DIRNAME/../temp-convert.sh`
— the folder this test file lives in,
one level up — so the suite works
wherever the repository is checked out,
with no path edited per machine. Every
invocation goes through `run`, so the
exit code becomes a checkable fact
instead of an accident that ends the
test. Both halves of a promise are
checked — the status *and* the printed
answer — because a script can be right
in one and wrong in the other. And the
refusals assert the exact code, 2, not
merely "something went wrong", because
the code is part of the script's
contract with anything that calls it.

## Running it

From the transcript
(`bats-lab/transcripts/t01-first-suite.txt`),
which first runs the script by hand so
the claims have a face:

```text
$ ./temp-convert.sh 100 C
212.0 F
$ ./temp-convert.sh 32 F
0.0 C
$ bats tests/temp-convert.bats
1..5
ok 1 boiling point of water in Fahrenheit
ok 2 freezing point of water in Celsius
ok 3 minus forty is the same in both scales
ok 4 a value that is not a number is refused
ok 5 an unknown scale is refused
[exit 0]
```

Read the report as three parts. The
plan line, `1..5`, states how many tests
were gathered — if it ever disagrees
with the file you wrote, the gathering
is where to look (chapter 14). Each
`ok` line names one kept promise, in the
words you gave it. And bats' own exit
code — the `[exit 0]` the transcript
adds after every run in this guide — is
the suite's verdict in one number.
Point bats at the folder instead of the
file and it runs every `.bats` file it
finds there; the same transcript ends
with the whole lab suite, `1..23`, all
ok, exit 0.

Your check, on your own machine: pick
the smallest script you own, write three
claims — one conversion-shaped success,
one refusal — and watch for your own
`1..3`.
