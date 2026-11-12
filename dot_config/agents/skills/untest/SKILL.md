---
name: untest
description: >-
  Find and delete tests that do not exercise production behavior, including tautologies,
  assertions over checked-in source, and assertions that merely restate another component's
  contract. Use when auditing a suite, reviewing test code, or when a test asserts on stub or
  harness behaviour. Excludes linters and source validators, even when packaged as tests.
  Triggers: "prune tautological tests", "this test asserts the fake".
---

# Untest

A tautological test asserts a value that the test itself supplied, where the value
travelled only through test-owned code — a stub, a fake, harness plumbing — before being
asserted. It cannot fail when production behaviour breaks. It costs suite time, and it
misleads the next reader into believing an area is covered when nothing is.

These are worse than missing tests. A gap is visible in a coverage report; a tautology
reports as covered.

A test can also be useless without being tautological. It may depend on a production file
without executing it, or verify an external component without exercising any decision made
by our code. Treat those as false coverage too.

## Scope: tests, not linters

Apply these criteria to tests that claim behavioral coverage. Do not apply them to linters or
source validators whose purpose is to enforce rules on checked-in artifacts or configuration.
Those tools may legitimately parse, grep, or compare source, and may be packaged as test targets
so CI can execute them. Classify a target by its purpose and invocation path, not by whether its
build rule is named `*_test`.

Review a linter for whether it enforces the intended rule reliably. Do not delete it merely
because it does not execute production behavior.

## Behavior is a prerequisite

A test must execute production logic and observe a result, state change, side effect, or
interaction caused by that logic. Reject tests whose oracle bypasses behavior:

- Do not grep, parse, snapshot, or use `contains`/regex assertions over the project's own
  checked-in source, embedded scripts, unit files, or templates to prove that they contain
  particular text. That restates the implementation instead of exercising it.
- Do not compare one checked-in source file with another. This only detects that duplicated
  sources diverged; it does not demonstrate that either source behaves correctly. Remove the
  duplication or test the behavior at the point where production consumes it.
- Do not test another component's contract. Assertions such as "systemd reads this mode" or
  "the standard library implements symlinks this way" belong to that component. Test the
  decision our code makes, the arguments it passes across the boundary, or how it handles the
  component's observable result.
- Do not add a test whose only failure mode is an intentional rename, relocation, or literal
  edit and whose expected value merely repeats that configuration. If the value is a real
  external contract, exercise the behavior that makes it a contract.

Text can still be legitimate test data. A parser may consume synthetic text, and a generator
may produce text whose semantics the test independently verifies. The prohibition is on using
the same checked-in source as both implementation and oracle.

## The decisive check: behavior, then mutation

Mutation is decisive only after the test passes the behavioral gate above. A source grep can
go red when a production file changes and still prove no behavior at all.

Reading a behavioral test tells you what it *looks* like it covers. Mutating production tells
you what it actually covers. For each suspect assertion, ask:

> Which production decision, transformation, or side effect could I corrupt to make this
> test fail?

If you can't name one, the test is tautological. Prove it by doing it: delete a guard,
flip a comparison, return a constant, drop a side effect. Run the suite.

- **Test goes red** → load-bearing. Keep it. Restore the mutation.
- **Test stays green** → nothing production-side feeds that assertion. Fix or delete.

Mutate one line at a time, and restore from a saved copy rather than by hand — a
half-reverted mutation poisons every later result.

## The cheap pre-filter: trace provenance

Mutation is decisive but slow. To find candidates first, trace where each asserted value
was assigned:

- Assigned from data production sent — a request field, a return value, emitted output,
  persisted state → **real**.
- Assigned by test-owned code — the fake's canned config, a stub that stamps a value, a
  recorder field the harness populates itself → **suspect**.

The signature to grep for is a value written and read entirely within test files. If the
test writes header X and later asserts header X arrived, no production code participated.

Also trace what the test actually executes. Reading a production source file is not executing
the behavior defined by that file, and observing an external component in isolation does not
exercise our integration with it.

## What looks tautological but is not

Do not prune these — over-pruning destroys real coverage, which is worse than the problem
you set out to fix.

- **Spies asserting requests production built.** A fake that records
  `createRequest{poolID: "p", name: "n"}` and a test that asserts the recorded value is
  verifying the mapping from options to request. Corrupt that mapping and it goes red.
- **Canned stub returns used as inputs.** Configuring a stub to return `"sbx-1"` and then
  asserting production *did something with it* — printed it, threaded it into the next
  call, cleaned it up — tests production.
- **Loose assertions on values that cannot be pinned.** `NotEmpty` on a timestamp still
  catches propagation breaking. Weak is not the same as tautological; tighten it rather
  than delete it.
- **Synthetic inputs to production logic.** Passing arbitrary unit text to the production
  file writer and checking replacement and permissions tests the writer. Reading the real
  embedded unit back and comparing it with its own source does not.

## Removing them

Prefer re-pointing over deleting. A tautological assertion often has a real source
nearby:

1. **Find a production-fed source for the same fact.** If the routing header is stamped by
   a transport the test replaces, the same ID may sit in the request payload, set from what
   production passed in. Assert that instead.
2. **If no real source exists, check whether the behaviour is covered elsewhere** before
   deleting. Frequently it already is, by a test that exercises the real path.
3. **Delete what is left**, along with the scaffolding that existed only to serve it —
   redefined constants, stub methods, unread struct fields, now-unused imports. Leaving the
   plumbing invites someone to rebuild the assertion later.

For a source-shape or external-contract test, first identify the actual behavior at risk. Add
or retain a behavioral test only when our code has a meaningful decision or side effect to
exercise; otherwise delete the test without manufacturing a replacement.

Then run the suite and confirm it still passes for the right reasons.

## Traps

- **A mutation that never applied looks exactly like a coverage gap.** If the edit is
  driven by a pattern match, assert the match succeeded and print what was changed. A
  silent no-op reports a false "not caught".
- **A constant redefined in the test is a signal, not a fix.** If production stopped
  exporting a value the test needs, ask why. Usually the behaviour moved somewhere the test
  no longer observes — which means the assertion has already stopped being real.
- **Dead scaffolding hides in plain sight.** Values written, read, and used only to build
  something nothing asserts. Grep each harness field for a reader outside test code.
- **Mutation proves coverage, not absence of tautology.** A green suite under mutation
  says the production path is covered by *something*; it does not say every test in the
  file earns its place. Use provenance to find the freeloaders.

## Reporting

Report what you changed and the evidence, not a verdict. For each finding: the assertion,
why nothing production-side fed it, and what replaced it. For each mutation: the line
corrupted and whether the suite caught it. State plainly which tests you left alone and
why — the false positives you resisted are as informative as the ones you removed.
