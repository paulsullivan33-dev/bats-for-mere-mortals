# Bats for Mere Mortals

Every machine accumulates Bash scripts:
the backup that runs at night, the little
converter somebody wrote once, the
installer glue holding a project
together. And almost every one of them
is tested the same way — by running it
and looking at what happens, once, by
hand, on a good day. **Bats** (the Bash
Automated Testing System) is the tool
that replaces that ritual with a file.
You write down what your script should
do — feed it this, it should print that,
refuse this, exit with that code — in
test files that are themselves Bash with
one new shape, the `@test` block. One
command, `bats`, runs every claim and
reports **ok**, **not ok**, or **skipped**
for each, and its own exit code tells a
build server whether the whole suite
passed. No assertion library is required
to start: a test passes if every command
in it succeeds, and `[ "$output" =
"212.0 F" ]` is a complete assertion.

The lab that wrote this guide ran the
real thing: **Bats 1.14.0**, installed
from the project's official release,
on a small Linux machine with Bash
5.2. Against it the lab wrote three
small scripts of its own — a temperature
converter, a backup-file namer, and a
word counter, all of them in this
repository's `bats-lab/` — and tested
them for real: twenty-three tests, all
passing. It also kept one test file
deliberately wrong, so you can see a
genuine failure report — the exact file
and line, the exact command that failed —
before one surprises you in your own
work, and it exercised the framework's
edges on purpose: setup and teardown
watched through a log file they wrote
themselves, helpers loaded three ways,
tests selected by name, by tag, and by
exclusion, three output formats and a
JUnit report, and the ways bats itself
complains when a file is missing,
empty, misspelled, or asked to run in
parallel without the tool that takes.

What the lab could not do, it did not
fake. Its machine has no **GNU parallel**,
so bats' parallel running is described
from the documentation and the honest
error you get without it, not from a
benchmark. The neighbour frameworks of
chapter 12 are characterised, not run.
`criteria.md` keeps the full ledger of
what was run and what was only read.

## What this guide covers

- [**What Bats is**](what-bats-is.md) —
  the mental model: scripts under test,
  claims written as Bash, and a report
  a machine can act on
- [**The moving parts**](the-moving-parts.md) —
  the runner, the test file, `run`, the
  setup and teardown hooks, helpers, and
  the temporary folders bats keeps
- [**Installing Bats**](installing-bats.md) —
  the release download, the one-command
  installer, and the version check that
  proves it runs
- [**Your first tests**](your-first-tests.md) —
  a five-test suite for a temperature
  converter, run for real, and how to
  read its report line by line
- [**When a test fails**](when-a-test-fails.md) —
  the deliberately wrong file: anatomy
  of a failure report, the suite's exit
  codes, and the third verdict, skipped
- [**run and output**](run-and-output.md) —
  what `run` catches for you: the status,
  the whole output, the output line by
  line, and the error stream kept apart
- [**Setup and teardown**](setup-and-teardown.md) —
  the four hooks that prepare and clean
  up, proven in order by a log they
  wrote themselves
- [**Helpers and load**](helpers-and-load.md) —
  sharing checks between tests: your own
  helper file, and the bats-support and
  bats-assert libraries most suites use
- [**Filtering and selecting**](filtering-and-selecting.md) —
  running one file, tests chosen by a
  pattern in their names, by tags, or by
  leaving some out — and counting first
- [**Formatters and reports**](formatters-and-reports.md) —
  pretty for your eyes, TAP for machines,
  TAP13, timings, and a JUnit report file
  for a build server
- [**Recipes**](recipes.md) — test the
  refusals first, make time an argument,
  keep a canary file that must fail, and
  hand a build server its report
- [**The neighbours**](the-neighbours.md) —
  shunit2, ShellSpec, a plain check
  function, and the linter next door:
  what each does that bats doesn't, and
  vice versa
- [**Limits**](limits.md) — Bash is the
  language, parallel needs a partner tool,
  a passing test proves only what it
  asserts, and the other edges, stated
  plainly
- [**Troubleshooting**](troubleshooting.md) —
  the missing file, the empty folder, the
  syntax error that stops everything, the
  version warning, and the pretty report
  that needs a terminal
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Testing interactive programs that expect
a person at the keyboard, or programs
driven through a terminal's full screen —
bats runs commands and reads what they
print; it is not a terminal puppeteer.
Writing the scripts themselves is the
Bash guide's job; this one assumes a
script exists and asks whether it keeps
its promises. Running the suite on a
schedule or a push — chapter 11 hands a
build server everything it needs, but
configuring that server is its own
subject, and this series' GitHub Actions
guide is the natural next step.

## How to use this guide

Read chapter 1 for the model and
chapter 2 before installing anything —
knowing which part holds what turns
later confusion into a named problem.
Chapters 3 and 4 get you a runner and a
green suite in one sitting. Read
chapter 5 slowly even if your own suite
is green: the failure report is the
half of the tool you will actually live
in. The lab's own material lives in
`bats-lab/` — the three scripts under
test, their suites under
`bats-lab/tests/`, the one wrong file
kept on purpose, the vendored helper
libraries under `bats-lab/test_helper/`,
and every transcript cited, in
`bats-lab/transcripts/`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Bash for Mere Mortals](https://paulsullivan33-dev.github.io/bash-for-mere-mortals/)
- [ShellCheck for Mere Mortals](https://paulsullivan33-dev.github.io/shellcheck-for-mere-mortals/)
- [Pre-commit for Mere Mortals](https://paulsullivan33-dev.github.io/pre-commit-for-mere-mortals/)
- [GitHub Actions for Mere Mortals](https://paulsullivan33-dev.github.io/github-actions-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/bats-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/bats-for-mere-mortals/blob/main/LICENSE-CODE).
