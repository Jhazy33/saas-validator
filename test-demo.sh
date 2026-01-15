#!/usr/bin/env bash

# Demo environment variables (NOT real keys)
export GOOGLE_API_KEY="demo-key-for-testing"
export SUPABASE_URL="https://demo-project.supabase.co"
export SUPABASE_ANON_KEY="demo-anon-key"
export VERCEL_TOKEN="demo-vercel-token"

echo "🧪 Running SaaS Validation System Demo..."
echo ""
echo "This will demonstrate the workflow without making actual deployments"
echo ""

# Check tools
echo "📦 Checking installed tools..."
for tool in fabric gemini supabase vercel; do
  if command -v $tool >/dev/null 2>&1; then
    echo "  ✅ $tool: $(which $tool)"
  else
    echo "  ❌ $tool: NOT installed"
  fi
done

echo ""
echo "⚠️  Note: This is a DEMONSTRATION mode"
echo "   - No real API calls will be made"
echo "   - No real deployments will occur"
echo "   - Missing tools (stitch, anti-gravity) will use fallbacks"
echo ""
echo "🚀 Ready to run validation script!"
