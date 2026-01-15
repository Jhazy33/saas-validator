# SaaS Validation System - AI-Powered Landing Page Generator

## 🎯 What This Skill Does

Automatically generates conversion-optimized landing pages from video content (YouTube, podcasts, etc.) to validate SaaS ideas in days instead of months. Uses AI to extract insights, create outlines, generate designs, write code, and deploy to production.

**Primary Outcome:** Transform any content source into a live, data-collecting landing page with a single command.

---

## 🚀 When to Use This Skill

**Use this skill when:**
- You have a SaaS idea and need to validate market interest before building
- You want to pressure-test multiple ideas quickly (10+ ideas/month)
- You have video content (YouTube, podcasts) describing product ideas
- You need landing pages with email capture and analytics
- You want to automate the full pipeline: content → design → code → deploy
- You're running lean and need to validate without hiring designers/developers

**Do NOT use this skill when:**
- You already have validated product-market fit
- You need complex, custom application logic beyond landing pages
- You require extensive backend functionality (user auth, payments, etc.)
- You have a large team with dedicated design/dev resources

---

## 👥 Who Should Use This

**Primary Users:**
- Solo founders validating multiple SaaS concepts
- Indie hackers shipping micro-SaaS products
- Product managers testing market demand
- Startup teams in pre-Seed validation phase
- Marketing teams running lead generation campaigns

**Skill Level Required:**
- **Beginner**: Can run the script and deploy landing pages
- **Intermediate**: Can customize prompts, designs, and workflows
- **Advanced**: Can extend the system, add new AI tools, create custom pipelines

---

## 🧠 How It Works

### Core Workflow

```
Video Content → Extract Insights → Generate Outline → Create Design → Generate Code → Setup Backend → Create GitHub Repo → Deploy → Collect Leads
```

### Step-by-Step Process

1. **Extract Wisdom** (Fabric)
   - Input: YouTube URL or video file
   - Process: AI extracts structured insights, quotes, facts
   - Output: `summary.md` with actionable content

2. **Generate Outline** (Gemini)
   - Input: Extracted insights
   - Process: Creates 5-7 section landing page structure
   - Output: `outline.json` with sections and copy

3. **Create Design** (Stitch)
   - Input: JSON outline
   - Process: Generates Figma-ready wireframes
   - Output: `design.figma` with visual design

4. **Generate Code** (Anti-Gravity)
   - Input: Figma design
   - Process: Converts to HTML/CSS/JS
   - Output: `frontend/` directory with static site

5. **Setup Backend** (Supabase)
   - Input: Project configuration
   - Process: Creates Postgres database + API endpoints
   - Output: `backend/` with migrations and edge functions

6. **Create GitHub Repository** (GitHub CLI)
   - Input: Project name and description
   - Process: Creates repository with main branch and feature branches
   - Output: Version-controlled repository with branching strategy
   - **Optional**: Use `--github` flag to enable

7. **Deploy** (Vercel)
   - Input: Frontend code
   - Process: Git-based deployment with edge functions
   - Output: Live HTTPS URL

8. **Collect Leads** (Zapier/n8n)
   - Input: Database changes
   - Process: Export to CSV, Slack, Google Sheets
   - Output: Lead lists for analysis

---

## 📋 Prerequisites

### Required Tools

```bash
# Install globally via npm
npm install -g fabric gemini-cli stitch-cli anti-gravity-cli supabase-cli vercel

# Or via Homebrew (macOS)
brew install fabric
brew install gemini
brew install stitch
brew install anti-gravity
brew install supabase
brew install vercel

# GitHub CLI (for repository management)
brew install gh

# Authenticate GitHub CLI
gh auth login
```

### Required API Keys

Set these in your `.env` file or shell environment:

```bash
# AI/ML Services
export GOOGLE_API_KEY="your-google-api-key"
export OPENAI_API_KEY="your-openai-api-key"

# Backend/Database
export SUPABASE_URL="your-supabase-project-url"
export SUPABASE_ANON_KEY="your-supabase-anon-key"
export SUPABASE_SERVICE_ROLE_KEY="your-supabase-service-role-key"

# Deployment
export VERCEL_TOKEN="your-vercel-token"
export VERCEL_ORG_ID="your-vercel-org-id"

# Integrations (optional)
export NOTION_TOKEN="your-notion-token"
export SLACK_WEBHOOK_URL="your-slack-webhook-url"
```

