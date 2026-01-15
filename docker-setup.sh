#!/bin/bash

# SaaS Validator - Docker Setup Script
# This script helps you set up and run the Docker environment locally

set -e

echo "🚀 SaaS Validator - Docker Setup"
echo "================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop first:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Desktop first:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo "⚠️  Please edit .env and add your API keys before continuing!"
    echo ""
    read -p "Press Enter after you've updated .env with your API keys..."
fi

# Parse command line arguments
COMMAND=${1:-"help"}

case $COMMAND in
    start|up)
        echo "🐳 Starting Docker containers..."
        docker-compose up -d
        echo ""
        echo "✅ Containers started!"
        echo ""
        echo "🌐 Access the application at:"
        echo "   Web App:        http://localhost:3000"
        echo "   Mailhog:        http://localhost:8025"
        echo "   pgAdmin:        http://localhost:5050 (admin@saas-validator.com / admin)"
        echo ""
        echo "📋 View logs with: docker-compose logs -f app"
        ;;

    stop|down)
        echo "🛑 Stopping Docker containers..."
        docker-compose down
        echo "✅ Containers stopped!"
        ;;

    restart)
        echo "🔄 Restarting Docker containers..."
        docker-compose restart
        echo "✅ Containers restarted!"
        ;;

    logs)
        echo "📋 Showing logs (press Ctrl+C to exit)..."
        docker-compose logs -f app
        ;;

    build)
        echo "🔨 Building Docker images..."
        docker-compose build
        echo "✅ Build complete!"
        ;;

    rebuild)
        echo "🔨 Rebuilding Docker images from scratch..."
        docker-compose build --no-cache
        echo "✅ Rebuild complete!"
        ;;

    clean)
        echo "🧹 Cleaning up Docker containers, volumes, and images..."
        read -p "⚠️  This will delete all data. Are you sure? (yes/no): " CONFIRM
        if [ "$CONFIRM" = "yes" ]; then
            docker-compose down -v
            docker system prune -f
            echo "✅ Cleanup complete!"
        else
            echo "❌ Cleanup cancelled"
        fi
        ;;

    status)
        echo "📊 Docker Container Status:"
        echo ""
        docker-compose ps
        ;;

    shell|sh)
        echo "🐚 Opening shell in app container..."
        docker-compose exec app sh
        ;;

    db)
        echo "🗄️  Opening PostgreSQL shell..."
        docker-compose exec postgres psql -U postgres -d saas_validator
        ;;

    redis)
        echo "📦 Opening Redis CLI..."
        docker-compose exec redis redis-cli
        ;;

    install)
        echo "📦 Installing dependencies..."
        docker-compose run --rm app npm install
        echo "✅ Dependencies installed!"
        ;;

    test)
        echo "🧪 Running tests..."
        docker-compose run --rm app npm test
        ;;

    help|*)
        echo "Usage: ./docker-setup.sh [command]"
        echo ""
        echo "Commands:"
        echo "   start, up       Start Docker containers"
        echo "   stop, down      Stop Docker containers"
        echo "   restart         Restart Docker containers"
        echo "   logs            Show application logs"
        echo "   build           Build Docker images"
        echo "   rebuild         Rebuild Docker images from scratch"
        echo "   clean           Remove all containers, volumes, and images"
        echo "   status          Show container status"
        echo "   shell, sh       Open shell in app container"
        echo "   db              Open PostgreSQL shell"
        echo "   redis           Open Redis CLI"
        echo "   install         Install npm dependencies"
        echo "   test            Run tests"
        echo "   help            Show this help message"
        echo ""
        echo "Quick Start:"
        echo "   1. Edit .env with your API keys"
        echo "   2. Run: ./docker-setup.sh start"
        echo "   3. Open: http://localhost:3000"
        ;;
esac
