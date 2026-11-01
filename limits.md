# Limits

**Outcome: you know where bats' edges
are before your suite leans on one.**
Every item here was either met by the
lab (and the transcript named) or is
stated as the tool's documented shape.

**Bash is the language.** Test files are
Bash; the hooks, helpers and assertions
are Bash. You can test any program `run`
can execute — the lab's scripts happen
to be Bash, but a compiled tool or a
Python script would be run the same
black-box way — yet everything *around*
the execution is shell, with shell's
quoting and splitting traps included.
Teams whose home language is elsewhere
may feel chapter 12's last neighbour
pulling at them, fairly.

**Parallel running needs a partner the
lab does not have.** `--jobs` spreads
tests across processes, but bats does
not do the spreading itself: it requires
GNU parallel (or the rush tool). Without
one, the run executes zero tests, warns,
and exits 1 — transcript t08 shows it,
on the lab's machine, verbatim. Suites
therefore run one test at a time, in
order. For suites of the size in this
guide that is seconds; for very large
suites it is the ceiling to plan around,
and installing the partner is the
documented way through it.

**A test proves only what it asserts.**
The framework's honesty is mechanical,
not magical: a test that runs the script
and checks only `$status` will pass a
script that prints garbage with a happy
exit code. The lab's deliberately wrong
file fails because its claims are false;
a suite whose claims are *vacuous*
passes forever and means nothing.
Choosing what to assert — chapter 6's
exact/partial/pattern judgement — is
the skill the tool cannot supply.

**State is yours to manage.** Each test
runs in its own process and gets fresh
temporary folders, which isolates more
than most frameworks bother to. But
anything a script does to the real
filesystem, a real service, or the
network is real. Bats gives you the
stagehands (chapter 7) and the scratch
space; deciding that a test may touch
only its temporary folder is a
discipline, not a feature.

**Names you read are not names you can
build on.** Test *descriptions* are for
people. The internal names bats derives
from them are rewritten — prefixed,
punctuation encoded — and chapter 7
shows a log line coming back as
`setup-2d5ffile`. Filters match the
descriptions (chapter 9), which is the
supported surface; anything that parses
bats' internals is building on sand.

**Output at the edges goes nowhere.**
What `teardown_file` prints is not shown
by any formatter the lab tried
(chapter 7). Symmetrically, what a
*passing* test prints is hidden unless
`--show-output-of-passing-tests` asks
for it. Diagnostics belong in files, or
in failing assertions — chapter 8's
helpers exist precisely to smuggle the
values into the failure report.

**Versions are real.** Features landed
across 1.x — `run` flags in 1.5, tags
and status filters later — and bats
will warn (the BW02 of transcript t08)
when a file uses more than it declares,
but an old bats simply lacks the newer
machinery. `bats_require_minimum_version`
is the suite's way of saying so up
front; a suite shared across machines
of different vintages should treat that
line as load-bearing.

**Interactivity is out of scope.** Bats
runs commands and reads their output
streams. Programs that expect a person
— prompts answered by hand, full-screen
terminal interfaces, anything whose
behaviour lives in keystrokes and
cursor movements — cannot be driven
honestly this way, and suites that try
end up testing their own scaffolding.
The guide's scope statement in the
README drew this line on the first
page; it is repeated here because it is
the limit most often walked into.
