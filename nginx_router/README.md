# NGINX Router

![Version](https://img.shields.io/badge/version-0.4.0-blue)
![Python](https://img.shields.io/badge/python-N%2FA-lightgrey)
![Node](https://img.shields.io/badge/node-N%2FA-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## Description / Overview

Reusable NGINX reverse proxy setup, containerized with Docker Compose, to expose HTTP/HTTPS endpoints and route traffic to backend services (API, WebSockets, static files). This module lives under `nginx_router/` within the `genericsuite-gitops` repo and provides:

- Example NGINX configuration (`nginx.example.conf`) covering HTTP and HTTPS, proxying for `/api/` and `/socket.io/`.
- Example Docker Compose file (`docker-compose.example.yml`) for running `nginx:alpine` with SSL material mounted.
- Makefile targets to start/stop, follow logs, and clean up the deployment using a shell wrapper.

## Table of Contents

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

## Features

- Reverse proxy for HTTP (80) and HTTPS (443).
- Proxy examples for REST (`/api/`) and WebSockets (`/socket.io/`).
- SSL/TLS configuration placeholders for certificates and client CA.
- Simple lifecycle via `make` targets.
- Log tailing and cleanup helpers.

## Technologies

- NGINX (official `nginx:alpine` image)
- Docker and Docker Compose
- Shell scripts / Makefile

## Getting Started

### Prerequisites

- Docker
- Docker Compose
- SSL certificates (if serving HTTPS): place under `nginx_router/ssl/`
- A `.env` file in `nginx_router/` (used by the run script and/or compose)

### Installation

1. Navigate to the `nginx_router/` directory.
2. Copy the example files to their operative names:

```bash
cp docker-compose.example.yml docker-compose.yml
cp nginx.example.conf nginx.conf
```

3. Provide certificates and keys under `ssl/` and update the NGINX config paths accordingly. Example paths in `nginx.example.conf`:

- `/etc/nginx/ssl/exampleserver.com.crt`
- `/etc/nginx/ssl/exampleserver.com.key`
- `/etc/nginx/ssl/ca.crt`

4. Create a `.env` file at `nginx_router/.env` with any required variables for your environment (refer to your deployment/compose needs). The run script requires `.env` to exist.

## Usage

This module exposes `make` targets that wrap Docker Compose. From `nginx_router/`:

- Start services:

```bash
make up
```

- Stop services:

```bash
make down
```

- Restart services and follow logs:

```bash
make restart
```

- Show logs once:

```bash
make logs
```

- Follow logs:

```bash
make logs-f
```

- Show service status:

```bash
make status
```

- Clean up (down + remove volumes + prune dangling resources):

```bash
make clean
```

- List available commands:

```bash
make help
```

- Create auto-signed SSL certificates (crt/key):

```bash
make ssl
```

Notes:

- `make up`/`down`/`restart` call the wrapper script which uses `docker-compose` under the hood. Ensure your `docker-compose.yml` matches the expected mounts:
  - `./nginx.conf:/etc/nginx/conf.d/default.conf:ro`
  - `./ssl:/etc/nginx/ssl:ro`
- Update `server_name`, certificate file paths, and proxy targets in `nginx.conf` to match your environment.

## Project Structure

```
nginx_router/
├─ Makefile
├─ README.md  ← this file
├─ docker-compose.example.yml
├─ nginx.example.conf
├─ run-nginx-router.sh
└─ ssl/
   └─ .gitignore
```

## License

This project is licensed under the MIT License. See the root repository file [LICENSE](../LICENSE).

## Contributing

- Fork the repo and create a feature branch.
- Make your changes with clear commit messages.
- Open a pull request with a concise description of changes and rationale.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [NGINX Router](https://github.com/tomkat-cr/genericsuite-gitops).
