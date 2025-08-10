# Technical Context: GenericSuite GitOps

## Technologies Used

### Core Infrastructure Technologies

#### Container and Orchestration
- **Docker**: Container runtime and image management
  - Version: Latest stable (24.x+)
  - Usage: Service containerization, local development, VPS deployment
  - Key Components: Docker Engine, Docker Compose, Docker Registry integration

- **Kubernetes**: Container orchestration platform
  - Version: 1.25+ (compatible with minikube)
  - Usage: Production deployments, scaling, service mesh
  - Key Components: Deployments, Services, ConfigMaps, Secrets, LoadBalancers

- **Minikube**: Local Kubernetes development
  - Version: Latest stable
  - Usage: Local Kubernetes testing and development
  - Configuration: Single-node cluster with LoadBalancer support

#### Scripting and Automation
- **Bash/Zsh**: Primary automation language
  - Compatibility: POSIX-compliant scripts for maximum portability
  - Usage: Installation scripts, deployment automation, system configuration
  - Standards: Error handling, idempotent operations, comprehensive logging

- **Python**: Utility and data processing scripts
  - Version: 3.10+
  - Usage: Network mapping, system information gathering, complex data processing
  - Libraries: Standard library focus for minimal dependencies

### AI/ML Service Stack

#### OLLAMA (Large Language Models)
- **Service**: Local LLM inference server
- **Models**: Support for various open-source language models
- **Integration**: REST API for application integration
- **Configuration**: GPU acceleration when available, CPU fallback

#### WebUI Services
- **Technology**: Web-based interfaces for AI services
- **Integration**: Reverse proxy configuration for external access
- **Security**: Authentication and access control integration

#### Stable Diffusion
- **Service**: Local image generation service
- **WebUI**: Web-based interface for image generation
- **Models**: Support for various Stable Diffusion model variants
- **Hardware**: GPU optimization with CUDA support

### Workflow and Automation

#### N8n Workflow Engine
- **Technology**: Node-based workflow automation
- **Database**: PostgreSQL backend for workflow persistence
- **Administration**: pgAdmin for database management
- **Integration**: REST API and webhook support for external integrations

#### Database Technologies
- **PostgreSQL**: Primary database for N8n and other services
  - Version: 16.x
  - Configuration: Optimized for workflow engine requirements
  - Backup: Automated backup strategies

- **Supabase**: Backend-as-a-Service integration
  - Usage: Testing and integration capabilities
  - Features: Real-time subscriptions, authentication, storage

### Development and Deployment Tools

#### Version Control and CI/CD
- **Git**: Version control system
- **GitHub**: Repository hosting and collaboration
- **GitLab Runner**: CI/CD pipeline execution (integration ready)
- **GitHub Actions**: Alternative CI/CD platform support

#### Development Environment
- **VSCode, Cursor, Windsurf**: Primary development environment
- **Extensions**: Docker, Kubernetes, Shell scripting support
- **Debugging**: Container debugging and log analysis tools

## Development Setup

### Prerequisites
```bash
# System requirements
- Linux-based system (Ubuntu 20.04+, CentOS 8+, macOS with Docker Desktop)
- Docker and Docker Compose
- Git
- Python 3.10+
- Bash/Zsh shell environment
```

### Local Development Environment Setup
```bash
# 1. Clone repository
git clone https://github.com/tomkat-cr/genericsuite-gitops.git
cd genericsuite-gitops

# 2. Install Docker (if not already installed)
./docker/install_docker_service.sh

# 3. Set up environment variables in ./n8n and ./k8
cd ./n8n
cp .env.example .env
# Edit .env with your specific configuration

cd ../k8
cp .env.example .env
# Edit .env with your specific configuration

# 4. Install optional AI services
./ollama/install_ollama_service.sh
./ollama/install_stable_diffusion.sh

# 5. Start development services
./n8n/run_n8n.sh
./ollama/run_webui.sh
```

### VPS Development Setup
```bash
# 1. Prepare VPS environment
./vps/generate_client_private_key.sh

# 2. Deploy application stack
./vps/deploy_to_vps.sh

# 3. Create server users and groups
./vps/create_server_users_and_groups.sh

# 4. Start services
./vps/run-server-containers.sh

# 5. Configure networking
./scripts/firewall_manager.sh open XXX
./scripts/firewall_manager.sh close XXX
```

### Kubernetes Development Setup
```bash
# 1. Install minikube
./k8/k8_install_minikube.sh

# 2. Start Kubernetes cluster
./k8/k8_start_minikube.sh

# 3. Apply configurations
./k8/apply_secrets.sh
./k8/apply_deployment.sh

# 4. Verify deployment
./k8/check_deployment.sh
```

## Technical Constraints

