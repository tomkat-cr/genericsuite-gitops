## GenericSuite GitOps — VPS

![GenericSuite Gitops VPS banner](../assets/generic.suite.gitops.vps.banner.010.png)

[![Version](https://img.shields.io/badge/version-rolling-blue)](version.txt)
![Python](https://img.shields.io/badge/Python-not%20required-lightgrey)
![Node](https://img.shields.io/badge/Node.js-not%20required-lightgrey)
[![License: ISC](https://img.shields.io/badge/License-MIT-green.svg)](../LICENSE)

### Overview

VPS module for GenericSuite GitOps. It packages scripts and a `docker-compose.yml` to provision a remote server user, generate SSH keys, rsync deployment artifacts, and manage containers on a VPS running Docker.

### Table of Contents

- **Features**
- **Technologies**
- **Getting Started**
  - Prerequisites
  - Installation
- **Usage**
- **Project Structure**
- **License**
- **Contributing**
- **Credits**

### Features

- **Provision server user**: Create a main Linux user, groups, and add to sudo/docker.
- **SSH keys**: Generate and install local SSH keys for VPS access.
- **Simple deploy**: Rsync minimal files and restart the stack remotely.
- **Container control**: Start/stop/restart and view logs for the VPS stack.

### Technologies

- **Docker** and **Docker Compose**
- **SSH** and **rsync**
- **Bash** scripts

### Getting Started

#### Prerequisites

- Local machine: `ssh`, `ssh-keygen`, `ssh-copy-id`, `rsync`.
- VPS: Linux with `docker` and `docker-compose` installed and running.

#### Installation

Clone the repository and navigate to the VPS module:

```bash
git clone https://github.com/tomkat-cr/genericsuite-gitops.git
cd genericsuite-gitops/vps
```

Recommended: review and customize `docker-compose.yml` to replace the placeholders (`exampleapp_*`) or assign values to the environment variables.

### Usage

All common operations are exposed through the `Makefile` targets. You can override variables inline, for example: `make deploy VPS_USER=ubuntu VPS_HOST=vps.example.com`.

#### Environment variables

These are read from `../k8/.env` when generating `vps/.env`:

- **APP_BACKEND_PUBLIC_URL**: Public base URL to reach the backend (e.g., `http://api.example.com`).
- **APP_BACKEND_PORT**: Public port for the backend (e.g., `5000`).
- **APP_DB_URI**: Database connection URI.
- **APP_SECRET_KEY**: Secret key for the backend.

Optional Compose customization (set in `vps/.env` or your shell):

- **APP_NAME**: Base app name used for container names (default: `exampleapp`).
- **IMAGE_REGISTRY**: Registry/namespace for images (default: `exampleapp_docker_account`).
- **APP_PLATFORM**: Compose `platform` override (e.g., `linux/arm64`).

#### Show available targets

```bash
make help
```

#### Generate SSH key pair and install on the server (run on local machine)

```bash
make ssh-key VPS_USER=ocrusr VPS_HOST=vps.exampleapp.com
```

This runs `generate_client_private_key.sh` and will create `~/.ssh/id_rsa_<user>_<host>` directly, then upload the public key using `ssh-copy-id`.

#### Create server user and groups (run on the server)

```bash
make users-create NEW_USER=ocrusr
```

This runs `create_server_users_and_groups.sh` on the current machine (should be the VPS) to create the user, add to `sudo`/`wheel` and `docker` groups.

#### Set application version used by images

```bash
make set-version VERSION=1.2.3
make show-version
```

This writes `version.txt` which is read by `run-server-containers.sh` and used by `docker-compose.yml` (via `APP_VERSION`).

#### Generate `.env` from `k8/.env` (local helper)

```bash
make generate-env
```

Creates `vps/.env` with `APP_REACT_APP_API_URL`, `APP_DB_URI`, and `APP_SECRET_KEY` derived from `../k8/.env`.

#### Deploy to VPS (rsync files and restart containers remotely)

```bash
make deploy VPS_USER=ocrusr VPS_HOST=vps.exampleapp.com VPS_PORT=22 SSH_KEY=~/.ssh/id_rsa_ocrusr_vps.exampleapp.com VPS_DIR=~/exampleapp_start VERSION=1.2.3
```

This runs `deploy_to_vps.sh` which:
- Generates `.env` from `../k8/.env`.
- Rsyncs `vps/` contents to `VPS_DIR`.
- Restarts the remote stack with `run-server-containers.sh`.

#### Manage containers on the VPS (when running on the VPS)

Start/stop/restart:

```bash
make up
make down
make restart
```

Logs and status:

```bash
make logs
make ps
make status
```

Tail logs remotely via SSH:

```bash
make remote-logs VPS_USER=ocrusr VPS_HOST=vps.example.com VPS_DIR=~/exampleapp_start
```

List containers remotely:

```bash
make remote-ps VPS_USER=ocrusr VPS_HOST=vps.example.com
```

Run an arbitrary docker-compose command:

```bash
make compose CMD="pull"
```

Clean local artifacts:

```bash
make clean-version
make clean
```

Run a remote command within the deployment directory:

```bash
make remote-cmd CMD="docker compose ps" VPS_USER=ocrusr VPS_HOST=vps.example.com VPS_DIR=~/exampleapp_start
```

### Security and hardening notes

- **Secrets**: Prefer Docker secrets for sensitive values when possible. This stack currently uses environment variables for compatibility. If your app supports reading from files, mount a secret and read from `/run/secrets/<name>`.
- **SSH key handling**: Keys are created directly with `ssh-keygen -f ~/.ssh/id_rsa_<user>_<host>` and set to secure permissions. Ensure your private key is `chmod 600`.
- **Restricted deploy scope**: Deployment only syncs the minimum required files (`.env`, `docker-compose.yml`, `run-server-containers.sh`, `version.txt`, etc.).
- **Service startup**: `run-server-containers.sh` prefers `systemctl` and falls back to `service` to start Docker.
- **Compose CLI**: The Makefile prefers `docker compose` and falls back to `docker-compose` if needed.
- **Firewall/ports**: Ensure VPS firewall allows only the necessary ports (e.g., 3001, 5000) and consider placing services behind a reverse proxy.
- **Linting**: Consider using `shellcheck` to lint and harden the bash scripts.

### Project Structure

```
vps/
  ├─ docker-compose.yml            # Compose stack for example frontend/backend images
  ├─ run-server-containers.sh      # Wrapper to export version/env and run docker-compose
  ├─ deploy_to_vps.sh              # Rsync files and restart stack on the VPS
  ├─ generate_client_private_key.sh# Create SSH keypair and install on VPS
  ├─ create_server_users_and_groups.sh # Provision user/groups on server
  ├─ version.txt                   # (generated) image version consumed by compose
  ├─ .env                          # (generated) env vars used by compose
  └─ .gitignore                    # ignores .env
```

### License

This project is licensed under the ISC License. See the [LICENSE](../LICENSE) file for details.

### Contributing

Contributions are welcome! Please open an issue or submit a pull request in the main repository.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [GenericSuite GitOps — VPS](https://github.com/tomkat-cr/genericsuite-gitops).


