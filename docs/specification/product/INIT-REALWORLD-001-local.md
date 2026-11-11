# INIT-REALWORLD-001 — spec slice for realworld-local

| Field | Value |
|-------|-------|
| Initiative | INIT-REALWORLD-001 |
| PRD | `realworld-meta/prd/INIT-REALWORLD-001.md` |
| PRD digest (H1) | `sha256:cdc1f66d5cf4c1f12fd0f9ed8bf28d320d4aef941d6abbb0612f53886a1fcfb4` |
| Meta PR | https://github.com/drivestream-lab/realworld-meta/pull/5 |
| Meta PR approved head (G1) | `a500df8eeefbea095ecdd65e00edb128416c3cf4` |
| Impact map | `realworld-meta/prd/reports/Impact-Map-INIT-REALWORLD-001.md` |
| Impact-map revision (H3) | `1` |
| Repo scope digest (H2) | `sha256:c771a5d610f5872dc3a5fc06cfc9e406341840f964ae998a630d9fc5a3ea93d9` |
| Tech-lead approval | https://github.com/drivestream-lab/realworld-meta/pull/5#pullrequestreview-5835509709 — `adh-reviewer[bot]` (adh.pe Gate-1 attestation), APPROVED, submitted `2026-11-10T01:45:11Z`, `commit_id` = approved head; label projection `impact-map-lgtm`; PR merged `2026-11-10T02:01:17Z` |
| Repo | `drivestream-lab/realworld-local` |
| Date | 2026-11-11 |
| Status | Draft — dev review required before Forge publish |

> **H4 citations:** The H1–H3 (and G1) rows above are the durable authority
> carrier for mid-lane freshness. Feas / TDD / plan digests are walk-time only
> and may be purged at initiative closure — see
> `prayog-skills/references/artifact-write-contract.md`.

## Overview

`realworld-local` is the **Wave0a live-prove compose environment** for INIT-REALWORLD-001:
it joins `realworld-api` and `realworld-web` on the shared `adh_local` network using
Postgres database `realworld`, so continuous UAT can drive the three kill paths
(guest bulletin read, seated auth+publish, post-logout seat denial) on web against
API (PRD Lock 9; impact-map scope for this repo).

**Out of scope for this repo:** product ownership of CAP-01..CAP-06 and CTR-01..CTR-06
(provider = `realworld-api`, consumer UAT = `realworld-web`); comments, follow graphs,
personalized feeds, OAuth, email verification, password recovery, account deletion,
admin/moderation, public who-favorited social proof, and server-side draft queues.

**Ownership:** this slice states observable compose / local-prove behavior —
reachable surfaces, join invariants, smoke readiness, and enablement of continuous
UAT. Architecture choices (exact Dockerfile path, image tagging, compose project
naming) are deferred to `/initiative-feasibility` and `/spec-technical-review`
(see Spec questions Q-03..Q-05).

**As-built baseline:** compose + Makefile + host-side `scripts/verify.sh` already
exist. Wave0a work **aligns and constrains** that surface so api+web stay jointly
runnable for kill-path prove — it is not a greenfield empty compose repo, and it
does **not** mint product bulletin/seat REQs here.

## Functional requirements

