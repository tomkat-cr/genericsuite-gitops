.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

tmux-help:
	if less >/dev/null 2>&1; then less docs/tmux-cheatsheet.md; else bash scripts/tmux_help.sh; fi

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

