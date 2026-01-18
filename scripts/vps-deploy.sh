#!/bin/bash

# SaaS Validator - VPS Deployment Script
# For Contabo VPS with SSH on port 2222

set -e

echo "🚀 SaaS Validator - VPS Deployment"
echo "===================================="
echo ""

# Configuration
VPS_HOST=""
VPS_USER="root"
VPS_PORT="2222"
APP_NAME="saas-validator"
APP_DIR="/var/www/$APP_NAME"
GIT_REPO="https://github.com/Jhazy33/saas-validator.git"

# Parse command line arguments
COMMAND=${1:-"help"}

case $COMMAND in
    deploy)
        echo "📦 Deploying to VPS..."

        # Check if VPS_HOST is set
        if [ -z "$VPS_HOST" ]; then
            echo "❌ VPS_HOST not set. Please export VPS_HOST environment variable:"
            echo "   export VPS_HOST=your.vps.ip.address"
            exit 1
        fi

        echo "🌐 Connecting to $VPS_HOST:$VPS_PORT..."

        # SSH commands to run on VPS
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
            set -e

            echo "📥 Updating system packages..."
            apt-get update && apt-get upgrade -y

            echo "🔧 Installing dependencies..."
            apt-get install -y curl git nginx ufw

            echo "🐳 Installing Docker..."
            if ! command -v docker &> /dev/null; then
                curl -fsSL https://get.docker.com -o get-docker.sh
                sh get-docker.sh
                usermod -aG docker root
            fi

            echo "📦 Installing Docker Compose..."
            if ! command -v docker compose &> /dev/null; then
                curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose
            fi

            echo "📁 Creating application directory..."
            mkdir -p $APP_DIR
            cd $APP_DIR

            if [ -d ".git" ]; then
                echo "🔄 Pulling latest changes..."
                git pull origin main
            else
                echo "📥 Cloning repository..."
                git clone $GIT_REPO .
            fi

            echo "🔐 Checking for .env file..."
            if [ ! -f .env ]; then
                echo "⚠️  .env file not found. Creating from template..."
                cp .env.example .env
                echo "❗ Please edit .env on the server with your production API keys!"
                echo "   Command: nano $APP_DIR/.env"
                exit 1
            fi

            echo "🐳 Building Docker containers..."
            docker compose build

            echo "🔄 Restarting services..."
            docker compose down
            docker compose up -d

            echo "✅ Deployment successful!"
            echo ""
            echo "📊 Service status:"
            docker compose ps

ENDSSH

        echo ""
        echo "✅ Deployment completed!"
        echo ""
        echo "🌐 Your application should be live at:"
        echo "   http://$VPS_HOST"
        ;;

    logs)
        echo "📋 Showing logs (press Ctrl+C to exit)..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "cd $APP_DIR && docker compose logs -f app"
        ;;

    status)
        echo "📊 Checking service status..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "cd $APP_DIR && docker compose ps"
        ;;

    restart)
        echo "🔄 Restarting services..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "cd $APP_DIR && docker compose restart"
        echo "✅ Services restarted!"
        ;;

    stop)
        echo "🛑 Stopping services..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "cd $APP_DIR && docker compose down"
        echo "✅ Services stopped!"
        ;;

    start)
        echo "▶️  Starting services..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "cd $APP_DIR && docker compose up -d"
        echo "✅ Services started!"
        ;;

    shell)
        echo "🐚 Opening shell on VPS..."
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST
        ;;

    backup)
        echo "💾 Creating backup..."
        BACKUP_DIR="/var/backups/$APP_NAME"
        BACKUP_FILE="$APP_NAME-$(date +%Y%m%d-%H%M%S).tar.gz"

        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << ENDSSH
            mkdir -p $BACKUP_DIR
            cd $APP_DIR
            tar -czf $BACKUP_DIR/$BACKUP_FILE \
                .env \
                docker-compose.yml \
                Dockerfile \
                package.json \
                app/ \
                lib/ \
                components/

            echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE"
            ls -lh $BACKUP_DIR/$BACKUP_FILE
ENDSSH
        ;;

    setup-ssl)
        echo "🔒 Setting up SSL with Let's Encrypt..."
        read -p "Enter your domain name: " DOMAIN

        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << ENDSSH
            apt-get install -y certbot python3-certbot-nginx

            # Configure Nginx
            cat > /etc/nginx/sites-available/$APP_NAME << 'EOF'
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

            ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
            nginx -t
            systemctl restart nginx

            # Get SSL certificate
            certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

            echo "✅ SSL configured successfully!"
ENDSSH
        ;;

    monitor)
        echo "📊 System resources:"
        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
            echo "CPU & Memory:"
            free -h
            echo ""
            echo "Disk Usage:"
            df -h
            echo ""
            echo "Docker Stats:"
            docker stats --no-stream
ENDSSH
        ;;

    update)
        echo "⬇️  Pulling latest changes and rebuilding..."

        ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
            cd $APP_DIR
            git pull origin main
            docker compose build
            docker compose up -d
            echo "✅ Update completed!"
ENDSSH
        ;;

    help|*)
        echo "Usage: ./scripts/vps-deploy.sh [command]"
        echo ""
        echo "Prerequisites:"
        echo "   export VPS_HOST=your.vps.ip.address"
        echo "   export VPS_USER=root  (default: root)"
        echo "   export VPS_PORT=2222  (default: 2222)"
        echo ""
        echo "Commands:"
        echo "   deploy      Deploy to VPS (first time or update)"
        echo "   logs        Show application logs"
        echo "   status      Show service status"
        echo "   restart     Restart services"
        echo "   start       Start services"
        echo "   stop        Stop services"
        echo "   shell       Open SSH shell on VPS"
        echo "   backup      Create backup of application"
        echo "   setup-ssl   Setup SSL certificate (requires domain)"
        echo "   monitor     Show system resource usage"
        echo "   update      Pull latest changes and rebuild"
        echo "   help        Show this help message"
        echo ""
        echo "Quick Start:"
        echo "   1. Set VPS_HOST environment variable"
        echo "   2. Run: ./scripts/vps-deploy.sh deploy"
        echo "   3. Monitor: ./scripts/vps-deploy.sh logs"
        ;;
esac
