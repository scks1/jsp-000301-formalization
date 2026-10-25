# JSP-000301 — Lean formalization (formalizer claim bundle)

**Catalog question** (The Justin Sun Prize, `problems/catalog-0301-0400.md#JSP-000301`):
"If two consecutive positive integers are powerful, must at least one be a perfect square?"

**Answer: No.** Solomon W. Golomb's counterexample ([Go70] *Powerful numbers*,
Amer. Math. Monthly 77(8) (1970), 848–852, doi:10.2307/2317020):
12167 = 23³ and 12168 = 2³·3²·13² are consecutive, both powerful, and neither
is a perfect square (both lie strictly between 110² = 12100 and 111² = 12321).

This repository is the complete Lean 4 formalization of that counterexample,
prepared for a formalizer (Lean-role) claim on JSP-000301. The mathematical
solution is Golomb's; the formalization is the contribution claimed here.

## Verify

Core Lean only — no Mathlib, no Lake project, nothing to download beyond the
pinned toolchain.

```bash
# toolchain: leanprover/lean4:v4.35.0 (see lean-toolchain; elan will honour it)
lean Statement.lean   # definitions only; exits 0, no output
lean Proof.lean       # full proof; exits 0 and prints exactly:
# 'jsp_000301_counterexample' depends on axioms: [propext, Quot.sound]
```

The axiom list is a subset of the standard set (`propext`,
`Classical.choice`, `Quot.sound`) and contains no `sorryAx`: the proof is
complete, with no `sorry`, `admit`, `native_decide`, or added axioms in any
`.lean` file in this repository. Full record: `AXIOM-AUDIT.md`.

## Files

| File | Contents |
|---|---|
| `Statement.lean` | Elementary definitions (`IsPrime`, `Powerful`, `IsSq`, `CatalogQuestion`). Core-Lean substitutes for the Mathlib notions, as documented in the file header. |
| `Proof.lean` | Self-contained proof: `jsp_000301_counterexample : ¬CatalogQuestion`, via a pure-core Euclid-lemma route (small primes 2, 3, 13, 23 by bounded `decide`; prime divisors of the two witnesses forced explicitly; divisibility witnesses given as quotients). The final line of the file is the `#print axioms` audit. |
| `AXIOM-AUDIT.md` | The audit standard, the exact audit procedure, and the passed audit record (Lean 4.35.0, 2026-10-24), including the routes attempted and the one used. |
| `formalization.yaml` | Submission disclosure: problem, informal source, tools and models used, AI disclosure, limitations. Two fields (`repository`, `commit`) are filled in at publication time. |
| `lean-toolchain` | `leanprover/lean4:v4.35.0` |
| `CLAIM-CHECKLIST.md` | The claim steps that follow publication — all of them the claimant's own actions; none has been taken. |
| `MANIFEST.sha256` | SHA-256 of every file above, recorded at bundle assembly so the published commit can be checked against this bundle. |

## Disclosure

This formalization was prepared by an AI agent (Árbol, a Muse agent by Meta)
acting for Simon Koch-Sultan, with human oversight. The Justin Sun Prize's
rules grant awards "without distinction among human researchers, human-AI
teams, or autonomous AI systems"; the applicant/payee of record is the natural
person named at claim time. Tools and roles are itemised in
`formalization.yaml`.

## Licence

MIT — see `LICENSE`. (The Prize asserts no ownership over submissions; this
licence is the claimant's choice for the public repository.)
