# Glossary

**Assertion** — a check inside a test:
a command whose exit code the test
believes. It may be Bash's own
`[ "$output" = "212.0 F" ]`, a function
from a helper, or a library's
`assert_output`. All three are the same
idea at different levels of ceremony.

**bats-assert** — the standard
assertion library of the bats project
(load on top of bats-support): `assert_success`,
`assert_output`, `assert_line` and
their `refute_` opposites, with failure
messages that print expected against
actual. Chapter 8.

**bats-gather-tests** — the pseudo-test
bats reports when a run fails before
any test could run: a missing file, a
syntax error, an unresolvable `load`.
Its failure in a report means "the
suite never started", whatever the
wording after it. Chapter 14.

**bats-support** — the foundation
library of the bats project: shared
plumbing, including the failure-message
machinery bats-assert builds on. Loaded
before bats-assert. Chapter 8.

**BW02 (and friends)** — bats' warning
codes, printed after a run when a file
does something its declared minimum
version doesn't cover. BW02 concerns
flags on `run`. The fix is a truthful
`bats_require_minimum_version` line.
Chapter 14.

**Exit status** — the number a command
ends with: 0 for success, anything else
for some shade of refusal or failure.
Tests are built from exit statuses —
of the script under test (`$status`)
and of the checks themselves.

**Formatter** — the component that
renders a run's facts for the terminal:
pretty, tap, tap13, or junit. Distinct
from a *report formatter*, which writes
a file at the same time. Chapter 10.

**Gathering** — bats' first stage:
finding the files, parsing them,
collecting the tests, and printing the
plan. Most of chapter 14 happens here.

**Helper** — a `.bash` file of shared
functions — assertions, fixture
builders — pulled into test files with
`load`. Chapter 8.

**Hook** — one of `setup_file`, `setup`,
`teardown`, `teardown_file`: functions
bats runs around a file's tests or
around each test. Chapter 7.

**load** — the bats command that sources
a helper file, resolving relative paths
against the test file's own folder, and
stops the run cleanly if the file
cannot be found.

**Plan line** — the first line of a TAP
report, `1..N`, stating how many tests
were gathered. If it disagrees with
what you wrote, gathering is where to
look.

**refute_** — the negative half of the
bats-assert vocabulary: `refute_output`,
`refute_line` and kin insist that a
pattern or line is *absent*.

**run** — the bats command that executes
the command under test and records the
outcome in `$status`, `$output`, and
`$lines` (and `$stderr`, with
`--separate-stderr`) instead of letting
the exit code end the test. Chapter 6.

**Skip** — a test's third verdict:
declared inside the test with `skip
"reason"`, recorded as an ok-with-note
in TAP and counted separately by the
pretty summary. For features honestly
not there yet, not for failures you'd
rather not see. Chapter 5.

**Suite** — all the tests a run covers:
one file, or every `.bats` file in a
folder. The unit whose exit code a
build server believes.

**Tag** — a label declared in a
`# bats test_tags=` comment above a
test, selectable with `--filter-tags`
(including `!` negation). Chapter 9.

**TAP** — the Test Anything Protocol: a
plan line, one `ok` / `not ok` line per
test, `#` lines for diagnostics. The
plain-text report bats emits when its
output is a pipe, and the facts every
other formatter dresses.

**TAP13** — TAP version 13: the same
report with a version header and room
for YAML diagnostic blocks. Chapter 10.

**Test file** — a `.bats` file: Bash in
which `@test "name" { ... }` blocks are
rewritten by bats into functions it can
run one by one.
