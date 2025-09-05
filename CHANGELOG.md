# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).


## [Unreleased] - Date

### Added

### Changed

### Fixed

### Removed


## [0.4.0] - 2025-09-04

### Added
- Add Nginx Router module [GS-180] [GS-234].
- Add SSL certificate generation with Let's Encrypt and Mkcert [GS-180].
- Add "README.md" and "Makefile" files to the "ollama", "n8n", "k8", "docker", "gitlab_runner", "vps", and "scripts" directories [GS-231].
- Add "ollama_update" to ollama manager [GS-229].
- Add memory bank documents in the "specs" directory [GS-208].
- Improved user experience with additional helper scripts and commands, e.g. Tmux cheatsheet [GS-231].

### Changed
- Update CHANGELOG format to be more semantic [GS-222].
- Vps - scripts enhanced to implement better linux server practices [GS-231].
- N8n - add init command and gitignore docker configuration files [GS-141].
- Change restart policy to 'unless-stopped' for n8n, postgres, and pgadmin services [GS-141].

### Fixed
- Fix connectivity checks across services [GS-231]


## [0.3.0] - 2025-07-07

### Added
- Add documentation to replace exampleapp and other example names to the app specific ones [GS-141].
- Add WebUI update with sh `run_webui.sh update`.

### Changed
- SECRET_GROUP envvar moved from apply_secrets.sh to .env [GS-141].
- Fix typos, add additional notes, remove hard-coded IDs in various files.
- Change to run "scripts/get_os_name_type.sh" with source or "." in the firewall manager. [GS-141]
- Change to get the latest n8n version in the docker compose file.


## [0.2.0] - 2025-02-18

### Added
- Abstract and add to the Genericsuite project (from FynApp GitOps project) [GS-141].
- Implement ollama server [GS-139].
- Implement n8n server [GS-165]
- Add WEBHOOK_URL to n8n service to customize the endpoint server base URL.

### Fixed
- "Makefile", "run_n8n.sh", "firewall_manager.sh" and "get_os_name_type.sh" scripts to work on Ubuntu.


## [0.1.3] - 2024-10-14

### Added
- Add firewall manager [GS-141].

### Changed
- Enhanced WebUI run with GPU support and opening the web port [GS-139].
- Better version check in docker installer [GS-141].
- NVIDIA container-toolkit install in "run_webui.sh" [GS-139].

### Fixed
- Fix sudo in the script (not running it) to minikube install and start [GS-141].
- Fix "get_my_ip" and "map_network" linting [GS-141].


## [0.1.2] - 2022-03-16

### Added
- Add Python scripts to get IP and scan the network.
- Create this repo `version.tx`t, `README.md` and `CHANGELOG.md` files.

### Changed
- "restart: unless-stopped" to the VPS docker compose configuration, to let the containers stay active on server reboots [FA-58].
- Separate databases for prod, staging and development [FA-31].
- Increase the VPS DKR images version.


## [0.1.11] - 2022-03-10

### Added
- Preview version with initial deployment of BE (Backend) and FE (Frontend) of Fynapp webapp.
- Release notes: a little bit of history
    - Create a pipeline to build and deploy the backend to a docker container in a Linux VPS [FA-3].
    - Create a develop branch and start using it with good SDLC practices [FA-13].
    - Create a pipeline to build and deploy BE & FE on Heroku [FA-18].
    - Recover local I5 y/o Celeron server and install Centos 7 [FA-21].
    - Install and configure Kubernetes on the local server and perform a spike the evaluate using this technology [FA-22].
    - Build a docker image in a Gitlab pipeline by install a Gitlab runner [FA-23].