| ID | Requirement | PRD source | Condition / event | Observable result | Evidence layer |
|----|-------------|-----------|-------------------|-------------------|----------------|
| REQ-01 | Join `realworld-api` and `realworld-web` on the shared `adh_local` network with Postgres DB `realworld` | PRD Lock 9; PRD §9 Operations; Impact-Map §2 scope for realworld-local | Operator brings the local stack up after shared infra (`adh_local` + Postgres) is available | API and web containers run on `adh_local` and use DB `realworld` (no second Postgres / Buzz in this compose) | inspection / live smoke |
| REQ-02 | Publish host-reachable API and web endpoints for UAT | PRD Lock 9; PRD §3 continuous UAT | Stack is up | API is reachable on the host API port and web on the host web port (as-built defaults: `3100` / `3101`) so a UAT observer can drive web against API | live smoke (`make verify` / equivalent) |
| REQ-03 | Point the web client at the local API for Wave0a prove | PRD Lock 9; Impact-Map §7 dependency order | Web image/service is built or started for this compose | Web uses the local API root (`http://localhost:3100/api` as-built bake) rather than an external demo API for Wave0a prove | inspection / live (CAP-01..CAP-03 kill paths via web) |
| REQ-04 | Provide a host-side black-box smoke that API and web are reachable without `docker exec` into app containers | PRD §9 Operations; Impact-Map §2 “enabling continuous UAT” | Operator runs the repo verify entrypoint after `up` | Smoke confirms API docs/articles (and a minimal auth probe) plus web root HTML are reachable from the host | live smoke / inspection |
| REQ-05 | Enable continuous UAT of the three kill paths on web against API | PRD §1 kill assumption; Lock 9; §3 continuous UAT stories | Stack is up and healthy; UAT observer drives guest read, seated auth+publish, and post-logout seat denial via web | The three kill paths are **demonstrable** against the joined stack (product acceptance of CAP/REQ behavior remains owned by api/web slices) | live (CAP-01, CAP-02, CAP-03; J-01, J-06, J-07) via web+api on this compose |
| REQ-06 | Fail closed when the shared `adh_local` network prerequisite is missing | PRD §9 Operations; Impact-Map §4 transitive depends_on | Operator attempts `up` without `adh_local` present | Compose does not silently invent a private network substitute that drops shared Postgres coupling; operator observes a clear prerequisite failure | inspection / live negative |
| REQ-07 | Keep apps-only composition (no second Postgres, Redis, or Buzz in this repo’s compose) | PRD Lock 9; service catalog / as-built README contract | Operator inspects or starts this compose | Only api + web app services are defined for Wave0a prove; data plane remains shared infra DB `realworld` | inspection |
| REQ-08 | Tear down leaves host ports free for a subsequent prove cycle | PRD §3 continuous UAT; Impact-Map §2 | Operator runs the documented down entrypoint after a prove session | API/web containers from this project are stopped; a later `up` can restore the prove surface | inspection / live smoke |

## Capabilities (carried from PRD)

| ID | Capability | Journeys | Notes |
|----|------------|----------|-------|
| CAP-01 | Public bulletin reading | J-01, J-02, J-03, J-04, J-12, J-14, J-17 | **Out-of-repo product ownership** (`realworld-api` / `realworld-web`); this repo **enables** live prove on compose |
| CAP-02 | Contribution seat lifecycle | J-05, J-06, J-07, J-08, J-11, J-14, J-17, J-18 | Same — enable prove only |
| CAP-03 | Seated bulletin contribution | J-06, J-08, J-12, J-14, J-18 | Same — enable prove only |
| CAP-04 | Seated own-work revision | J-09, J-10, J-15 | Same — enable prove only |
| CAP-05 | Private shelf | J-07, J-08, J-09, J-13, J-16 | Same — enable prove only |
| CAP-06 | Own nameplate | J-07, J-08, J-13, J-19 | Same — enable prove only |

> Impact-map H2 for this repo has empty `capabilities=` — no product CAP ownership.
> CAP/J rows are carried so journeys are not dropped silently; live evidence on
> REQ-05 cites CAP/J for kill-path enablement only.

## Journeys (carried from PRD)