### Platform Accounts

- **GitHub**: For version control and CI/CD
- **Supabase**: Free tier for database and edge functions
- **Vercel**: Free tier for hosting
- **Figma**: Free tier for design files (Stitch integration)
- **Zapier/n8n**: For lead export automation

---

## 🎯 Core Commands

### Quick Start (One Command)

```bash
# Basic usage with YouTube URL
./validate.sh "AI-Invoice-Validator" "https://www.youtube.com/watch?v=64PEJqIuZA8"
```

### Advanced Usage

```bash
# With custom design theme
./validate.sh "SaaS-Idea" "$YOUTUBE_URL" --theme material

# With A/B test variant
./validate.sh "SaaS-Idea" "$YOUTUBE_URL" --variant B

# With custom prompt
./validate.sh "SaaS-Idea" "$YOUTUBE_URL" --prompt ./custom-prompts/v1.txt

# Batch process playlist
for url in $(cat playlist.txt); do
  ./validate.sh "Idea-$(date +%s)" "$url"
done
```

---

## 📁 Project Structure

After running `validate.sh`, you'll get:

```
SaaS-Idea-01/
├── frontend/                    # Static site assets
│   ├── index.html              # Main landing page
│   ├── main.css                # Styles
│   └── main.js                 # Interactive elements
├── backend/                     # Supabase configuration
│   ├── migrations/
│   │   └── 20230920_create_leads.sql
│   └── functions/
│       └── capture.js          # Email capture endpoint
├── design.figma                # Design file (optional)
├── outline.json                # Structured outline
├── summary.md                  # Extracted insights
├── validate.sh                 # Pipeline script
├── .env                        # Environment variables
└── .github/
    └── workflows/
        └── validate.yml        # CI/CD automation
```

---

## ✅ Success Criteria

**Deployment Success:**
- [ ] Script runs without errors
- [ ] Landing page is accessible at Vercel URL
- [ ] Email capture form submits successfully
- [ ] Leads appear in Supabase database
- [ ] Analytics are tracking page views

**Validation Success:**
- [ ] Page receives 100+ unique visitors
- [ ] Email capture rate > 3%
- [ ] At least 10 qualified leads collected
- [ ] Clear pivot/ship decision can be made

**Quality Gates:**
- [ ] No AI hallucinations in copy (manual review)
- [ ] Design matches brand guidelines (if applicable)
- [ ] Mobile-responsive (test on device)
- [ ] Accessibility check passes (WCAG AA)

---

## 🚦 Common Workflows

### 1. Validate New Idea from YouTube

```bash
./validate.sh "My-SaaS-Concept" "https://youtube.com/watch?v=..."
```

**Time:** 10-15 minutes | **Outcome:** Live landing page

### 2. Iterate on Existing Idea

```bash
# Modify outline.json with new copy
./validate.sh "My-SaaS-Concept-v2" "" --update
```

**Time:** 5 minutes | **Outcome:** Updated landing page

### 3. A/B Test Two Variants

```bash
./validate.sh "My-SaaS-A" "$YOUTUBE_URL" --variant A
./validate.sh "My-SaaS-B" "$YOUTUBE_URL" --variant B
```

**Time:** 20 minutes | **Outcome:** Two live pages for comparison

### 4. Create with GitHub Repository

```bash
# Create landing page AND GitHub repository
./validate.sh "My-SaaS-Concept" "$YOUTUBE_URL" --github true

# Or create private repository
./validate.sh "My-SaaS-Concept" "$YOUTUBE_URL" --github true --visibility private
```

**Time:** 15 minutes | **Outcome:** Live landing page + GitHub repo with version control

**What happens:**
- Creates GitHub repository with main branch
- Initializes with README.md and .gitignore
- Creates feature branch for testing
- Pushes all code to repository
- Enables GitHub Actions CI/CD

