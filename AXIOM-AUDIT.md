# JSP-000301 — axiom audit procedure and current state

## The standard a final submission must meet

Per the field guide's artefact checklist and JSP's own `lean-verify`
skill (github.com/TheJustinSunPrize/awards, `skills/lean-verify/SKILL.md`,
read 2026-10-24):

- No `sorry`, `admit`, `native_decide`, or new axioms in the target
  theorem's transitive dependencies.
- `#print axioms <target>` must list only the standard classical
  foundations: `propext`, `Classical.choice`, `Quot.sound`. Anything
  else — above all `sorryAx` — means incomplete.
- A submission whose main theorem rests on literature results introduced
  as axioms was closed by JSP (PR #947, JSP-000060, per the field guide):
  do not axiomatise Golomb's result; the counterexample check below is
  computational, so no literature axiom is needed at all.
- `decide` (kernel computation) is not `native_decide`: a `by decide`
  proof is checked by the Lean kernel and introduces no extra trust or
  axioms. JSP's skill asks that any native computation be reported
  separately; this package uses none.

## Audit procedure (run on the exact submission commit)

```bash
# in the submission repo, with the pinned toolchain (lean-toolchain):
lake build                       # or: lean Proof.lean for the core-only prep files
grep -rn "sorry\|admit\|native_decide" --include='*.lean' .
# then confirm the audit line at the end of Proof.lean prints only
# standard axioms (a subset of [propext, Classical.choice, Quot.sound]):
lean Proof.lean   # last line prints the axiom list
```

Record, in the submission's verification note: toolchain file contents,
the exact commit SHA, the command, its full output, and the date. JSP
maintainers reproduce the check independently; a self-check report is
optional supporting evidence, not a substitute.

## Current state (2026-10-24, Lean 4.35.0, core only) — PROOF COMPLETE

The two `powerful_*` lemmas were closed on 2026-10-24 by route 3
(pure-core Euclid lemma; see "Routes" below). `Proof.lean` now
contains no `sorry`, `admit`, or `native_decide` token anywhere
(comments included — verified by grep, clean) and no `axiom`
declarations.

Final recorded run (2026-10-24, after the last edit to `Proof.lean`):

```bash
~/.elan/bin/lean Proof.lean    # in jsp-000301/, toolchain leanprover/lean4:v4.35.0
```

Output (complete; the command prints nothing else):

```text
'jsp_000301_counterexample' depends on axioms: [propext, Quot.sound]
```

Exit code 0. Wall time 7.6 s (user 0.5 s — wall time on this VM is
dominated by process-start latency; an identical earlier run of the
same final file measured 17.7 s wall / 0.6 s user). `[propext,
Quot.sound]` is a subset of the standard set; `Classical.choice` is
not needed because every step is computational or constructive.
**`sorryAx` is gone.**

Second check (optional, not kernel-grade): the AXLE pilot checker
(axiom-axle 1.9.0, `axle --json verify-proof Statement.lean
Proof.lean --environment lean-4.35.0`, run 2026-10-25 01:41 UTC)
returned `okay = true`, `failed_declarations = []`,
`lean_messages.errors = []`, `tool_messages.errors = []`. Raw output:
`../project/axle-verify-proof.json`. Local Lean remains the ground
truth; AXLE is recorded as a corroborating check only.

Note on `Statement.lean`: it is unchanged and still contains its one
by-design standalone `sorry` (line 62) so the statement file
typechecks on its own. The submission layout drops that placeholder:
`Proof.lean`'s `jsp_000301_counterexample` is the canonical theorem,
and it is proved. The no-`sorry` requirement is met by `Proof.lean`,
which is the file the axiom audit above ran on.

## Closing the two open lemmas — routes and outcome

1. **Mathlib route (planned main line; NOT needed in the end).** In a
   Mathlib project, restate `Powerful` via `Nat.factorization`, with
   bridge lemmas `IsPrime p ↔ Nat.Prime p` and `IsSq n ↔ IsSquare n`.
   Preliminaries were checked before any download: disk re-verified
   at 29 GB free (the ~7–8 GB cache would have fit), but available
   RAM at run time was only ~1.0 GB of 7.7 GB, which makes compiling
   against imported Mathlib oleans the riskiest step on this VM; and
   route 3 closed the proof first, at zero download. No Mathlib
   project was created and nothing was downloaded. The route remains
   available if a future JSP target needs real Mathlib machinery.
2. **Core-Lean bounded-`decide` route over the target's own divisors
   (attempted 2026-10-24, failed on resources, not on logic, and NOT
   used).** Enumerate the divisors of 12167 / 12168 by `decide`.
   Attempt log: with `set_option maxRecDepth 100000`, plain
   `by decide` hit the default 200,000-heartbeat limit at ~57 s
   (`tmp-test/test3.lean`). A rerun with `maxHeartbeats 0`
   (`tmp-test/test4.lean`) was killed (SIGKILL) after 3m03s with no
   result; memory exhaustion is the likely cause on this 7.7 GB /
   no-swap VM but is unconfirmed from the output. Do not repeat this
   route unchanged.
3. **Euclid-lemma route (pure core) — USED, proof closed.** Core Lean
   already contains everything needed:
   - `IsPrime.dvd_mul`: for prime `p` (elementary definition),
     `p ∣ a * b → p ∣ a ∨ p ∣ b`. Proof: `Nat.gcd p a ∣ p`, so the
     gcd is `1` or `p` by primality of `p`; if `1`, then
     `Nat.Coprime.dvd_of_dvd_mul_left` (core,
     `Init/Data/Nat/Coprime.lean`) gives `p ∣ b`; if `p`, then
     `p = Nat.gcd p a ∣ a`.
   - `IsPrime.eq_of_dvd`: a prime dividing a prime equals it.
   - Small primes 2, 3, 13, 23 are proved `IsPrime` by
     `isPrime_of_dvd_ball`: the divisor condition is a decidable
     bounded check `∀ q < p + 1, q ∣ p → q = 1 ∨ q = p`, discharged
     by `decide`. The ball bound is the *prime's own* size (≤ 24),
     not the target's — this is the structuring that avoids route
     2's blowup (24 cheap iterations instead of an enumeration at
     n ≈ 1.2·10⁴).
   - `powerful_12167`: Euclid applied to `23 * 23 * 23` forces any
     prime divisor to be 23; `23 * 23 ∣ 12167` by explicit quotient.
   - `powerful_12168`: Euclid applied factor-by-factor to
     `2^3 · 3^2 · 13^2` forces a prime divisor to be 2, 3 or 13;
     `4, 9, 169 ∣ 12168` by explicit quotients (3042, 1352, 72).

## What must never appear in the submission

`sorry`/`admit` anywhere in the dependency cone; any `axiom`
declaration; `native_decide`; literature results as hypotheses of the
main theorem (the theorem must remain the unconditional
`¬ CatalogQuestion`).