| ID | Actor | Trigger | Main flow | Primary edge | Abandon | Caps |
|----|-------|---------|-----------|--------------|---------|------|
| J-01 | Guest | Wants published content | Open global feed → open article when present → read | Empty bulletin → empty feed, still ungated | Leaves without registering | CAP-01 |
| J-02 | Guest | Follows a topic | Open tag lane → scan → open matching article | Empty tag → empty for that tag only | Leaves lane | CAP-01 |
| J-03 | Guest | Curious about an author | Open public profile → see public fields → open author article when present | Zero articles → profile visible, empty list | Leaves profile | CAP-01 |
| J-04 | Guest | Continues discovery across tags | Read multi-tagged article → follow each tag → confirm membership → open another match when present | Sole article in a lane → only that article | Stops after one hop | CAP-01 |
| J-05 | Visitor → eligible member | Decides to join | Register unique identity → membership exists → login (OQ-04) | Duplicate identity → refused; remains Guest | Abandons form; remains Guest | CAP-02 |
| J-06 | Seated member | Puts writing on bulletin | Authenticate → compose tagged markdown → publish → Guest sees feed/lanes/profile | Zero tags → publish refused | Logout before publish; no article | CAP-02, CAP-03 |
| J-07 | Seated → Guest → Seated | Ends then resumes seat | Logout → contribution denied → reads still work → login → contribution works | Stale seat must not mutate while unseated | N/A | CAP-02, CAP-05, CAP-06 |
| J-08 | Guest | Probes the seat | Attempts publish, favorite, profile self-update while unseated | Each fails closed, no side effects | Registers (enters J-05) | CAP-02, CAP-03, CAP-05, CAP-06 |
| J-09 | Author | Fixes or removes own writing | Edit and/or delete own article → bulletin reflects | After delete, not-found; shelf must not resurrect body (PRD REQ-33) | Cancels edit; prior version remains | CAP-04, CAP-05 |
| J-10 | Peer member | Attacks ownership | Attempts edit/delete on another’s article | Bulletin unchanged; denial observed | Returns to own articles | CAP-04 |
| J-11 | Member | Valid vs invalid seating | Login succeeds; bad credentials refused | Invalid login leaves seat inactive | Stops trying | CAP-02 |
| J-12 | Seated + Guest | Bootstraps bulletin | From zero articles, publish first tagged → Guest feed non-empty → Guest opens | Publish fail → empty ungated feed remains | Abandon compose; stays empty | CAP-01, CAP-03 |
| J-13 | Seated member | Private shelf + nameplate | Favorite other author’s article → see shelf → unfavorite; update bio/image → Guest sees update | Favorite own → refused | Leaves shelf unused; cancels nameplate edit | CAP-05, CAP-06 |
| J-14 | Guest → Seated | Converts mid-read | Guest reads → registers → logs in → publishes own tagged article | If login skipped, contribution unavailable until seated | Abandons join; still can read | CAP-01, CAP-02, CAP-03 |
| J-15 | Author | Retags published writing | Edit tag set → lane membership moves; empty tag set refused | Reader in old lane no longer finds article | Cancels edit; prior tags remain | CAP-04 |
| J-16 | Peer member | Probes shelf privacy | A favorites; B attempts to inspect A’s shelf | B cannot see A’s favorites | B favorites same article into B’s own shelf | CAP-05 |
| J-17 | Former seated (now Guest) | Confirms bulletin open after unseat | Logout → open feed → open own prior article → read as Guest | Contribution still denied on same visit | Leaves without reseating | CAP-01, CAP-02 |
| J-18 | Seated member | Abandons / unseats mid-compose | Starts compose → logout or abandon without publish → Guest feed unchanged | Partial client state must not create published article | N/A | CAP-02, CAP-03 |
| J-19 | Peer member | Attacks nameplate ownership | Attempts to change another’s public profile | Target unchanged; denial observed | Returns to own nameplate | CAP-06 |

> Product journey acceptance is owned by `realworld-api` / `realworld-web`.
> This repo’s duty is that the joined compose surface remains available so those
> journeys (especially kill-path J-01 / J-06 / J-07) can be live-proven (REQ-05).

## Negative and failure paths

