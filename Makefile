.PHONY: up down logs ps verify

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
COMPOSE := docker compose -p realworld -f $(ROOT)docker-compose.yml

up:
	@docker network inspect adh_local >/dev/null
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
