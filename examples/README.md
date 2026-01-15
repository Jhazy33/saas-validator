# Examples - Real-World Usage Patterns

This directory contains real-world examples of how to use the SaaS Validation System.

## 📁 Available Examples

### 1. YouTube Video Validation
**Location:** `./youtube-validation/`

Extracts insights from a YouTube video and generates a landing page.

```bash
scripts/validate.sh \
  "AI-Email-Categorizer" \
  "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

**Use Case:** You found a great video explaining a problem/solution and want to validate a SaaS around it.

---

### 2. Manual Idea Validation
**Location:** `./manual-idea/`

Creates a landing page from your own written idea/spec.

```bash
# Create your summary.md
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

# Run validation
scripts/validate.sh \
  "AI-Invoice-Validator" \
  "" \
  --summary my-idea/summary.md
```

**Use Case:** You have your own idea and don't need to extract from video content.

---

### 3. A/B Testing Framework
**Location:** `./ab-testing/`

Tests two different landing page variants to see which converts better.

```bash
# Deploy Variant A
scripts/validate.sh \
  "Test-A" \
  "$YOUTUBE_URL" \
  --variant A \
  --prompt templates/prompts/conversion-focused.txt

# Deploy Variant B
scripts/validate.sh \
  "Test-B" \
  "$YOUTUBE_URL" \
  --variant B \
  --prompt templates/prompts/minimalist.txt

# After 100 visits each, compare conversion rates
```

**Use Case:** You want to test different value propositions, designs, or CTAs.

---

### 4. Batch Processing Playlist
**Location:** `./batch-processing/`

Processes multiple videos from a playlist at once.

```bash
# Create playlist.txt file
cat > playlist.txt << 'EOF'
https://www.youtube.com/watch?v=video1
https://www.youtube.com/watch?v=video2
https://www.youtube.com/watch?v=video3
EOF

# Process all videos
for url in $(cat playlist.txt); do
  IDEA_NAME="Idea-$(date +%s)-$((RANDOM % 1000))"
  scripts/validate.sh "$IDEA_NAME" "$url"
done
```

**Use Case:** You have a playlist of 10+ videos and want to validate ideas from each.

---

### 5. Custom Design Theme
**Location:** `./custom-theme/`

Uses a custom design theme (brutalist, material, etc.).

```bash
# Create custom theme
cat > my-theme.json << 'EOF'
{
  "colors": {
    "primary": "#FF0000",
    "background": "#FFFF00",
    "accent": "#000000"
  },
  "typography": {
    "heading": "Courier New, monospace"
  }
}
EOF

# Deploy with custom theme
scripts/validate.sh \
  "My-Idea" \
  "$YOUTUBE_URL" \
  --theme my-theme.json
```

**Use Case:** You want a specific aesthetic that matches your brand.

---

### 6. Lead Export Automation
**Location:** `./lead-export/`

Automatically exports leads to CSV, Slack, or Google Sheets.

```bash
# Export to CSV
supabase db query \
  "SELECT email, timestamp FROM leads ORDER BY timestamp DESC;" \
  --project-ref "$SUPABASE_URL" \
  --output leads.csv

# Send to Slack (add to capture.js)
curl -X POST "$SLACK_WEBHOOK_URL" \
  -d "{\"text\": \"🎉 New lead: $email\"}"
```

**Use Case:** You want real-time notifications of new signups.

---

### 7. Analytics Integration
**Location:** `./analytics/`

Integrates Plausible, Google Analytics, or custom analytics.

```html
<!-- Add to frontend/index.html -->
<script defer data-domain="your-site.com" src="https://plausible.io/js/script.js"></script>

<!-- Or Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
```

**Use Case:** You want detailed analytics on visitor behavior.

---

### 8. Fact-Checking Pipeline
**Location:** `./fact-checking/`

Validates AI-generated claims to prevent hallucinations.

```bash
# Run fact-check script
bash scripts/fact-check.sh summary.md

# Manual review of claims
grep -E "^[0-9]+\." summary.md
```

**Use Case:** You're concerned about AI making false claims and want to verify everything.

---

## 📊 Example Results

### Case Study: AI Invoice Validator

**Time to Deploy:** 12 minutes
**Total Cost:** $0 (free tiers)
**Traffic (Day 1):** 47 visitors
**Email Signups:** 3
**Conversion Rate:** 6.4%
**Decision:** ✅ Build MVP

**What Worked:**
- Clear problem statement (billing mistakes cost 10-20% revenue)
- Specific benefit (99% accuracy in 2-3 seconds)
- Strong CTA ("Get Early Access")
- Social proof ("Trusted by 500+ companies")

**What Didn't Work:**
- Initial headline was too generic (refined after 20 visitors)
- Form placement was below fold (moved above fold)
- No urgency element (added "Limited to first 100 users")

---

## 🎯 Choosing the Right Example

| Your Situation | Use This Example |
|----------------|------------------|
| Saw a great video about a problem | YouTube Video Validation |
| Have your own idea spec | Manual Idea Validation |
| Want to test different approaches | A/B Testing Framework |
| Have many ideas to test | Batch Processing Playlist |
| Need specific brand aesthetic | Custom Design Theme |
| Want real-time notifications | Lead Export Automation |
| Need detailed analytics | Analytics Integration |
| Concerned about AI accuracy | Fact-Checking Pipeline |

---

## 📝 Contributing Examples

Have a real-world example to share?

1. Create a new directory: `./your-example-name/`
2. Add a `README.md` with:
   - What problem you were solving
   - How you used the system
   - Results (conversion rate, decision made)
   - Lessons learned
3. Submit a PR!

---

## 🚀 Quick Start

Pick an example above and run it! Each example includes all the commands and files you need.

**Remember:** The goal is to validate quickly, not build perfectly. Deploy, test, iterate. 🎯
