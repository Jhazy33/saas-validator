# Tool Reference - Complete Stack Guide

## 📚 Table of Contents

1. [AI/ML Tools](#aiml-tools)
2. [Design Tools](#design-tools)
3. [Code Generation](#code-generation)
4. [Backend/Database](#backenddatabase)
5. [Deployment](#deployment)
6. [Analytics & Automation](#analytics--automation)
7. [Integration Platforms](#integration-platforms)

---

## 🤖 AI/ML Tools

### Fabric (Pattern Orchestration)

**Purpose**: Extract structured insights from videos, podcasts, documents

**Installation**:
```bash
npm install -g fabric
# or
brew install fabric
```

**Key Patterns**:
```bash
# Extract wisdom from video
fabric -y "https://www.youtube.com/watch?v=xxx" --pattern extract_wisdom_dm

# Summarize podcast
fabric -y "https://podcast.url/episode" --pattern summarize_podcast

# Extract from blog post
fabric -y "https://blog.url/post" --pattern extract_blog_insights
```

**Configuration**:
```bash
# Setup Fabric
fabric --setup

# View available patterns
fabric --list-patterns

# Create custom pattern
cat > ~/.config/fabric/patterns/custom_wisdom.yaml << 'EOF'
name: custom_wisdom
description: Extract 20-30 key insights
system: You are an expert at extracting actionable insights...
user: Extract wisdom from: {input}
EOF
```

**Environment Variables**:
```bash
export FABRIC_API_KEY="your-key"
export FABRIC_MODEL="gpt-4"  # or claude-3-opus
```

**Common Issues**:
- **Rate limiting**: Reduce concurrent requests or upgrade API tier
- **Timeouts**: Use `--timeout 180` for longer videos
- **Pattern not found**: Run `fabric --sync-patterns`

---

### Google Gemini (Outline Generation)

**Purpose**: Generate structured landing page outlines from insights

**Installation**:
```bash
npm install -g gemini-cli
# or
pip install google-generativeai
```

**Usage**:
```bash
# Basic prompt
gemini "Generate a landing page outline for AI invoice validator"

# From file
gemini --prompt-file outline_prompt.txt

# With custom temperature
gemini "Prompt here" --temperature 0.3 --model gemini-pro

# JSON output
gemini "Return JSON only" --response-format json
```

**Prompt Template**:
```bash
cat > gemini-prompt.txt << 'EOF'
You are a conversion optimization expert. Generate a landing page outline for:

**Product**: {PRODUCT_NAME}

**Key Insights**:
{INSIGHTS}

**Requirements**:
1. Hero section with bold headline
2. Problem section (3 pain points)
3. Solution section (2-3 benefits)
4. Features section (4-6 features)
5. Social proof (2-3 testimonials)
6. CTA section
7. Footer

Return JSON with:
{
  "sections": [
    {"title": "Hero", "body": "..."}
  ]
}

If uncertain, respond with "I don't know".
EOF

gemini --prompt-file gemini-prompt.txt > outline.json
```

**Environment Variables**:
```bash
export GOOGLE_API_KEY="your-api-key"
export GEMINI_MODEL="gemini-pro"  # or gemini-ultra
```

**Best Practices**:
- Use `--temperature 0` for deterministic output
- Always specify JSON format for structured data
- Add uncertainty guards to prompts
- Validate JSON output before using

---

## 🎨 Design Tools

### Stitch (UI Wireframe Generation)

**Purpose**: Convert outlines into Figma-ready designs

**Installation**:
```bash
npm install -g stitch-cli
# or
brew install stitch
```

**Usage**:
```bash
# Basic design from JSON
stitch design --from-json outline.json --output design.figma

# With custom theme
stitch design --from-json outline.json --theme minimal --output design.figma

# Preview in browser
stitch design --from-json outline.json --preview

# Export to multiple formats
stitch design --from-json outline.json --output design.figma --export png,svg
```

**Themes**:
```json
{
  "minimal": {
    "colors": {
      "primary": "#000000",
      "background": "#FFFFFF",
      "accent": "#0066FF"
    },
    "typography": {
      "heading": "Inter, sans-serif",
      "body": "Inter, sans-serif"
    },
    "spacing": "generous"
  },
  "brutalist": {
    "colors": {
      "primary": "#000000",
      "background": "#FFFF00",
      "accent": "#FF0000"
    },
    "typography": {
      "heading": "Courier New, monospace",
      "body": "Arial, sans-serif"
    },
    "spacing": "compact"
  }
}
```

**Configuration**:
```bash
# Create config file
cat > ~/.stitch/config.yaml << 'EOF'
default_theme: minimal
export_format: figma
auto_preview: false
figma_token: your-figma-token
EOF
```

**Figma Integration**:
1. Get Figma Personal Access Token
2. Set `FIGMA_TOKEN` environment variable
3. Stitch will auto-sync designs to your Figma account

---

### Figma (Manual Design Editing)

**Purpose**: Fine-tune auto-generated designs

**Features**:
- Drag-and-drop editing
- Component libraries
- Prototyping
- Handoff to developers

**Workflows**:
```bash
# Open Stitch-generated design
open design.figma

# Make manual adjustments
# - Adjust colors/typography
# - Add custom graphics
# - Fix spacing issues

# Export for code generation
# File → Export → Figma JSON
```

**Plugins**:
- **Stitch to Code**: Auto-generate HTML/CSS
- **Content Reel**: Add stock photos/icons
- **Autoflow**: Create user flow diagrams

---

## 💻 Code Generation

### Anti-Gravity (Design → Code)

**Purpose**: Convert Figma designs to production HTML/CSS/JS

**Installation**:
```bash
npm install -g anti-gravity-cli
# or
brew install anti-gravity
```

**Usage**:
```bash
# Basic conversion
anti-gravity --design design.figma --output frontend/

# With framework
anti-gravity --design design.figma --output frontend/ --framework react

# Responsive design
anti-gravity --design design.figma --output frontend/ --responsive

# With accessibility
anti-gravity --design design.figma --output frontend/ --a11y

# Single file output
anti-gravity --design design.figma --output index.html --single-file
```

**Output Structure**:
```
frontend/
├── index.html          # Main HTML
├── main.css            # Styles
├── main.js             # Interactivity
└── assets/             # Images, fonts
    ├── logo.png
    └── hero-bg.jpg
```

**Configuration**:
```bash
cat > ~/.anti-gravity/config.yaml << 'EOF'
framework: vanilla
css_preprocessor: none
js_bundler: none
responsive: true
accessibility: WCAG_AA
minify: true
EOF
```

**Supported Frameworks**:
- Vanilla (HTML/CSS/JS)
- React
- Vue
- Svelte
- Astro

---

## 🗄️ Backend/Database

### Supabase (Backend-as-a-Service)

**Purpose**: Database, auth, storage, edge functions

**Installation**:
```bash
npm install -g supabase
```

**Setup**:
```bash
# Login
supabase login

# Create project (via dashboard first)
supabase init --project-ref "your-project-ref"

# Link to existing project
supabase link --project-ref "your-project-ref"
```

**Database Operations**:
```bash
# Create migration
supabase migration new create_leads_table

# Write migration SQL
cat > supabase/migrations/20240120_create_leads.sql << 'EOF'
CREATE TABLE leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text NOT NULL UNIQUE,
  timestamp timestamptz NOT NULL DEFAULT now(),
  source text DEFAULT 'landing_page'
);

CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_leads_timestamp ON leads(timestamp DESC);
EOF

# Push migration
supabase db push

# Reset database (dev only)
supabase db reset
```

**Edge Functions**:
```bash
# Create function
supabase functions new capture

# Deploy function
supabase functions deploy capture --project-ref "your-project-ref"

# Invoke function
supabase functions invoke capture --project-ref "your-project-ref" --data '{"email":"test@example.com"}'

# View logs
supabase functions logs capture --project-ref "your-project-ref"
```

**Typescript Client**:
```bash
npm install @supabase/supabase-js

# Generate types
supabase gen types typescript --project-id "your-project-id" > src/types/supabase.ts
```

**Environment Variables**:
```bash
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_ANON_KEY="your-anon-key"
export SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
```

---

## 🚀 Deployment

### Vercel (Edge Deployment)

**Purpose**: Deploy static sites with zero configuration

**Installation**:
```bash
npm install -g vercel
```

**Setup**:
```bash
# Login
vercel login

# Link project
vercel link

# Deploy to preview
vercel

# Deploy to production
vercel --prod
```

**Configuration**:
```json
{
  "buildCommand": "echo 'No build needed'",
  "outputDirectory": "frontend",
  "framework": null,
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "https://your-project.supabase.co/functions/v1/:path*"
    }
  ],
  "env": {
    "SUPABASE_URL": "@supabase-url",
    "SUPABASE_ANON_KEY": "@supabase-anon-key"
  }
}
```

**Custom Domain**:
```bash
# Add domain
vercel domains add saas-idea.com

# View DNS records
vercel domains ls
```

**Environment Variables**:
```bash
# Set via CLI
vercel env add SUPABASE_URL production
vercel env add SUPABASE_ANON_KEY production

# Or via dashboard
# https://vercel.com/your-project/settings/environment-variables
```

**Analytics**:
```bash
# Enable Vercel Analytics
npm install @vercel/analytics

# Add to frontend/index.html
<script src="https://cdn.jsdelivr.net/npm/@vercel/analytics/dist/analytics.umd.js"></script>
```

---

## 📊 Analytics & Automation

### Zapier (Workflow Automation)

**Purpose**: Connect apps without code

**Use Cases**:
- New lead → Slack notification
- New lead → Google Sheets row
- New lead → Email campaign (Mailchimp)
- Database changes → Dashboard update

**Setup**:
1. Create Zapier account
2. Create new Zap
3. **Trigger**: Webhooks by Zapier → "Catch Hook"
4. **Action**: Google Sheets → "Create Spreadsheet Row"
5. Copy webhook URL: `https://hooks.zapier.com/hooks/catch/xxx/yyy/`

**Implementation**:
```javascript
// Add to Supabase edge function
await fetch('https://hooks.zapier.com/hooks/catch/xxx/yyy/', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, timestamp: new Date().toISOString() })
});
```

**Pricing**:
- Free: 100 tasks/month
- Starter: $19.99/month (750 tasks)
- Professional: $49.99/month (2500 tasks)

---

### n8n (Self-Hosted Automation)

**Purpose**: Open-source alternative to Zapier

**Installation**:
```bash
npm install -g n8n

# Start server
n8n start

# Access at http://localhost:5678
```

**Workflow Example**:
```json
{
  "nodes": [
    {
      "parameters": {
        "url": "https://your-project.supabase.co/rest/v1/leads",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth"
      },
      "name": "Supabase Get Leads",
      "type": "n8n-nodes-base.httpRequest"
    },
    {
      "parameters": {
        "operation": "append",
        "documentId": "your-google-sheet-id",
        "sheetName": "Leads"
      },
      "name": "Google Sheets Append",
      "type": "n8n-nodes-base.googleSheets"
    },
    {
      "parameters": {
        "channel": "#leads",
        "text": "New leads: {{$node[\"Supabase Get Leads\"].json[\"email\"]}}"
      },
      "name": "Slack Notification",
      "type": "n8n-nodes-base.slack"
    }
  ],
  "connections": {
    "Supabase Get Leads": {
      "main": [
        [
          {
            "node": "Google Sheets Append",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

**Advantages over Zapier**:
- Self-hosted (free, unlimited workflows)
- More complex logic (conditionals, loops)
- Better API integrations
- Data privacy (keep on your servers)

---

### Plausible (Privacy-Friendly Analytics)

**Purpose**: Simple web analytics (Google Analytics alternative)

**Installation**:
```bash
# Docker
docker run -d --name plausible \
  -p 8000:8000 \
  plausible/plausible:latest

# Or use hosted: https://plausible.io/
```

**Integration**:
```html
<!-- Add to frontend/index.html -->
<script defer data-domain="your-site.com" src="https://plausible.io/js/script.js"></script>
```

**Usage**:
```bash
# Track page views
plausible('PageView');

# Track custom events
plausible('Signup', { props: { variant: 'A' } });

# Track outbound links
plausible('Outbound Link: Click');
```

**Benefits**:
- GDPR compliant (no cookies)
- Lightweight (< 1KB)
- Owner-controlled data
- Simple dashboard

---

## 🔌 Integration Platforms

### NotebookLM (Knowledge Base)

**Purpose**: Organize research, citations, notes

**Usage**:
```bash
# Add sources
# - YouTube videos
# - PDF documents
# - Web pages
# - Text notes

# Ask questions
# "What are the top 5 insights from this video?"
# "Create a summary of all sources about X"

# Export to Markdown
# File → Export → Markdown
```

**Integration**:
```bash
# Export NotebookLM notes to Fabric
cat > notebook.txt << 'EOF'
[Paste NotebookLM summary here]
EOF

fabric -i notebook.txt --pattern extract_wisdom_dm
```

---

## 🛠️ Development Tools

### GitHub Actions (CI/CD)

**Purpose**: Automate deployment on git push

**Workflow File**:
```yaml
# .github/workflows/deploy.yml
name: Deploy Landing Page

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install tools
        run: |
          npm i -g fabric gemini-cli stitch-cli anti-gravity-cli

      - name: Generate landing page
        env:
          YOUTUBE_URL: ${{ secrets.YOUTUBE_URL }}
          IDEA_NAME: ${{ secrets.IDEA_NAME }}
        run: |
          ./validate.sh "$IDEA_NAME" "$YOUTUBE_URL"

      - name: Deploy to Vercel
        run: |
          vercel deploy --prod --token=${{ secrets.VERCEL_TOKEN }}
```

**Secrets** (GitHub Repository Settings):
```
YOUTUBE_URL=https://youtube.com/watch?v=...
IDEA_NAME=My-SaaS-Concept
GOOGLE_API_KEY=xxx
OPENAI_API_KEY=yyy
SUPABASE_URL=zzz
SUPABASE_ANON_KEY=aaa
VERCEL_TOKEN=bbb
```

---

## 📦 Optional Tools

### Notion API (Documentation)

```bash
npm install @notionhq/client

# Sync landing page data to Notion database
```

### Discord/Slack Bots (Community Management)

```bash
# Notify Discord channel of new leads
curl -H "Content-Type: application/json" \
  -d "{\"content\": \"🎉 New lead: $email\"}" \
  "$DISCORD_WEBHOOK_URL"
```

### Typeform (Survey Collection)

```javascript
// Embed Typeform in landing page
// Replace email capture with Typeform
```

---

## 🚦 Tool Selection Guide

| Task | Recommended Tool | Alternative |
|------|------------------|-------------|
| Video transcription | Fabric | Whisper API |
| Outline generation | Gemini | GPT-4, Claude |
| Design generation | Stitch | Figma AI, Relume |
| Code generation | Anti-Gravity | v0.dev, Locofocus |
| Database | Supabase | Neon, PlanetScale |
| Hosting | Vercel | Netlify, Cloudflare Pages |
| Analytics | Plausible | Vercel Analytics, GA4 |
| Automation | n8n | Zapier, Make |

---

## 💡 Pro Tips

1. **Start simple**: Use hosted versions (Supabase cloud, Vercel free tier)
2. **Version control**: Commit all generated files to Git
3. **Monitor costs**: Set up billing alerts for API usage
4. **Rate limiting**: Cache responses, batch requests
5. **Security**: Never commit API keys, use environment variables
6. **Backups**: Export Supabase data weekly
7. **Testing**: Always test email capture before sharing

---

## 🆘 Getting Help

- **Fabric**: https://github.com/danielmiessler/fabric
- **Supabase**: https://supabase.com/docs
- **Vercel**: https://vercel.com/docs
- **n8n**: https://docs.n8n.io
- **Gemini**: https://ai.google.dev/docs

---

This tool reference should help you understand and troubleshoot each component of the validation pipeline.
