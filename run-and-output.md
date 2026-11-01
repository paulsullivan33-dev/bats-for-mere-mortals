# run and Output

**Outcome: you can catch everything a
command does — how it ended, all it
printed, its printed lines one by one,
and its error stream separately — and
check each in the way that suits it.**
Almost every line of every test in this
guide begins with `run`, because `run`
is what turns a command's behaviour into
facts a test can assert. The suite that
explores it is `bats-lab/tests/run-and-output.bats`,
and its transcript is
`bats-lab/transcripts/t03-run-and-output.txt`:
six tests, all passing.

## What run leaves behind

```bash
run "$BATS_TEST_DIRNAME/../word-count.sh" "$BATS_TEST_DIRNAME/../sample-text.txt"
```

`word-count.sh` prints two lines for the
lab's nine-word sample file. After the
`run`, three variables describe the
whole performance:

- `$status` — the exit code, here 0.
  `run` deliberately does not let the
  code end the test; capturing it is the
  point.
- `$output` — everything the command
  printed, as one string. Chapter 4
  compared it whole (`[ "$output" =
  "212.0 F" ]`), and for this two-line
  answer the whole-string comparison is
  exact, newline included:

  ```bash
  [ "$output" = "lines: 3
  words: 9" ]
  ```

  One courtesy to know about: `run`
  removes the *trailing* newline, so the
  string ends at `9`, not after it — the
  equality above passing is the proof.
- `$lines` — the same output as an
  array, one element per line, for when
  the lines have individual meanings:

  ```bash
  [ "${lines[0]}" = "lines: 3" ]
  [ "${lines[1]}" = "words: 9" ]
  [ "${#lines[@]}" -eq 2 ]
  ```

And when an exact match is more than
the promise warrants, a pattern will do —
the suite checks the count's shape, not
its value, with Bash's own `=~`:

```bash
[[ "$output" =~ ^lines:\ [0-9]+ ]]
```

Choosing between exact, partial, and
pattern checks is most of test-writing
judgement: assert exactly what the
script promises, no more (a test that
nails down accidents breaks on every
refactor) and no less (a test that only
checks the exit code would pass a script
printing nonsense happily).

## The error stream: mixed, or apart

By default `run` merges the command's
standard error into `$output`. For the
lab's scripts that is often what you
want — their refusal messages are part
of their behaviour, and two suites check
them as output. When the streams must
be judged separately, `run` takes a
flag:

```bash
run --separate-stderr "$BATS_TEST_DIRNAME/../word-count.sh" missing.txt
[ "$status" -eq 2 ]
[ -z "$output" ]
[[ "$stderr" == *"no such file: missing.txt"* ]]
```

Now the error text lives in `$stderr`,
and `$output` is provably empty — the
test asserts both. One piece of ceremony
comes with the flag, and the lab met it
as a warning before it met it as a rule:
flags on `run` arrived in bats 1.5, and
bats asks files that use them to say so.
The suite therefore opens with

```bash
bats_require_minimum_version 1.5.0
```

and transcript t08 shows the warning
(code BW02) that the same suite produces
without the line — bats still runs the
tests, but it tells you, in writing,
that the file assumes more than it
declared. Treat the declaration as part
of the file's honesty: anyone reading
the suite learns the oldest bats that
can be trusted with it.

## Two things run is not

`run` does not feed the command input:
a script that reads its standard input
needs the input arranged around the
`run` (a pipeline inside a `bash -c`, or
input from a file the script takes as an
argument, as all three lab scripts do).
And `run` does not make a failing
command pass: it records the failure in
`$status` and carries on so that the
*test's* checks decide what the failure
means. The converter's refusals exit 2
by design; in chapter 4's suite that 2
is a kept promise, asserted like any
other number.
