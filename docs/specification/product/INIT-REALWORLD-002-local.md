# INIT-REALWORLD-002 — spec slice for realworld-local

| Field | Value |
|-------|-------|
| Initiative | INIT-REALWORLD-002 |
| PRD | `realworld-meta/prd/INIT-REALWORLD-002.md` |
| PRD digest (H1) | `sha256:5a9b49dd102202262edca3cb3d2bf315f43782884372d945be9274124b974c92` |
| Meta PR | https://github.com/drivestream-lab/realworld-meta/pull/8 |
| Meta PR approved head (G1) | `ee9fe45ad23d988eface7517a3a65a7b58b592c1` |
| Impact map | `realworld-meta/prd/reports/Impact-Map-INIT-REALWORLD-002.md` |
| Impact-map revision (H3) | `1` |
| Repo scope digest (H2) | `sha256:a43cf05dc8d4ddacef6d61c97b0efe2a7dad7ebe1ed7bbd4060ea5ebf7a1a358` |
| Tech-lead approval | Review `PRR_kwDOVac9Rs8AAAABXAtAcQ` / id `5839208561` by `adh-reviewer[bot]` (Gate‑1 attestation by adh.pe), APPROVED at `2026-11-10T08:58:03Z`; `commit_id` = `ee9fe45ad23d988eface7517a3a65a7b58b592c1` (matches merged meta PR #8 head; label `impact-map-lgtm`) |
| Repo | drivestream-lab/realworld-local |
| Date | 2026-11-12 |
| Status | Draft — dev review required before Forge publish |

> **H4 citations:** The H1–H3 (and G1) rows above are the durable authority
> carrier for mid-lane freshness. Feas / TDD / plan digests are walk-time only
> and may be purged at initiative closure — see
> `prayog-skills/references/artifact-write-contract.md`.

## Overview

`realworld-local` is the **live-prove compose environment** for INIT-REALWORLD-002: it joins `realworld-api` and `realworld-web` on the shared `adh_local` network against Postgres database `realworld`, so continuous UAT can demonstrate author-subscription trust and denial-honest empty kill paths on web against API (impact-map local scope; PRD §1 kill assumption).

**Out of this repo:** Product CAP/REQ ownership for ungated public discovery, seat-bound author subscription, denial-honest empties, and subscription-stream lifecycle (`realworld-api` provider; `realworld-web` consumer UAT chrome); follower/following counts as social proof; comments; OAuth; email verification; mobile/native clients; composed subscription∩tag surfaces; reopening INIT-REALWORLD-001 seat/publish/favorites/nameplate rules.

**Ownership:** this spec states observable local-prove environment behavior only (compose join, documented host endpoints, host-side smoke verify, documented infra prerequisite). Implementation architecture (compose file layout, Dockerfile choice, Makefile targets) is **not** decided here — routed to feasibility / technical review.

## Functional requirements

| ID | Requirement | PRD source | Condition / event | Observable result | Evidence layer |
|----|-------------|-----------|-------------------|-------------------|----------------|
| REQ-01 | Join api and web as a single local prove stack on the shared `adh_local` network | Impact-map local scope; PRD Lock 1 programme note (compose join for later eng waves); dependency order §7 | Operator brings the local prove stack up after shared infra is available | Both api and web containers are part of the same compose project and attached to external network `adh_local` | inspection / live |
| REQ-02 | Persist tenant data via shared Postgres database `realworld` (no second Postgres in this stack) | Impact-map local scope (“adh_local/DB realworld”) | Operator brings the stack up with shared Postgres already running on `adh_local` | Api is configured to use database `realworld` on the shared Postgres host; compose does not start a second Postgres service | inspection |
| REQ-03 | Expose the API on the documented host prove port | Impact-map local scope; continuous UAT enablement | Stack is up | Host can reach the API at the documented local URL (baseline: `http://localhost:3100`) | live / `scripts/verify.sh` |
| REQ-04 | Expose the web UAT surface on the documented host prove port, bound to the local API | Impact-map local scope; web-against-API prove | Stack is up | Host can reach the web client at the documented local URL (baseline: `http://localhost:3101`); web is built/configured so its API root targets the local API prove URL (baseline: `http://localhost:3100/api`) | live / `scripts/verify.sh` |
| REQ-05 | Provide a host-side smoke verify that confirms api+web readiness without entering app containers | Impact-map local scope; continuous UAT enablement | Operator runs the documented verify entrypoint with the stack up | Verify succeeds only when API docs/articles (and a minimal register smoke) and web root are reachable from the host; it does not `docker exec` into app containers | live / inspection (`scripts/verify.sh`) |
| REQ-06 | Keep the local stack limited to apps-only RealWorld prove services | PRD non-goals; impact-map local scope | Operator inspects compose services | Compose does not introduce Redis, Buzz, or a second Postgres; only the api+web apps required for subscription / denial-honest empty prove | inspection |
| REQ-07 | Document and enforce the shared-infra prerequisite for bring-up | Impact-map dependency order (api → web → local) | Operator attempts bring-up without `adh_local` / shared Postgres ready | Bring-up fails closed or is blocked until `adh_local` exists; docs state that shared infra (`adh-iac-local` / `make infra-up`) must precede local up | inspection / live |
| REQ-08 | Enable continuous UAT of author-subscription and denial-honest empty kill paths on the joined stack | PRD §1 kill assumption; CAP-01..CAP-04; impact-map local scope | Shared infra + local stack are up; api and web subscription / discovery surfaces exist | Guest ungated public discovery, seated subscribe/unsubscribe with viewer-relative state, empty subscription stream without silent global fill, fail-closed unseated/self/missing denials, stream lifecycle (publish-in/delete-out), and stream privacy are demonstrable against this local join (product behavior owned by api/web; local supplies the reachable prove environment) | live (CAP-01..CAP-04; J-01, J-04, J-05, J-07, J-08, J-10, J-11, J-12, J-13, J-15, J-16) — environment evidence; product REQs owned by api/web |

> **Id convention:** `REQ-*` is canonical. Legacy display alias `FR-{nn}` ≡ `REQ-{nn}` — prefer `REQ-*`.
>
> **Behavioral acceptance vs evidence:** Condition/event + observable result are
> the product acceptance statement (implementation-neutral). Evidence layer
> names how it will be proved later. Live evidence cites `CAP-*` and/or `J-*`
> when this repo’s REQs enable those prove rungs.

## Capabilities (carried from PRD)

| ID | Capability | Journeys | Notes |
|----|------------|----------|-------|
| CAP-01 | Ungated unpersonalized public discovery | J-01, J-02, J-03, J-09, J-10, J-14 | **Out of repo** — owned by realworld-api (provider) + realworld-web (UAT). Local enables prove host reachability only. |
| CAP-02 | Seat-bound author-subscription stewardship | J-04, J-06, J-07, J-10, J-12, J-13 | **Out of repo** — api/web. Local enables joined prove environment. |
| CAP-03 | Denial-honest empties and fail-closed outcomes | J-07, J-08, J-10, J-12, J-15 | **Out of repo** — api/web. Kill-path prove enabled by REQ-08. |
| CAP-04 | Subscription-stream lifecycle honesty | J-05, J-06, J-08, J-11, J-14, J-15, J-16 | **Out of repo** — api/web. Kill-path prove enabled by REQ-08. |

> Impact-map: this repo has **no product CAP ownership** beyond enabling continuous UAT of author-subscription and denial-honest empty kill paths.

## Journeys (carried from PRD)

| ID | Actor | Trigger | Main flow | Primary edge | Abandon | Caps |
|----|-------|---------|-----------|--------------|---------|------|
| J-01 | Guest | Wants public articles without signing in | Opens public listing → opens a published article when present → reads | Empty listing → still ungated | Leaves without registering | CAP-01 — kill-path prove enabled by REQ-08 |
| J-02 | Guest | Explores topics | Opens tag catalog/lane → scans → opens a matching article when present | Empty lane for that tag only | Leaves tags | CAP-01 — out-of-repo N/A |
| J-03 | Seated member | Checks unpersonalized global listing | Opens global article listing → confirms membership is not subscription-filtered | Empty global listing still readable | Leaves listing | CAP-01 — out-of-repo N/A |
| J-04 | Seated member | Builds / clears a subscription | Opens an author’s public presentation → subscribes → sees subscription state true → unsubscribes → sees false | Self-subscribe attempt → refused (enters J-07) | Cancels without subscribe | CAP-02 — kill-path prove enabled by REQ-08 |
| J-05 | Seated member | Uses the subscription stream | Subscribes to an author who has published articles → opens subscription stream → opens one such article | If author has no articles → empty stream (J-08) | Unsubscribes (enters J-06) | CAP-04 — kill-path prove enabled by REQ-08 |
| J-06 | Seated member | Proves stream honesty after unsubscribe | Unsubscribes from an author → subscription state false → stream loses that author’s articles → global listing unchanged by unsubscribe alone | Last unsubscribe → empty stream | N/A — unsubscribe is the act | CAP-04, CAP-02 — out-of-repo N/A |
| J-07 | Seated member | Attempts self-subscribe | Tries to subscribe to own author identity | Graph unchanged; denial observed | Returns to other authors | CAP-03, CAP-02 — kill-path prove enabled by REQ-08 |
| J-08 | Seated member | Opens stream with nothing to show | Subscribes to zero authors (or subscribed authors silent) → opens subscription stream | Empty state; must not silently show global membership; not an error wall | Switches to global listing | CAP-03, CAP-04 — kill-path prove enabled by REQ-08 |
| J-09 | Guest | Sees subscribe affordance while browsing | Views public author/article surface that offers subscribe to seated actors → continues public discovery without authenticating | If Guest tries subscribe → denied (J-10) | Leaves | CAP-01 — out-of-repo N/A |
| J-10 | Seated → Guest | Unseats after using subscriptions | Subscribes to someone → logs out → completes public listing/open as Guest → attempts subscribe/unsubscribe | Public discovery works; mutations fail closed | Reseats (J-13) | CAP-01, CAP-03, CAP-02 — kill-path prove enabled by REQ-08 |
| J-11 | Author + Subscriber | Subscribed author publishes | Subscriber already subscribes to Author → Author publishes new tagged article → Subscriber opens subscription stream | New article in stream; public/tag update as ungated discovery for all readers | Subscriber unsubscribes first | CAP-04 — kill-path prove enabled by REQ-08 |
| J-12 | Seated member | Targets a missing author | Attempts subscribe on unknown author identity | Fail closed; graph unchanged (IM-03 / OQ-03 default) | Returns to known authors | CAP-03 — kill-path prove enabled by REQ-08 |
| J-13 | Seated member | Proves subscription persistence across reseat | Subscribes to an author → logs out → logs in → checks subscription state (and stream if author has articles) | State still subscribed; mutations were denied while unseated | Abandons reseat | CAP-02 — kill-path prove enabled by REQ-08 |
| J-14 | Seated member | Proves public/tag stay unpersonalized under churn | Subscribes/unsubscribes while checking public listing, global listing, and a tag lane | Memberships unchanged by subscriptions alone | Stops probing | CAP-01, CAP-04 — out-of-repo N/A |
| J-15 | Guest + Peer | Prove stream privacy | Guest (and/or a peer who is not the subscriber) attempts to treat Member A’s subscription stream as public discovery | A’s stream membership is not revealed as public truth; Guest stays on ungated public discovery | Stops probing | CAP-04, CAP-03 — kill-path prove enabled by REQ-08 |
| J-16 | Author + Subscriber | Subscribed author deletes | Subscriber already has Author’s article in stream → Author deletes that article → Subscriber opens subscription stream | Article gone from stream; Guest open-by-reference not-found | Subscriber unsubscribes first | CAP-04 — kill-path prove enabled by REQ-08 |

## Negative and failure paths

| REQ | Condition | Required behavior | Why it matters | Evidence |
|-----|-----------|-------------------|----------------|----------|
| REQ-01 / REQ-07 | `adh_local` network missing | Bring-up fails closed / blocked; stack does not silently create a substitute private network that orphans shared Postgres | Prevents “green” compose that cannot reach shared DB | live / inspection |
| REQ-02 | Shared Postgres / DB `realworld` unavailable | Api does not become a healthy prove target; verify must not pass against a phantom stack | Subscription UAT needs durable tenant DB for edges + stream | live |
| REQ-03 / REQ-04 | Api or web not published on documented host ports | Host-side verify fails; UAT observer cannot drive kill paths | Prove is host-reachable web-against-API | live (`scripts/verify.sh`) |
| REQ-04 | Web API root still points at a third-party demo host | Local prove is invalid even if web HTML loads | Prevents false pass against external Conduit | inspection / live |
| REQ-05 | Verify implemented via `docker exec` into app | Violates host-side black-box rule | Keeps prove aligned with UAT observer surface | inspection |
| REQ-06 | Extra Redis / Buzz / second Postgres added “for convenience” | Out of local scope; expands ops surface without INIT authority | Keeps local apps-only | inspection |
| REQ-08 | Stack up but api/web product surfaces missing subscription / denial-honest kill paths | Environment REQs may pass while product kill paths fail — product failure belongs to api/web specs, not to local CAP ownership | Separates environment enablement from product acceptance | live (cross-repo) |

## Out of scope for this repo

- Provider truth for CAP-01..CAP-04 / CTR-01..CTR-04 — **realworld-api**
- Consumer UAT chrome and kill-path driving UI — **realworld-web**
- Product field rules (follower/following counts, listing/stream ordering, missing-author denial shape, unknown-tag empty vs not-found, Guest observation of subscription state, self-subscribe chrome, composed subscription∩tag) — locked via IM defaults into **api/web** specs (IM-01..IM-05, IM-08..IM-09)
- Comments; OAuth / third-party identity; email verification gates; mobile/native clients
- Reopening INIT-REALWORLD-001 publish / seat / favorites / nameplate requirement sets
- Mid-view push without re-open for last-unsubscribe empty chrome or delete-out (OQ-06 / IM-06, OQ-11 / IM-11 deferred)
- Clarification-round counting process (OQ-07 / IM-07) — programme process, not local
- Standing up shared Postgres / `adh_local` itself (owned by shared infra / `adh-iac-local`)

## Cross-service contracts

Local does **not** own CTR-01..CTR-04 (provider=`realworld-api`, consumer=`realworld-web`). Those seams are specified in the api/web slices. This repo’s boundary is the compose join that makes those seams reachable for live prove of author-subscription and denial-honest empties.

| Contract ID | Provider / owner | Consumer / owner | Entry point | Input shape | Output shape | Invariants | Errors | Compatibility / versioning | Contract-test location |
|-------------|------------------|------------------|-------------|-------------|--------------|------------|--------|----------------------------|------------------------|
| CTR-L01 | realworld-local / @drivestream-lab/platform-devs | Programme UAT observer (and downstream live-verify) | Join INIT-002 prove stack | Shared infra ready (`adh_local` + Postgres with DB `realworld`); build contexts for sibling api/web checkouts | Host-reachable API + web endpoints with web API root bound to local API | Apps-only stack; no second Postgres/Redis/Buzz; host-side verify without `docker exec`; dependency order api → web → local | Missing `adh_local`; missing shared DB; unhealthy api/web; wrong API root | Additive on Wave0a local join from INIT-001; breaking host URL / DB name changes require INIT revision | `scripts/verify.sh` (baseline); deeper CAP/J packs owned by api/web plans |

## Non-functional requirements

| Area | Requirement or N/A rationale | Acceptance / evidence |
|------|------------------------------|-----------------------|
| Security | N/A as product seat/subscription rule owner — fail-closed subscribe denials are api/web. Local must not weaken prove by pointing web at a non-local API root (REQ-04). Default local secrets are for local prove only. | inspection / verify |
| Reliability | N/A beyond fail-closed bring-up when shared infra is missing (REQ-07). Not a multi-region SLA INIT. | inspection / live |
| Performance / capacity | N/A for local UAT scale; no concurrent-load target locked (PRD §9). | N/A |
| Observability | N/A as product kill criterion; compose logs remain an engineering concern (`make logs`). Buzz/coach signal is programme process, not a CAP. | N/A for product acceptance |
| Privacy / data handling | N/A beyond using dedicated DB name `realworld` on shared Postgres; no product stream-privacy ownership here (REQ-19 owned by api/web). | inspection |
| Migration / compatibility | Builds on INIT-REALWORLD-001 clean-slate corpus; local join remains the same adh_local/DB realworld baseline. Subscriptions are additive social state owned by api — local does not migrate corpus. | as-built / feasibility |
| Rollback / recovery | N/A as product REQ — `make down` / recreate is engineering recovery. | N/A |
| Operations / support | This repo **is** the intended live-prove environment for eng waves after the meta product lane. Documented up/verify/down entrypoints required (REQ-05, REQ-07). No 24×7 support envelope locked. | live / inspection |

## Assumptions

| ID | Assumption | Evidence | Owner | Status | Invalidated when |
|----|------------|----------|-------|--------|------------------|
| A-01 | Shared infra (`adh_local` + Postgres) is provided by `adh-iac-local` (or equivalent) before local up | README + compose `external: true` network; impact-map dependency notes | PE | confirmed (Wave0a default) | Local is required to own/bootstrap Postgres inside this compose |
| A-02 | Sibling checkouts `../realworld-api` and `../realworld-web` are the compose build contexts | Current `docker-compose.yml` build contexts | PE | open | Monorepo layout or image registry changes build source |
| A-03 | Documented host ports remain `3100` (api) and `3101` (web) for UAT scripts | README + compose ports + `scripts/verify.sh` defaults | PE | confirmed (baseline) | Port map changes without updating verify/docs |
| A-04 | Host-side verify is black-box HTTP; deeper CAP/J live packs live under api/web test layouts | `scripts/verify.sh` header comment; layout-defaults `live_verify_dir` | PE | confirmed | Local is assigned product live-verify ownership |
| A-05 | IM-01..IM-05 and IM-08..IM-09 product defaults are applied in api/web specs; local does not re-decide them | Impact-map §10 Gate 1 note; Hermes non-interactive lock of deferred defaults | PM | confirmed | Blocking IM reopened for local-owned product behavior (none today) |
| A-06 | As-built index is absent; current compose/Makefile/verify are existing baseline enablement from INIT-001 | Source scan 2026-11-12; empty `docs/specification/as-built/` | PE | open | As-built index published with environment capability rows |
| A-07 | INIT-REALWORLD-001 local join REQs remain the environment baseline; this INIT adds kill-path prove obligation for subscription / denial-honest empties without changing host ports or DB name | Sibling INIT-001-local spec; impact-map H2 for 002 | PE | confirmed | Lead requires a separate prove stack for subscription |

## Spec questions (ambiguities — need PM or domain confirmation before feasibility)

| ID | Lane | Question | Owner | Blocking | Required by | Default if deferred | Status | Resolution link |
|----|------|----------|-------|----------|-------------|---------------------|--------|-----------------|
| Q-01 | PM | Public follower/following counts vs viewer-relative boolean only (OQ-01 / IM-01) | PM | no | feasibility (api/web) | Boolean subscription state only; counts out of scope | resolved (not local-owned) | Impact-Map IM-01 → api/web REQs |
| Q-02 | PM | Ordering rule for global listing vs subscription stream (OQ-02 / IM-02) | PM | no | feasibility (api/web) | Newest-first by same publish/update time rule as INIT-001 OQ-06 default | resolved (not local-owned) | Impact-Map IM-02 → api/web REQs |
| Q-03 | PM | Subscribe/unsubscribe targeting missing or deactivated author (OQ-03 / IM-03) | PM | no | feasibility (api/web) | Fail closed; subscription graph unchanged (REQ-12) | resolved (not local-owned) | Impact-Map IM-03 → api/web REQs |
| Q-04 | PM | Unknown tag: empty lane vs distinct not-found (OQ-04 / IM-04) | PM | no | feasibility (api/web) | Empty lane for unknown/blank-normalized tags | resolved (not local-owned) | Impact-Map IM-04 → api/web REQs |
| Q-05 | PM | Guest observation of another viewer’s subscription state on public profiles (OQ-05 / IM-05) | PM | no | feasibility (api/web) | Omit seated-only subscription state for Guest; show subscribe affordance without gating public discovery | resolved (not local-owned) | Impact-Map IM-05 → api/web REQs |
| Q-06 | PE | Last-unsubscribe empty-stream chrome without re-open (OQ-06 / IM-06) | PE | no | later | Same visit after re-check/re-open is enough | open | Impact-Map IM-06; not local-owned |
| Q-07 | PM | Clarification rounds counted per CTR vs per product PR thread (OQ-07 / IM-07) | PM | no | later | Per product PR conversation; ≤2 rounds total | open | Impact-Map IM-07; programme process — not local-owned |
| Q-08 | PM | Composed subscription ∩ tag surface (OQ-08 / IM-08) | PM | no | feasibility (api/web) | Separate surfaces only; no composed third surface | resolved (not local-owned) | Impact-Map IM-08 → api/web REQs |
| Q-09 | PM | Own-author self-subscribe affordance chrome (OQ-09 / IM-09) | PM | no | feasibility (api/web) | No successful self-subscribe path; hide or disable both fine if REQ-10 holds | resolved (not local-owned) | Impact-Map IM-09 → api/web REQs |
| Q-10 | PE | Already-subscribed subscribe attempt distinguishability (OQ-10 / IM-10) | PE | no | later | Both leave state subscribed; no error required if graph unchanged | open | Impact-Map IM-10; not local-owned |
| Q-11 | PE | Subscription-stream delete-out same-visit without re-open (OQ-11 / IM-11) | PE | no | later | Next open of the stream after delete is enough | open | Impact-Map IM-11; not local-owned |
| Q-12 | PE | Whether local keeps sibling-path build contexts (`../realworld-api`, `../realworld-web`) vs published images for INIT-002 prove | PE | no | technical review / plan | Keep sibling-path builds as today; document prerequisite checkout layout | open | Feasibility / technical review |
| Q-13 | PE | Whether host ports `3100`/`3101` remain locked for external UAT scripts or may move behind a single proxy | PE | no | technical review / plan | Keep `3100`/`3101` + current verify defaults | open | Feasibility / technical review |

## Draft check summary (D1–D12)

| Check | Status | Evidence / findings |
|-------|--------|---------------------|
| D1 Approved handoff current | PASS | H1 digest matches PRD file (`sha256:5a9b49dd…`); H3 map_revision=1; H2 local scope digest `sha256:a43cf05d…`; G1 APPROVED review `commit_id` = meta PR #8 head `ee9fe45a…`; label `impact-map-lgtm`; repo affected not deferred/blocked |
| D1b No open blocking IM-* | PASS | Impact-map §10: no `Blocking: yes` open rows; Gate 1 note allows consuming IM-01..IM-05 and IM-08..IM-09 defaults; none block local environment REQs |
| D2 Complete PRD traceability | PASS | Local in-scope obligation (impact-map local scope / kill-path enablement) mapped to REQ-01..REQ-08; CAP-01..CAP-04 explicitly out-of-repo N/A with owners |
| D2b Journeys carried | PASS | J-01..J-16 carried; kill-path journeys cited on REQ-08; others marked out-of-repo N/A |
| D3 Repo-bounded scope | PASS | Environment-only scope matches impact-map H2; api/web product ownership and non-goals listed under Out of scope |
| D4 Observable acceptance | PASS | Each REQ has condition/event, observable result, evidence layer; implementation-neutral (no Dockerfile/Makefile mandate as acceptance) |
| D5 Negative/failure paths | PASS | Table covers missing network/DB, wrong API root, docker-exec verify, scope creep, product vs environment failure split |
| D6 Assumptions/questions | PASS | Assumptions evidenced; questions have lane/owner/blocking/default/status; material PM defaults locked from IM into owning repos |
| D7 Cross-repository contracts | PASS | CTR-L01 compose-join seam; CTR-01..CTR-04 explicitly not owned here |
| D8 NFR applicability | PASS | All eight areas specified or N/A with reason |
| D9 As-built alignment | PASS | As-built index absent; source scan notes existing compose/Makefile/verify as baseline enablement vs INIT-002 kill-path prove still depending on api/web product surfaces |
| D10 Dependency order | PASS | Matches impact-map: api → web → local; local depends on api+web |
| D11 Zero unresolved blockers | PASS | No blocking Q remaining; Q-06/Q-07/Q-10..Q-13 non-blocking with defaults |
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
| Existing spec PR | none |
| Proposed branch | `chore/INIT-REALWORLD-002-spec-realworld-local` |
| Proposed base | `develop` |
| Proposed title | `[INIT-REALWORLD-002] Spec — realworld-local` |
| PR type | **Draft** (entire spec lifecycle) |
| Local artifacts to publish | `docs/specification/product/INIT-REALWORLD-002-local.md`, `docs/specification/README.md`, `docs/specification/reports/Spec-PR-Body-INIT-REALWORLD-002-realworld-local.md` |
| Forge readiness | fill `handoff.forge` for `open_draft_pr`; recommend `/commit-workspace` then `/open-draft-pr` — do not commit/push/open PR inside this skill |
| Reviewer | @drivestream-lab/platform-devs |
| Initial Gate 2 label | `spec-pending` |
| Additional invalidation label | none |
| Blocking items | none |

**No GitHub side effects have occurred.** Persist the draft locally; Forge publish is a later `/commit-workspace` / `/open-draft-pr` or Gateflow ForgeClient step.

### Proposed Draft PR body

```markdown
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

- PRD: `realworld-meta/prd/INIT-REALWORLD-002.md`
- Meta PRD PR: https://github.com/drivestream-lab/realworld-meta/pull/8
- Spec PR: pending
- Service profile: not present (`docs/specification/product/00-service-profile.md` absent)

```yaml
handoff:
  contract: sdd-delivery/v2
  stage: spec-draft
  outcome: pass
  artifact:
    path: docs/specification/product/INIT-REALWORLD-002-local.md
  blockers: []
  signals:
    pr_ready: true
    draft_verdict: PASS
    map_revision: 1
    meta_pr: https://github.com/drivestream-lab/realworld-meta/pull/8
    meta_pr_approved_head: ee9fe45ad23d988eface7517a3a65a7b58b592c1
    prd_digest: sha256:5a9b49dd102202262edca3cb3d2bf315f43782884372d945be9274124b974c92
    scope_digest: sha256:a43cf05dc8d4ddacef6d61c97b0efe2a7dad7ebe1ed7bbd4060ea5ebf7a1a358
    open_non_blocking_questions:
      - Q-06
      - Q-07
      - Q-10
      - Q-11
      - Q-12
      - Q-13
  next_candidates:
    - spec-pr-action
  human_checkpoint: false
  external_action: true
  forge:
    action: open_draft_pr
    draft: true
    apply_labels:
      - spec-pending
    title: "[INIT-REALWORLD-002] Spec — realworld-local"
    body_path: docs/specification/reports/Spec-PR-Body-INIT-REALWORLD-002-realworld-local.md
```
