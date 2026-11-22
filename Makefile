SHELL := /usr/bin/env bash

PROFILE ?= cli-memory
VARS_FILE := ansible/vars/$(PROFILE).yml
INVENTORY_FILE := ansible/inventory.ini
PLAYBOOK := ansible/compose-build.yml
GENERATED_COMPOSE := ansible/.generated/docker-compose.yml
ENV_FILE := .env

.PHONY: help build up down ps logs clean

help:
	@echo "Текущий профиль (PROFILE): $(PROFILE)"
	@echo ""
	@echo "Команды:"
	@echo "  make build [PROFILE=...]   — сгенерировать compose и забилдить образы через Ansible"
	@echo "  make up [PROFILE=...]      — забилдить и поднять сервисы"
	@echo "  make down [PROFILE=...]    — остановить и удалить контейнеры"
	@echo "  make ps [PROFILE=...]      — показать статус контейнеров"
	@echo "  make logs [PROFILE=...]    — смотреть логи"
	@echo "  make clean                 — удалить сгенерированные файлы Ansible"

build:
	@test -f "$(VARS_FILE)" || (echo "Файл переменных не найден: $(VARS_FILE)" && exit 1)
	@ansible-playbook "$(PLAYBOOK)" -i "$(INVENTORY_FILE)" -e "@$(VARS_FILE)"

up:
	@test -f "$(VARS_FILE)" || (echo "Файл переменных не найден: $(VARS_FILE)" && exit 1)
	@test -f "$(ENV_FILE)" || cp .env.example "$(ENV_FILE)"
	@docker compose --env-file .env -f "$(GENERATED_COMPOSE)" up -d --build

down:
	@test -f "$(GENERATED_COMPOSE)" && docker compose -f "$(GENERATED_COMPOSE)" down || true

ps:
	@test -f "$(GENERATED_COMPOSE)" && docker compose -f "$(GENERATED_COMPOSE)" ps || true

logs:
	@test -f "$(GENERATED_COMPOSE)" && docker compose -f "$(GENERATED_COMPOSE)" logs -f || true

clean:
	@rm -rf ansible/.generated