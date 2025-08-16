#!/bin/bash

# Docker development script for ecommerce application
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to build the application
build_app() {
    print_status "Building Spring Boot application..."
    docker-compose build app
    print_success "Application built successfully"
}

# Function to start all services
start_services() {
    print_status "Starting all services..."
    docker-compose up -d
    print_success "All services started"
}

# Function to stop all services
stop_services() {
    print_status "Stopping all services..."
    docker-compose down
    print_success "All services stopped"
}

# Function to restart services
restart_services() {
    print_status "Restarting services..."
    docker-compose restart
    print_success "Services restarted"
}

# Function to view logs
view_logs() {
    if [ -z "$1" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs -f
    else
        print_status "Showing logs for $1..."
        docker-compose logs -f "$1"
    fi
}

# Function to check service health
check_health() {
    print_status "Checking service health..."
    
    # Check PostgreSQL
    if docker-compose exec postgres pg_isready -U postgres > /dev/null 2>&1; then
        print_success "PostgreSQL is healthy"
    else
        print_error "PostgreSQL is not healthy"
    fi
    
    # Check Redis
    if docker-compose exec redis redis-cli ping > /dev/null 2>&1; then
        print_success "Redis is healthy"
    else
        print_error "Redis is not healthy"
    fi
    
    # Check Application
    if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
        print_success "Application is healthy"
    else
        print_error "Application is not healthy"
    fi
}

# Function to clean up Docker resources
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker-compose down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to show help
show_help() {
    echo "Docker Development Script for Ecommerce Application"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build the application"
    echo "  start       Start all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  logs        View logs for all services"
    echo "  logs <svc>  View logs for specific service (app, postgres, redis, nginx)"
    echo "  health      Check health of all services"
    echo "  cleanup     Stop services and clean up Docker resources"
    echo "  shell       Open shell in application container"
    echo "  db          Connect to PostgreSQL database"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs app"
    echo "  $0 health"
}

# Function to open shell in app container
open_shell() {
    print_status "Opening shell in application container..."
    docker-compose exec app /bin/sh
}

# Function to connect to database
connect_db() {
    print_status "Connecting to PostgreSQL database..."
    docker-compose exec postgres psql -U postgres -d ecommerce_db
}

# Main script logic
case "$1" in
    "build")
        check_docker
        build_app
        ;;
    "start")
        check_docker
        start_services
        print_status "Services are starting up..."
        sleep 10
        check_health
        print_success "Application is available at: http://localhost:8080"
        print_success "Swagger UI is available at: http://localhost:8080/swagger-ui.html"
        ;;
    "stop")
        check_docker
        stop_services
        ;;
    "restart")
        check_docker
        restart_services
        ;;
    "logs")
        check_docker
        view_logs "$2"
        ;;
    "health")
        check_docker
        check_health
        ;;
    "cleanup")
        check_docker
        cleanup
        ;;
    "shell")
        check_docker
        open_shell
        ;;
    "db")
        check_docker
        connect_db
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    "")
        print_warning "No command specified. Use 'help' to see available commands."
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
