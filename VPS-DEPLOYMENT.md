# VPS Deployment Guide

## Overview

This guide covers deploying SaaS Validator to a Contabo VPS using Docker and SSH.

## Prerequisites

- **VPS Server**: Contabo VPS with Ubuntu 20.04+ or Debian 11+
- **SSH Access**: SSH credentials with port 2222
- **Domain Name** (optional): For SSL setup
- **API Keys**: Production API keys (Supabase, Google Gemini, etc.)

## Initial Setup

### 1. Prepare Environment Variables

Create a production `.env` file template:

```bash
# On your local machine
cat > .env.production << EOF
# Supabase
SUPABASE_URL=your_production_supabase_url
SUPABASE_ANON_KEY=your_production_supabase_key
NEXT_PUBLIC_SUPABASE_URL=your_production_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_production_supabase_key

# Google AI
GOOGLE_API_KEY=your_production_google_api_key

# Application
NEXT_PUBLIC_APP_URL=https://your-domain.com
NODE_ENV=production

# Database
DATABASE_URL=postgresql://postgres:password@localhost:5432/saas_validator

# Redis
REDIS_URL=redis://localhost:6379
EOF
```

### 2. Set VPS Connection Environment

```bash
# Set your VPS details
export VPS_HOST="your.vps.ip.address"
export VPS_USER="root"
export VPS_PORT="2222"

# Test SSH connection
ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "echo 'Connection successful'"
```

### 3. Run Initial Deployment

```bash
# Deploy to VPS
./scripts/vps-deploy.sh deploy
```

This will:
- Update system packages
- Install Docker and Docker Compose
- Clone the repository
- Build Docker containers
- Start services

## Deployment Commands

### Deploy for the First Time

```bash
export VPS_HOST="your.vps.ip.address"
./scripts/vps-deploy.sh deploy
```

### Update Existing Deployment

```bash
# Pull latest changes and rebuild
./scripts/vps-deploy.sh update
```

### View Logs

```bash
# Follow logs in real-time
./scripts/vps-deploy.sh logs

# Or SSH directly and view logs
ssh -p 2222 root@YOUR_VPS_IP
cd /var/www/saas-validator
docker compose logs -f app
```

### Check Service Status

```bash
./scripts/vps-deploy.sh status
```

### Restart Services

```bash
./scripts/vps-deploy.sh restart
```

### Stop/Start Services

```bash
# Stop
./scripts/vps-deploy.sh stop

# Start
./scripts/vps-deploy.sh start
```

## SSL/HTTPS Setup

### Using Let's Encrypt (Free)

```bash
./scripts/vps-deploy.sh setup-ssl
```

You'll be prompted for your domain name. The script will:
- Install Nginx
- Configure reverse proxy
- Obtain SSL certificate
- Set up automatic renewal

### Manual Nginx Configuration

If you need custom Nginx configuration:

```bash
# SSH into VPS
ssh -p 2222 root@YOUR_VPS_IP

# Edit Nginx config
nano /etc/nginx/sites-available/saas-validator
```

Example Nginx configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Database Management

### Access PostgreSQL

```bash
# SSH into VPS
ssh -p 2222 root@YOUR_VPS_IP

# Access PostgreSQL container
docker exec -it saas-validator-postgres psql -U postgres -d saas_validator

# Or use the script
./scripts/vps-deploy.sh shell
# Then inside: docker exec -it saas-validator-postgres psql -U postgres -d saas_validator
```

### Backup Database

```bash
ssh -p 2222 root@YOUR_VPS_IP << 'EOF'
docker exec saas-validator-postgres pg_dump -U postgres saas_validator > backup.sql
EOF
```

### Restore Database

```bash
scp backup.sql root@YOUR_VPS_IP:/tmp/
ssh -p 2222 root@YOUR_VPS_IP
docker exec -i saas-validator-postgres psql -U postgres saas_validator < /tmp/backup.sql
```

## Monitoring

### System Resources

```bash
./scripts/vps-deploy.sh monitor
```

### Docker Logs

```bash
# Application logs
docker compose logs -f app

# Database logs
docker compose logs -f postgres

# All services
docker compose logs -f
```

### PM2-style Process Management (Alternative)

If you prefer PM2 over Docker Compose:

```bash
# On VPS
npm install -g pm2

# Start application
pm2 start npm --name "saas-validator" -- start

# Monitor
pm2 monit

# View logs
pm2 logs saas-validator

# Restart
pm2 restart saas-validator
```

## Security Best Practices

### 1. Firewall Configuration

