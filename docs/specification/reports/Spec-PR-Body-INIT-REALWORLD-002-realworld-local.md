## Initiative

INIT-REALWORLD-002 — Author-subscription trust with denial-honest empties

## Meta handoff

- Meta PRD PR: https://github.com/drivestream-lab/realworld-meta/pull/8
- Approved meta head: `ee9fe45ad23d988eface7517a3a65a7b58b592c1`
- Impact-map revision: 1
- PRD digest: `sha256:5a9b49dd102202262edca3cb3d2bf315f43782884372d945be9274124b974c92`
- Repo scope digest: `sha256:a43cf05dc8d4ddacef6d61c97b0efe2a7dad7ebe1ed7bbd4060ea5ebf7a1a358`

## Spec path

`docs/specification/product/INIT-REALWORLD-002-local.md`

## Summary

- 8 REQs covering local compose prove join (adh_local + DB realworld + host-side verify) enabling author-subscription / denial-honest empty kill-path UAT
- No product CAP ownership; CAP-01..CAP-04 / J-01..J-16 carried as out-of-repo N/A (api/web) with kill-path journeys cited on REQ-08
- Open non-blocking engineering questions: Q-06, Q-07, Q-10, Q-11, Q-12, Q-13

## Gate 2 — spec package readiness

Initial label: `spec-pending`

- [ ] Spec slice published on this PR head (via Forge `/commit-workspace` / `/open-draft-pr`)
- [ ] Feasibility report (later Forge publish)
- [ ] Technical design + ADRs (later Forge publish)
- [ ] Implementation plan §9 (later Forge publish)
- [ ] PE sets `spec-lgtm` on exact final head before merge

Requested reviewer: @drivestream-lab/platform-devs
