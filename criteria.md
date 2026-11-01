# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's scripts convert temperatures, name invented
   backups, and count words in a pangram.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 13 names what the tool
   cannot do: Bash is its only language, parallel running needs
   GNU parallel or rush and without one runs zero tests, a test
   proves only what it asserts, the filesystem state a script
   touches is the suite author's responsibility, bats' internal
   test names are rewritten and not an interface, output printed
   by teardown_file is shown by no formatter, features are
   versioned and old releases lack the newer ones, and
   interactive, full-screen programs are out of its reach.
8. **The ethics rule is in the text, early.** Bats executes
   arbitrary Bash with the reader's own permissions — every
   test, setup and helper is a program — so chapter 1 states
   the trust line before any procedure depends on it: a test
   suite deserves the same read-before-running as any other
   downloaded code, a stranger's suite is a stranger's program,
   and bats itself makes no network calls and reports nothing
   anywhere. The lab only ever ran code written for it, against
   invented data, on loopback-free local ground.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox,
shared with other work while the lab ran (timings are therefore
the machine's, and the guide says so). Bats **1.14.0** was
installed from the official release archive
(`v1.14.0.tar.gz` from the bats-core project's GitHub releases)
with its own `install.sh`, and run unmodified, under GNU bash
5.2.21. The helper libraries are the project's own
**bats-support 0.3.0** and **bats-assert 2.2.4**, downloaded
from the same official source and vendored, trimmed to loaders,
sources and licences, under `bats-lab/test_helper/`. All
transcripts live in `bats-lab/transcripts/`; the scripts under
test, their suites, the guide's own helper, and the deliberately
wrong exhibit all live in `bats-lab/`.

Conventions of the transcripts: each command is preceded by a
`$` line and followed by an `[exit N]` line the lab added so
the suite's verdict is visible without commentary; pretty-
formatter transcripts have their colour escape codes removed,
and nothing else altered.

Run for real, with transcripts as evidence:

- Install from the release archive, the prefix layout statement,
  `bats --version` (1.14.0), the host's Bash version, and the
  recorded absence of GNU parallel and rush (t00).
- The temperature converter run by hand, then the first
  suite (5 tests) and the whole lab suite — 23 tests across
  five files, all passing, exit 0 (t01).
- The deliberately wrong exhibit in both the pretty and the
  TAP formatter: 2 failures with exact file, line and failing
  command, 1 skip with its reason, suite exit 1 both ways (t02).
- `run` under the microscope: `$status`, whole `$output`
  (trailing newline removed), `$lines` element by element and
  counted, a pattern match, and `--separate-stderr` with
  `$stderr` standing alone and `$output` asserted empty (t03).
- The lifecycle: setup_file, setup, teardown, teardown_file
  logged per stage and read back in exact order; teardown
  shown running after a deliberately failing middle test in a
  scratch suite; the internal-name lesson (a description's
  internal name returning punctuation-encoded) and the
  invisibility of teardown_file's own printing, both met while
  writing the lab suite and described in chapter 7 (t04).
- Helpers: the guide's own two-function helper loaded and
  passing, bats-support plus bats-assert loaded and passing
  (assert_success, assert_failure with exact code,
  assert_output exact and --partial, assert_line by index,
  refute_line), and a helper failing on purpose, its
  expected/actual message and both source lines shown in the
  report (t05).
- Selection: `--count` (23), `--filter` by name pattern (2 of
  5), `--negative-filter` (4 of 5), `--filter-tags` selecting
  the one `clock` test and, negated, the other three (t06).
- Presentation: pretty on a green suite, tap13's header and
  body, `--timing` per-test durations, and a JUnit report
  written by `--report-formatter junit` to a pre-made folder
  while TAP ran on the terminal, the XML's head quoted in
  chapter 10 (t07).
- Bats complaining: a nonexistent file, an
  empty folder (exit 1) and the same folder under
  `--allow-empty-suite` (exit 0), a syntax error failing the
  whole file at the gather stage, a `load` of a missing helper
  failing the same stage with bats' own message, the BW02
  warning produced by the run-and-output suite with its
  version declaration removed (the suite still passes), the
  pretty formatter dying without `TERM` (tput message, exit
  2, no report), and `--jobs 2` without GNU parallel running
  zero tests with its warning (t08).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- Parallel execution itself (`--jobs` with GNU parallel or
  rush present), and the `--no-parallelize-*` refinements:
  the lab machine has neither tool, and t08 records what
  happens instead.
- `--filter-status` (rerunning the last run's failures),
  named in chapter 11 as documented, to be verified by the
  reader before pipeline use.
- Install routes other than the release archive: git clone,
  Homebrew and other distribution packages, and the npm
  package — listed in chapter 3 with the version caution,
  none of them exercised.
- Recursive discovery with `-r` (the lab suite folder is
  flat) and tap13's YAML failure blocks (the failing exhibit
  was rendered in pretty and tap).
- The neighbour frameworks of chapter 12 (shunit2, ShellSpec)
  — characterised from their documentation, not run or
  benchmarked; the plain check function shown there is plain
  Bash and is presented as an illustration, not a measurement.
- Test-driven use against interactive or full-screen
  programs, which chapter 13 places outside the tool's reach
  rather than reporting as a failure.

Fixtures are this guide's own and deliberately generic: a
temperature converter, a backup-file namer fed fixed invented
stamps, a word counter, and a three-line pangram as its sample
text. No person, organisation, place or real system appears
in any of them, and nothing in the lab touched a network
beyond downloading the official releases named above.
