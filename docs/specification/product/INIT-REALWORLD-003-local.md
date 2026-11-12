# INIT-REALWORLD-003 — spec slice for realworld-local

| Field | Value |
|-------|-------|
| Initiative | INIT-REALWORLD-003 |
| PRD | `realworld-meta/prd/INIT-REALWORLD-003.md` |
| PRD digest (H1) | `sha256:5cccf07066a0333027279aac0cae64d3f3be10773b7a5b37106302f2bbb9ceb8` |
| Meta PR | https://github.com/drivestream-lab/realworld-meta/pull/10 |
| Meta PR approved head (G1) | `abfbbcff877a83c298776fd4801b8ac4c75ddfba` |
| Impact map | `realworld-meta/prd/reports/Impact-Map-INIT-REALWORLD-003.md` |
| Impact-map revision (H3) | `1` |
| Repo scope digest (H2) | N/A — `drivestream-lab/realworld-local` is **deferred** (not affected); no `scope_digest` minted for this repo in map revision 1 |
| Tech-lead approval | Review `PRR_kwDOVac9Rs8AAAABXCDSZQ` / id `5840622181` by `adh-reviewer[bot]` (Gate‑1 attestation by adh.pe), APPROVED at `2026-11-10T10:48:57Z`; `commit_id` = `abfbbcff877a83c298776fd4801b8ac4c75ddfba` (matches merged meta PR #10 head; label `impact-map-lgtm`) |
| Repo | drivestream-lab/realworld-local |
| Date | 2026-11-12 |
| Status | **Gate closed — out of scope this INIT** (impact-map deferred; no product REQs for this repo) |

> **H4 citations:** The H1–H3 (and G1) rows above are the durable authority
> carrier for mid-lane freshness. Feas / TDD / plan digests are walk-time only
> and may be purged at initiative closure — see
> `prayog-skills/references/artifact-write-contract.md`.
>
> **T0 stop:** `/spec-draft` requires this repo to be `affected` with an H2
> `scope_digest` and not deferred/blocked. Impact-map revision 1 lists
> `realworld-local` under **Deferred repositories** (compose joins api+web;
> this INIT proves on the API machine-consumable surface and does not expand
> product scope to web UI; optional local API host does not mint a product CAP).
> Sole affected product owner is `drivestream-lab/realworld-api`
> (`INIT-REALWORLD-003-api.md`). No local environment/product REQs are drafted here.

## Overview

`realworld-local` has **no in-scope delivery** for INIT-REALWORLD-003 under the approved impact map. Replay-ready personal search memory (park / recall / relabel / discard with query-string fidelity and owner isolation) is owned and proven on the machine-consumable API surface of `realworld-api`. Compose/env hosting may remain available as optional infrastructure, but this INIT does not assign local a product CAP or mint a compose delta as Gate 1 scope.

**Out of this repo (this INIT):** all CAP-01..CAP-03 / REQ-01..REQ-13 product behavior — provider `realworld-api`. Settings / any web UI — `realworld-web` (also deferred). Share/public parks, auto-run, ranking product, INIT-001 favorites, INIT-002 subscriptions — unchanged non-goals.

**Ownership:** this artifact records the Gate 1 scope stop for `realworld-local` only. It does **not** invent local REQs, compose acceptance, or architecture. Revisit when eng needs a compose/env delta specifically for API-only live prove of CAP-01..CAP-03 (impact-map §3 revisit), via a new map revision that promotes local to Affected with a `scope_digest`.

## Functional requirements

| ID | Requirement | PRD source | Condition / event | Observable result | Evidence layer |
|----|-------------|-----------|-------------------|-------------------|----------------|
| — | None — this repo is impact-map **deferred**; no local REQs this INIT | Impact-map §3 Deferred; PRD Lock 1 / §3 (API + meta product changes; no web UI); PRD §8 (no cross-repo CTR) | N/A | N/A — no local product/env CAP to accept this INIT | N/A |

> **Id convention:** `REQ-*` is canonical. No `REQ-*` rows are minted for a deferred repo.
>
> Do not treat empty REQ table as “pass with zero work” for Forge — D1 FAIL closes the gate.

## Capabilities (carried from PRD)

| ID | Capability | Journeys | Notes |
|----|------------|----------|-------|
| CAP-01 | Park a personal search intent | J-01, J-02, J-08, J-12 | **Out of repo** — owned by `realworld-api` (local deferred) |
| CAP-02 | Recall and maintain own search memory | J-01, J-02, J-03, J-04, J-05, J-08, J-10 | **Out of repo** — owned by `realworld-api` (local deferred) |
| CAP-03 | Private continuity isolation | J-06, J-07, J-09, J-11 | **Out of repo** — owned by `realworld-api` (local deferred) |

## Journeys (carried from PRD)

| ID | Actor | Trigger | Main flow | Primary edge | Abandon | Caps |
|----|-------|---------|-----------|--------------|---------|------|
| J-01 | Seated member | Named park for later reuse | Park query + label → recall fidelity | Duplicate query allowed (OQ-06 default) | Abandon before park | CAP-01, CAP-02 — **out of repo** (`realworld-api`) |
| J-02 | Seated member | Unlabeled park | Park query, no label → recall | — | Abandon → no park | CAP-01, CAP-02 — **out of repo** |
| J-03 | Seated member | Continue prior search | Own-recall with query text | Empty list valid | Leave unchanged | CAP-02 — **out of repo** |
| J-04 | Seated member | Clearer mnemonic | Relabel → query unchanged | Clear label (OQ-07 default) | Abandon mid-relabel | CAP-02 — **out of repo** |
| J-05 | Seated member | Discard park | Discard → absent from recall | — | — | CAP-02 — **out of repo** |
| J-06 | Peer member | Harvest another’s memory | List/access A’s parks | Denied / no disclosure | — | CAP-03 — **out of repo** |
| J-07 | Guest / post-logout | Stewardship without seat | Park/list/relabel/discard | Fail closed | — | CAP-03 — **out of repo** |
| J-08 | Seated member | Continuity across sessions | Park → logout → login → recall | Same query text | — | CAP-01, CAP-02 — **out of repo** |
| J-09 | Peer member | Alter another’s park | Relabel/discard A’s park | A unchanged | — | CAP-03 — **out of repo** |
| J-10 | Seated member | Last discard | Discard final → empty recall | Empty valid | — | CAP-02 — **out of repo** |
| J-11 | Seated member | Bad park identity | Relabel/discard missing/non-owned | Fail closed | — | CAP-03 — **out of repo** |
| J-12 | Seated member | Empty query park | Park empty/whitespace | Refused; recall unchanged | — | CAP-01 — **out of repo** |

## Negative and failure paths

| REQ | Condition | Required behavior | Why it matters | Evidence |
|-----|-----------|-------------------|----------------|----------|
| — | N/A for this repo | No local failure paths this INIT — API owns seat/isolation kill paths; no compose delta assigned | Prevents inventing env REQs for a deferred prove host | N/A |

## Out of scope for this repo

- **All** INIT-REALWORLD-003 product CAPs/REQs — provider `drivestream-lab/realworld-api` (affected; H2 `sha256:6e1a5775a890e03ad0295e43e795e36962fd431132a03412cf647282dc8331c7`)
- Settings / any web UI for parked-search stewardship — `drivestream-lab/realworld-web` (also deferred)
- Cross-repo CTR seams (PRD §8: none)
- Inventing a compose/env delta “for convenience” while map keeps local deferred
- Share/public/collaborative parks; auto-run; ranking product; INIT-001 favorites; INIT-002 subscriptions; comments; OAuth; email verification; mobile/native; admin tooling; new infra services

**Revisit condition (impact-map §3):** Eng needs compose/env delta specifically for API-only live prove of CAP-01..CAP-03 — new map revision with local `affected` + `scope_digest`.

## Cross-service contracts

None — no cross-repository boundary this INIT (PRD §8; impact-map §6). Stewardship owned and proven on `realworld-api` only. Local does not own a compose-join CTR while deferred.

## Non-functional requirements

| Area | Requirement or N/A rationale | Acceptance / evidence |
|------|------------------------------|-----------------------|
| Security | N/A this repo — seat/peer isolation is API-owned (PRD REQ-04, REQ-10–REQ-13) | N/A |
| Reliability | N/A — no local CAP this INIT | N/A |
| Performance / capacity | N/A — no local CAP this INIT | N/A |
| Observability | N/A — no local CAP this INIT | N/A |
| Privacy / data handling | N/A this repo — private parks must not be exposed via a local-owned surface this INIT because no local CAP is in scope | N/A |
| Migration / compatibility | N/A — no local product/env delta assigned | N/A |
| Rollback / recovery | N/A — no local product/env delta assigned | N/A |
| Operations / support | N/A — optional existing compose host may remain; this INIT does not expand local ops scope | N/A |

## Assumptions

| ID | Assumption | Evidence | Owner | Status | Invalidated when |
|----|------------|----------|-------|--------|------------------|
| A-01 | Impact-map revision 1 deferral of `realworld-local` is authoritative for this `/spec-draft` invoke | Impact-map §3; PRD Lock 1 / §3 / §8; map revisit = compose/env delta for API-only prove | PM | confirmed | Map revision promotes local to affected with H2 |
| A-02 | Lead “all impacted repos” listing does not override the committed impact-map disposition for this repo | Skill NON-NEGOTIABLE 7; impact-map SSOT for H2 | PE | confirmed | Approved map revision changes local disposition |
| A-03 | API sibling owns CAP-01..CAP-03 prove; local must not mint competing env REQs while deferred | Impact-map §2 Affected = api only; sibling `INIT-REALWORLD-003-api.md` | PE | confirmed | Local promoted to affected |
| A-04 | Existing INIT-001/002 local compose baseline may continue unchanged without this INIT assigning new REQs | Sibling local specs; impact-map deferred reason (optional host ≠ product CAP) | PE | confirmed | Map assigns compose/env delta as affected scope |

## Spec questions (ambiguities — need PM or domain confirmation before feasibility)

| ID | Lane | Question | Owner | Blocking | Required by | Default if deferred | Status | Resolution link |
|----|------|----------|-------|----------|-------------|---------------------|--------|-----------------|
| Q-01 | PM | Confirm `realworld-local` remains deferred for INIT-REALWORLD-003 (no compose/env CAP) vs promote to affected for API-only live prove | PM | yes | Gate 1 / next map | Remain deferred; no local REQs; API-only INIT; existing compose may host prove without new CAP | open — gate closed on current map | Impact-Map §3 Deferred; revisit condition |
| Q-02 | PE | As-built index `docs/specification/as-built/implementation-status.md` is absent in this workspace | PE | no | later when local promoted | Treat as empty as-built until index exists; does not unblock deferred gate | open | Missing path noted at T0 |
| Q-03 | PE | If later promoted: whether API-only prove needs compose/env delta beyond current api+web join (ports/DB/`verify.sh`) | PE | no | feasibility / technical review (only if promoted) | Keep current join; document API prove path without inventing web UI | open | Impact-Map §3 revisit |

> **Bounded clarification (Hermes non-interactive):** Q-01 default locked from impact-map + PRD — remain deferred; do not invent local REQs. Q-02/Q-03 non-blocking for this stop. Material gate = D1 deferred disposition → workflow `blocked` (not `pass`). IM-01..IM-07 defaults are for the api draft, not local.

## Draft check summary (D1–D12)

| Check | Status | Evidence / findings |
|-------|--------|---------------------|
| D1 Approved handoff current | **FAIL** | H1 matches PRD (`sha256:5cccf070…`); H3 map_revision=1; G1 APPROVED `commit_id` = meta PR #10 head `abfbbcff…`; label `impact-map-lgtm` — **but** this repo is **deferred** (not affected); **no H2 `scope_digest`** for `realworld-local` |
| D1b No open blocking IM-* | PASS | Impact-map §10: IM-01..IM-07 are `Blocking: no`; Gate 1 note allows defaults for api draft — irrelevant to local deferred stop |
| D2 Complete PRD traceability | N/A → PASS rationale | No in-scope local REQs; CAP-01..CAP-03 carried as out-of-repo N/A |
| D2b Journeys carried | PASS | J-01..J-12 listed with owning repo `realworld-api` / out-of-repo |
| D3 Repo-bounded scope | PASS | Zero local REQs; deferral + revisit condition match impact-map §3 |
| D4 Observable acceptance | N/A → PASS rationale | No applicable local REQ rows |
| D5 Negative/failure paths | N/A → PASS rationale | No local failure surface this INIT |
| D6 Assumptions/questions | PASS | A-01..A-04 confirmed; Q-01 blocking recorded; Q-02/Q-03 non-blocking |
| D7 Cross-repository contracts | PASS | None — PRD §8 / impact-map §6; no CTR-L minted while deferred |
| D8 NFR applicability | PASS | All eight areas N/A with reason |
| D9 As-built alignment | NEEDS INPUT (non-gating here) | As-built index absent; source not scanned for inventing REQs because D1 already FAIL |
| D10 Dependency order | PASS | Matches impact-map §7: api only; local deferred (not in build order) |
| D11 Zero unresolved blockers | **FAIL** | Q-01 Blocking=yes while map keeps local deferred — gate closed until map promotes local or human accepts out-of-scope stop |
| D12 Output completeness | PASS | Header H1/H3/G1 + deferred H2 N/A, tables, check summary, outcome, PR readiness, handoff present |

**Draft verdict:** FAIL

**Selected workflow outcome:** `blocked`
**Outcome reason:** Explicit Gate 1 closure — `realworld-local` is deferred (not affected, no H2) on approved impact-map revision 1; D1 FAIL; do not draft in-scope local REQs or fill `handoff.forge` for `open_draft_pr`.

Do not advance to `/initiative-feasibility` unless the workflow outcome is
`pass`, the draft verdict is PASS, and the developer review below is complete.

## PR readiness handoff

| Item | Value |
|------|-------|
| Workflow outcome | `blocked` — impact-map deferred this repo; D1 FAIL (no H2) |
| Verdict | PR BLOCKED |
| Existing spec PR | none |
| Proposed branch | N/A — do not open Draft spec PR while deferred |
| Proposed base | `develop` |
| Proposed title | N/A |
| PR type | N/A |
| Local artifacts to publish | `docs/specification/product/INIT-REALWORLD-003-local.md` (gate-stop record only) |
| Forge readiness | **omit** `handoff.forge` — outcome is not `pass`; do not recommend `/open-draft-pr` for this repo until map promotes local |
| Reviewer | N/A |
| Initial Gate 2 label | N/A |
| Additional invalidation label | none |
| Blocking items | Q-01 (local deferred on current map); D1 no H2 for this repo |

**No GitHub side effects have occurred.** This file is a durable out-of-scope / gate-stop record only. Next workflow node is `spec-human-decision` (human checkpoint). To unblock local env work: revise Impact-Map to `affected` with a new `scope_digest` (compose/env delta for API-only prove), re-approve Gate 1, then re-run `/spec-draft`.

### Proposed Draft PR body

```markdown
N/A — PR BLOCKED (repo deferred on Impact-Map revision 1).
```

## Developer review

- [ ] Scope matches the approved impact-map repo disposition (**deferred** — no H2)
- [ ] No local REQs invented while deferred
- [ ] CAP/J carried as out-of-repo N/A with owning repo named
- [x] Blocking gate recorded (Q-01 / D1)
- [ ] Developer confirmed draft is ready for feasibility — **not applicable** while `blocked`

## After Draft PR creation

N/A while outcome is `blocked`. If a later map revision promotes this repo:

```bash
launchpad apply-gates --repo realworld-local --apply
```

| PE action | Remove | Add |
|-----------|--------|-----|
| Pending/new revision | `spec-lgtm`, `spec-blocked` | `spec-pending` |
| Request changes/hold | `spec-pending`, `spec-lgtm` | `spec-blocked` |
| Approve full package | `spec-pending`, `spec-blocked`, `spec-revised`, `spec-stale` | `spec-lgtm` |

## References

- PRD: `realworld-meta/prd/INIT-REALWORLD-003.md`
- Meta PRD PR: https://github.com/drivestream-lab/realworld-meta/pull/10
- Spec PR: none (blocked)
- Service profile: not present (`docs/specification/product/00-service-profile.md` absent)
- Impact map: `realworld-meta/prd/reports/Impact-Map-INIT-REALWORLD-003.md`
- Sibling API spec (affected): `realworld-api/docs/specification/product/INIT-REALWORLD-003-api.md`

```yaml
handoff:
  contract: sdd-delivery/v2
  stage: spec-draft
  outcome: blocked
  artifact:
    path: docs/specification/product/INIT-REALWORLD-003-local.md
  blockers:
    - Q-01
  signals:
    pr_ready: false
    draft_verdict: FAIL
    map_revision: 1
    meta_pr: https://github.com/drivestream-lab/realworld-meta/pull/10
    meta_pr_approved_head: abfbbcff877a83c298776fd4801b8ac4c75ddfba
    prd_digest: sha256:5cccf07066a0333027279aac0cae64d3f3be10773b7a5b37106302f2bbb9ceb8
    scope_digest: null
    repo_disposition: deferred
    d1: FAIL
    affected_owner: drivestream-lab/realworld-api
    codegraph_provider: degraded-none
    grounding_depth: none
  next_candidates:
    - spec-human-decision
  human_checkpoint: true
  external_action: false
```
