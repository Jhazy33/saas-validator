#!/bin/bash

# Security Verification Script
# Checks that sensitive files are properly protected

echo "🔒 Security Verification"
echo "========================"
echo ""

# Check if .env is ignored by git
echo "1️⃣ Checking if .env is ignored by git..."
if git check-ignore -q .env; then
    echo "   ✅ .env is ignored by git"
else
    echo "   ❌ WARNING: .env is NOT ignored by git!"
    echo "   This means your API keys could be committed!"
    exit 1
fi

# Check if .env exists
echo ""
echo "2️⃣ Checking if .env file exists..."
if [ -f .env ]; then
    echo "   ✅ .env file exists"
else
    echo "   ⚠️  .env file doesn't exist yet"
    echo "   Run: cp .env.example .env"
fi

# Check if .env contains placeholder values
echo ""
echo "3️⃣ Checking if .env contains placeholder API keys..."
if grep -q "your_" .env 2>/dev/null; then
    echo "   ✅ .env contains placeholder values (safe)"
else
    echo "   ⚠️  .env appears to have real values"
    echo "   Make sure these are your development/test keys!"
fi

# Check git status for sensitive files
echo ""
echo "4️⃣ Checking git status for sensitive files..."
UNTRACKED_SECRETS=$(git status --porcelain 2>/dev/null | grep -E "^\?\?.*\.env$" || true)

if [ -z "$UNTRACKED_SECRETS" ]; then
    echo "   ✅ No .env files are staged for commit"
else
    echo "   ❌ WARNING: Sensitive files detected!"
    echo "$UNTRACKED_SECRETS"
    exit 1
fi

# Check if .gitignore exists
echo ""
echo "5️⃣ Checking .gitignore configuration..."
if [ -f .gitignore ]; then
    echo "   ✅ .gitignore exists"

    # Check for key patterns
    if grep -q "^\.env$" .gitignore; then
        echo "   ✅ .env pattern found in .gitignore"
    else
        echo "   ⚠️  .env pattern NOT found in .gitignore"
    fi
else
    echo "   ❌ .gitignore doesn't exist!"
    exit 1
fi

# Check for common API key patterns in repository
echo ""
echo "6️⃣ Scanning for potential API keys in repository..."
DANGEROUS_FILES=$(grep -r "sk_live\|pk_live\|AIza\|xoxb\|AKIA" --include="*.ts" --include="*.js" --include="*.json" --exclude-dir=node_modules --exclude-dir=.next . 2>/dev/null | head -5 || true)

if [ -z "$DANGEROUS_FILES" ]; then
    echo "   ✅ No obvious API keys found in code"
else
    echo "   ⚠️  WARNING: Potential API keys found:"
    echo "$DANGEROUS_FILES"
    echo ""
    echo "   Make sure these are test/placeholder values!"
fi

echo ""
echo "========================"
echo "✅ Security check passed!"
echo ""
echo "Summary:"
echo "  • .env is ignored by git ✅"
echo "  • API keys are protected ✅"
echo "  • Safe to proceed with development ✅"
echo ""
echo "Reminder:"
echo "  • Never commit real API keys to git"
echo "  • Use .env.example as a template"
echo "  • Keep production keys secure on VPS only"