### 5. Manage GitHub Branches

```bash
# Create new feature branch
./scripts/github-setup.sh branch "feature/new-cta"

# Switch to branch
./scripts/github-setup.sh switch "develop"

# Create pull request
./scripts/github-setup.sh pr-create "Update CTA button" "Improves conversion" feature/new-cta main

# List all branches
./scripts/github-setup.sh list
```

**Time:** 2-5 minutes | **Outcome:** Organized development workflow

### 6. Export Leads for Analysis

```bash
supabase db query "SELECT email, timestamp FROM leads ORDER BY timestamp DESC;" \
  --project-ref "$SUPABASE_URL" \
  --output "leads.csv"
```

**Time:** 1 minute | **Outcome:** CSV for analysis

---

## 🛠️ Customization Options

### Prompt Templates

Create custom prompt templates in `./prompts/`:

```
prompts/
├── minimal-outline.txt
├── detailed-outline.txt
└── conversion-focused.txt
```

### Design Themes

Supported themes:
- `minimal` - Clean, whitespace-heavy
- `material` - Google Material Design
- `brutalist` - Bold, raw aesthetic
- `corporate` - Professional, business-focused

### Analytics Integrations

Edit `frontend/main.js` to add:

```javascript
// Google Analytics
gtag('event', 'sign_up', {
  'event_category': 'engagement',
  'event_label': 'email_capture'
});

// Plausible (self-hosted)
plausible('PageView');
```

---

## ⚠️ Troubleshooting

### Fabric extraction fails

**Issue:** `fabric: command not found`

**Fix:**
```bash
npm install -g fabric
fabric --setup
```

### Supabase migration error

**Issue:** `relation "leads" does not exist`

**Fix:**
```bash
cd backend
supabase db reset --project-ref "$SUPABASE_URL"
```

### Vercel deployment timeout

**Issue:** Build exceeds 60-second timeout

**Fix:**
```bash
# Deploy without building
vercel deploy --prod --prebuilt
```

### GitHub CLI not authenticated

**Issue:** `gh auth status` fails

**Fix:**
```bash
gh auth login
# Follow prompts to authenticate
```

### GitHub repository creation fails

**Issue:** Repository already exists or permission denied

**Fix:**
```bash
# Check existing repos
gh repo list

# Use different name
./validate.sh "My-SaaS-Concept-2" "$YOUTUBE_URL" --github true

# Or manually specify owner
export GITHUB_USER="your-username"
```

### Branch conflicts

**Issue:** Git merge conflicts or branch out of sync

**Fix:**
```bash
# Sync with remote
git fetch origin
git rebase origin/main

# Or create fresh branch
./scripts/github-setup.sh branch "feature/fresh-start"
```

### Low conversion rate (< 1%)

**Issue:** Landing page not converting

**Fix:**
- Review hero section copy (is it compelling?)
- Check CTA visibility (above the fold?)
- Verify email capture is working (test submission)
- A/B test different value propositions

---

## 📚 Related Documentation

- **QUICKSTART.md** - Get running in 5 minutes
- **ADVANCED.md** - Deep technical implementation
- **TOOLS.md** - Complete tool reference guide
- **examples/** - Real-world usage examples

---

## 🔄 Version History

- **v1.0** - Initial release with full pipeline automation
- **v1.1** - Added A/B testing support
- **v1.2** - Integrated NotebookLM knowledge base
- **v1.3** - Added GitHub repository management with branching strategy

---

## 🤝 Contributing

To extend this skill:

1. **Add new tool integrations**: Edit `validate.sh` and `TOOLS.md`
2. **Create prompt templates**: Add to `./prompts/` directory
3. **Share examples**: Add to `./examples/` with README
4. **Report bugs**: Open issue with error logs and reproduction steps

---

## 📖 Next Steps

1. **Read QUICKSTART.md** for immediate setup
2. **Review ADVANCED.md** for customization options
3. **Explore examples/** for real-world implementations
4. **Run your first validation**: `./validate.sh "Test-Idea" "https://youtube.com/watch?v=..."`

---

**Remember:** Validate, don't build. 1-2 weeks of traffic data beats months of code.
