.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

# -------------------------------------------------------------------------------------
# Configuration
# -------------------------------------------------------------------------------------
DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
VERSION_FILE := $(DIR)/version.txt

# App version read from local version.txt (created by set-version or deploy)
VERSION ?= $(shell [ -f $(VERSION_FILE) ] && cat $(VERSION_FILE) || echo latest)

# VPS connection settings (override via: make <target> VAR=value)
VPS_USER ?= ocrusr
VPS_HOST ?= vps.exampleapp.com
VPS_PORT ?= 22
VPS_DIR  ?= ~/exampleapp_start
SSH_KEY  ?= ~/.ssh/id_rsa_$(VPS_USER)_$(VPS_HOST)

# Optional username for server user creation (script can also infer per distro)
NEW_USER ?=

# Docker Compose file path
COMPOSE_FILE := $(DIR)/docker-compose.yml

# -------------------------------------------------------------------------------------
# Utility
# -------------------------------------------------------------------------------------
print-config:
	@echo "Directory       : $(DIR)"
	@echo "Version file    : $(VERSION_FILE)"
	@echo "VERSION         : $(VERSION)"
	@echo "VPS_USER        : $(VPS_USER)"
	@echo "VPS_HOST        : $(VPS_HOST)"
	@echo "VPS_PORT        : $(VPS_PORT)"
	@echo "VPS_DIR         : $(VPS_DIR)"
	@echo "SSH_KEY         : $(SSH_KEY)"
	@echo "NEW_USER        : $(NEW_USER)"

# -------------------------------------------------------------------------------------
# Version management
# -------------------------------------------------------------------------------------
set-version:
	@if [ -z "$(VERSION)" ] || [ "$(VERSION)" = "latest" ]; then \
		echo "Usage: make set-version VERSION=x.y.z" ; \
		exit 1 ; \
	fi
	@echo "$(VERSION)" > $(VERSION_FILE)
	@echo "Set version to $(VERSION) in $(VERSION_FILE)"

show-version:
	@echo "Current version: $(VERSION)"

clean-version:
	@rm -f $(VERSION_FILE)
	@echo "Removed $(VERSION_FILE)"

# -------------------------------------------------------------------------------------
# SSH keys and server user provisioning
# -------------------------------------------------------------------------------------
ssh-key:
	@cd $(DIR) && bash ./generate_client_private_key.sh "$(VPS_USER)" "$(VPS_HOST)"

users-create:
	@cd $(DIR) && bash ./create_server_users_and_groups.sh $(NEW_USER)

# -------------------------------------------------------------------------------------
# Local docker-compose control (intended to be run on the VPS)
# -------------------------------------------------------------------------------------
up:
	@cd $(DIR) && bash ./run-server-containers.sh

down:
	@cd $(DIR) && bash ./run-server-containers.sh down

restart:
	$(MAKE) down
	$(MAKE) up

logs:
	@cd $(DIR) && { docker compose -f $(COMPOSE_FILE) logs -f || docker-compose -f $(COMPOSE_FILE) logs -f; }

ps:
	@docker ps

# Free-form docker-compose command: make compose CMD="pull"
compose:
	@if [ -z "$(CMD)" ]; then echo "Usage: make compose CMD=\"<docker-compose args>\"" ; exit 1 ; fi
	@cd $(DIR) && { docker compose -f $(COMPOSE_FILE) $(CMD) || docker-compose -f $(COMPOSE_FILE) $(CMD); }

# -------------------------------------------------------------------------------------
# Deploy to VPS (rsync files and restart remotely)
# -------------------------------------------------------------------------------------
deploy:
	@cd $(DIR) && bash ./deploy_to_vps.sh "$(VERSION)" "$(VPS_USER)" "$(VPS_HOST)" "$(VPS_PORT)" "$(SSH_KEY)" "$(VPS_DIR)"

# Recreate .env from k8/.env (same logic used by deploy)
generate-env:
	@cd $(DIR) ; \
	if [ -f "$(DIR)/../k8/.env" ]; then \
		set -o allexport; . "$(DIR)/../k8/.env" ; set +o allexport ; \
		echo "APP_REACT_APP_API_URL=$$APP_BACKEND_PUBLIC_URL:$$APP_BACKEND_PORT" > .env ; \
		echo "APP_DB_URI=$$APP_DB_URI" >> .env ; \
		echo "APP_SECRET_KEY=$$APP_SECRET_KEY" >> .env ; \
		echo "Generated $(DIR)/.env from k8/.env" ; \
	else \
		echo "File not found: $(DIR)/../k8/.env" ; \
		exit 1 ; \
	fi

clean:
	@cd $(DIR) && rm -f .env
	@echo "Removed $(DIR)/.env"

status:
	@$(MAKE) --no-print-directory show-version
	@docker ps

# -------------------------------------------------------------------------------------
# Optional remote helpers
# -------------------------------------------------------------------------------------
remote-logs:
	@ssh -p $(VPS_PORT) -i $(SSH_KEY) $(VPS_USER)@$(VPS_HOST) "cd $(VPS_DIR) && { docker compose -f docker-compose.yml logs -f || docker-compose -f docker-compose.yml logs -f; }"

remote-ps:
	@ssh -p $(VPS_PORT) -i $(SSH_KEY) $(VPS_USER)@$(VPS_HOST) "docker ps"

remote-cmd:
	@if [ -z "$(CMD)" ]; then echo "Usage: make remote-cmd CMD=\"<command>\"" ; exit 1 ; fi
	@ssh -p $(VPS_PORT) -i $(SSH_KEY) $(VPS_USER)@$(VPS_HOST) "cd $(VPS_DIR) && $(CMD)"


