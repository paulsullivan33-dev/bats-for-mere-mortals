# Formatters and Reports

**Outcome: the same run can be dressed
for a person, a pipe, a stricter machine
reader, or a build server's report file
— and you know which one you are looking
at, and why.** Chapter 2 named the
split: bats gathers *facts* (each test's
verdict and diagnostics) and a formatter
renders them. This chapter exercises the
renderers; all of it is transcript
`bats-lab/transcripts/t07-formatters-and-reports.txt`,
with chapter 5's t02 as the failure
exhibit.

## Which formatter you get by default

Bats chooses by audience. Attached to a
terminal, you get **pretty** — check
marks and crosses, one indented block
per file, a summary line (`5 tests, 0
failures`). Piped into a file or another
program, you get **tap** — the plan line
and `ok` lines of chapter 4. The `--help`
text says it in so many words: *pretty
(default), tap (default w/o term)*. That
is why the transcripts in this guide so
often show TAP: they are captured
through pipes, and the choice was bats',
made correctly. Either can be forced
with `--formatter` (or the shorthands
`-p` and `-t`), as chapter 5 did to show
one run both ways.

## tap13: the stricter dialect

```text
$ bats --formatter tap13 tests/temp-convert.bats
TAP version 13
1..5
ok 1 boiling point of water in Fahrenheit
...
```

TAP version 13 is TAP with a header and
room for structured diagnostics in YAML
blocks under failing tests — the dialect
stricter consumers ask for. On a green
run it differs from plain TAP by its
first line alone; the lab's failing
exhibit was rendered in pretty and tap
(chapter 5), and tap13's failure
dressing is described here from the
format rather than from a lab run.

## Timing

`--timing` (or `-T`) appends each test's
duration to its line:

```text
$ bats --timing tests/temp-convert.bats
1..5
ok 1 boiling point of water in Fahrenheit in 13ms
ok 2 freezing point of water in Celsius in 18ms
...
```

The numbers are the lab machine's — a
shared, two-CPU sandbox — and yours will
differ; treat timings as a smoke alarm,
not a benchmark. Their real use is
finding the test that quietly became
the slow one.

## Reports for build servers: JUnit

A **report formatter** runs alongside
the display formatter and writes a file
instead of the terminal. The dialect
build servers read is JUnit XML:

```text
$ bats --report-formatter junit --output ../bats-labwork/reports2 tests/temp-convert.bats
1..5
ok 1 boiling point of water in Fahrenheit
...
$ head -8 ../bats-labwork/reports2/report.xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites time="0.062">
<testsuite name="temp-convert.bats" tests="5" failures="0" errors="0" skipped="0" time="0.062" timestamp="2026-11-01T02:30:41" hostname="htch-runtime">
    <testcase classname="temp-convert.bats" name="boiling point of water in Fahrenheit" time="0.012" />
```

The terminal still showed TAP while the
file was written — display and report
are separate choices. Two practical
notes, both from the run itself: the
`--output` folder must exist before the
run (the lab made it first; bats' help
says so plainly), and the XML carries
the facts a server graphs — per-suite
counts of tests, failures, errors and
skips, and a time per test. Combined
with the exit code of chapter 5, this
is the whole hand-off chapter 11's
recipes rely on: the server watches the
number, and reads the file when the
number is 1.
