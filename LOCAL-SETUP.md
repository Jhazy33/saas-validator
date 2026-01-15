# Local Development Setup

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker Desktop** (Mac/Windows) or **Docker Engine** (Linux)
  - Download: https://www.docker.com/products/docker-desktop
- **Git**
  - Mac: Pre-installed or install via Xcode Command Line Tools
  - Windows: https://git-scm.com/download/win
- **GitHub Account** (optional, if you want to push changes)

## Quick Start (5 Minutes)

### 1. Clone the Repository

```bash
git clone https://github.com/Jhazy33/saas-validator.git
cd saas-validator
```

### 2. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your API keys
nano .env  # or use your preferred editor
```

**Required API Keys:**

- **Supabase** (Authentication & Database)
  - Sign up: https://supabase.com
  - Create a new project
  - Copy Project URL and anon key to `.env`

- **Google Gemini** (AI Processing)
  - Get API key: https://ai.google.dev
  - Copy to `.env` as `GOOGLE_API_KEY`

- **Stripe** (Payments - Optional for MVP)
  - Sign up: https://stripe.com
  - Get test keys from Dashboard → Developers → API keys
  - Copy to `.env`

### 3. Start Docker Containers

```bash
# Make setup script executable (first time only)
chmod +x docker-setup.sh

# Start all services
./docker-setup.sh start
```

This will start:
- **Next.js App** (port 3000)
- **PostgreSQL Database** (port 5432)
- **Redis Cache** (port 6379)
- **Mailhog** (Email testing - port 8025)
- **pgAdmin** (Database management - port 5050)

### 4. Access the Application

Open your browser and navigate to:

- **Web App:** http://localhost:3000
- **Mailhog** (email testing): http://localhost:8025
- **pgAdmin** (database): http://localhost:5050
  - Email: admin@saas-validator.com
  - Password: admin

## Development Workflow

### View Logs

```bash
# Follow logs in real-time
./docker-setup.sh logs

# Or use Docker Compose directly
docker-compose logs -f app
```

### Run Commands Inside Container

```bash
# Open shell in container
./docker-setup.sh shell

# Once inside, run any npm command
npm run dev
npm test
npm run build
```

### Install New Dependencies

```bash
# Install packages
./docker-setup.sh install

# Or directly
docker-compose run --rm app npm install package-name
```

### Run Tests

```bash
./docker-setup.sh test
```

### Database Access

```bash
# PostgreSQL shell
./docker-setup.sh db

# Inside PostgreSQL
\dt                    # List tables
\q                     # Quit
```

### Redis Access

```bash
./docker-setup.sh redis

# Inside Redis
KEYS *                 # List all keys
GET keyname            # Get value
EXIT                   # Quit
```

## Common Commands

```bash
# Start containers
./docker-setup.sh start

# Stop containers
./docker-setup.sh stop

# Restart containers
./docker-setup.sh restart

# Rebuild images (after code changes)
./docker-setup.sh rebuild

# Check container status
./docker-setup.sh status

# Clean everything (deletes all data)
./docker-setup.sh clean
```

## Project Structure

```
saas-validator/
├── app/                    # Next.js 14 app directory
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Home page
│   └── globals.css        # Global styles
├── components/            # React components
│   └── ui/               # UI components
├── lib/                   # Utility libraries
│   ├── supabase.ts       # Supabase client
│   └── utils.ts          # Utility functions
├── public/               # Static assets
├── Dockerfile            # Docker image configuration
├── docker-compose.yml    # Docker services configuration
├── docker-setup.sh       # Setup helper script
├── package.json          # NPM dependencies
├── tsconfig.json         # TypeScript configuration
├── tailwind.config.ts    # Tailwind CSS configuration
├── next.config.js        # Next.js configuration
└── .env                  # Environment variables (not in git)
```

## Troubleshooting

### Port Already in Use

If you see errors about ports being in use:

```bash
# Check what's using the port
lsof -i :3000  # Check port 3000

# Kill the process
kill -9 <PID>
```

### Docker Build Fails

```bash
# Clean Docker cache
docker system prune -a

# Rebuild from scratch
./docker-setup.sh rebuild
```

### Container Won't Start

```bash
# Check logs
docker-compose logs app

# Restart containers
./docker-setup.sh restart
```

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Restart PostgreSQL
docker-compose restart postgres
```

### Need to Reset Everything?

```bash
# Stop and remove all containers, volumes, and images
./docker-setup.sh clean

# Start fresh
./docker-setup.sh start
```

## Development Tips

### Hot Reload

The development server supports hot reload. Changes to code will automatically reflect in the browser.

### Debugging

1. **View logs:** `./docker-setup.sh logs`
2. **Open shell:** `./docker-setup.sh shell`
3. **Check container status:** `./docker-setup.sh status`

### Database Migrations

If you're using Supabase migrations:

```bash
# Generate types
npm run db:generate

# Push migrations
npm run db:push

# Open Supabase Studio
npm run db:studio
```

## Next Steps

1. ✅ **Complete Local Setup** (you are here)
2. 📖 **Read FRONTEND-SPEC.md** - Complete UI specification
3. 🎨 **Build Frontend** - Use Google Stitch or build manually
4. 🧪 **Test Locally** - Verify all features work
5. 🚀 **Deploy to VPS** - See DEPLOYMENT.md

## Getting Help

- **Documentation:** Check the `/docs` folder
- **Issues:** https://github.com/Jhazy33/saas-validator/issues
- **Docker Logs:** `./docker-setup.sh logs`

## Environment Variables Reference

See `.env.example` for all available variables. Key variables:

```bash
# Supabase (Required)
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key

# Google AI (Required)
GOOGLE_API_KEY=your_gemini_key

# Application
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development

# Database (for direct connection)
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/saas_validator

# Redis
REDIS_URL=redis://redis:6379
```

## Performance Tips

1. **Allocate enough RAM to Docker:** Minimum 4GB, recommended 8GB
2. **Use SSD storage:** Significantly faster than HDD
3. **Close unused containers:** `docker-compose stop` to free resources
4. **Monitor resources:** Docker Desktop Dashboard → Containers

---

**Ready to build?** Start the development server:

```bash
./docker-setup.sh start
```

Then open http://localhost:3000 in your browser! 🚀
