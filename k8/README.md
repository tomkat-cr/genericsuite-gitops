## GenericSuite GitOps — Kubernetes (k8)

![GenericSuite Gitops Kubernetes banner](../assets/generic.suite.gitops.kubernetes.banner.010.png)

![version](https://img.shields.io/badge/version-rolling-blue)
![Python](https://img.shields.io/badge/Python-not%20required-lightgrey)
![Node](https://img.shields.io/badge/Node.js-not%20required-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

### Description / Overview

This `k8/` directory contains Kubernetes manifests and helper scripts to deploy a two-tier example application (React frontend + Flask backend) on a small Kubernetes cluster. It's intended for learning and testing purposes, not for production use.

It includes utilities to install Minikube, install `kubectl`, generate and apply secrets, open/forward ports, and manage the deployment lifecycle.

### Table of Contents

- [Features](#features)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [License](#license)
- [Contributing](#contributing)
- [Credits](#credits)

### Features

- **Minikube/Kubernetes setup**: Install Minikube and `kubectl` for local clusters.
- **Declarative deployment**: Apply/delete the app using `deployment.yml`.
- **Secrets management**: Create a Kubernetes secret from local `.env` variables.
- **Networking helpers**: Open firewall ports and forward cluster services to your machine.
- **Convenient Make targets**: Wraps common actions in a simple CLI.

### Technologies

- **Kubernetes** (`kubectl`, Services, Deployments)
- **Minikube**
- **Docker**
- **Bash**

### Getting Started

#### Prerequisites

- Linux or macOS host with Docker installed and running (for Minikube with Docker driver).

- `sudo` privileges for installation scripts where required.

- Optional helper scripts referenced by some installers:
  - `../docker/install_docker_service.sh`
  - `../scripts/get_os_name_type.sh`
  - `../scripts/firewall_manager.sh`

Create a `k8/.env` file with at least the following variables (used by `apply_secrets.sh` and defaults in `get_defaults.sh`):

```env
# Required by apply_secrets.sh
APP_DB_URI="postgresql://user:pass@host:5432/dbname"
APP_SECRET_KEY="your-secret-key"
SECRET_GROUP="exampleapp_secret_generic"
APP_BACKEND_PUBLIC_URL="http://dev.exampleapp.com"
APP_BACKEND_PORT="5000"

# Optional (have defaults in get_defaults.sh)
APP_FRONTEND_PUBLIC_URL="http://dev.exampleapp.com"
APP_FRONTEND_PORT="3001"
```

#### Installation

- Install Kubernetes CLI only (Linux):

```bash
make install-kubernetes
```

Or manually:

```bash
cd k8
sudo bash ./k8_install_kubernetes.sh
```

- Install Minikube (auto-detects Debian/RHEL-like distros and ensures Docker):

```bash
make install-minikube
```

Or manually:

```bash
cd k8
sudo bash ./k8_install_minikube.sh
```

- Start Minikube and helper services:

```bash
make start-minikube
```

Or manually:

```bash
cd k8
bash ./k8_start_minikube.sh
```

### Usage

- Generate and apply Kubernetes secrets from `.env`:

```bash
make apply-secrets
```

Or manually:

```bash
cd k8
bash ./apply_secrets.sh
```

- Apply the deployment (two services: `exampleappfront`, `exampleappback`):

```bash
make apply
```

Or manually:

```bash
cd k8
  bash ./apply_deployment.sh
  ```

- Forward services to local ports defined in `.env` or defaults:

```bash
make forward-ports
```

Or manually:

```bash
cd k8
  bash ./forward_app_ports.sh
  # Frontend -> ${APP_FRONTEND_PORT}:3001
  # Backend  -> ${APP_BACKEND_PORT}:5000
```

- Open firewall ports (depends on `../scripts/firewall_manager.sh`):

```bash
make open-fw
```

Or manually:

```bash
cd k8
bash ./open_fw_app_ports.sh
```

- Inspect services:

```bash
make status
```

Or manually:

```bash
cd k8
bash ./check_deployment.sh
# or directly
kubectl get svc -o wide
```

- Delete the deployment:

```bash
make delete
```

Or manually:

```bash
cd k8
bash ./delete_deployment.sh
```

### Project Structure

- `deployment.yml`: Two Deployments (frontend/backend) and two Services (separate public ports via `nodePort`).
- `deployment-v1.yml`: Alternate deployment with both containers under a single Service (not ideal when distinct public ports are required).
- `apply_deployment.sh`: `kubectl apply -f deployment.yml`.
- `delete_deployment.sh`: `kubectl delete -f deployment.yml`.
- `apply_secrets.sh`: Validates `.env` and creates secret `${SECRET_GROUP}` with `exampleapp_*` keys.
- `forward_app_ports.sh`: Port-forwards cluster Services to local ports.
- `open_fw_app_ports.sh`: Opens firewall ports using repo script.
- `check_deployment.sh`: Shows services with `kubectl get svc -o wide`.
- `get_defaults.sh`: Sources `.env` and sets default app URLs/ports.
- `k8_start_minikube.sh`: Starts Docker, `kubectl proxy`, Minikube, dashboard, and tunnel.
- `k8_install_minikube.sh`: Wrapper that checks Docker, detects OS, and calls distro-specific installer.
- `k8_install_minikube_centos.sh`: Installs KVM, Minikube, `kubectl` on CentOS/RHEL.
- `k8_install_minikube_ubuntu.sh`: Installs VirtualBox, Minikube, `kubectl` on Ubuntu/Debian.
- `k8_install_kubernetes.sh`: Installs standalone `kubectl` with checksum verification (Linux x86_64/arm64).
- `.gitignore`: Ignores `.env`.

### License

MIT License. See the repository [LICENSE](../LICENSE) file for details.

### Contributing

Contributions are welcome via issues and PRs. Please follow conventional commit messages and keep scripts idempotent where possible.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [`GenericSuite GitOps`](https://github.com/tomkat-cr/genericsuite-gitops).


