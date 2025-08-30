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
ssl:
	bash ./local_ssl_certs_creation.sh

init:
	bash ./run-nginx-router.sh init