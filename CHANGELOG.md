# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).


## Unreleased
---

### New

### Changes

### Fixes

### Breaks


## 0.3.0 (2025-07-07)
---

### New
Add documentation to replace exampleapp and other example names to the app specific ones [GS-141].
Add "webUi" update with sh `run_webui.sh update`.

### Changes
SECRET_GROUP envvar moved from apply_secrets.sh to .env [GS-141].
Fix typos, add additional notes, remove hard-coded IDs in various files.
Change to run "scripts/get_os_name_type.sh" with source or "." in the firewall manager. [GS-141]
Change to get the latest n8n version in the docker compose file.


## 0.2.0 (2025-02-18)
---

### New
Abstract and add to the Genericsuite project (from FynApp GitOps project) [GS-141].
Implement ollama server [GS-139].
Implement n8n server [GS-165]
Add WEBHOOK_URL to n8n service to customize the endpoint server base URL.

### Fixes
"Makefile", "run_n8n.sh", "firewall_manager.sh" and "get_os_name_type.sh" scripts to work on Ubuntu.


## 0.1.3 (2024-10-14)
---

### New
Add firewall manager [GS-141].

### Changes
Enhanced webui run with GPU support and opening the web port [GS-139].
Better version check in docker installer [GS-141].
NVIDIA container-toolkit install in run_webui [GS-139].

### Fixes
Fix sudo in the script (not running it) to minikube install and start [GS-141].
Fix "get_my_ip" and "map_network" linting [GS-141].


## 0.1.2 (2022-03-16)
---

### Changes
FA-58: "restart: unless-stopped" to the VPS docker compose configuration, to let the containers stay active on server reboots.
FA-31: Separate databases for prod, staging and development.
Increase the VPS DKR images version.

### New
Add Python scripts to get IP and scan the network.
Create this repo `version.tx`t, `README.md` and `CHANGELOG.md` files.


## 0.1.11 (2022-03-10)
---

### New
Preview version with initial deployment of BE (Backend) and FE (Frontend) of Fynapp webapp.
Release notes:
FA-3: Create a pipeline to build and deploy the backend to a docker container in a Linux VPS.
FA-13: Create a develop branch and start using it with good SDLC practices.
FA-18: Create a pipeline to build and deploy BE & FE on Heroku.
FA-21: Recover local I5 y/o Celeron server and install Centos 7.
FA-22: Install and configure Kubernetes on the local server and perform a spike the evaluate using this technology.
FA-23: Build a docker image in a Gitlab pipeline by install a Gitlab runner.