| REQ | Condition | Required behavior | Why it matters | Evidence |
|-----|-----------|-------------------|----------------|----------|
| REQ-01 / REQ-06 | `adh_local` network absent | `up` fails closed with clear prerequisite error; no silent private-network substitute | Shared Postgres coupling is load-bearing for Wave0a prove | inspection / live negative |
| REQ-01 | Shared Postgres / DB `realworld` unavailable | API does not become a healthy prove surface; operator sees failed health / verify | Prevents false “stack up” when bulletin APIs cannot run | live smoke / inspection |
| REQ-02 / REQ-04 | API or web not reachable on host ports after purported `up` | Verify/smoke fails; kill-path UAT must not be claimed | Hosts continuous UAT honesty | live smoke |
| REQ-03 | Web still aimed at external demo API | Wave0a local prove is invalid; treat as composition defect | Lock 9 requires web against local API | inspection / live |
| REQ-05 | Stack up but api or web unhealthy | Kill-path UAT blocked; do not claim continuous UAT enabled | Separates smoke pass from journey prove | live |
| REQ-07 | Extra data-plane services appear in this compose | Reject as scope drift for Wave0a | Keeps apps-only / shared-infra contract | inspection |
| REQ-08 | Down incomplete; ports still held by stale containers | Subsequent prove cycle fails; operator must recover | Continuous UAT needs repeatable cycles | live / inspection |

## Out of scope for this repo

- Product CAP-01..CAP-06 behavior and acceptance — **`realworld-api`** (provider) and **`realworld-web`** (consumer UAT)
- CTR-01..CTR-06 semantic field meaning / fail-closed product rules — **api ↔ web**
- Creating or owning shared Postgres / `adh_local` infra — **`adh-iac-local`** (prerequisite)
- Comments, follow/unfollow, personalized (“your”) feed, OAuth, email verification, password recovery, account deletion, admin/moderation
- Public who-favorited social proof; server-side draft queues
- Expanding host smoke into full journey live packs (owned by web/api verify plans)
- Multi-session logout cascade (OQ-05) and mid-read push after delete (OQ-09) — deferred elsewhere

## Cross-service contracts

None — no product CTR provider/consumer boundary owned by this repo. CTR-01..CTR-06 remain `realworld-api` → `realworld-web`. This repo’s impact-map edge is an **operational compose dependency** on both (Impact-Map §7): join them for live prove without minting a product contract id.

| Contract ID | Provider / owner | Consumer / owner | Entry point | Input shape | Output shape | Invariants | Errors | Compatibility / versioning | Contract-test location |
|-------------|------------------|------------------|-------------|-------------|--------------|------------|--------|----------------------------|------------------------|
| — | — | — | N/A — compose dependency only | N/A | N/A | api+web jointly reachable on `adh_local` / DB `realworld` for Wave0a | Missing network / unhealthy service / wrong API_ROOT | N/A (ops surface) | `scripts/verify.sh` (smoke); journey packs planned under api/web |

## Non-functional requirements

| Area | Requirement or N/A rationale | Acceptance / evidence |
|------|------------------------------|-----------------------|
| Security | N/A as product seat/auth authority — seat fail-closed rules are owned by api/web. Compose must not require exposing contribution mutations without the API’s seat gate. Local default secrets are for Wave0a prove only, not a production hardening INIT. | inspection; kill-path prove remains on api/web |
| Reliability | Stack must be start/stop repeatable for continuous UAT (REQ-08). No multi-region SLA. Mid-action network interruption recovery is out of Wave0a UAT prove (PRD non-goal). | live up/down + smoke |
| Performance / capacity | N/A for Wave0a UAT scale; no concurrent-load target locked. | N/A (documented) |
| Observability | N/A as product REQ — `make logs` / compose logs are engineering convenience, not a kill criterion. | N/A (documented) |
| Privacy / data handling | N/A beyond hosting the same DB namespace `realworld` used by the apps; shelf/nameplate privacy owned by api/web. | N/A (documented) + api/web REQs |
| Migration / compatibility | Clean-slate UAT — no tenant corpus migration in this repo. Compose must stay apps-only on shared infra. | inspection / as-built |
| Rollback / recovery | N/A as product REQ — delivery rollback is engineering; `down` restores a stopped local prove surface (REQ-08). | inspection |
| Operations / support | This repo **is** the intended live-prove environment (PRD §9). Documented prerequisite: `adh-iac-local` infra up before `make up`. No 24×7 support envelope locked. | README + REQ-01/06 |

