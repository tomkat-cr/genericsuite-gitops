# GenericSuite GitOps - Docker Service Installer
# Manage Docker CE installation and service lifecycle across major Linux distros.

.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

# -----------------------------
# Configuration
# -----------------------------
# Optional: pass a user to be added to the docker group during install
# Example: make install OTHER_USER=alice
OTHER_USER ?=

# Use sudo by default for privileged operations
SUDO ?= sudo

# Paths
SCRIPT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
INSTALLER  := $(SCRIPT_DIR)/install_docker_service.sh
OS_INFO    := $(abspath $(SCRIPT_DIR)/../scripts/get_os_name_type.sh)

# -----------------------------
# Installation
# -----------------------------
.PHONY: install
install: ## Install Docker CE using the cross-distro installer (adds users to docker group, starts service, runs hello-world)
	$(SUDO) bash "$(INSTALLER)" $(OTHER_USER)

# -----------------------------
# Service management
# -----------------------------
.PHONY: start stop restart status enable disable is-enabled
start: ## Start docker service
	$(SUDO) systemctl start docker

stop: ## Stop docker service
	$(SUDO) systemctl stop docker

restart: ## Restart docker service
	$(SUDO) systemctl restart docker

status: ## Show docker service status
	$(SUDO) systemctl status docker --no-pager

enable: ## Enable docker to start at boot
	$(SUDO) systemctl enable docker

disable: ## Disable docker from starting at boot
	$(SUDO) systemctl disable docker

is-enabled: ## Check if docker is enabled at boot
	$(SUDO) systemctl is-enabled docker || true

# -----------------------------
# Utilities
# -----------------------------
.PHONY: test hello group-add logs os-info
test: hello ## Run docker hello-world to verify installation

hello: ## Run docker hello-world
	docker run --rm hello-world

group-add: ## Add OTHER_USER to docker group (requires OTHER_USER and sudo). Example: make group-add OTHER_USER=alice
	@if [ -z "$(OTHER_USER)" ]; then \
		echo "ERROR: Provide OTHER_USER, e.g. make group-add OTHER_USER=alice"; \
		exit 1; \
	fi
	$(SUDO) usermod -a -G docker $(OTHER_USER)
	@echo "User '$(OTHER_USER)' added to group 'docker'. You may need to re-login or run: newgrp docker"

logs: ## Show recent docker service logs
	$(SUDO) journalctl -u docker --no-pager -n 200

os-info: ## Display detected OS info used by the installer
	bash "$(OS_INFO)"


