# Implementation status (as-built index)

> Bootstrap index written during `/spec-draft` for INIT-REALWORLD-001 because no prior
> `docs/specification/` tree existed. Rows describe **current tree evidence**, not
> Wave0a acceptance.

| Capability / surface | Status | Evidence | Notes |
|----------------------|--------|----------|-------|
| Compose joins api + web on `adh_local` | present | `docker-compose.yml` | External network `adh_local`; ports `3100` (api), `3101` (web); DB URL `…/realworld` on hostname `postgres` |
| Build contexts | present | `docker-compose.yml` build `../realworld-api`, `../realworld-web` with `overlay/Dockerfile` | Local `docker/api.Dockerfile` and `docker/web.Dockerfile` exist but are **not** referenced by compose |
| Web API_ROOT bake | present | compose `args.API_ROOT: http://localhost:3100/api` | Matches web workspace local-API expectation |
| Host-side smoke verify | present | `scripts/verify.sh`, `make verify` | Hits `/docs`, `/api/articles`, register, and web `/`; does **not** drive full kill-path journeys |
| Infra prerequisite gate | present (partial) | `Makefile` `up` inspects `adh_local` | Fails if network missing; DB `realworld` creation is outside this repo (`adh-iac-local`) |
| Spec slice INIT-REALWORLD-001 | draft | `docs/specification/product/INIT-REALWORLD-001-local.md` | Not Forge-published / not wave-accepted |
| Product CAP implementation | N/A (other repos) | impact-map H2 | This repo enables prove; does not own CAP-01..CAP-06 |

Per-initiative detail: none yet (`Implementation-Status-INIT-REALWORLD-001.md` after waves).
