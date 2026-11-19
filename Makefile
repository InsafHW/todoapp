include .env
export

export PROJECT_ROOT=$(shell pwd)

.PHONY: env-up env-down migrate-create migrate-action migrate-up migrate-down env-port-forward-up env-port-forward-close

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres

env-port-forward-up:
	@docker compose up -d port-forwarder

env-port-forward-close:
	@docker compose down port-forwarder

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Parameter seq is missing"; \
		exit 1; \
	fi
	@docker compose run --rm --user "$$(id -u):$$(id -g)" todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Parameter action is missing"; \
		exit 1; \
	fi
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database "postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@todoapp-postgres:5432/$(POSTGRES_DB)?sslmode=disable" \
		$(action)

migrate-up:
	@make migrate-action action=up

migrate-down:
	@make migrate-action action=down