.PHONY: help
SHELL := /bin/bash

help:
	cat Makefile

# Variables
K8_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Installation and cluster management
install-kubernetes:
	cd $(K8_DIR) && sudo bash ./k8_install_kubernetes.sh

install-minikube:
	cd $(K8_DIR) && sudo bash ./k8_install_minikube.sh

start-minikube:
	cd $(K8_DIR) && bash ./k8_start_minikube.sh

# Secrets
apply-secrets:
	cd $(K8_DIR) && bash ./apply_secrets.sh

# Deployment lifecycle
apply:
	cd $(K8_DIR) && bash ./apply_deployment.sh

delete:
	cd $(K8_DIR) && bash ./delete_deployment.sh

status:
	cd $(K8_DIR) && bash ./check_deployment.sh

# Networking helpers
forward-ports:
	cd $(K8_DIR) && bash ./forward_app_ports.sh

open-fw:
	cd $(K8_DIR) && bash ./open_fw_app_ports.sh


