# Service profile — realworld-local

| Field | Value |
|-------|-------|
| Repo | `drivestream-lab/realworld-local` |
| Role | Wave0a **live-prove compose environment** joining `realworld-api` + `realworld-web` on shared `adh_local` / Postgres DB `realworld` |
| Profile | Apps-only compose; no second Postgres, no Redis, no Buzz; host-side `make verify` smoke against published ports |
| Providers / dependents | Builds and runs sibling `../realworld-api` and `../realworld-web`; depends on `adh-iac-local` infra (`adh_local` network + shared Postgres) |
| Source layout (as-found) | `docker-compose.yml`, `Makefile`, `scripts/verify.sh`, optional `docker/*.Dockerfile` (compose currently builds sibling `overlay/Dockerfile`) |

## Domain this repo owns

- Compose wiring that runs API + web together for Wave0a continuous UAT
- Host-reachable local endpoints for guest/member kill-path driving (web against API)
- Host-side black-box smoke that API and web are reachable on the compose surface
- Documented prerequisite that shared infra (`adh_local`, DB `realworld`) is up before `make up`

## Explicit non-ownership (other repos / non-goals)

- Bulletin / seat / shelf / nameplate product behavior and CTR-01..CTR-06 — `realworld-api` (provider) + `realworld-web` (consumer UAT)
- Product CAP-01..CAP-06 acceptance beyond **enabling** their live prove — impact-map scope: no product CAP ownership
- Comments, follow graphs, personalized feeds, OAuth, email verification, admin tooling — out of INIT-REALWORLD-001
