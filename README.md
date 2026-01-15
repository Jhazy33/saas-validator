# SaaS Validation System - AI-Powered Landing Page Generator

> **Validate, don't build.** Transform any idea into a live, data-collecting landing page in 15 minutes.

## 🎯 What This Does

Automatically generates conversion-optimized landing pages from video content (YouTube, podcasts, etc.) to validate SaaS ideas in **days instead of months**.

**Primary Outcome:** Transform any content source into a live, data-collecting landing page with a single command.

---

## ⚡ Quick Start

### 1. Install Tools (2 minutes)

```bash
npm install -g fabric gemini-cli stitch-cli anti-gravity-cli supabase-cli vercel
```

### 2. Set API Keys

```bash
# Copy template
cp templates/.env.example .env

# Edit with your actual keys
nano .env  # Add: GOOGLE_API_KEY, SUPABASE_URL, SUPABASE_ANON_KEY, VERCEL_TOKEN

# Source it
source .env
```

### 3. Deploy Your First Landing Page

```bash
scripts/validate.sh "AI-Invoice-Validator" "https://www.youtube.com/watch?v=64PEJqIuZA8"
```

**That's it!** Your landing page is now live at `https://ai-invoice-validator.vercel.app`

---

## 📚 Documentation

- **[SKILL.md](./SKILL.md)** - Complete skill overview and usage guide
- **[QUICKSTART.md](./QUICKSTART.md)** - Get running in 5 minutes
- **[ADVANCED.md](./ADVANCED.md)** - Customization, A/B testing, scaling
- **[TOOLS.md](./TOOLS.md)** - Complete tool reference guide

---

## 🚀 Usage Examples

### From YouTube Video

```bash
scripts/validate.sh \
  "My-SaaS-Idea" \
  "https://www.youtube.com/watch?v=xxx"
```

### From Your Own Idea

```bash
# Create summary.md manually
echo "# My Idea" > my-idea/summary.md

scripts/validate.sh \
  "My-SaaS-Idea" \
  "" \
  --summary my-idea/summary.md
```

### With Custom Theme

```bash
scripts/validate.sh \
  "My-SaaS-Idea" \
  "$YOUTUBE_URL" \
  --theme brutalist
```

### A/B Test Two Variants

```bash
scripts/validate.sh "Test-A" "$YOUTUBE_URL" --variant A
scripts/validate.sh "Test-B" "$YOUTUBE_URL" --variant B
```

### With GitHub Repository

```bash
# Create landing page AND GitHub repository
scripts/validate.sh \
  "My-SaaS-Idea" \
  "$YOUTUBE_URL" \
  --github true \
  --visibility private

# This creates:
# - GitHub repository with main branch
# - Feature branch for testing
# - CI/CD pipeline via GitHub Actions
# - Complete version history
```

### Manage GitHub Branches

```bash
# Create new feature branch
scripts/github-setup.sh branch "feature/new-idea"

# Switch branches
scripts/github-setup.sh switch "develop"

# Create pull request
scripts/github-setup.sh pr-create "Add new feature" "Description"
```

---

## 📁 Folder Structure

```
saas-validation-system/
├── SKILL.md                  # Main overview
├── QUICKSTART.md             # 5-minute setup guide
├── ADVANCED.md               # Advanced customization
├── TOOLS.md                  # Tool reference
├── README.md                 # This file
├── scripts/
│   ├── validate.sh           # Main automation script
│   └── github-setup.sh       # GitHub repository management
├── .github/
│   └── workflows/
│       └── deploy.yml        # CI/CD automation
├── templates/
│   ├── .env.example          # Environment variables template
│   ├── vercel.json           # Vercel configuration
│   └── prompts/
│       └── conversion-focused.txt
└── examples/
    └── (coming soon)
```

---

## 🔄 How It Works

```
Video Content → Extract Insights → Generate Outline → Create Design → Generate Code → Deploy → Collect Leads
     (Fabric)          (Fabric)          (Gemini)         (Stitch)      (Anti-Gravity)   (Vercel)      (Supabase)
```

**Total Time:** ~15 minutes
**Cost:** ~$5-10/month (Supabase free tier + Vercel free tier)

---

## ✅ Success Criteria

**Deployment Success:**
- [ ] Script runs without errors
- [ ] Landing page accessible at Vercel URL
- [ ] Email capture form submits successfully
- [ ] Leads appear in Supabase database

**Validation Success:**
- [ ] Page receives 100+ unique visitors
- [ ] Email capture rate > 3%
- [ ] At least 10 qualified leads collected
- [ ] Clear pivot/ship decision can be made

---

## 🎯 Next Steps

1. **Read [QUICKSTART.md](./QUICKSTART.md)** for immediate setup
2. **Review [ADVANCED.md](./ADVANCED.md)** for customization options
3. **Deploy your first landing page** using the command above
4. **Drive traffic** - Share on social media, forums, etc.
5. **Analyze results** after 100 visits → Make build/kill decision

---

## 🛠️ Tech Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Insight Extraction | [Fabric](https://github.com/danielmiessler/fabric) | Extract wisdom from videos |
| Outline Generation | [Google Gemini](https://ai.google.dev/) | Generate landing page structure |
| Design | [Stitch](https://stitch.cli/) | Create Figma-ready designs |
| Code Generation | [Anti-Gravity](https://anti-gravity.cli/) | Convert designs to HTML/CSS/JS |
| Backend | [Supabase](https://supabase.com/) | Database + API |
| Deployment | [Vercel](https://vercel.com/) | Hosting + CI/CD |
| Analytics | [Plausible](https://plausible.io/) | Privacy-friendly analytics |

---

## 🐛 Troubleshooting

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
```

### "Low conversion rate (< 1%)"
- Review hero section copy (is it compelling?)
- Check CTA visibility (above the fold?)
- Verify email capture is working (test submission)
- A/B test different value propositions

See [QUICKSTART.md](./QUICKSTART.md) for more troubleshooting tips.

---

## 📖 Philosophy

> **You build, you learn, you ship.** Replace the *build* with *validate* and the learning curve drops from 6-month to 3-day.

Most SaaS failures stem from poor problem validation. 1-2 weeks of traffic data beats months of code. Landing pages are hypothesis-testing labs where every email sign-up is a market signal.

**Key Principles:**
- **Vertical, AI-native products win** - A niche idea is 3-5× more valuable than a generic tool
- **Small teams are agile** - You can iterate faster than large competitors
- **Data beats opinions** - Let the leads guide your next move
- **Fail fast, learn faster** - Test 10 ideas, find 1 winner, build full MVP

---

## 🤝 Contributing

To extend this skill:

1. **Add new tool integrations**: Edit `scripts/validate.sh` and `TOOLS.md`
2. **Create prompt templates**: Add to `templates/prompts/` directory
3. **Share examples**: Add to `examples/` with README
4. **Report bugs**: Open issue with error logs and reproduction steps

---

## 📈 Roadmap

- [ ] Add more design themes (corporate, playful, minimal-dark)
- [ ] Integrate with more AI models (Claude, GPT-4)
- [ ] Create web UI for non-technical users
- [ ] Add analytics dashboard
- [ ] Batch processing for multiple ideas
- [ ] One-click deployment to other platforms (Netlify, Cloudflare)

---

## 📄 License

MIT License - Feel free to use this for your own validation projects.

---

## 🎉 You're Ready!

**Total setup time:** 15 minutes
**First deployment:** ~10 minutes (after setup)
**Subsequent deployments:** ~5 minutes

**Goal:** Test 10 ideas this month → Find 1 winner → Build full MVP

---

**Remember:** Validate, don't build. Data beats opinions. 🚀
