/-
  JSP-000301 — Statement file (separate from the proof file, per the JSP /
  field-guide standard artefact).

  Catalog question (problems/catalog-0301-0400.md#JSP-000301):
    "If two consecutive positive integers are powerful, must at least one
     be a perfect square?"

  Catalog status: Solved. Proof contributor: Solomon W. Golomb
  (counterexample, [Go70] "Powerful numbers", Amer. Math. Monthly 77(8)
  (1970), 848–852). Lean proof: No. Eligible to claim: No (the Lean
  formalization is the missing prerequisite — that is the formalizer
  opportunity).

  Resolution (catalog review note, source review 2026-09-13):
    12167 = 23^3 and 12168 = 2^3 * 3^2 * 13^2 are consecutive, both
    powerful, and neither is a perfect square (both lie strictly between
    110^2 = 12100 and 111^2 = 12321). So the answer to the catalog
    question is NO, and a complete formalization is a *finite*
    verification: exhibit the counterexample pair and check the three
    properties below.

  Definitions are elementary and core-Lean only (Lean core 4.35 has no
  `Nat.Prime` and no `minFac` — both live in Mathlib/Batteries; verified
  2026-10-24, see ../toolchain/TOOLCHAIN.md). In a Mathlib build, the JSP
  submission should additionally provide the bridge lemmas
  `IsPrime p ↔ Nat.Prime p` and `IsSq n ↔ IsSquare n`; the statements
  below are the standard definitions those bridges connect to.

  Toolchain pin: leanprover/lean4:v4.35.0 (see ./lean-toolchain in this repo).
-/

/-- Elementary primality: `p ≥ 2` and every divisor of `p` is `1` or `p`.
    (Core-Lean substitute for `Nat.Prime`; see the header note.) -/
def IsPrime (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ q : Nat, q ∣ p → q = 1 ∨ q = p

/-- A positive integer `n` is *powerful* if every prime divisor of `n`
    occurs with exponent at least two, stated divisor-wise: whenever a
    prime `p` divides `n`, so does `p * p`. This is Golomb's definition
    in [Go70]: "a powerful number has exponent at least two in every
    prime factor" (as quoted in the JSP catalog review note). -/
def Powerful (n : Nat) : Prop :=
  ∀ p : Nat, IsPrime p → p ∣ n → p * p ∣ n

/-- `n` is a perfect square. -/
def IsSq (n : Nat) : Prop :=
  ∃ r : Nat, r * r = n

/-- The proposition the catalog question asks about: for every pair of
    consecutive positive integers, if both are powerful then at least
    one of them is a perfect square. -/
def CatalogQuestion : Prop :=
  ∀ n : Nat, Powerful n → Powerful (n + 1) → IsSq n ∨ IsSq (n + 1)

/-
  The resolved theorem `jsp_000301_counterexample : ¬ CatalogQuestion`
  (witness `n = 12167`, Golomb 1970) is stated and fully proved in
  `Proof.lean`, which is the canonical submission file. It is not
  restated here: this statement file carries the definitions only, so
  the whole repository checks with no incomplete steps anywhere.
-/
