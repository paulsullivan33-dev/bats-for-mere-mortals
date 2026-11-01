# The Neighbours

**Outcome: you can place bats among the
other ways of testing shell work, and
say what each would give you that bats
doesn't — and what it wouldn't.** The
neighbours in this chapter are
characterised from their documentation,
not run by this guide's lab; the text
does not claim benchmarks or results
for any of them.

## shunit2 — the elder

shunit2 predates bats and carries an
xUnit shape into shell: assertion
functions with names like `assertEquals`,
test functions discovered by prefix,
one file that is both library and
runner. Suites in shunit2 read more
like a Java test class and less like
the prose-named claims of chapter 4,
and there is no `run` capturing output
into variables — you arrange that
yourself. Projects with shunit2 suites
already written have no reason to move;
projects starting today usually choose
between bats and the next neighbour.

## ShellSpec — the fuller framework

ShellSpec is a complete testing
framework for shell scripts, with a
descriptive specification style
(`Describe`/`It`/`When`/`The output
should equal ...`), its own mocking and
matching vocabulary, and support for
several shells beyond Bash. It asks
more learning than bats — a real
domain language rather than Bash with
one new shape — and returns more
structure, particularly for describing
many cases of one behaviour. If your
tests are mostly "run it, check what
it printed", bats is the smaller tool;
if they read like specifications, the
neighbour was built for you.

## A plain check function — no framework at all

For three checks, the honest competitor
is a twenty-line script:

```bash
check() {  # check DESCRIPTION COMMAND...
  if "$@" > /dev/null 2>&1; then
    echo "ok - $1"
  else
    echo "NOT OK - $1"
  fi
}
```

People outgrow it at predictable
moments: when a failing check should
stop but the script should continue,
when the *values* matter and not just
the verdict, when half the checks need
the same preparation. Bats is roughly
where that growth lands — chapter 8's
helper is the same `check` idea with a
runner around it. Starting with the
plain function is respectable; what is
not respectable is the fourth neighbour,
**testing by running it once and
looking**, which is not a framework but
the absence of one, and the thing every
tool in this chapter exists to replace.

## Testing from another language

A Python or JavaScript project often
tests its shell scripts from its own
runner — pytest or its kin spawning the
script as a subprocess and asserting on
the result. That keeps one test stack
for the whole project, which is a real
virtue. What it gives up is the shell's
own feel: `run`, `$lines`, the hooks,
and helpers written in the language the
scripts are written in. It is a
reasonable trade when the scripts are
guests in the project, and a poor one
when the scripts *are* the project.

## ShellCheck — the neighbour that doesn't run anything

ShellCheck belongs in this chapter
because readers meet the two together
and they are not rivals. ShellCheck
*reads* a script and reports suspicious
shapes — quoting and splitting bugs and
their hundred cousins. Bats *runs* the
script and reports broken promises. A
script can pass one and fail the other
in both directions, and a healthy
project uses both: the linter on every
save (this series' Pre-commit guide
wires exactly that), the tests on every
build. The ShellCheck guide in this
series is the companion volume.
