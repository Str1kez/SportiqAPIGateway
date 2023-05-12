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

build:
	docker build . -t api-gateway:latest

reload:
	docker exec -it api_gateway openresty -s reload

ssl:
	openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./ssl/nginx.key -out ./ssl/nginx.crt
