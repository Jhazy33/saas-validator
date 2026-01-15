# Quick Start Guide - Deploy Your First Landing Page in 15 Minutes

## ⚡ 5-Minute Setup

### Step 1: Install Tools (2 minutes)

```bash
# Install all CLI tools in one command
npm install -g fabric gemini-cli stitch-cli anti-gravity-cli supabase-cli vercel

# Verify installation
fabric --version
gemini --version
stitch --version
supabase --version
vercel --version
```

### Step 2: Set API Keys (2 minutes)

```bash
# Create .env file
cat > ~/.claude/skills/saas-validation-system/.env << 'EOF'
# AI Services
GOOGLE_API_KEY=your-key-here
OPENAI_API_KEY=your-key-here

# Database
SUPABASE_URL=your-project-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Deployment
VERCEL_TOKEN=your-vercel-token
EOF

# Source it
source ~/.claude/skills/saas-validation-system/.env
```

**Get API Keys:**
- **Google**: https://makersuite.google.com/app/apikey
- **OpenAI**: https://platform.openai.com/api-keys
- **Supabase**: https://supabase.com/dashboard → New Project → Settings → API
- **Vercel**: https://vercel.com/account/tokens

### Step 3: Make Script Executable (1 minute)

```bash
chmod +x ~/.claude/skills/saas-validation-system/scripts/validate.sh
```

---

## 🚀 Deploy Your First Landing Page (10 minutes)

### Option A: From YouTube Video

```bash
~/.claude/skills/saas-validation-system/scripts/validate.sh \
  "AI-Invoice-Validator" \
  "https://www.youtube.com/watch?v=64PEJqIuZA8"
```

### Option B: From Your Own Idea

```bash
# Create a summary.md manually
mkdir -p my-idea
cat > my-idea/summary.md << 'EOF'
# AI Invoice Validator

## Problem
Manual invoice validation is slow and error-prone. Businesses lose 10-20% of revenue to billing mistakes.

## Solution
AI-powered invoice validation that catches 99% of errors in seconds.

## Key Features
- Instant validation (2-3 seconds)
- Integrates with QuickBooks, Xero
- Saves 20+ hours per month
- 99% accuracy rate
EOF

# Run without YouTube URL
~/.claude/skills/saas-validation-system/scripts/validate.sh \
  "AI-Invoice-Validator" \
  "" \
  --summary my-idea/summary.md
```

---

## ✅ What Just Happened?

The script automatically:

1. **Extracted insights** from the video (or used your summary)
2. **Generated outline** with 5-7 sections (Hero, Problem, Solution, Features, CTA, etc.)
3. **Created design** in Figma-ready format
4. **Wrote code** (HTML/CSS/JS)
5. **Setup database** (Supabase leads table)
6. **Deployed to Vercel** (live HTTPS URL)
7. **Setup email capture** (working form)

**Output:**
```
✅ Done! Your landing page is live at:
https://ai-invoice-validator.vercel.app

📊 Database: https://supabase.com/dashboard/project/xxx
📧 Test email capture: Visit the page and submit!
```

---

## 🧪 Test Your Landing Page

```bash
# 1. Visit the URL
open https://ai-invoice-validator.vercel.app

# 2. Fill out the email form with test@email.com

# 3. Check it appeared in Supabase
supabase db query "SELECT * FROM leads ORDER BY timestamp DESC LIMIT 1;" \
  --project-ref "$SUPABASE_URL"
```

---

## 📊 View Your Leads

### Method 1: Supabase Dashboard (GUI)
1. Go to https://supabase.com/dashboard
2. Click your project
3. Table Editor → leads

### Method 2: Export to CSV

```bash
supabase db query "SELECT email, timestamp FROM leads ORDER BY timestamp DESC;" \
  --project-ref "$SUPABASE_URL" \
  --output leads.csv

# View in Excel/Google Sheets
open leads.csv
```

### Method 3: Real-time Slack Alerts (Optional)

```bash
# Install n8n
npm install -g n8n

# Import workflow from ~/.claude/skills/saas-validation-system/examples/n8n-leads-to-slack.json
n8n import ~/.claude/skills/saas-validation-system/examples/n8n-leads-to-slack.json
```

---

## 🎯 Next Steps

### Day 1: Launch
- [ ] Landing page is live ✅
- [ ] Test email capture works ✅
- [ ] Share on Twitter/LinkedIn/Hacker News

### Day 2-7: Drive Traffic
- [ ] Post on Product Hunt
- [ ] Share in relevant communities (Reddit, Discord, Slack)
- [ ] Run $50-100 in Facebook/Reddit ads
- [ ] Email your network

### Day 7: Analyze Results
```bash
# Check conversion rate
visits=1000  # from Vercel Analytics
signups=$(supabase db query "SELECT COUNT(*) FROM leads;" --project-ref "$SUPABASE_URL" | grep -o '[0-9]*')
conversion=$(echo "scale=2; $signups / $visits * 100" | bc)
echo "Conversion rate: $conversion%"
```

**Decision Framework:**
- **Conversion > 5%**: Build full MVP
- **Conversion 3-5%**: Iterate copy/design, test more traffic
- **Conversion < 3%**: Pivot or kill idea

---

## 🔄 Make Updates

### Change Copy

```bash
# Edit outline.json
vim ai-invoice-validator/outline.json

# Re-run with --update flag
~/.claude/skills/saas-validation-system/scripts/validate.sh \
  "AI-Invoice-Validator-v2" \
  "" \
  --outline ai-invoice-validator/outline.json
```

### A/B Test

```bash
# Create two versions
~/.claude/skills/saas-validation-system/scripts/validate.sh \
  "Test-A" \
  "$YOUTUBE_URL" \
  --variant A

~/.claude/skills/saas-validation-system/scripts/validate.sh \
  "Test-B" \
  "$YOUTUBE_URL" \
  --variant B

# Compare conversion rates after 100 visits each
```

---

## 🐛 Common Issues & Fixes

### "fabric: command not found"
```bash
npm install -g fabric
fabric --setup
```

### "Supabase: connection refused"
```bash
# Check API keys
echo $SUPABASE_URL
echo $SUPABASE_ANON_KEY

# Reset database
supabase db reset --project-ref "$SUPABASE_URL"
```

### "Vercel: deployment timeout"
```bash
# Deploy without build
vercel deploy --prod --prebuilt
```

### "No leads appearing"
```bash
# 1. Check browser console for errors
# 2. Test email endpoint directly:
curl -X POST https://your-project.supabase.co/functions/v1/capture \
  -H "Authorization: Bearer $SUPABASE_ANON_KEY" \
  -d '{"email":"test@example.com"}'

# 3. Check Supabase logs
supabase functions logs capture --project-ref "$SUPABASE_URL"
```

---

## 📚 Learn More

- **ADVANCED.md** - Custom prompts, integrations, scaling
- **TOOLS.md** - Deep dive into each tool in the stack
- **examples/** - Real-world landing pages and workflows

---

## 🎉 You're Live!

**What to do now:**

1. **Celebrate** 🍺 - You validated an idea in < 1 day (not 6 months!)
2. **Drive traffic** - Share everywhere, run ads, post on forums
3. **Check analytics** - Watch for conversion rate signals
4. **Make decision** - Build MVP, pivot, or kill after 100 visits

**Remember:** Data beats opinions. Let the leads guide your next move.

---

**Total Time:** 15 minutes (setup + deployment)
**Next Validation:** ~10 minutes (tools already installed)

**Goal:** Test 10 ideas this month → Find 1 winner → Build full MVP
