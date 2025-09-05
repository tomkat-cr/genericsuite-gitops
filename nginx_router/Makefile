# Nginx Router Makefile
# Manages Docker Compose services for production deployment

.PHONY: help run down restart logs clean status ssl

# Default target
help:
	@echo "Nginx Router Commands:"
	@echo "  run         - Start all services"
	@echo "  up          - Alias for run"
	@echo "  down        - Stop all services"
	@echo "  restart     - Restart all services"
	@echo "  logs        - Show logs for all services"
	@echo "  logs-f      - Follow logs for all services"
	@echo "  clean       - Stop services and remove volumes"
	@echo "  status      - Show service status"
	@echo "  ssl         - Create auto-signed SSL certificates (crt/key)"
	@echo "  init        - Initialize nginx-router configuration"

# Start all services
run:
	bash run-nginx-router.sh run

up: run
	
# Stop all services
down:
	bash ./run-nginx-router.sh down

# Restart all services
restart-docker:
	bash ./run-nginx-router.sh restart

# Restart all services
restart: restart-docker logs-f

hard-restart: down up

# Show logs
logs:
	docker compose logs

# Follow logs
logs-f:
	docker compose logs -f

# Clean up - stop services and remove volumes
clean:
	docker compose down -v
	docker system prune -f

# Show service status
status:
	docker compose ps

# Create auto-signed SSL certificates (crt/key)
ssl-auto:
	bash ../scripts/create_local_ssl_certs.sh

# Create letsencrypt SSL certificates (crt/key) for macOS
ssl-macos:
	bash ../scripts/create_le_ssl_cert_macos.sh

# Create letsencrypt SSL certificates (crt/key) for Debian/Ubuntu
ssl-debian:
	bash ../scripts/create_le_ssl_cert_debian.sh

# Create letsencrypt SSL certificates (crt/key)
ssl:
	@echo "Please specify your OS, for example: make ssl-debian or make ssl-macos"

init:
	bash ./run-nginx-router.sh init