## Assumptions

| ID | Assumption | Evidence | Owner | Status | Invalidated when |
|----|------------|----------|-------|--------|------------------|
| A-01 | Shared infra (`adh_local` + Postgres with DB `realworld`) is provided by `adh-iac-local`, not minted here | README; compose external network; Impact-Map depends_on | PE | confirmed | Local compose is required to ship its own Postgres |
| A-02 | Sibling checkouts `../realworld-api` and `../realworld-web` are available for compose build contexts | `docker-compose.yml` build contexts | PE | confirmed | Monorepo layout or image registry changes build source |
| A-03 | Host smoke (`scripts/verify.sh`) is necessary but not sufficient for full journey acceptance | as-built verify.sh vs PRD J-* live packs | PE | confirmed | Verify is expanded to own full CAP/J packs in this repo |
| A-04 | Wave0a web must use local API root, not production Conduit demo | PRD Lock 9; compose `API_ROOT` bake; web as-built gap | PM/PE | confirmed | Offline/demo API prove replaces local join |
| A-05 | Product CAP/REQ acceptance remains in api/web slices; this repo enables continuous UAT only | Impact-Map §2 H2 empty capabilities | PE | confirmed | Impact-map assigns product CAPs to local |
| A-06 | PRD OQ-01..OQ-04 and OQ-06..OQ-08 defaults are locked for api/web; they do not mint local product REQs | PRD §11; Hermes non-interactive lock | PM | confirmed | OQ reopened with compose-visible product change |

## Spec questions (ambiguities — need PM or domain confirmation before feasibility)

| ID | Lane | Question | Owner | Blocking | Required by | Default if deferred | Status | Resolution link |
|----|------|----------|-------|----------|-------------|---------------------|--------|-----------------|
| Q-01 | PM | OQ/IM defaults that affect product (registration, tags, nameplate, ordering, delete/favorite) | PM | no | feasibility (api/web) | Apply PRD OQ-01..04, OQ-06..08 defaults; local has no product field REQs | resolved | PRD OQ defaults; api/web slices own REQ rows |
| Q-02 | PE | Multi-session logout cascade / mid-read push (OQ-05 / OQ-09) | PE | no | later | Unseat logging-out session only; next navigation sufficient — no local compose delta | open | PRD OQ-05/OQ-09 |
| Q-03 | PE | Whether compose should keep sibling `overlay/Dockerfile` build or switch to in-repo `docker/*.Dockerfile` | PE | no | technical review | Keep as-built compose build contexts (`overlay/Dockerfile`); treat unused local Dockerfiles as cleanup candidates | open | Architecture — not decided here |
| Q-04 | PE | How far host `verify.sh` must grow vs relying on api/web `tests/verify` journey packs | PE | no | plan | Keep host smoke minimal (REQ-04); full J-* live packs stay in api/web plans; REQ-05 is enablement | open | Plan / live-verify ownership |
| Q-05 | PE | Pin exact published host ports / compose project name as compatibility surface | PE | no | technical review | As-built defaults (`3100`/`3101`, project `realworld`) unless conflict forces change | open | Architecture — not decided here |

## Draft check summary (D1–D12)

