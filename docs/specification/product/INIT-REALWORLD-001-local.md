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
| Tech-lead approval | Review `PRR_kwDOVac9Rs8AAAABW9LPzQ` / id `5835509709` by `adh-reviewer[bot]` (Gate‑1 attestation by adh.pe), APPROVED at `2026-11-10T01:45:11Z`; `commit_id` = `a500df8eeefbea095ecdd65e00edb128416c3cf4` (matches merged meta PR #5 head; label `impact-map-lgtm`) |
| Repo | drivestream-lab/realworld-local |
| Date | 2026-11-11 |
| Status | Draft — dev review required before Forge publish |

> **H4 citations:** The H1–H3 (and G1) rows above are the durable authority
> carrier for mid-lane freshness. Feas / TDD / plan digests are walk-time only
> and may be purged at initiative closure — see
> `prayog-skills/references/artifact-write-contract.md`.

## Overview

`realworld-local` is the **Wave0a live-prove compose environment**: it joins `realworld-api` and `realworld-web` on the shared `adh_local` network against Postgres database `realworld`, so continuous UAT can demonstrate the three kill paths (guest bulletin read, seated auth+publish, post-logout seat denial) on web against API (PRD Lock 9; impact-map scope).

**Out of this repo:** Product CAP/REQ ownership for bulletin, seat, publish, revise, shelf, and nameplate (`realworld-api` provider; `realworld-web` consumer UAT chrome); comments, follows, personalized feeds, OAuth, who-favorited social proof, drafts/moderation, password recovery, account deletion, admin roles.

**Ownership:** this spec states observable local-prove environment behavior only (compose join, documented host endpoints, host-side smoke verify, documented infra prerequisite). Implementation architecture (compose file layout, Dockerfile choice, Makefile targets) is **not** decided here — routed to feasibility / technical review.

## Functional requirements

| ID | Requirement | PRD source | Condition / event | Observable result | Evidence layer |
|----|-------------|-----------|-------------------|-------------------|----------------|
| REQ-01 | Join api and web as a single local prove stack on the shared `adh_local` network | PRD Lock 9; §9 Operations; impact-map local scope | Operator brings the local prove stack up after shared infra is available | Both api and web containers are part of the same compose project and attached to external network `adh_local` | inspection / live |
| REQ-02 | Persist tenant data via shared Postgres database `realworld` (no second Postgres in this stack) | PRD Lock 9; impact-map local scope (“adh_local/DB realworld”) | Operator brings the stack up with shared Postgres already running on `adh_local` | Api is configured to use database `realworld` on the shared Postgres host; compose does not start a second Postgres service | inspection |
| REQ-03 | Expose the API on the documented host prove port | PRD Lock 9; continuous UAT stories | Stack is up | Host can reach the API at the documented local URL (baseline: `http://localhost:3100`) | live / `scripts/verify.sh` |
| REQ-04 | Expose the web UAT surface on the documented host prove port, bound to the local API | PRD Lock 9; Wave0a web-against-API prove | Stack is up | Host can reach the web client at the documented local URL (baseline: `http://localhost:3101`); web is built/configured so its API root targets the local API prove URL (baseline: `http://localhost:3100/api`) | live / `scripts/verify.sh` |
| REQ-05 | Provide a host-side smoke verify that confirms api+web readiness without entering app containers | PRD Lock 9; continuous UAT enablement | Operator runs the documented verify entrypoint with the stack up | Verify succeeds only when API docs/articles (and a minimal register smoke) and web root are reachable from the host; it does not `docker exec` into app containers | live / inspection (`scripts/verify.sh`) |
| REQ-06 | Keep the local stack limited to apps-only RealWorld prove services | PRD non-goals (no extra product surfaces); impact-map local scope | Operator inspects compose services | Compose does not introduce Redis, Buzz, or a second Postgres; only the api+web apps required for Wave0a prove | inspection |
| REQ-07 | Document and enforce the shared-infra prerequisite for bring-up | PRD Lock 9; impact-map dependency order (api → web → local) | Operator attempts bring-up without `adh_local` / shared Postgres ready | Bring-up fails closed or is blocked until `adh_local` exists; docs state that shared infra (`adh-iac-local` / `make infra-up`) must precede local up | inspection / live |
| REQ-08 | Enable continuous UAT of the three kill paths on the joined stack | PRD §1 kill assumption; Lock 9; continuous UAT stories | Shared infra + local stack are up; api and web Wave0a surfaces exist | Guest bulletin read, seated auth+publish, and post-logout seat denial are demonstrable against this local join (product behavior owned by api/web; local supplies the reachable prove environment) | live (J-01, J-06, J-07) — environment evidence; product REQs owned by api/web |

> **Id convention:** `REQ-*` is canonical. Legacy display alias `FR-{nn}` ≡ `REQ-{nn}` — prefer `REQ-*`.
>
> **Behavioral acceptance vs evidence:** Condition/event + observable result are
> the product acceptance statement (implementation-neutral). Evidence layer
> names how it will be proved later. Live evidence cites `CAP-*` and/or `J-*`
> when this repo’s REQs enable those prove rungs.

## Capabilities (carried from PRD)

| ID | Capability | Journeys | Notes |
|----|------------|----------|-------|
| CAP-01 | Public bulletin reading | J-01, J-02, J-03, J-04, J-12, J-14, J-17 | **Out of repo** — owned by realworld-api (provider) + realworld-web (UAT). Local enables prove host reachability only. |
| CAP-02 | Contribution seat lifecycle | J-05, J-06, J-07, J-08, J-11, J-14, J-17, J-18 | **Out of repo** — api/web. Local enables joined prove environment. |
| CAP-03 | Seated bulletin contribution | J-06, J-08, J-12, J-14, J-18 | **Out of repo** — api/web. |
| CAP-04 | Seated own-work revision | J-09, J-10, J-15 | **Out of repo** — api/web. |
| CAP-05 | Private shelf | J-07, J-08, J-09, J-13, J-16 | **Out of repo** — api/web. |
| CAP-06 | Own nameplate | J-07, J-08, J-13, J-19 | **Out of repo** — api/web. |

> Impact-map: this repo has **no product CAP ownership** beyond enabling continuous UAT of the three kill paths.

## Journeys (carried from PRD)

| ID | Actor | Trigger | Main flow | Primary edge | Abandon | Caps |
|----|-------|---------|-----------|--------------|---------|------|
| J-01 | Guest | Wants published content | Opens global feed → opens article when present → reads | Empty bulletin → empty ungated feed | Leaves without registering | CAP-01 — **prove on web/api; local N/A beyond host join** |
| J-02 | Guest | Follows a topic | Opens tag lane → opens matching article | Empty tag lane for that tag only | Leaves lane | CAP-01 — out-of-repo N/A |
| J-03 | Guest | Curious about an author | Opens public profile → opens author’s article when present | Profile with zero articles | Leaves profile | CAP-01 — out-of-repo N/A |
| J-04 | Guest | Continues discovery across tags | Multi-tagged article → each tag lane → confirms membership | Sole article in a lane | Stops after one hop | CAP-01 — out-of-repo N/A |
| J-05 | Visitor → eligible member | Decides to join | Registers unique identity → membership exists → logs in (IM-04) | Duplicate identity refused | Abandons; remains Guest | CAP-02 — out-of-repo N/A |
| J-06 | Seated member | Puts writing on bulletin | Authenticates → publishes tagged markdown → Guest sees it | Zero tags → refuse | Unseat before publish; no article | CAP-02, CAP-03 — kill-path prove enabled by REQ-08 |
| J-07 | Seated → Guest → Seated | Ends then resumes seat | Logout → contribution denied → read still works → login → contribution works | Stale seat must not mutate while unseated | N/A | CAP-02, CAP-05, CAP-06 — kill-path prove enabled by REQ-08 |
| J-08 | Guest | Probes the seat | Attempts publish, favorite, profile self-update while unseated | Each fails closed; no side effects | Registers (J-05) | CAP-02, CAP-03, CAP-05, CAP-06 — out-of-repo N/A |
| J-09 | Author | Fixes or removes own writing | Edits and/or deletes own article | After delete, Guest not-found; shelf must not resurrect | Cancels edit; prior remains | CAP-04, CAP-05 — out-of-repo N/A |
| J-10 | Peer member | Attacks ownership | Attempts edit/delete on another’s article | Bulletin unchanged | Returns to own work | CAP-04 — out-of-repo N/A |
| J-11 | Member | Valid vs invalid seating | Good login seats; bad credentials refused | Invalid login leaves seat inactive | Stops trying | CAP-02 — out-of-repo N/A |
| J-12 | Seated + Guest | Bootstraps empty bulletin | First tagged publish → Guest feed non-empty → Guest opens | Failed publish leaves empty ungated feed | Abandon compose; empty remains | CAP-01, CAP-03 — out-of-repo N/A |
| J-13 | Seated member | Private shelf + nameplate | Favorite others → shelf → unfavorite; update bio/image → Guest sees | Favorite own → refused | Leaves unused / cancels | CAP-05, CAP-06 — out-of-repo N/A |
| J-14 | Guest → Seated | Converts mid-read | Guest reads → registers → logs in → publishes | Contribution unavailable until seated | Abandons join; still reads | CAP-01, CAP-02, CAP-03 — out-of-repo N/A |
| J-15 | Author | Retags published writing | Edits tag set → lane membership moves; empty tag set refused | Old lane no longer lists article | Cancels; prior tags remain | CAP-04 — out-of-repo N/A |
| J-16 | Peer member | Probes shelf privacy | A favorites; B attempts to inspect A’s shelf | B cannot see A’s shelf | B favorites into B’s own shelf | CAP-05 — out-of-repo N/A |
| J-17 | Former seated (now Guest) | Confirms bulletin after unseat | Logout → feed → open own prior article as Guest | Contribution still fail-closed | Leaves without reseating | CAP-01, CAP-02 — related to kill-path prove (REQ-08) |
| J-18 | Seated member | Abandons / unseats mid-compose | Starts compose → abandon or logout without publish | No published article | N/A | CAP-02, CAP-03 — out-of-repo N/A |
| J-19 | Peer member | Attacks nameplate ownership | Attempts to change another’s profile | Target unchanged | Returns to own nameplate | CAP-06 — out-of-repo N/A |

## Negative and failure paths

| REQ | Condition | Required behavior | Why it matters | Evidence |
|-----|-----------|-------------------|----------------|----------|
| REQ-01 / REQ-07 | `adh_local` network missing | Bring-up fails closed / blocked; stack does not silently create a substitute private network that orphans shared Postgres | Prevents “green” compose that cannot reach shared DB | live / inspection |
| REQ-02 | Shared Postgres / DB `realworld` unavailable | Api does not become a healthy prove target; verify must not pass against a phantom stack | Kill-path UAT needs durable tenant DB | live |
| REQ-03 / REQ-04 | Api or web not published on documented host ports | Host-side verify fails; UAT observer cannot drive kill paths | Wave0a prove is host-reachable web-against-API | live (`scripts/verify.sh`) |
| REQ-04 | Web API root still points at a third-party demo host | Local prove is invalid for Lock 9 even if web HTML loads | Prevents false pass against external Conduit | inspection / live |
| REQ-05 | Verify implemented via `docker exec` into app | Violates host-side black-box rule | Keeps prove aligned with UAT observer surface | inspection |
| REQ-06 | Extra Redis / Buzz / second Postgres added “for convenience” | Out of Wave0a local scope; expands ops surface without INIT authority | Keeps local apps-only | inspection |
| REQ-08 | Stack up but api/web product surfaces missing kill paths | Environment REQs may pass while product kill paths fail — product failure belongs to api/web specs, not to local CAP ownership | Separates environment enablement from product acceptance | live (cross-repo) |

## Out of scope for this repo

- Provider truth for CAP-01..CAP-06 / CTR-01..CTR-06 — **realworld-api**
- Consumer UAT chrome and kill-path driving UI — **realworld-web**
- Product field rules (registration uniqueness, tag normalization, nameplate editable set, feed ordering, favorite-on-missing, delete not-found) — locked via IM defaults into **api/web** specs (IM-01..IM-04, IM-06..IM-08)
- Comments, follows, personalized feeds, OAuth, who-favorited social proof
- Draft/moderation queues; password recovery; account deletion; admin tooling
- Multi-session logout cascade (OQ-05 / IM-05 deferred)
- Mid-read live push after delete (OQ-09 / IM-09 deferred)
- Mobile or native clients
- Standing up shared Postgres / `adh_local` itself (owned by shared infra / `adh-iac-local`)

## Cross-service contracts

Local does **not** own CTR-01..CTR-06 (provider=`realworld-api`, consumer=`realworld-web`). Those seams are specified in the api/web slices. This repo’s boundary is the compose join that makes those seams reachable for Wave0a live prove.

| Contract ID | Provider / owner | Consumer / owner | Entry point | Input shape | Output shape | Invariants | Errors | Compatibility / versioning | Contract-test location |
|-------------|------------------|------------------|-------------|-------------|--------------|------------|--------|----------------------------|------------------------|
| CTR-L01 | realworld-local / @drivestream-lab/platform-devs | Programme UAT observer (and downstream live-verify) | Join Wave0a prove stack | Shared infra ready (`adh_local` + Postgres with DB `realworld`); build contexts for sibling api/web checkouts | Host-reachable API + web endpoints with web API root bound to local API | Apps-only stack; no second Postgres/Redis/Buzz; host-side verify without `docker exec`; dependency order api → web → local | Missing `adh_local`; missing shared DB; unhealthy api/web; wrong API root | New Wave0a local join; breaking host URL / DB name changes require INIT revision | `scripts/verify.sh` (baseline); deeper CAP/J packs owned by api/web plans |

## Non-functional requirements

| Area | Requirement or N/A rationale | Acceptance / evidence |
|------|------------------------------|-----------------------|
| Security | N/A as product seat rule owner — seat fail-closed is api/web. Local must not weaken prove by pointing web at a non-local API root (REQ-04). Default local secrets are for local prove only. | inspection / verify |
| Reliability | N/A beyond fail-closed bring-up when shared infra is missing (REQ-07). Not a multi-region SLA INIT. | inspection / live |
| Performance / capacity | N/A for Wave0a UAT scale; no concurrent-load target locked. | N/A |
| Observability | N/A as product kill criterion; compose logs remain an engineering concern (`make logs`). | N/A for product acceptance |
| Privacy / data handling | N/A beyond using dedicated DB name `realworld` on shared Postgres; no product shelf/nameplate ownership here. | inspection |
| Migration / compatibility | Clean-slate Wave0a — no prior tenant corpus migration required in this repo. Existing compose is baseline enablement, not a guaranteed kill-path pass until api/web surfaces exist. | as-built / feasibility |
| Rollback / recovery | N/A as product REQ — `make down` / recreate is engineering recovery. | N/A |
| Operations / support | This repo **is** the intended live-prove environment (PRD §9). Documented up/verify/down entrypoints required (REQ-05, REQ-07). No 24×7 support envelope locked. | live / inspection |

## Assumptions

| ID | Assumption | Evidence | Owner | Status | Invalidated when |
|----|------------|----------|-------|--------|------------------|
| A-01 | Shared infra (`adh_local` + Postgres) is provided by `adh-iac-local` (or equivalent) before local up | README + compose `external: true` network; impact-map dependency notes | PE | confirmed (Wave0a default) | Local is required to own/bootstrap Postgres inside this compose |
| A-02 | Sibling checkouts `../realworld-api` and `../realworld-web` are the compose build contexts for Wave0a | Current `docker-compose.yml` build contexts | PE | open | Monorepo layout or image registry changes build source |
| A-03 | Documented host ports remain `3100` (api) and `3101` (web) for Wave0a UAT scripts | README + compose ports + `scripts/verify.sh` defaults | PE | confirmed (baseline) | Port map changes without updating verify/docs |
| A-04 | Host-side verify is black-box HTTP; deeper CAP/J live packs live under api/web test layouts | `scripts/verify.sh` header comment; layout-defaults `live_verify_dir` | PE | confirmed | Local is assigned product live-verify ownership |
| A-05 | IM-01..IM-04 and IM-06..IM-08 product defaults are applied in api/web specs; local does not re-decide them | Impact-map §10 Gate 1 note; sibling specs | PM | confirmed | Blocking IM reopened for local-owned product behavior (none today) |
| A-06 | As-built index is absent; current compose/Makefile/verify are existing baseline enablement | Source scan 2026-11-11; empty `docs/specification/as-built/` | PE | open | As-built index published with environment capability rows |

## Spec questions (ambiguities — need PM or domain confirmation before feasibility)

| ID | Lane | Question | Owner | Blocking | Required by | Default if deferred | Status | Resolution link |
|----|------|----------|-------|----------|-------------|---------------------|--------|-----------------|
| Q-01 | PM | Registration field/uniqueness set (OQ-01 / IM-01) | PM | no | feasibility (api/web) | Unique username + unique email + password; bio/image via nameplate | resolved (not local-owned) | Impact-Map IM-01 → api/web REQs |
| Q-02 | PM | Tag normalization limits (OQ-02 / IM-02) | PM | no | feasibility (api/web) | Free-form; reject blank; ≥1 non-blank tag | resolved (not local-owned) | Impact-Map IM-02 → api/web REQs |
| Q-03 | PM | Nameplate editable vs identity-locked (OQ-03 / IM-03) | PM | no | feasibility (api/web) | Bio/image editable; username/email locked | resolved (not local-owned) | Impact-Map IM-03 → api/web REQs |
| Q-04 | PM | Register-may-seat vs login-required (OQ-04 / IM-04) | PM | no | feasibility (api/web) | Eligibility only; login before contribution | resolved (not local-owned) | Impact-Map IM-04 → api/web REQs |
| Q-05 | PE | Multi-session logout cascade (OQ-05 / IM-05) | PE | no | later | Unseat logging-out session only | open | Impact-Map IM-05; not local-owned |
| Q-06 | PM | Global feed ordering (OQ-06 / IM-06) | PM | no | feasibility (api/web) | Newest-first by publish/update time | resolved (not local-owned) | Impact-Map IM-06 → api/web REQs |
| Q-07 | PM | Favorite missing/deleted article (OQ-07 / IM-07) | PM | no | feasibility (api/web) | Fail closed; shelf unchanged | resolved (not local-owned) | Impact-Map IM-07 → api/web REQs |
| Q-08 | PM | Guest open-by-reference after delete (OQ-08 / IM-08) | PM | no | feasibility (api/web) | Stable not-found; no prior body | resolved (not local-owned) | Impact-Map IM-08 → api/web REQs |
| Q-09 | PE | Mid-read refresh vs next navigation after delete (OQ-09 / IM-09) | PE | no | later | Next navigation / reopen sufficient | open | Impact-Map IM-09; not local-owned |
| Q-10 | PE | Whether local keeps sibling-path build contexts (`../realworld-api`, `../realworld-web`) vs published images for Wave0a | PE | no | technical review / plan | Keep sibling-path builds as today; document prerequisite checkout layout | open | Feasibility / technical review |
| Q-11 | PE | Whether host ports `3100`/`3101` are locked for external UAT scripts or may move behind a single proxy | PE | no | technical review / plan | Keep `3100`/`3101` + current verify defaults for Wave0a | open | Feasibility / technical review |

## Draft check summary (D1–D12)

| Check | Status | Evidence / findings |
|-------|--------|---------------------|
| D1 Approved handoff current | PASS | H1 digest matches PRD file (`sha256:cdc1f66d…`); H3 map_revision=1; H2 local scope digest `sha256:c771a5d6…`; G1 APPROVED review `commit_id` = meta PR #5 head `a500df8e…`; label `impact-map-lgtm`; repo affected not deferred/blocked |
| D1b No open blocking IM-* | PASS | Impact-map §10: no `Blocking: yes` open rows; product IM defaults routed to api/web; none block local environment REQs |
| D2 Complete PRD traceability | PASS | Local in-scope obligation (Lock 9 / Operations / impact-map local scope) mapped to REQ-01..REQ-08; CAP-01..CAP-06 explicitly out-of-repo N/A with owners |
| D2b Journeys carried | PASS | J-01..J-19 carried; kill-path journeys cited on REQ-08; others marked out-of-repo N/A |
| D3 Repo-bounded scope | PASS | Environment-only scope matches impact-map H2; api/web product ownership and non-goals listed under Out of scope |
| D4 Observable acceptance | PASS | Each REQ has condition/event, observable result, evidence layer; implementation-neutral (no Dockerfile/Makefile mandate as acceptance) |
| D5 Negative/failure paths | PASS | Table covers missing network/DB, wrong API root, docker-exec verify, scope creep, product vs environment failure split |
| D6 Assumptions/questions | PASS | Assumptions evidenced; questions have lane/owner/blocking/default/status; material PM defaults deferred to owning repos |
| D7 Cross-repository contracts | PASS | CTR-L01 compose-join seam; CTR-01..CTR-06 explicitly not owned here |
| D8 NFR applicability | PASS | All eight areas specified or N/A with reason |
| D9 As-built alignment | PASS | As-built index absent; source scan notes existing compose/Makefile/verify as baseline enablement vs Wave0a kill-path prove still depending on api/web product surfaces |
| D10 Dependency order | PASS | Matches impact-map: api → web → local; local depends on api+web |
| D11 Zero unresolved blockers | PASS | No blocking Q remaining; Q-05/Q-09/Q-10/Q-11 non-blocking with defaults |
| D12 Output completeness | PASS | Header H1–H3/G1, tables, check summary, outcome, PR readiness, handoff present |

**Draft verdict:** PASS

**Selected workflow outcome:** `pass`
**Outcome reason:** D1–D12 PASS, Gate 1 current, zero unresolved material questions, local environment REQs bounded to impact-map H2, PR READY for Forge publish.

Do not advance to `/initiative-feasibility` unless the workflow outcome is
`pass`, the draft verdict is PASS, and the developer review below is complete.

## PR readiness handoff

| Item | Value |
|------|-------|
| Workflow outcome | `pass` — D1–D12 PASS; Gate 1 current; local scope bounded to compose prove |
| Verdict | PR READY |
| Existing spec PR | none open (historical CLOSED: https://github.com/drivestream-lab/realworld-local/pull/1) |
| Proposed branch | `chore/INIT-REALWORLD-001-spec-realworld-local` |
| Proposed base | `develop` |
| Proposed title | `[INIT-REALWORLD-001] Spec — realworld-local` |
| PR type | **Draft** (entire spec lifecycle) |
| Local artifacts to publish | `docs/specification/product/INIT-REALWORLD-001-local.md`, `docs/specification/README.md` |
| Forge readiness | fill `handoff.forge` for `open_draft_pr`; recommend `/commit-workspace` then `/open-draft-pr` — do not commit/push/open PR inside this skill |
| Reviewer | @drivestream-lab/platform-devs |
| Initial Gate 2 label | `spec-pending` |
| Additional invalidation label | none |
| Blocking items | none |

**No GitHub side effects have occurred.** Persist the draft locally; Forge publish is a later `/commit-workspace` / `/open-draft-pr` or Gateflow ForgeClient step.

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

- 8 REQs covering Wave0a local compose prove join (adh_local + DB realworld + host-side verify)
- No product CAP ownership; CAP-01..CAP-06 / J-01..J-19 carried as out-of-repo N/A (api/web)
- Open non-blocking engineering questions: Q-05, Q-09, Q-10, Q-11

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
- Service profile: not present (`docs/specification/product/00-service-profile.md` absent)

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
    draft_verdict: PASS
    map_revision: 1
    meta_pr: https://github.com/drivestream-lab/realworld-meta/pull/5
    meta_pr_approved_head: a500df8eeefbea095ecdd65e00edb128416c3cf4
    prd_digest: sha256:cdc1f66d5cf4c1f12fd0f9ed8bf28d320d4aef941d6abbb0612f53886a1fcfb4
    scope_digest: sha256:c771a5d610f5872dc3a5fc06cfc9e406341840f964ae998a630d9fc5a3ea93d9
    open_non_blocking_questions:
      - Q-05
      - Q-09
      - Q-10
      - Q-11
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
