#!/bin/bash

# Docker Infrastructure Validation Script
# Tests if Docker environment is ready BEFORE adding API keys

echo "🐳 Docker Infrastructure Validation"
echo "===================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS_COUNT=0
FAIL_COUNT=0

check_pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((PASS_COUNT++))
}

check_fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((FAIL_COUNT++))
}

check_warn() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
}

# Test 1: Docker Installation
echo "1️⃣  Checking Docker Installation..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
    check_pass "Docker installed (version $DOCKER_VERSION)"
else
    check_fail "Docker is not installed"
    echo ""
    echo "Install Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Test 2: Docker Compose
echo ""
echo "2️⃣  Checking Docker Compose..."
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version --short 2>/dev/null || echo "unknown")
    check_pass "Docker Compose available (version $COMPOSE_VERSION)"
    DOCKER_COMPOSE="docker compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version | awk '{print $3}' | sed 's/,//')
    check_pass "Docker Compose available (version $COMPOSE_VERSION - standalone)"
    DOCKER_COMPOSE="docker-compose"
else
    check_fail "Docker Compose not available"
    exit 1
fi

# Test 3: Docker Daemon Running
echo ""
echo "3️⃣  Checking Docker Daemon..."
if docker info &> /dev/null; then
    check_pass "Docker daemon is running"
else
    check_fail "Docker daemon is not running"
    echo ""
    echo "Start Docker Desktop application"
    exit 1
fi

# Test 4: Docker Build
echo ""
echo "4️⃣  Testing Docker Build (this may take a minute)..."
cd "$(dirname "$0")/.."

if docker compose build app --no-cache 2>&1 | grep -q "Successfully built\|DONE"; then
    check_pass "Docker image builds successfully"
else
    check_fail "Docker build failed"
    echo ""
    echo "Run: docker compose build app"
    echo "Check the error messages above"
fi

# Test 5: Docker Compose Configuration
echo ""
echo "5️⃣  Validating docker-compose.yml..."
if docker compose config &> /dev/null; then
    check_pass "docker-compose.yml syntax is valid"
else
    check_fail "docker-compose.yml has syntax errors"
fi

# Test 6: Required Files Exist
echo ""
echo "6️⃣  Checking Required Files..."
REQUIRED_FILES=(
    "Dockerfile"
    "docker-compose.yml"
    ".env"
    "package.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        check_pass "$file exists"
    else
        check_fail "$file missing"
    fi
done

# Test 7: Ports Available
echo ""
echo "7️⃣  Checking Port Availability..."
PORTS=(3000 5432 6379 8025 5050)
PORTS_AVAILABLE=true

for port in "${PORTS[@]}"; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        check_warn "Port $port is already in use"
        PORTS_AVAILABLE=false
    else
        check_pass "Port $port is available"
    fi
done

if [ "$PORTS_AVAILABLE" = false ]; then
    echo ""
    echo "⚠️  Some ports are in use. This may cause conflicts."
    echo "   Stop services using these ports or proceed with caution."
fi

# Test 8: Disk Space
echo ""
echo "8️⃣  Checking Disk Space..."
AVAILABLE_GB=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_GB" -gt 10 ]; then
    check_pass "Sufficient disk space (${AVAILABLE_GB}GB available)"
else
    check_warn "Low disk space (${AVAILABLE_GB}GB available, recommend 10GB+)"
fi

# Test 9: Memory (Docker Desktop only on Mac)
echo ""
echo "9️⃣  Checking Docker Resources..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DOCKER_MEMORY=$(docker system info 2>/dev/null | grep "Total Memory" | awk '{print $3}' || echo "unknown")
    if [[ "$DOCKER_MEMORY" == *"GiB"* ]]; then
        MEMORY_VALUE=$(echo $DOCKER_MEMORY | sed 's/GiB//')
        if (( $(echo "$MEMORY_VALUE >= 4" | bc -l) )); then
            check_pass "Docker memory configured (${DOCKER_MEMORY})"
        else
            check_warn "Low Docker memory (${DOCKER_MEMORY}, recommend 4GB+)"
        fi
    else
        check_warn "Could not determine Docker memory allocation"
    fi
else
    check_pass "Memory check (Linux - system managed)"
fi

# Test 10: .gitignore Protection
echo ""
echo "🔟 Checking .gitignore Protection..."
if [ -f ".gitignore" ]; then
    if grep -q "^\.env$" .gitignore; then
        check_pass ".env is in .gitignore"
    else
        check_fail ".env is NOT in .gitignore (security risk!)"
    fi

    if grep -q "secrets" .gitignore || grep -q "\*key\*" .gitignore; then
        check_pass "API key patterns in .gitignore"
    else
        check_warn "Limited API key patterns in .gitignore"
    fi
else
    check_fail ".gitignore file missing"
fi

# Summary
echo ""
echo "===================================="
echo "📊 VALIDATION SUMMARY"
echo "===================================="
echo ""
echo -e "${GREEN}Passed:${NC}   $PASS_COUNT"
echo -e "${RED}Failed:${NC}   $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Your Docker environment is ready!"
    echo ""
    echo "📝 Next Steps:"
    echo "   1. Get API keys (see API-SETUP-GUIDE.md)"
    echo "   2. Update .env with your API keys"
    echo "   3. Start services: ./docker-setup.sh start"
    echo ""
    echo "🌐 Services will run on:"
    echo "   • Web App:   http://localhost:3000"
    echo "   • Mailhog:   http://localhost:8025"
    echo "   • pgAdmin:   http://localhost:5050"
    exit 0
else
    echo -e "${RED}❌ VALIDATION FAILED${NC}"
    echo ""
    echo "Please fix the $FAIL_COUNT failed check(s) above before proceeding."
    echo ""
    echo "Common fixes:"
    echo "  • Docker not running: Start Docker Desktop"
    echo "  • Port conflicts: Stop other services using ports 3000, 5432, 6379"
    echo "  • Build failures: Check Dockerfile and package.json"
    exit 1
fi
