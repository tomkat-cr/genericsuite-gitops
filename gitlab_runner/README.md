### GitLab Runner Docker Utilities

![GenericSuite Gitops GitLab Runner banner](../assets/generic.suite.gitops.gitlab.banner.010.png)

![Version](https://img.shields.io/badge/version-rolling-blue)
![Python](https://img.shields.io/badge/Python-not%20required-lightgrey)
![Node](https://img.shields.io/badge/Node.js-not%20required-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## Description / Overview
Helper utilities to manage a GitLab Runner inside a Docker container. This directory provides a single script that wraps common lifecycle tasks such as starting/stopping the runner, registration, log viewing, upgrading, enabling privileged mode, and connectivity checks. It is OS-aware for config directory placement (macOS/Linux) and includes an optional SELinux helper for RHEL/Fedora-based systems.

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
- Start, stop, restart the GitLab Runner container
- Interactive runner registration against a GitLab instance
- View container logs with timestamps and details
- Upgrade to the latest `gitlab/gitlab-runner` image
- Enable privileged mode in `config.toml`
- Trigger a runner config update and restart
- Quick connectivity check to the GitLab Runners API (or custom URL)
- Optional SELinux policy helper for accessing Docker socket on RHEL/Fedora

## Technologies
- Bash/sh
- Docker

## Getting Started

### Prerequisites
- [Docker Engine installed and running](../docker/README.md)
- Access to a [GitLab](https://gitlab.com/) project or organization
- A runner registration token (from [GitLab](https://gitlab.com/) > Settings > CI/CD > Runners)
- macOS or Linux
  - Config directory placement is automatic:
    - macOS: `/Users/Shared/gitlab-runner/config`
    - Linux: `/srv/gitlab-runner/config`

### Installation

1. Ensure Docker is installed and that your user can run `docker` commands.

2. From the repository root, navigate to this directory:

```bash
cd gitlab_runner
```

3. Optionally, use the provided `Makefile` for convenience (see [Usage](#usage)).

## Usage

You can call the script directly or use the Makefile targets. The script auto-detects OS and uses the appropriate config directory.

### Script (direct)

```bash
# Show available actions
sh gitlab_runner_run.sh

# Start the runner container (ports and volumes are handled by the script)
sh gitlab_runner_run.sh start

# Stop and remove the container
sh gitlab_runner_run.sh stop

# Restart the container
sh gitlab_runner_run.sh restart

# View logs (follow, with timestamps)
sh gitlab_runner_run.sh logs

# Register the runner interactively
sh gitlab_runner_run.sh register

# Enable privileged mode in config.toml and restart
sh gitlab_runner_run.sh enable-privileged

# Pull latest runner image and restart
sh gitlab_runner_run.sh upgrade-version

# Apply config changes by restarting
sh gitlab_runner_run.sh update-config

# Connectivity check (defaults to GitLab Runners API)
sh gitlab_runner_run.sh check-connectivity

# Connectivity check to a custom URL
sh gitlab_runner_run.sh check-connectivity https://gitlab.com/api/v4/runners
```

Notes:

- The container exposes port `8093` on the host mapped to `8093` in the container. This is typically used for runner metrics if configured.

- The script mounts the Docker socket into the container and mounts the runner config directory at `/etc/gitlab-runner`.

### Makefile (recommended)
Common tasks are wrapped as Make targets:

```bash
# From this directory
make help            # prints the Makefile
make start           # start runner
make stop            # stop and remove container
make restart         # restart container
make logs            # follow logs
make register        # interactive registration
make upgrade         # pull latest image and restart
make update-config   # apply config changes by restarting
make privileged      # enable privileged mode and restart
make check           # connectivity check (uses URL variable if provided)
make selinux-fix     # install SELinux dockersock policy (RHEL/Fedora)
make status          # show container status

# Example with custom URL for connectivity check
make check URL=https://gitlab.com/api/v4/runners
```

## Project Structure
```
gitlab_runner/
  ├─ gitlab_runner_run.sh       # Main management script
  ├─ Makefile                   # Convenience targets (this directory)
  └─ README.md                  # You are here
```

## License
This project is licensed under the MIT License. See the root `LICENSE` file for details.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [The GenericSuite GitOps on GitHub](https://github.com/tomkat-cr/genericsuite-gitops).
