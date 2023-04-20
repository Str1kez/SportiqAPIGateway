.SILENT:

args := $(wordlist 2, 100, $(MAKECMDGOALS))

env:
	cp .env.example .env

up:
	docker compose up -d --remove-orphans

down:
	docker compose down
