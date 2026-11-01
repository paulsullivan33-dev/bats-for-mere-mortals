# When a Test Fails

**Outcome: you can read a failure report
the way its author hoped someone would —
which test, which line, which exact
command — and you know what the suite's
exit code promises a build server.** A
guide that only shows green reports is
teaching half the tool, so this guide's
lab keeps a file that is wrong on
purpose: `bats-lab/failing-example.bats`.
It lives *outside* the `tests/` folder so
no ordinary run ever trips over it; the
lab runs it only here, and in chapter
11's canary recipe.

## The exhibit

```bash
#!/usr/bin/env bats

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
```

Two claims are false — 0 °C is 32.0 °F,
not 30.0; and the script refuses the K
scale with exit 2, not 0. The third test
is honest in a different way: the
feature it names does not exist, so
instead of asserting something false or
leaving a landmine, it calls `skip` with
its reason and stops there.

## The report, for a person

Run with the pretty formatter (transcript
`bats-lab/transcripts/t02-the-failing-example.txt`;
the colour codes are removed here, the
words are exact):

```text
$ bats --formatter pretty failing-example.bats
failing-example.bats
 ✗ zero Celsius is thirty Fahrenheit (wrong on purpose)
   (in test file failing-example.bats, line 12)
     `[ "$output" = "30.0 F" ]' failed
 ✗ a bad scale still exits zero (wrong on purpose)
   (in test file failing-example.bats, line 17)
     `[ "$status" -eq 0 ]' failed
 - kelvin support (not yet, so skipped) (skipped: temp-convert.sh speaks only C and F for now)

3 tests, 2 failures, 1 skipped
[exit 1]
```

Three facts per failure, always the
same three. **The test**, by the name
you wrote. **The place**: file and line
number of the command that failed —
line 12 is the output check, and the
status check on line 11 had already
passed, which tells you the script ran
and exited happily but printed the
"wrong" thing. **The command itself**,
quoted exactly as written, so there is
no guessing which of the test's several
checks gave way. A test stops at its
first failing command — nothing after
line 12 in that test was run — but the
suite does not stop: the second test ran
and failed on its own line 17, and the
summary counts all three verdicts,
including the skip and its reason.

## The same run, for a machine

Without `--formatter`, a run whose
output is a pipe gets TAP (chapter 10
explains the choice), and the failure
lines grow `#` diagnostics:

```text
$ bats failing-example.bats
1..3
not ok 1 zero Celsius is thirty Fahrenheit (wrong on purpose)
# (in test file failing-example.bats, line 12)
#   `[ "$output" = "30.0 F" ]' failed
not ok 2 a bad scale still exits zero (wrong on purpose)
# (in test file failing-example.bats, line 17)
#   `[ "$status" -eq 0 ]' failed
ok 3 kelvin support (not yet, so skipped) # skip temp-convert.sh speaks only C and F for now
[exit 1]
```

Note the skipped test's line: `ok 3 …
# skip …`. In TAP a skip is recorded as
an ok with an explanation — it is not a
promise kept, and the summary in the
pretty report counts it separately,
which is the more honest bookkeeping.
Neither report shows what the script
*actually* printed (32.0 F) — only that
the comparison failed. When you need
the actual values while debugging, the
options exist (`--print-output-on-failure`
shows `$output` for failing tests, and
chapter 8's assertion libraries print
expected against actual as a matter of
course); transcript t05 shows a helper
doing exactly that. For a first read,
the file-line-command triple is usually
enough to open the test at the right
line and see the whole story.

## The exit codes, all of them

A bats run ends in one of a few ways,
and this guide's lab met them all:

- **0** — every gathered test passed
  (skips do not spoil it), or an empty
  suite was explicitly allowed with
  `--allow-empty-suite`.
- **1** — at least one test failed, or
  the run never got going: a missing
  file, an empty folder, a file that
  does not parse (chapter 14, transcript
  t08). A build server needs no finer
  distinction than "not green", and 1
  is the whole vocabulary of not green.
- **2** — met once by the lab, when the
  pretty formatter could not start
  without a terminal type (chapter 14):
  bats reporting that *it*, not the
  tests, had the problem.

The suite is the unit of trust: a build
server that runs `bats tests/` and keys
on the exit code will catch every
failure this chapter showed, and will
never be told "passed" by a run where
something failed. What it cannot catch
is a claim nobody wrote — which is
chapter 13's subject.
