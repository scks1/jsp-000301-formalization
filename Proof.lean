/-
  JSP-000301 — Proof file (companion to Statement.lean).

  Standalone core-Lean file: the definitions are repeated here so the
  file can be checked with a bare `lean Proof.lean` and no Lake project
  or Mathlib. In the eventual JSP submission repository these become a
  single library (Statement imported by Proof); the repetition is a
  prep-package convenience, not the submission layout.

  Status of the parts (checked 2026-10-24, Lean 4.35.0, core only):
  - `not_isSq_12167`, `not_isSq_12168` ...... PROVED, complete.
  - Factorisation identities ................ PROVED (`by decide`).
  - `powerful_12167`, `powerful_12168` ...... PROVED, complete
    (closed 2026-10-24 via the pure-core Euclid-lemma route —
    AXIOM-AUDIT.md route 3: `IsPrime.dvd_mul` from
    `Nat.Coprime.dvd_of_dvd_mul_left`, small primes 2, 3, 13, 23 by
    bounded-ball `decide` over their finitely many candidate
    divisors). The earlier bounded-`decide` route over the divisors
    of 12167 itself (AXIOM-AUDIT.md route 2) remains a recorded
    resource failure and was NOT used.
  - Main theorem ............................ PROVED from the parts;
    `#print axioms` reports `[propext, Quot.sound]` — no incomplete-proof axiom.
    (Full audit record: AXIOM-AUDIT.md.)
-/