| Check | Status | Evidence / findings |
|-------|--------|---------------------|
| D1 Approved handoff current | PASS | Hermes host `/spec-draft` 2026-11-11 (non-interactive): H1 `sha256:cdc1f66d5cf4c1f12fd0f9ed8bf28d320d4aef941d6abbb0612f53886a1fcfb4` matches promoted PRD bytes; H3 map_revision=1; H2 `sha256:c771a5d610f5872dc3a5fc06cfc9e406341840f964ae998a630d9fc5a3ea93d9` recomputed from recipe (empty capabilities/contracts; depends_on api,web; scope summary match); G1 APPROVED review https://github.com/drivestream-lab/realworld-meta/pull/5#pullrequestreview-5835509709 `commit_id`=`a500df8eeefbea095ecdd65e00edb128416c3cf4` equals meta PR #5 head; label `impact-map-lgtm`; merged `2026-11-10T02:01:17Z`; repo affected not deferred/blocked |
| D1b No open blocking IM-* | PASS | IM-01..IM-09 all Blocking=no; Gate 1 note allows consuming defaults |
| D2 Complete PRD traceability | PASS | Local REQs trace to Lock 9 / §3 / §9 / Impact-Map §2; CAP-01..06 carried as enablement/out-of-repo ownership with no silent drop |
| D2b Journeys carried | PASS | J-01..J-19 listed; REQ-05 live evidence cites CAP/J for kill-path enablement |
| D3 Repo-bounded scope | PASS | Compose/UAT-enablement only; product CAP/CTR owned by api/web; matches H2 empty capabilities |
| D4 Observable acceptance | PASS | Condition/event + observable result + evidence on every REQ; no Dockerfile/module ADR choice in REQs |
| D5 Negative/failure paths | PASS | Missing network, unhealthy services, wrong API_ROOT, scope drift, tear-down — each with why-it-matters |
| D6 Assumptions/questions | PASS | A-01..A-06 evidenced; Q rows have lane/owner/blocking/required-by/default/status; material PM locks resolved via PRD defaults |
| D7 Cross-repository contracts | PASS | No product CTR owned here; api↔web CTR-01..06 noted; compose dependency documented per map §7 |
| D8 NFR applicability | PASS | All eight rows present; N/A rows have rationale; Operations owns live-prove role |
| D9 As-built alignment | PASS | Overview + as-built index distinguish present compose/verify vs Wave0a enablement constraints |
| D10 Dependency order | PASS | Matches map: api → web → local; this repo depends on api+web |
| D11 Zero unresolved blockers | PASS | No Blocking=yes Q/IM; Q-02..Q-05 non-blocking with defaults |
| D12 Output completeness | PASS | Header H1–H3/G1, tables, checks, outcome, PR readiness, handoff envelope present |

**Draft verdict:** PASS

**Selected workflow outcome:** `pass`
**Outcome reason:** D1–D12 PASS; Gate 1 H1/H2/H3/G1 current; material OQ/IM defaults locked by Hermes non-interactive clarification loop into api/web ownership notes + local enablement REQs; zero Blocking=yes questions; PR READY for Forge `open_draft_pr` (not executed in this skill).

Do not advance to `/initiative-feasibility` unless the workflow outcome is
`pass`, the draft verdict is PASS, and the developer review below is complete.

## PR readiness handoff

| Item | Value |
|------|-------|
| Workflow outcome | `pass` — D1–D12 PASS; Gate 1 current; material OQs locked; local scope compose-only |
| Verdict | PR READY |
| Existing spec PR | none |
| Proposed branch | `chore/INIT-REALWORLD-001-spec-realworld-local` |
| Proposed base | `develop` |
| Proposed title | `[INIT-REALWORLD-001] Spec — realworld-local` |
| PR type | **Draft** (entire spec lifecycle) |
| Local artifacts to publish | `docs/specification/product/INIT-REALWORLD-001-local.md`, `docs/specification/product/00-service-profile.md`, `docs/specification/as-built/implementation-status.md`, `docs/specification/README.md`, `docs/specification/reports/.gitkeep` |
| Forge readiness | `handoff.forge` filled for `open_draft_pr`; recommend `/commit-workspace` then `/open-draft-pr` (or Gateflow ForgeClient on `spec-pr-action`) — do not commit/push/open PR inside this skill |
| Reviewer | @drivestream-lab/platform-devs |
| Initial Gate 2 label | `spec-pending` |
| Additional invalidation label | none |
| Blocking items | none |

**No GitHub side effects have occurred.** Persist the draft locally; Forge publish requires `/commit-workspace` / `/open-draft-pr` or automated `spec-pr-action`.

### Proposed Draft PR body

