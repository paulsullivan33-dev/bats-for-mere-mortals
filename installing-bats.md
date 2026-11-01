# Installing Bats

**Outcome: a `bats` program on your
machine that can state its version —
`Bats 1.14.0` — before any test file
exists.** Bats is a small, self-contained
piece of software: no interpreter to
install beyond the Bash you already
have, no services, no configuration.
The whole install is a download, an
unpack, and one script.

## The release install, as the lab did it

The lab installed bats from the
project's official releases on GitHub
(`github.com/bats-core/bats-core`).
Transcript
`bats-lab/transcripts/t00-install-and-version.txt`
is the whole thing:

```text
$ curl -sLO https://github.com/bats-core/bats-core/archive/refs/tags/v1.14.0.tar.gz
$ tar xzf v1.14.0.tar.gz
$ ./bats-core-1.14.0/install.sh /home/hatch/workspace/bats-labwork/t00/bats-prefix
Installed Bats to /home/hatch/workspace/bats-labwork/t00/bats-prefix/bin/bats
$ ./bats-prefix/bin/bats --version
Bats 1.14.0
```

Three ideas hide in those four lines.
First, `install.sh` takes a **prefix** —
the folder bats should live under — and
it can be anywhere you may write: a
system folder with `sudo ./install.sh
/usr/local`, or, as the lab did, a
private folder while evaluating. Nothing
about bats cares where it lives. Second,
what the prefix receives is a small
tree: `bin/bats` to run, `lib/bats-core/`
holding the library files (including the
formatters of chapter 10), and
`libexec/bats-core/` holding the helper
executables whose names appear in bats'
own error messages. Third, the version
check is the install check: if
`bats --version` answers, everything the
rest of this guide needs is present.

The lab's machine ran **GNU bash
5.2.21**; bats is itself Bash, so the
shell is the only platform there is.
Put the prefix's `bin` on your `PATH`
and every later chapter can say just
`bats`.

## The other doors (documented, not run)

The project's documentation lists more
ways in, which the lab did not exercise
and this guide does not claim results
for. A **git clone** of the repository
followed by the same `install.sh` is the
route for tracking development. Most
**package managers** carry bats —
Homebrew, and the package collections of
the larger Linux distributions among
them — and it is also published on
**npm** as `bats` for projects already
living in that world. One caution applies
to every packaged route, and it is worth
more than the convenience: **check the
version you actually got.** Bats has
grown features steadily — tags and
several flags in this guide are young —
and an old package will run old suites
happily while knowing nothing of them.
The guide's floor is declared in chapter
6 (`bats_require_minimum_version`), and
`bats --version` takes one second.

## Removing it

Because everything sits under the one
prefix, removing bats is removing that
folder. Nothing was written anywhere
else: no configuration in your home
folder, no state in your projects. The
test files you write remain yours and
remain readable — they are Bash with a
costume, and chapter 2 explained the
costume.
