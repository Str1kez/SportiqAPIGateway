.SILENT:

args := $(wordlist 2, 100, $(MAKECMDGOALS))

env:
	cp .env.example .env

up:
	docker compose up -d --remove-orphans

down:
	docker compose down

sh:
	docker exec -it api_gateway sh

reload:
	docker exec -it api_gateway openresty -s reload
