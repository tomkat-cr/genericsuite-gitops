
# The Genericsuite GitOps.

![GenericSuite Gitops banner](./assets/generic.suite.gitops.banner.010.png)

![Version](https://img.shields.io/badge/version-v0.4.0-blue)
![Python](https://img.shields.io/badge/Python-3.11-yellow)
![Node](https://img.shields.io/badge/Node.js-not%20required-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

<img 
    align="right"
    width="100"
    height="100"
    src="https://genericsuite.carlosjramirez.com/images/gs_logo_circle.svg"
    title="GenericSuite logo by Carlos J. Ramirez"
/>

[GenericSuite](https://www.carlosjramirez.com/en/genericsuite/) Gitops provides the scripts and configurations needed to deploy on various platforms (local development servers, VPS) using orchestration technologies like Kubernetes, and manage artifacts and repositories with Docker and GitHub.

## Features

- [N8N](./n8n/README.md): Install and configure a local N8n service.
- [Ollama](./ollama/README.md#ollama): Install and configure a local OLLAMA service.
- [WebUI](./ollama/README.md#open-webui): Run the local WebUI service.
- [Stable Diffusion](./ollama/README.md#stable-diffusion): Install and configure a local Stable Diffusion service, and run its WebUi.
- [K8](./k8/README.md): Deploy your App on a Kubernetes cluster.
- [VPS Deployment](./vps/README.md): Prepare a VPS server with a fully configured environment to run your App.
- [Docker](./docker/README.md): installation toolkit for Linux servers.
- [GitLab Runner](./gitlab_runner/README.md): Install and configure a local GitLab Runner service.
- [Server Utilities](./Makefile): Server utilities for network scanning, port forwarding, tmux documentation, and more.

## Getting Started

Click on each feature to get instructions about getting started, pre-requisites, installation, configuration, and operation.

Also visit the [GenericSuite Documentation](https://genericsuite.carlosjramirez.com/Backend-Development/GenericSuite-GitOps) for more details about the project.

## Usage

Click on each feature to get instructions about configuration and operation.

There are some additional helper utilities in the main [Makefile](./Makefile) that can be used to manage the server:

```bash
# From this directory
make help               # prints the Makefile
make tmux-help          # tmux cheatsheet
make get-my-ip          # get my IP address (python3 required)
make get-os-name-type   # get OS name and type
make lsof-listeners     # list all listeners using lsof
make map-network        # map network (python3 required)
make watch-gpu          # watch GPU usage
make ollama             # Shows ollama Makefile help
make n8n                # Shows n8n Makefile help
make k8                 # Shows k8 Makefile help
make vps                # Shows vps Makefile help
make docker             # Shows docker Makefile help
make gitlab_runner      # Shows gitlab_runner Makefile help
```

Also check the [The GenericSuite Git Operations](https://genericsuite.carlosjramirez.com/Backend-Development/GenericSuite-GitOps#usage) for more details.

## Documentation

* [https://genericsuite.carlosjramirez.com](https://genericsuite.carlosjramirez.com)
* Mirror: [https://genericsuite.readthedocs.io](https://genericsuite.readthedocs.io)

## License

GenericSuite is open-sourced software licensed under the [MIT license](./LICENSE).

## Credits

This project is developed and maintained by [Carlos J. Ramirez](https://github.com/tomkat-cr). For more information or to contribute to the project, visit [The GenericSuite GitOps on GitHub](https://github.com/tomkat-cr/genericsuite-gitops).

Happy Coding!