def IsPrime (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ q : Nat, q ∣ p → q = 1 ∨ q = p

def Powerful (n : Nat) : Prop :=
  ∀ p : Nat, IsPrime p → p ∣ n → p * p ∣ n

def IsSq (n : Nat) : Prop :=
  ∃ r : Nat, r * r = n

def CatalogQuestion : Prop :=
  ∀ n : Nat, Powerful n → Powerful (n + 1) → IsSq n ∨ IsSq (n + 1)

/-- Any `n` strictly between consecutive squares `a*a` and `(a+1)*(a+1)`
    is not a square. Core-Lean proof. -/
theorem not_isSq_of_between {n a : Nat} (h1 : a * a < n)
    (h2 : n < (a + 1) * (a + 1)) : ¬IsSq n := by
  rintro ⟨r, hr⟩
  rcases Nat.lt_or_ge r (a + 1) with h | h
  · have hrle : r ≤ a := Nat.lt_succ_iff.mp h
    have hle : r * r ≤ a * a := Nat.mul_le_mul hrle hrle
    omega
  · have hge : (a + 1) * (a + 1) ≤ r * r := Nat.mul_le_mul h h
    omega

/-- 12167 lies strictly between 110^2 = 12100 and 111^2 = 12321. -/
theorem not_isSq_12167 : ¬IsSq 12167 :=
  not_isSq_of_between (a := 110) (by decide) (by decide)

/-- 12168 lies in the same interval. -/
theorem not_isSq_12168 : ¬IsSq 12168 :=
  not_isSq_of_between (a := 110) (by decide) (by decide)

/-- Golomb's factorisations, as recorded in the JSP catalog review note. -/
theorem factor_12167 : 12167 = 23 * 23 * 23 := by decide
theorem factor_12168 : 12168 = (2 * 2 * 2) * (3 * 3) * (13 * 13) := by decide

/-! ### Euclid-lemma infrastructure (pure core, no Mathlib)

The two `powerful_*` lemmas need: a prime divisor `p` of a product of
small primes is one of those primes. The only real lemma is Euclid's,
and core Lean proves it almost directly: `Nat.gcd p a ∣ p`, so the gcd
is `1` or `p`; in the first case `Nat.Coprime.dvd_of_dvd_mul_left`
(core, `Init/Data/Nat/Coprime.lean`) gives `p ∣ b`, in the second
`p = Nat.gcd p a ∣ a`. -/

/-- Euclid's lemma for the elementary `IsPrime`: a prime dividing a
    product divides one of the factors. -/
theorem IsPrime.dvd_mul {p a b : Nat} (hp : IsPrime p) (h : p ∣ a * b) :
    p ∣ a ∨ p ∣ b := by
  rcases hp.2 (Nat.gcd p a) (Nat.gcd_dvd_left p a) with h1 | h1
  · right
    exact (show Nat.Coprime p a from h1).dvd_of_dvd_mul_left h
  · left
    have hg : Nat.gcd p a ∣ a := Nat.gcd_dvd_right p a
    rwa [h1] at hg

/-- If a prime `p` divides a prime `q`, then `p = q`. -/
theorem IsPrime.eq_of_dvd {p q : Nat} (hp : IsPrime p) (hq : IsPrime q)
    (h : p ∣ q) : p = q := by
  rcases hq.2 p h with h1 | h1
  · have h2 := hp.1
    omega
  · exact h1

/-- Primality of a concrete number from a decidable check of its
    finitely many candidate divisors (`q ≤ p`; the ball `q < p + 1`
    has a `Decidable` instance in core and reduces by `decide` for
    the small primes used here — this is NOT the failed route-2
    enumeration over the divisors of 12167). -/
theorem isPrime_of_dvd_ball {p : Nat} (h2 : 2 ≤ p)
    (hball : ∀ q < p + 1, q ∣ p → q = 1 ∨ q = p) : IsPrime p := by
  refine ⟨h2, fun q hq => ?_⟩
  have hle : q ≤ p := Nat.le_of_dvd (by omega) hq
  exact hball q (by omega) hq

theorem isPrime_2 : IsPrime 2 := isPrime_of_dvd_ball (by decide) (by decide)
theorem isPrime_3 : IsPrime 3 := isPrime_of_dvd_ball (by decide) (by decide)
theorem isPrime_13 : IsPrime 13 := isPrime_of_dvd_ball (by decide) (by decide)
theorem isPrime_23 : IsPrime 23 := isPrime_of_dvd_ball (by decide) (by decide)

/-- 12167 = 23^3 is powerful: its only prime divisor is 23
    (Euclid's lemma applied to `23 * 23 * 23`), and `23 * 23 ∣ 12167`. -/
theorem powerful_12167 : Powerful 12167 := by
  intro p hp hdiv
  have h23 : p ∣ 23 := by
    have h1 : p ∣ 23 * 23 * 23 := by
      rw [← factor_12167]; exact hdiv
    rcases hp.dvd_mul h1 with h | h
    · rcases hp.dvd_mul h with h | h
      · exact h
      · exact h
    · exact h
  have hp23 : p = 23 := hp.eq_of_dvd isPrime_23 h23
  rw [hp23]
  exact ⟨23, by decide⟩

/-- 12168 = 2^3 * 3^2 * 13^2 is powerful: a prime divisor of the
    product is 2, 3 or 13 (Euclid's lemma applied factor by factor),
    and `4, 9, 169` all divide 12168. -/
theorem powerful_12168 : Powerful 12168 := by
  intro p hp hdiv
  have h1 : p ∣ (2 * 2 * 2) * ((3 * 3) * (13 * 13)) := by
    have e : 12168 = (2 * 2 * 2) * ((3 * 3) * (13 * 13)) := by decide
    rwa [e] at hdiv
  have hcases : p ∣ 2 ∨ p ∣ 3 ∨ p ∣ 13 := by
    rcases hp.dvd_mul h1 with h | h
    · rcases hp.dvd_mul h with h | h
      · rcases hp.dvd_mul h with h | h
        · exact Or.inl h
        · exact Or.inl h
      · exact Or.inl h
    · rcases hp.dvd_mul h with h | h
      · rcases hp.dvd_mul h with h | h
        · exact Or.inr (Or.inl h)
        · exact Or.inr (Or.inl h)
      · rcases hp.dvd_mul h with h | h
        · exact Or.inr (Or.inr h)
        · exact Or.inr (Or.inr h)
  rcases hcases with h | h | h
  · have hp2 : p = 2 := hp.eq_of_dvd isPrime_2 h
    rw [hp2]; exact ⟨3042, by decide⟩
  · have hp3 : p = 3 := hp.eq_of_dvd isPrime_3 h
    rw [hp3]; exact ⟨1352, by decide⟩
  · have hp13 : p = 13 := hp.eq_of_dvd isPrime_13 h
    rw [hp13]; exact ⟨72, by decide⟩

/-- JSP-000301 resolved: the catalog question is false.
    The witness is `n = 12167` (Golomb 1970): 12167 and 12168 are
    consecutive, both powerful, and neither is a perfect square. -/
theorem jsp_000301_counterexample : ¬CatalogQuestion := by
  intro h
  have hsq := h 12167 powerful_12167 powerful_12168
  rcases hsq with h1 | h2
  · exact not_isSq_12167 h1
  · -- `12167 + 1` reduces to `12168` definitionally.
    exact not_isSq_12168 h2

-- Axiom audit line (see AXIOM-AUDIT.md). Expected output:
-- 'jsp_000301_counterexample' depends on axioms: [propext, Quot.sound]
#print axioms jsp_000301_counterexample
