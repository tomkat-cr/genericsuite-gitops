# CLAUDE.md

This file provides guidance to AI Coding Assistants (Claude Code, Gemini CLI, Cursor, Antigravity, etc.) when working with code in this repository.

## What This Repository Does

GenericSuite GitOps is a DevOps automation toolkit providing shell scripts and configurations for deploying applications across local development, VPS, and Kubernetes environments. It serves as the operational backbone for the GenericSuite ecosystem.

## Common Commands

```bash
make help                  # List all top-level Makefile targets
make get-my-ip             # Detect local IP (requires Python 3)
make get-os-name-type      # Detect OS and distro
make lsof-listeners        # List active port listeners
make watch-gpu             # Monitor GPU usage
make sast-test             # Run SAST testing

# Service-specific help (each prints that module's Makefile targets)
make ollama
make n8n
make k8
make vps
make docker
make gitlab_runner
```

Each service subdirectory has its own Makefile. Run `make` or `make help` inside the directory for module-specific commands (e.g., `cd n8n && make help`).

## Architecture

### Directory Layout

| Directory | Purpose |
|-----------|---------|
| `k8/` | Kubernetes + minikube deployment manifests and lifecycle scripts |
| `vps/` | VPS deployment via Docker Compose; user/group provisioning |
| `docker/` | Cross-distro Docker CE installer for Linux |
| `n8n/` | N8n workflow automation with PostgreSQL + pgAdmin backend |
| `ollama/` | OLLAMA LLM server, Open WebUI, and Stable Diffusion |
| `nginx_router/` | NGINX reverse proxy with HTTP/HTTPS and SSL support |
| `gitlab_runner/` | GitLab Runner CI/CD integration |
| `scripts/` | Shared utilities: SSL certs, firewall, OS detection, network tools |
| `docs/` | AI context documents (projectBrief, systemPatterns, techContext, etc.) |

### Patterns and Conventions

**Modular service layout** — each service directory follows the same structure:
- `Makefile` (service commands)
- `README.md` (usage docs)
- `install_*.sh` / `run_*.sh` (lifecycle scripts)
- `docker-compose.yml` (container stack)
- `.env.example` (config template — copy to `.env` and edit before use)

**Environment-based config** — all secrets and runtime config live in `.env` files (never committed). Always copy `.env.example` to `.env` before running any service.

**Idempotent scripts** — all scripts are safe to re-run; they check for existing state before taking action.

**Cross-platform OS detection** — scripts source `scripts/get_os_name_type.sh` to branch on distro-specific behavior (Ubuntu/Debian vs. RHEL/Fedora vs. macOS).

**Template placeholders** — config files use placeholder names like `exampleapp` that must be replaced with the actual application name before use (e.g., `k8/deployment.yml`, `nginx_router/nginx.exampleserver.conf`).

### Key Script Responsibilities

- `vps/create_server_users_and_groups.sh` — provisions Linux users, groups, and sudo access on a fresh VPS
- `vps/deploy_to_vps.sh` — full application stack deployment via Docker Compose
- `k8/apply_deployment.sh` / `k8/apply_secrets.sh` — deploy K8s manifests and secrets
- `k8/k8_start_minikube.sh` — start local K8s cluster via minikube
- `nginx_router/run-nginx-router.sh` — NGINX lifecycle (start/stop/reload/reconfigure SSL)
- `scripts/create_local_ssl_certs.sh` — generate self-signed certs (mkcert)
- `scripts/create_le_ssl_cert_debian.sh` — Let's Encrypt cert via Certbot (Debian/Ubuntu)
- `scripts/firewall_manager.sh` — UFW/firewalld abstraction layer
- `ollama/run_ollama.sh` — OLLAMA LLM server lifecycle
- `gitlab_runner/gitlab_runner_run.sh` — register and start GitLab Runner

### Technology Stack

- **Scripting**: Bash/Zsh (all automation), Python 3 (IP/network utilities)
- **Containers**: Docker, Docker Compose, Kubernetes (minikube for local)
- **Services**: N8n, OLLAMA, Stable Diffusion, PostgreSQL, pgAdmin, NGINX
- **Security**: UFW/firewalld, SSH key generation, Kubernetes secrets, SSL/TLS (mkcert + Let's Encrypt)

## Important Notes

- The files `AGENTS.md`, `GEMINI.md`, etc. (if present) have only a referece to `@CLAUDE.md` — edit only `CLAUDE.md`.
- Skills, commands, rules, and sub-agents are located in the `.claude/` directory.
