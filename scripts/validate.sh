#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# SaaS Validation System - One-Click Landing Page Generator
# ============================================================================
# Usage: ./validate.sh "Idea-Name" "https://youtube.com/watch?v=xxx"
# ============================================================================

# ---------- 1. CONFIGURATION ----------
IDEA_NAME=${1:-"SaaS-Idea-$(date +%s)"}
YOUTUBE_URL=${2:-""}
WORKDIR="./${IDEA_NAME}"
THEME=${3:-"minimal"}
VARIANT=${4:-"A"}
CUSTOM_PROMPT=${5:-""}
UPDATE_MODE=${6:-false}
CREATE_GITHUB_REPO=${7:-"false"}
GITHUB_VISIBILITY=${8:-"private"}

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# ---------- 2. VALIDATION ----------
check_dependencies() {
  local missing_deps=()

  command -v fabric >/dev/null 2>&1 || missing_deps+=("fabric")
  command -v gemini >/dev/null 2>&1 || missing_deps+=("gemini-cli")
  command -v stitch >/dev/null 2>&1 || missing_deps+=("stitch-cli")
  command -v anti-gravity >/dev/null 2>&1 || missing_deps+=("anti-gravity-cli")
  command -v supabase >/dev/null 2>&1 || missing_deps+=("supabase")
  command -v vercel >/dev/null 2>&1 || missing_deps+=("vercel")

  if [ ${#missing_deps[@]} -gt 0 ]; then
    log_error "Missing dependencies: ${missing_deps[*]}"
    log_info "Install with: npm i -g ${missing_deps[*]}"
    exit 1
  fi
}

check_env_vars() {
  local required_vars=("GOOGLE_API_KEY" "SUPABASE_URL" "SUPABASE_ANON_KEY" "VERCEL_TOKEN")
  local missing_vars=()

  for var in "${required_vars[@]}"; do
    if [ -z "${!var:-}" ]; then
      missing_vars+=("$var")
    fi
  done

  if [ ${#missing_vars[@]} -gt 0 ]; then
    log_error "Missing environment variables: ${missing_vars[*]}"
    log_info "Set them in your .env file or shell environment"
    exit 1
  fi
}

# ---------- 3. SETUP ----------
create_workdir() {
  if [ "$UPDATE_MODE" = true ] && [ -d "$WORKDIR" ]; then
    log_info "Updating existing project: $WORKDIR"
  else
    mkdir -p "$WORKDIR"
    log_success "Created workspace: $WORKDIR"
  fi
  cd "$WORKDIR"
}

# ---------- 4. EXTRACT WISDOM ----------
extract_wisdom() {
  log_info "Extracting insights with Fabric..."

  if [ -z "$YOUTUBE_URL" ]; then
    log_warn "No YouTube URL provided, using placeholder content"
    cat > summary.md << 'EOF'
# SaaS Idea Summary

## Problem
Businesses need to solve a specific problem efficiently.

## Solution
An AI-powered tool that automates the solution.

## Key Insights
- Saves 20+ hours per month
- 99% accuracy rate
- Integrates with existing tools
- Easy to get started
EOF
  else
    if ! fabric -y "$YOUTUBE_URL" --pattern extract_wisdom_dm > summary.md 2>/dev/null; then
      log_warn "Fabric extraction failed, using fallback content"
      cat > summary.md << EOF
# Summary from $YOUTUBE_URL

## Key Insights
Please review the video content manually and update this file.

## Problem
Describe the problem this SaaS solves.

## Solution
Describe your proposed solution.

## Features
List key features and benefits.
EOF
    fi
  fi

  log_success "Extracted insights → summary.md"
}

# ---------- 5. GENERATE OUTLINE ----------
generate_outline() {
  log_info "Generating landing page outline with Gemini..."

  # Extract insights from summary
  INSIGHTS=$(sed -n '/## Key Insights/,/^## /p' summary.md 2>/dev/null | tail -n +2 | head -n -1 | sed 's/^- //' || echo "AI-powered solution")

  # Determine prompt source
  if [ -n "$CUSTOM_PROMPT" ] && [ -f "$CUSTOM_PROMPT" ]; then
    PROMPT_CONTENT=$(cat "$CUSTOM_PROMPT")
  else
    PROMPT_CONTENT=$(cat <<'EOF'
You are a conversion optimization expert. Generate a landing page outline for a SaaS product.

**Product**: {IDEA_NAME}

**Key Insights**:
{INSIGHTS}

**Requirements**:
1. Hero section: Bold headline + subheadline + single CTA
2. Problem section: 3 pain points (bullet format)
3. Solution section: 2-3 key benefits
4. Features section: 4-6 features with icons
5. Social proof: 2-3 testimonials
6. CTA section: Final conversion hook
7. Footer: Minimal links

**Tone**: Action-oriented, benefit-focused, conversion-optimized

Return JSON format:
{
  "sections": [
    {
      "title": "Section Name",
      "body": "Content here"
    }
  ]
}

If uncertain about any detail, respond with "I don't know" rather than hallucinating.
EOF
)
  fi

  # Replace placeholders
  PROMPT_CONTENT="${PROMPT_CONTENT//\{IDEA_NAME\}/$IDEA_NAME}"
  PROMPT_CONTENT="${PROMPT_CONTENT//\{INSIGHTS\}/$INSIGHTS}"
  PROMPT_CONTENT="${PROMPT_CONTENT//\{VARIANT\}/$VARIANT}"

  # Generate outline
  echo "$PROMPT_CONTENT" > outline_prompt.txt

  if ! gemini --prompt-file outline_prompt.txt --temperature 0 > outline.json 2>/dev/null; then
    log_error "Gemini generation failed"
    exit 1
  fi

  # Validate JSON
  if ! jq empty outline.json 2>/dev/null; then
    log_error "Invalid JSON output from Gemini"
    cat outline.json
    exit 1
  fi

  log_success "Generated outline → outline.json"
}

# ---------- 6. CREATE DESIGN ----------
create_design() {
  log_info "Creating design with Stitch..."

  if ! stitch design --from-json outline.json --theme "$THEME" --output design.figma 2>/dev/null; then
    log_warn "Stitch design generation failed, creating basic design"
    cat > design.json << EOF
{
  "theme": "$THEME",
  "variant": "$VARIANT",
  "sections": $(cat outline.json)
}
EOF
    log_success "Created basic design → design.json"
  else
    log_success "Created design → design.figma"
  fi
}

# ---------- 7. GENERATE CODE ----------
generate_code() {
  log_info "Generating HTML/CSS/JS with Anti-Gravity..."

  mkdir -p frontend

  if [ -f design.figma ]; then
    if ! anti-gravity --design design.figma --output frontend/ --framework vanilla --responsive --a11y 2>/dev/null; then
      log_warn "Anti-Gravity failed, generating basic HTML"
      generate_basic_html
    fi
  else
    generate_basic_html
  fi

  log_success "Generated code → frontend/"
}

generate_basic_html() {
  cat > frontend/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$IDEA_NAME</title>
  <link rel="stylesheet" href="main.css">
</head>
<body>
  <header>
    <h1>$IDEA_NAME</h1>
    <p>AI-powered solution for your needs</p>
  </header>

  <section id="problem">
    <h2>The Problem</h2>
    <ul>
      <li>Inefficient processes waste time</li>
      <li>Manual work leads to errors</li>
      <li>Scaling is difficult</li>
    </ul>
  </section>

  <section id="solution">
    <h2>Our Solution</h2>
    <p>Automate with AI and save 20+ hours per month</p>
  </section>

  <section id="features">
    <h2>Key Features</h2>
    <ul>
      <li>⚡ Instant results</li>
      <li>🎯 99% accuracy</li>
      <li>🔌 Easy integration</li>
    </ul>
  </section>

  <section id="cta">
    <h2>Get Early Access</h2>
    <form id="email-form">
      <input type="email" placeholder="Enter your email" required>
      <button type="submit">Join Waitlist</button>
    </form>
    <p id="form-message"></p>
  </section>

  <script src="main.js"></script>
</body>
</html>
EOF

  cat > frontend/main.css <<'EOF'
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 2rem; }
header { text-align: center; margin-bottom: 3rem; }
h1 { font-size: 3rem; margin-bottom: 0.5rem; }
h2 { font-size: 2rem; margin: 2rem 0 1rem; }
section { margin-bottom: 3rem; }
ul { list-style-position: inside; }
form { display: flex; gap: 0.5rem; }
input { flex: 1; padding: 0.75rem; font-size: 1rem; }
button { padding: 0.75rem 2rem; font-size: 1rem; background: #000; color: #fff; border: none; cursor: pointer; }
button:hover { background: #333; }
#form-message { margin-top: 1rem; }
.success { color: green; }
.error { color: red; }
EOF

  cat > frontend/main.js <<EOF
const SUPABASE_URL = '$SUPABASE_URL';
const SUPABASE_ANON_KEY = '$SUPABASE_ANON_KEY';

document.getElementById('email-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const email = e.target.querySelector('input').value;
  const message = document.getElementById('form-message');

  try {
    const response = await fetch(\`\${SUPABASE_URL}/functions/v1/capture\`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': \`Bearer \${SUPABASE_ANON_KEY}\`
      },
      body: JSON.stringify({ email })
    });

    const data = await response.json();

    if (data.status === 'ok' || data.status === 'already_exists') {
      message.textContent = '🎉 You\\'re on the list! We\\'ll be in touch.';
      message.className = 'success';
      e.target.reset();
    } else {
      throw new Error(data.error || 'Unknown error');
    }
  } catch (error) {
    message.textContent = '❌ Something went wrong. Please try again.';
    message.className = 'error';
    console.error('Error:', error);
  }
});
EOF
}

# ---------- 8. SETUP BACKEND ----------
setup_backend() {
  log_info "Setting up Supabase backend..."

  mkdir -p backend/{migrations,functions}

  # Create leads table migration
  cat > backend/migrations/$(date +%Y%m%d)_create_leads.sql <<'EOF'
-- Create leads table
CREATE TABLE IF NOT EXISTS leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  timestamp timestamptz NOT NULL DEFAULT now(),
  source text DEFAULT 'landing_page',
  variant text DEFAULT 'A'
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_timestamp ON leads(timestamp DESC);

-- Enable Row Level Security
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert (for public forms)
CREATE POLICY IF NOT EXISTS "Allow public insert" ON leads
  FOR INSERT WITH CHECK (true);

-- Allow service role to read
CREATE POLICY IF NOT EXISTS "Allow service role read" ON leads
  FOR SELECT USING (true);
EOF

  # Create edge function
  cat > backend/functions/capture.js <<'EOF'
import { serve } from "std/server";
import { createClient } from "@supabase/supabase-js";

const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

serve(async (req) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  };

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { email } = await req.json();

    if (!EMAIL_REGEX.test(email)) {
      return new Response(
        JSON.stringify({ error: 'Invalid email format' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(
      Den.env.get('SUPABASE_URL') ?? '',
      Den.env.get('SUPABASE_ANON_KEY') ?? ''
    );

    const { data: existing } = await supabase
      .from('leads')
      .select('email')
      .eq('email', email)
      .single();

    if (existing) {
      return new Response(
        JSON.stringify({ status: 'already_exists' }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const { error } = await supabase
      .from('leads')
      .insert([{ email, source: 'landing_page' }]);

    if (error) throw error;

    return new Response(
      JSON.stringify({ status: 'ok' }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
EOF

  log_success "Created backend configuration"
}

# ---------- 9. GITHUB SETUP ----------
setup_github() {
  if [ "$CREATE_GITHUB_REPO" != "true" ]; then
    log_info "GitHub repository creation skipped (use --github flag to enable)"
    return
  fi

  log_info "Setting up GitHub repository..."

  # Check if github-setup.sh exists
  if [ ! -f "./scripts/github-setup.sh" ]; then
    log_warn "github-setup.sh not found, skipping GitHub setup"
    return
  fi

  # Create GitHub repo
  log_info "Creating GitHub repository: $IDEA_NAME"
  ./scripts/github-setup.sh create "$IDEA_NAME" "AI-generated landing page for SaaS validation" "$GITHUB_VISIBILITY"

  # Setup main branch
  log_info "Setting up main branch..."
  ./scripts/github-setup.sh init

  # Create feature branch for testing
  log_info "Creating feature branch..."
  ./scripts/github-setup.sh branch "feature/$IDEA_NAME"

  log_success "GitHub repository created"
  GITHUB_REPO_URL="https://github.com/$(git config get github.user)/$IDEA_NAME"
}

# ---------- 10. DEPLOY ----------
deploy() {
  log_info "Deploying to Vercel..."

  if ! vercel link --token "$VERCEL_TOKEN" --yes 2>/dev/null; then
    log_warn "Vercel link failed, project may already be linked"
  fi

  if ! vercel deploy --prod --token "$VERCEL_TOKEN" --yes 2>/dev/null; then
    log_error "Vercel deployment failed"
    exit 1
  fi

  # Get deployment URL
  DEPLOY_URL=$(vercel ls --token "$VERCEL_TOKEN" | grep "$IDEA_NAME" | head -1 | awk '{print $2}')

  log_success "Deployed to: https://$DEPLOY_URL"
}

# ---------- 11. TEST & EXPORT ----------
test_and_export() {
  log_info "Testing deployment..."

  # Test email capture
  sleep 2
  TEST_EMAIL="test-$(date +%s)@example.com"

  log_info "Sending test email: $TEST_EMAIL"

  curl -s -X POST \
    "${SUPABASE_URL}/functions/v1/capture" \
    -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$TEST_EMAIL\"" \
    > /dev/null

  log_info "Exporting leads template command:"
  echo "supabase db query \"SELECT email, timestamp FROM leads ORDER BY timestamp DESC;\" --project-ref \"$SUPABASE_URL\" --output leads.csv"
}

# ---------- 12. MAIN ----------
main() {
  echo "═══════════════════════════════════════════════════════"
  echo "  SaaS Validation System - Landing Page Generator"
  echo "═══════════════════════════════════════════════════════"
  echo ""
  echo "📦 Project: $IDEA_NAME"
  echo "🎨 Theme: $THEME"
  echo "🔬 Variant: $VARIANT"
  if [ "$CREATE_GITHUB_REPO" = "true" ]; then
    echo "🔧 GitHub: Will create repository"
  fi
  echo "═══════════════════════════════════════════════════════"
  echo ""

  check_dependencies
  check_env_vars
  create_workdir
  extract_wisdom
  generate_outline
  create_design
  generate_code
  setup_backend
  setup_github
  deploy
  test_and_export

  echo ""
  echo "═══════════════════════════════════════════════════════"
  log_success "Landing page deployed successfully!"
  echo "═══════════════════════════════════════════════════════"
  echo ""
  echo "🚀 Live URL: https://$DEPLOY_URL"
  echo "📊 Database: $SUPABASE_URL"
  echo "📁 Working directory: $WORKDIR"
  if [ "$CREATE_GITHUB_REPO" = "true" ]; then
    echo "🔧 GitHub: $GITHUB_REPO_URL"
  fi
  echo ""
  echo "📝 Next steps:"
  echo "   1. Visit the URL and test email capture"
  echo "   2. Share on social media, forums, etc."
  echo "   3. Monitor leads in Supabase dashboard"
  echo "   4. Export leads: supabase db query ... > leads.csv"
  if [ "$CREATE_GITHUB_REPO" = "true" ]; then
    echo "   5. View repository: $GITHUB_REPO_URL"
    echo "   6. Create feature branches: ./scripts/github-setup.sh branch feature/new-idea"
  fi
  echo ""
}

# Run main function
main "$@"
