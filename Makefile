.PHONY: up down logs ps verify

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
COMPOSE := docker compose -p realworld -f $(ROOT)docker-compose.yml
LAB_NETWORK := lab_local

up:
	@docker network inspect $(LAB_NETWORK) >/dev/null 2>&1 || { \
	  echo "ERROR: network $(LAB_NETWORK) missing. Start shared lab first:"; \
	  echo "  cd ../dev-infra-lab && make infra-up"; \
	  exit 1; \
	}
	$(COMPOSE) up -d --build
	$(COMPOSE) ps

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

verify:
	@bash "$(ROOT)scripts/verify.sh"
