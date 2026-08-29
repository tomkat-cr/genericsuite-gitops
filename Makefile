.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

tmux-help:
	if less >/dev/null 2>&1; then less help/tmux-cheatsheet.md; else bash scripts/tmux_help.sh; fi

get-my-ip:
	if command -v python3 >/dev/null 2>&1; then python3 scripts/get_my_ip.py; else echo "Error: python3 not found"; fi

get-os-name-type:
	bash scripts/get_os_name_type.sh

lsof-listeners:
	bash scripts/lsof_listeners.sh

map-network:
	if command -v python3 >/dev/null 2>&1; then python3 scripts/map_network.py; else echo "Error: python3 not found"; fi

watch-gpu:
	bash ollama/watch_gpu.sh

ollama:
	@cat ollama/Makefile

n8n:
	@cat n8n/Makefile

k8:
	@cat k8/Makefile

vps:
	@cat vps/Makefile

docker:
	@cat docker/Makefile

gitlab_runner:
	@cat gitlab_runner/Makefile

nginx-router:
	@cat nginx_router/Makefile

nginx-router-init:
	cd nginx_router && make init

nginx-router-run:
	cd nginx_router && make run

nginx-router-down:
	cd nginx_router && make down

nginx-router-restart:
	cd nginx_router && make restart

nginx-router-hard-restart:
	cd nginx_router && make hard-restart

nginx-router-logs-f:
	cd nginx_router && make logs-f

nginx-router-status:
	cd nginx_router && make status

nginx-router-clean:
	cd nginx_router && make clean

# Create auto-signed SSL certificates (crt/key)
nginx-router-ssl-auto:
	bash ./scripts/create_local_ssl_certs.sh

# Create letsencrypt SSL certificates (crt/key) for macOS
nginx-router-ssl-macos:
	bash ./scripts/create_le_ssl_cert_macos.sh

# Create letsencrypt SSL certificates (crt/key) for Debian/Ubuntu
nginx-router-ssl-debian:
	bash ./scripts/create_le_ssl_cert_debian.sh

# Create letsencrypt SSL certificates (crt/key)
nginx-router-ssl:
	@echo "Please specify your OS, for example: make nginx-router-ssl-debian or make nginx-router-ssl-macos"

sast-test:
	snyk auth
	snyk code test --severity-threshold=high --all-projects .
	snyk test --severity-threshold=high --all-projects .
