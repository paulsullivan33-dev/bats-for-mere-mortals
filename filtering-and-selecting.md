# Filtering and Selecting

**Outcome: you can run exactly the tests
a moment calls for — one file, the tests
whose names match a pattern, the tests
carrying a tag, everything except a
pattern — and count a suite before
running it.** A suite is run whole most
of the time, and should be. But while
you work, the whole suite is the wrong
granularity: you are fixing the freezing
test, or the clock-shaped test is the
one under suspicion. Everything in this
chapter is transcript
`bats-lab/transcripts/t06-filtering-and-counting.txt`.

## Start with files

The coarsest selection is the one from
chapter 4: name a file, get that file's
tests; name a folder, get every `.bats`
file directly in it. (Subfolders are
not entered unless `-r` asks for it —
documented behaviour; the lab's suite
folder is flat, and its recursive runs
happen only inside recipes that say
so.) When a folder is the target, files
run in name order and tests in file
order, every time — a run's numbering
is stable enough to cite in a bug
report.

## Count before you run

```text
$ bats --count tests/
23
[exit 0]
```

`--count` gathers without executing and
prints how many tests a target holds.
It earns its place two ways: as a sanity
check that gathering found what you
think you wrote (a file quietly missed
is a suite quietly smaller), and as the
before/after number when a filter is
about to narrow a run — a filter that
matches nothing is a typo until proved
otherwise.

## By name: --filter

`--filter` takes a regular expression
matched against test *names* — the
quoted descriptions, the words you
chose:

```text
$ bats --filter 'freezing|boiling' tests/temp-convert.bats
1..2
ok 1 boiling point of water in Fahrenheit
ok 2 freezing point of water in Celsius
[exit 0]
```

Two of the file's five tests ran; the
plan line shrinks to `1..2`, so the
report never pretends the others
passed. The mirror flag,
`--negative-filter`, keeps everything
the pattern does *not* match:

```text
$ bats --negative-filter 'boiling' tests/temp-convert.bats
1..4
ok 1 freezing point of water in Celsius
ok 2 minus forty is the same in both scales
ok 3 a value that is not a number is refused
ok 4 an unknown scale is refused
[exit 0]
```

Name filters reward names written like
chapter headings — descriptive, with
the vocabulary of the thing tested —
because the name is the handle every
selection tool grips.

## By tag: --filter-tags

Some selections are not about names but
about *kind*: the slow ones, the ones
needing the network, the ones that read
the real clock. A tag is declared in a
comment directly above the test:

```bash
# bats test_tags=clock
@test "the default stamp is the current time, in shape at least" {
```

and selected by name:

```text
$ bats --filter-tags 'clock' tests/backup-name.bats
1..1
ok 1 the default stamp is the current time, in shape at least
[exit 0]

$ bats --filter-tags '!clock' tests/backup-name.bats
1..3
ok 1 a fixed stamp gives an exact name
ok 2 the prefix is kept whole, spaces and all
ok 3 an empty prefix is refused
[exit 0]
```

The leading `!` negates, as the second
run shows: what ran is the file's three
`core`-tagged tests — everything except
the one clock test. Tags can be combined (a
test may carry several, and multiple
`--filter-tags` flags express "or"
between groups) — the combination rules
are in `bats --help`; the lab exercised
the single-tag and negated forms above,
and those two cover the everyday cases:
*run the tagged ones*, and *run
everything but*.

## The selection habit

Filters are for the workbench, not the
verdict. The suite's promise is made by
the unfiltered run — the one a build
server makes, exit code and all — and a
filtered run that passes proves only
what it ran. The lab's transcripts keep
the discipline visible: every filtered
run in this chapter is followed, in
t06, by the whole file run clean.