### Platform Constraints
- **Operating System**: Linux-based systems (Ubuntu, RHEL, Fedora, Debian, etc.)
- **Architecture**: x86_64 (AMD64) primary, ARM64 support where available
- **Shell Environment**: Bash 4.0+ or Zsh compatibility required
- **Network**: Internet connectivity required for initial setup and image pulls

### Resource Constraints
- **Minimum RAM**: 4GB for basic deployment, 8GB+ recommended for AI services
- **Storage**: 20GB minimum, 100GB+ recommended for AI models and data
- **CPU**: 2+ cores minimum, 4+ cores recommended for production workloads
- **Network**: Stable internet connection for container image downloads

### Security Constraints
- **User Permissions**: Non-root user execution where possible
- **Network Security**: Firewall configuration and port management
- **Secrets Management**: No secrets in version control, environment variable based
- **Container Security**: Non-privileged containers, security scanning integration

### Compatibility Constraints
- **Docker Version**: 20.10+ required for all features
- **Kubernetes Version**: 1.25+ for full compatibility
- **Python Version**: 3.10+ for utility scripts
- **Shell Compatibility**: POSIX compliance for maximum portability

## Dependencies

### System Dependencies
```bash
# Core system packages
- curl, wget: HTTP client tools
- git: Version control
- unzip, tar: Archive extraction
- jq: JSON processing
- openssl: Cryptographic operations
- ufw: Firewall management (Ubuntu/Debian)
- firewalld: Firewall management (CentOS/RHEL)
```

### Container Dependencies
```yaml
# Docker images used
- postgres:16: Database services
- docker.n8n.io/n8nio/n8n: Workflow engine
- dpage/pgadmin4: Database administration
- ollama/ollama: Language model inference
- Various AI model containers for Stable Diffusion
```

### Development Dependencies
```bash
# Development tools
- make: Build automation
- docker-compose: Local orchestration
- kubectl: Kubernetes CLI
- minikube: Local Kubernetes
- python3-pip: Python package management
```

### Runtime Dependencies
- **Docker Engine**: Container runtime
- **Docker Compose**: Multi-container orchestration
- **Kubernetes**: Production orchestration (optional)
- **PostgreSQL**: Database services
- **Network Tools**: Port forwarding, firewall management

## Tool Usage Patterns

### Script Execution Pattern
```bash
# Standard script execution pattern
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../common/functions.sh"

# Main execution
main() {
    log_info "Starting ${0##*/}"
    
    # Pre-flight checks
    check_prerequisites
    
    # Main logic
    execute_main_logic
    
    # Validation
    validate_results
    
    log_info "Completed ${0##*/}"
}

main "$@"
```

### Configuration Management Pattern
```bash
# Environment variable loading pattern
load_environment() {
    local env_file="${1:-.env}"
    
    if [[ -f "$env_file" ]]; then
        # Load environment variables
        set -a  # Automatically export variables
        source "$env_file"
        set +a
        
        log_info "Loaded environment from $env_file"
    else
        log_warn "Environment file $env_file not found"
    fi
}
```

### Error Handling Pattern
```bash
# Comprehensive error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    
    log_error "Error occurred in script ${BASH_SOURCE[1]} at line $line_number"
    log_error "Exit code: $exit_code"
    
    # Cleanup operations
    cleanup_on_error
    
    exit $exit_code
}

trap 'handle_error $LINENO' ERR
```

### Service Health Check Pattern
```bash
# Service health validation
check_service_health() {
    local service_name=$1
    local health_endpoint=$2
    local max_attempts=${3:-30}
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        if curl -f -s "$health_endpoint" > /dev/null; then
            log_info "$service_name is healthy"
            return 0
        fi
        
        log_info "Waiting for $service_name (attempt $attempt/$max_attempts)"
        sleep 10
        ((attempt++))
    done
    
    log_error "$service_name failed health check"
    return 1
}
```

## Performance Considerations

### Container Optimization
- **Multi-stage builds**: Minimize final image size
- **Layer caching**: Optimize Docker build performance
- **Resource limits**: Prevent resource exhaustion
- **Health checks**: Ensure service reliability

### Network Optimization
- **Port management**: Efficient port allocation and forwarding
- **Load balancing**: Distribute traffic across service instances
- **Caching**: Implement caching strategies where appropriate
- **Compression**: Enable compression for web services

### Storage Optimization
- **Volume management**: Persistent storage for stateful services
- **Backup strategies**: Regular backup of critical data
- **Log rotation**: Prevent log files from consuming excessive storage
- **Cleanup procedures**: Regular cleanup of temporary files and unused containers

### Monitoring and Observability
- **Resource monitoring**: CPU, memory, disk, and network usage
- **Service monitoring**: Application-level health and performance metrics
- **Log aggregation**: Centralized logging for troubleshooting
