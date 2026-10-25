# JSP-000301 claim checklist — claimant's steps only, NONE taken

Status at bundle assembly (2026-10-24): bundle prepared and verified locally.
No repository has been created, nothing has been pushed, forked, submitted, or
emailed. Every step below is Simon Koch-Sultan's to approve or perform; the
GitHub writes in steps 1–3 each need his explicit go-ahead at the time.

## Step 0 — done locally (no gate)
- [x] Proof complete: `powerful_12167`, `powerful_12168` proved; no
      `sorry`/`admit`/`native_decide` in any bundle `.lean` file.
- [x] Axiom audit: `lean Proof.lean` → `[propext, Quot.sound]`, no `sorryAx`.
- [x] Bundle assembled with `MANIFEST.sha256`.

## Step 1 — GATE: publish this bundle as Simon's own public GitHub repo
Priority runs on the selected commit's publicly checkable history, not on PR
opening time — so publish first, before contacting anyone about the claim.

```bash
cd claim-bundle
git init && git add -A
git commit -m "JSP-000301: Lean formalization of Golomb's powerful-numbers counterexample"
# create the (empty, public) repo on Simon's GitHub account, then:
git remote add origin <Simon's repo URL>
git push -u origin main
```

- [ ] Repo created under Simon's account and pushed
- [ ] Fill `formalization.yaml`: `repository:` and `commit:` (full 40-char SHA
      of the pushed commit); amend or add a follow-up commit and note which
      SHA is the selected proof commit
- [x] Repository licence decided: MIT (`LICENSE` added at publication, 2026-10-24)

## Step 2 — GATE: catalog PR to TheJustinSunPrize/awards
- [ ] Fork the awards repo; update the JSP-000301 catalog entry with: Lean
      source repo URL, branch, full commit SHA, statement/proof entry points
      (`Proof.lean`, theorem `jsp_000301_counterexample`), reproduction
      instructions (`lean Proof.lean` on the pinned toolchain), and the
      mathematical-solution evidence (Golomb [Go70])
- [ ] Open the PR completing the repo's PR template (Simon approves the exact
      text first)

## Step 3 — after the PR merges: claim-award issue
- [ ] Open the `[Award claim] JSP-000301` issue from Simon's own account
      (proxy applications are not accepted), role = Lean formalization,
      linking the merged PR and the proof repo

## Step 4 — GATE: identity verification (private, by email only)
- [ ] Email thejustinsunprize@hejustinsun.com using the repo's template, from
      the follow-up address named in the issue, linking issue + merged PR
- [ ] KYC as required by the Prize rules before disbursement; applicant/payee
      must be a natural person or legal entity — default: Simon personally
- [ ] Identity materials go by email only, never on GitHub

## Step 5 — 14-day public review (no action)
- [ ] Runs from when maintainers add the contribution to `candidates/`

## Step 6 — GATE: recipient confirmation + payout details
- [ ] Written confirmation when asked; payment network/address sent by email
      only. Payout is crypto-only under the rules: TRC-20 USDT or ERC-20 USDC
- [ ] Amount note: JSP-000301's tier allocation is committee-set and
      unpublished; the formalizer share is 30% of whatever is set. Recorded
      in program books at $0 until liquidated.

Fallbacks if anything above has changed since 2026-10-24: re-read the awards
repo's `docs/award-process.md` and `docs/verification.md` before acting — the
process in this checklist is as read on 2026-10-24.
