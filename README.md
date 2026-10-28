# realworld-local

Product compose for the RealWorld proof tenant. **Apps only.**

Joins the shared `adh_local` network and uses Postgres database `realworld` on `adh-postgres`. No second Postgres, no Buzz.

| Service | Port | Image |
| --- | --- | --- |
| api | `3100` | build `../realworld-api` |
| web | `3101` | build `../realworld-web` (API_ROOT `http://localhost:3100/api`) |

```bash
# from adh-iac-local
make infra-up

# from this repo
make up
make verify
make down
```

`make verify` is host-side HTTP against those URLs. It does not `docker exec` into the app.
