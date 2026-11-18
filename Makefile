include .env
export

export PROJECT_ROOT=$(shell pwd)

.PHONY: env-up env-down migrate-create

env-up:
	docker compose up -d todoapp-postgres

env-down:
	docker compose down todoapp-postgres

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Parameter seq is missing"; \
		exit 1; \
	fi
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"