#!/usr/bin/env bash
# Black-box verify against compose on the host. Never docker exec into the app.
set -euo pipefail

API="${REALWORLD_API_URL:-http://localhost:3100}"
WEB="${REALWORLD_WEB_URL:-http://localhost:3101}"

echo "verify api docs ${API}/docs"
curl -sf "${API}/docs" >/dev/null

echo "verify api articles ${API}/api/articles"
curl -sf "${API}/api/articles" | python3 -c 'import json,sys; body=json.load(sys.stdin); assert "articles" in body, body; print("  articles_count=", len(body.get("articles") or []))'

echo "verify api register"
email="g0-$(date +%s)@example.test"
payload=$(printf '{"user":{"username":"%s","email":"%s","password":"g0g0g0g0"}}' "g0user${RANDOM}" "$email")
curl -sf -X POST "${API}/api/users" \
  -H 'Content-Type: application/json' \
  -d "$payload" | python3 -c 'import json,sys; u=json.load(sys.stdin)["user"]; assert u.get("token"); print("  user=", u.get("username"))'

echo "verify web ${WEB}/"
html="$(curl -sf "${WEB}/")"
echo "$html" | grep -q '<div id="root">'

echo "verify OK (shared DB realworld via ${API})"
