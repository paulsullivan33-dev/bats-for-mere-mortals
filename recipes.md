# Recipes

**Outcome: four working patterns, each
assembled from pieces the earlier
chapters ran for real.** Where a recipe
leans on something the lab only read,
the recipe says so at that step.

## 1. Test the refusals first

For any script that takes input, write
the refusal tests before the happy ones:

```bash
@test "a value that is not a number is refused" {
  run "$BATS_TEST_DIRNAME/../temp-convert.sh" warm C
  [ "$status" -eq 2 ]
}
```

Chapter 4's suite is the worked example.
The reasoning: a script's conversions
are usually right the day they are
written and stay right; its input
checking is where edits quietly widen
the gate. Assert the *exact* refusal
code, and the refusal message too where
other tools may read it — chapter 6
shows the message checked both mixed
into `$output` and apart in `$stderr`.

## 2. Make time an argument

A script whose output depends on the
clock produces a different right answer
every second, and exact assertions
become impossible. The lab's
`backup-name.sh` shows the seam: the
stamp is an optional second argument,
defaulting to now.

```bash
stamp=${2:-$(date +%Y%m%d-%H%M%S)}
```

In use, nothing changes. In tests, the
stamp is fixed and the whole name can be
asserted exactly (`photos-20261031-093000.tar.gz`).
One test still exercises the real clock
— the shape of its output checked by
pattern, never the value — and carries
a tag (`clock`) so it can be run, or
skipped, on purpose (chapter 9). Any
"now", "today", or random source in a
script wants the same treatment: an
optional input with a live default.

## 3. Keep a canary file that must fail

A build server that has never seen red
will eventually show green for the wrong
reason — a suite not gathered, a path
gone stale, an empty folder passing as
success. Keep one file like chapter 5's
`failing-example.bats` *outside* the
real suites, and let the build run it
as its own step whose expected result
is exit code **1**:

```bash
bats canary/failing-example.bats
# this step is SUPPOSED to exit 1:
# 2 failures, 1 skipped, as designed
```

If the canary ever exits 0, the alarm
system itself is broken, whatever the
real suites say. Everything the canary
relies on was run by the lab: the file,
its two failures and one skip, and its
exit code (transcript t02). The same
instinct produced `--allow-empty-suite`'s
opposite number in chapter 14: an empty
suite *fails* by default, so a suite
that silently gathers nothing cannot
impersonate a passing one.

## 4. Hand a build server its two signals

Chapter 10's hand-off, assembled. The
server runs the whole suite, watches
the exit code, and archives the report:

```bash
mkdir -p test-reports
bats --report-formatter junit \
     --output test-reports \
     tests/
echo "suite exit code: $?"
```

Exit 0: green, and the XML is a record.
Exit 1: red, and the XML names the
failing tests for the server's report
page while the log carries the TAP
diagnostics. The report folder is made
first because `--output` requires an
existing directory (chapter 10). The
lab ran every element of this — the
formatter, the report file, the exit
codes; what it did not do is configure
an actual server, which is the GitHub
Actions guide's territory in this
series.

## A note on rerunning only failures

Bats offers `--filter-status failed`,
which reruns the tests that failed (or
were absent) in the last completed run —
the natural tight loop after a red
suite. The lab did not exercise it, so
it is named here as documented rather
than demonstrated; if you adopt it,
verify its behaviour on your own suite
before trusting it in a pipeline. The
same honesty applies to running suites
in parallel with `--jobs`, which needs
GNU parallel (or rush) installed: the
lab's machine has neither, and
chapter 14 shows the error that fact
produces.