```markdown
## Initiative

INIT-REALWORLD-001 — Public bulletin with session-bound contribution seat

## Meta handoff

- Meta PRD PR: https://github.com/drivestream-lab/realworld-meta/pull/5
- Approved meta head: `a500df8eeefbea095ecdd65e00edb128416c3cf4`
- Impact-map revision: 1
- PRD digest: `sha256:cdc1f66d5cf4c1f12fd0f9ed8bf28d320d4aef941d6abbb0612f53886a1fcfb4`
- Repo scope digest: `sha256:c771a5d610f5872dc3a5fc06cfc9e406341840f964ae998a630d9fc5a3ea93d9`

## Spec path

`docs/specification/product/INIT-REALWORLD-001-local.md`

## Summary

- Compose / live-prove slice enabling Wave0a kill-path UAT (REQ-01..REQ-08)
- No product CAP ownership; CAP-01..CAP-06 / J-01..J-19 carried as enablement / out-of-repo N/A
- Open non-blocking engineering questions: Q-02, Q-03, Q-04, Q-05

## Gate 2 — spec package readiness

Initial label: `spec-pending`

- [ ] Spec slice published on this PR head (via Forge `/commit-workspace` / `/open-draft-pr`)
- [ ] Feasibility report (later Forge publish)
- [ ] Technical design + ADRs (later Forge publish)
- [ ] Implementation plan §9 (later Forge publish)
- [ ] PE sets `spec-lgtm` on exact final head before merge

Requested reviewer: @drivestream-lab/platform-devs
```

## Developer review

- [ ] Scope matches the approved impact-map repo scope digest
- [ ] REQs have condition/event, observable result, and evidence layer
- [ ] Contracts are semantic (logical operation); no architecture decisions in REQs
- [ ] No blocking question remains
- [ ] Developer confirmed draft is ready for feasibility

## After Draft PR creation

PE controls Gate 2 labels on the spec PR. Never infer approval from labels
alone — `spec-lgtm` requires matching artifacts on the exact PR head.

Provision labels before PR creation when missing:

```bash
launchpad apply-gates --repo realworld-local --apply
```

| PE action | Remove | Add |
|-----------|--------|-----|
| Pending/new revision | `spec-lgtm`, `spec-blocked` | `spec-pending` |
| Request changes/hold | `spec-pending`, `spec-lgtm` | `spec-blocked` |
| Approve full package | `spec-pending`, `spec-blocked`, `spec-revised`, `spec-stale` | `spec-lgtm` |

## References

- PRD: `realworld-meta/prd/INIT-REALWORLD-001.md`
- Meta PRD PR: https://github.com/drivestream-lab/realworld-meta/pull/5
- Spec PR: pending
- Service profile: `docs/specification/product/00-service-profile.md`
- As-built: `docs/specification/as-built/implementation-status.md`
- Impact map: `realworld-meta/prd/reports/Impact-Map-INIT-REALWORLD-001.md`

```yaml
handoff:
  contract: sdd-delivery/v2
  stage: spec-draft
  outcome: pass
  artifact:
    path: docs/specification/product/INIT-REALWORLD-001-local.md
  blockers: []
  signals:
    pr_ready: true
    codegraph_provider: degraded-none
    grounding_depth: light
    map_revision: 1
    meta_pr: https://github.com/drivestream-lab/realworld-meta/pull/5
    meta_pr_approved_head: a500df8eeefbea095ecdd65e00edb128416c3cf4
    prd_digest: sha256:cdc1f66d5cf4c1f12fd0f9ed8bf28d320d4aef941d6abbb0612f53886a1fcfb4
    scope_digest: sha256:c771a5d610f5872dc3a5fc06cfc9e406341840f964ae998a630d9fc5a3ea93d9
  next_candidates:
    - spec-pr-action
  human_checkpoint: false
  external_action: true
  forge:
    action: open_draft_pr
    draft: true
    apply_labels:
      - spec-pending
    title: "[INIT-REALWORLD-001] Spec — realworld-local"
    body_path: docs/specification/product/INIT-REALWORLD-001-local.md
```
