.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

# Variables
SCRIPT := ./gitlab_runner_run.sh
URL ?= https://gitlab.com/api/v4/runners

# Convenience targets mapping to script actions
start:
	sh $(SCRIPT) start

stop:
	sh $(SCRIPT) stop

restart:
	sh $(SCRIPT) restart

logs:
	sh $(SCRIPT) logs

register:
	sh $(SCRIPT) register

upgrade:
	sh $(SCRIPT) upgrade-version

update-config:
	sh $(SCRIPT) update-config

privileged:
	sh $(SCRIPT) enable-privileged

check:
	sh $(SCRIPT) check-connectivity $(URL)

selinux-fix:
	sh $(SCRIPT) install-selinux-dockersock

status:
	docker ps --filter name=gitlab-runner | cat


