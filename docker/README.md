### GenericSuite GitOps — Docker Service Installer

![GenericSuite Gitops Docker banner](../assets/generic.suite.gitops.docker.banner.010.png)

![version](https://img.shields.io/badge/version-rolling-blue)
![Python](https://img.shields.io/badge/Python-not%20required-lightgrey)
![Node](https://img.shields.io/badge/Node.js-not%20required-lightgrey)
![license](https://img.shields.io/badge/license-MIT-green)

## Overview

This directory provides a cross-distro Docker CE installer and service utilities for Linux hosts, as part of the GenericSuite GitOps toolkit. It can install Docker CE on Debian/Ubuntu, RHEL/CentOS/Fedora, Raspbian, add users to the `docker` group, enable and start the `docker` service, and verify with `hello-world`.

Windows and macOS installations are not covered by this project. They are available through [Docker Desktop](https://docs.docker.com/desktop/). For instructions on how to install Docker Desktop, see [Overview of Docker Desktop](https://docs.docker.com/desktop/) in the Docker documentation.

## Table of Contents

- Features
- Technologies
- Getting Started
  - Prerequisites
  - Installation
- Usage
- Project Structure
- License
- Contributing
- Credits

## Features

- **Cross-distro install**: Ubuntu, Debian, RHEL, CentOS, Fedora, Raspbian, Amazon Linux (RHEL-like path)
- **User group setup**: Adds specified user and the OS user to the `docker` group
- **Service management**: Start/stop/restart/status/enable/disable via Make targets
- **Post-install check**: Runs `docker run hello-world`
- **OS detection helper**: Uses `scripts/get_os_name_type.sh` for normalized OS variables

## Technologies

- Bash
- systemd (service control)
- [Docker CE](https://docs.docker.com/engine/install/) (engine, CLI, containerd, buildx, compose plugin)

## Getting Started

### Prerequisites

- A supported Linux distribution with systemd and network access to Docker package repositories
- `sudo` privileges
- For Debian/Ubuntu-based: `curl`, `ca-certificates` (handled by installer)

### Installation

Use the provided Makefile to install Docker CE. Optionally pass `OTHER_USER` to add an additional user to the `docker` group.

```bash
cd docker
make install OTHER_USER=$USER
```

This will:
- Detect your OS and version
- Configure the official Docker repository
- Install Docker CE and related components
- Add users to the `docker` group
- Start the `docker` service
- Run `hello-world` to validate

## Usage

The following commands are available via the Makefile:

```bash
# Show all available targets
make help

# Install Docker CE and verify
make install OTHER_USER=$USER

# Service controls
make start
make stop
make restart
make status
make enable
make disable
make is-enabled

# Utilities
make test        # runs hello-world
make hello       # runs hello-world
make group-add OTHER_USER=alice
make logs        # recent docker service logs
make os-info     # show OS info detected by the helper script
```

If you added a user to the `docker` group, that user may need to sign out/in or run `newgrp docker` to refresh group membership.

## Project Structure

```
docker/
  ├─ Makefile
  └─ install_docker_service.sh
scripts/
  └─ get_os_name_type.sh
```

## License

This project is licensed under the MIT License. See the repository [LICENSE](../LICENSE) file for details.

## Contributing

Contributions are welcome! Please open issues or pull requests with clear descriptions and rationale.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [GenericSuite GitOps](https://github.com/tomkat-cr/genericsuite-gitops).
