# realworld-local

Product compose for the RealWorld proof tenant. **Apps only.**

Joins the shared **`lab_local`** network from [dev-infra-lab](../dev-infra-lab) and uses Postgres database `realworld` on `lab-postgres` (Compose DNS: `postgres`). No second Postgres, no Buzz.

| Service | Port | Image |
| --- | --- | --- |
| api | `3100` | build `../realworld-api` |
| web | `3101` | build `../realworld-web` (API_ROOT `http://localhost:3100/api`) |

```bash
# from dev-infra-lab
make infra-up

# from this repo
make up
make verify
make down
```

`make verify` is host-side HTTP against those URLs. It does not `docker exec` into the app.