```bash
# SSH into VPS
ssh -p 2222 root@YOUR_VPS_IP

# Configure UFW firewall
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 2222/tcp  # Custom SSH port
ufw enable
```

### 2. SSH Hardening

Edit `/etc/ssh/sshd_config`:

```bash
# Disable root login (create user first)
PermitRootLogin no

# Disable password authentication (use SSH keys)
PasswordAuthentication no

# Change SSH port (already 2222)
Port 2222
```

Restart SSH:

```bash
systemctl restart sshd
```

### 3. Automatic Updates

```bash
# Install unattended-upgrades
apt-get install unattended-upgrades

# Configure automatic security updates
dpkg-reconfigure -plow unattended-upgrades
```

## Backup Strategy

### Application Backup

```bash
./scripts/vps-deploy.sh backup
```

Manual backup:

```bash
ssh -p 2222 root@YOUR_VPS_IP
cd /var/www/saas-validator
tar -czf /var/backups/saas-validator-$(date +%Y%m%d).tar.gz \
    .env \
    docker-compose.yml \
    Dockerfile \
    package.json \
    app/ \
    lib/ \
    components/
```

### Automated Backups (Cron)

```bash
# SSH into VPS
crontab -e

# Add daily backup at 2 AM
0 2 * * * cd /var/www/saas-validator && tar -czf /var/backups/saas-validator-$(date +\%Y\%m\%d).tar.gz .env docker-compose.yml app/ lib/ && find /var/backups/ -name "saas-validator-*" -mtime +7 -delete
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker compose logs app

# Check container status
docker compose ps

# Restart container
docker compose restart app
```

### Out of Memory

```bash
# Check memory usage
free -h

# Add swap space (if needed)
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

### Port Already in Use

```bash
# Check what's using the port
netstat -tulpn | grep :3000

# Kill the process
kill -9 <PID>
```

### Docker Build Fails

```bash
# Clean Docker cache
docker system prune -a

# Rebuild from scratch
docker compose build --no-cache
```

## Performance Optimization

### 1. Enable Nginx Caching

```nginx
# Add to Nginx config
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m;

location / {
    proxy_cache my_cache;
    proxy_pass http://localhost:3000;
    # ... other proxy settings
}
```

### 2. Optimize Docker Resources

Edit `/var/www/saas-validator/docker-compose.yml`:

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### 3. Enable Redis Caching

Already included in docker-compose.yml. Configure in your application:

```javascript
import { createClient } from 'redis'

const redis = createClient({
  url: process.env.REDIS_URL
})

await redis.connect()
```

## Scaling

### Vertical Scaling (More Resources)

Upgrade your Contabo VPS plan in the dashboard, then restart services.

### Horizontal Scaling (Multiple Servers)

1. Set up a load balancer (Nginx)
2. Deploy multiple app instances
3. Use shared PostgreSQL and Redis

Example Nginx load balancer:

```nginx
upstream backend {
    server server1:3000;
    server server2:3000;
    server server3:3000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

## Rollback

If something goes wrong:

```bash
# SSH into VPS
ssh -p 2222 root@YOUR_VPS_IP

# Revert to previous Git commit
cd /var/www/saas-validator
git log --oneline  # Find previous commit hash
git checkout <previous-commit-hash>

# Rebuild and restart
docker compose build
docker compose up -d
```

Or restore from backup:

```bash
cd /var/www/saas-validator
tar -xzf /var/backups/saas-validator-YYYYMMDD.tar.gz
docker compose restart
```

## Cost Monitoring

### Contabo VPS Pricing

- VPS S: €6.99/month (4GB RAM, 2 CPU cores, 200GB SSD)
- VPS M: €9.99/month (8GB RAM, 4 CPU cores, 400GB SSD)
- VPS L: €14.99/month (16GB RAM, 6 CPU cores, 800GB SSD)

Recommendation: Start with VPS S, upgrade if needed.

### Monitoring Costs

Use Contabo dashboard to monitor:
- Bandwidth usage
- CPU usage
- Disk space

## Next Steps

After successful deployment:

1. ✅ Verify application is accessible
2. ✅ Test all core functionality
3. ✅ Set up monitoring (Uptime monitoring)
4. ✅ Configure backup automation
5. ✅ Set up error tracking (Sentry, etc.)
6. ✅ Configure CDN (Cloudflare, optional)

## Support

For issues or questions:
- GitHub Issues: https://github.com/Jhazy33/saas-validator/issues
- Documentation: See LOCAL-SETUP.md for local development

---

**Remember**: Always test changes locally first before deploying to VPS!
