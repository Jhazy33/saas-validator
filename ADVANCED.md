# Advanced Implementation - Deep Technical Guide

## 🔧 Custom Prompt Engineering

### Prompt Template System

Create reusable prompt templates for different landing page styles:

```
prompts/
├── conversion-focused.txt
├── brand-aware.txt
├── minimal-v1.txt
└── enterprise.txt
```

### Example: Conversion-Focused Prompt

```bash
cat > prompts/conversion-focused.txt << 'EOF'
You are a conversion optimization expert. Generate a landing page outline for:

**Product**: {IDEA_NAME}

**Key Insights**:
{INSIGHTS}

**Requirements**:
1. Hero section: Bold headline + subheadline + single CTA
2. Problem section: 3 pain points (bullet format)
3. Solution section: 2-3 key benefits (social proof)
4. Features section: 4-6 features with icons
5. Social proof: 2-3 testimonials (real or placeholder)
6. CTA section: Final conversion hook + urgency
7. Footer: Minimal links + copyright

**Tone**: Direct, action-oriented, benefit-focused
**Output**: JSON with "sections" array containing "title" and "body" keys

**Conversion triggers to include**:
- Scarcity ("Limited access")
- Social proof ("Join 500+ companies")
- Specificity ("Save 20+ hours/month")
- Risk reversal ("Free trial, no credit card")

If uncertain about any detail, respond with "I don't know" rather than hallucinating.
EOF
```

### Using Custom Prompts

```bash
# Method 1: Pass directly
./validate.sh "My-Idea" "$YOUTUBE_URL" --prompt prompts/conversion-focused.txt

# Method 2: Set as default
export DEFAULT_PROMPT="prompts/conversion-focused.txt"
./validate.sh "My-Idea" "$YOUTUBE_URL"
```

---

## 🎨 Design Customization

### Theme System

Create custom design themes:

```bash
cat > themes/brutalist-theme.json << 'EOF'
{
  "colors": {
    "primary": "#000000",
    "secondary": "#FFFFFF",
    "accent": "#FF0000",
    "background": "#FFFF00"
  },
  "typography": {
    "heading": "Courier New, monospace",
    "body": "Arial, sans-serif",
    "size": {
      "h1": "4rem",
      "h2": "3rem",
      "body": "1.1rem"
    }
  },
  "spacing": {
    "section": "2rem",
    "element": "1rem"
  },
  "border": {
    "width": "4px",
    "style": "solid",
    "color": "#000000"
  }
}
EOF
```

### Apply Custom Theme

```bash
./validate.sh "My-Idea" "$YOUTUBE_URL" --theme themes/brutalist-theme.json
```

### Figma Integration

**Manual Design Edits:**

1. Open generated `design.figma` in Figma
2. Make custom adjustments
3. Export as updated design file
4. Re-run with `--design` flag:

```bash
./validate.sh "My-Idea" "$YOUTUBE_URL" --design path/to/custom-design.figma
```

---

## 🧪 Advanced A/B Testing

### Multi-Variant Testing Framework

```bash
#!/bin/bash
# ab-test.sh

IDEA="AI-Invoice-Validator"
YOUTUBE_URL="https://www.youtube.com/watch?v=64PEJqIuZA8"
VARIANTS=("A" "B" "C")

for variant in "${VARIANTS[@]}"; do
  ./validate.sh \
    "${IDEA}-${variant}" \
    "$YOUTUBE_URL" \
    --variant "$variant" \
    --prompt "prompts/variant-${variant}.txt"
done

echo "✅ A/B Test deployed:"
echo "  Variant A: https://${IDEA}-A.vercel.app"
echo "  Variant B: https://${IDEA}-B.vercel.app"
echo "  Variant C: https://${IDEA}-C.vercel.app"
```

### Statistical Significance Calculator

```python
# scripts/calculate-significance.py
import math
from scipy import stats

def ab_test_significance(conversions_a, visitors_a, conversions_b, visitors_b):
    """Calculate if B is statistically better than A"""

    rate_a = conversions_a / visitors_a
    rate_b = conversions_b / visitors_b

    # Two-proportion z-test
    p_a = conversions_a / visitors_a
    p_b = conversions_b / visitors_b
    p_pooled = (conversions_a + conversions_b) / (visitors_a + visitors_b)

    se = math.sqrt(p_pooled * (1 - p_pooled) * (1/visitors_a + 1/visitors_b))
    z_score = (p_b - p_a) / se

    p_value = 1 - stats.norm.cdf(z_score)

    return {
        "rate_a": rate_a,
        "rate_b": rate_b,
        "lift": (rate_b - rate_a) / rate_a,
        "z_score": z_score,
        "p_value": p_value,
        "significant": p_value < 0.05
    }

# Usage
result = ab_test_significance(
    conversions_a=15,
    visitors_a=500,
    conversions_b=25,
    visitors_b=500
)

print(f"Variant A: {result['rate_a']:.2%}")
print(f"Variant B: {result['rate_b']:.2%}")
print(f"Lift: {result['lift']:.2%}")
print(f"Significant: {result['significant']}")
```

---

## 📊 Advanced Analytics

### Custom Event Tracking

Edit `frontend/main.js`:

```javascript
// Track custom events
function trackEvent(eventName, properties = {}) {
  // Google Analytics 4
  if (typeof gtag !== 'undefined') {
    gtag('event', eventName, properties);
  }

  // Plausible (self-hosted)
  if (typeof plausible !== 'undefined') {
    plausible(eventName, { props: properties });
  }

  // Custom backend
  fetch('/api/track', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ event: eventName, ...properties })
  });
}

// Track specific interactions
document.querySelector('.cta-button').addEventListener('click', () => {
  trackEvent('cta_click', {
    variant: 'A',
    placement: 'hero'
  });
});

document.querySelector('form').addEventListener('submit', () => {
  trackEvent('email_submit', {
    variant: 'A',
    timestamp: new Date().toISOString()
  });
});
```

### Supabase Analytics Tables

```sql
-- Create analytics tables
CREATE TABLE page_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id text NOT NULL,
  url text NOT NULL,
  referrer text,
  user_agent text,
  timestamp timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id text NOT NULL,
  event_name text NOT NULL,
  properties jsonb,
  timestamp timestamptz NOT NULL DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_page_views_session ON page_views(session_id);
CREATE INDEX idx_events_name ON events(event_name);
CREATE INDEX idx_events_session ON events(session_id);
```

### Analytics Dashboard (Supabase)

```sql
-- Conversion rate query
SELECT
  COUNT(DISTINCT pv.session_id) as visitors,
  COUNT(DISTINCT l.email) as signups,
  ROUND(COUNT(DISTINCT l.email)::numeric / COUNT(DISTINCT pv.session_id) * 100, 2) as conversion_rate
FROM page_views pv
LEFT JOIN leads l ON TRUE
WHERE pv.timestamp > NOW() - INTERVAL '7 days';

-- Top referrers
SELECT
  referrer,
  COUNT(DISTINCT session_id) as visits,
  COUNT(DISTINCT l.email) as signups
FROM page_views pv
LEFT JOIN leads l ON TRUE
GROUP BY referrer
ORDER BY visits DESC
LIMIT 10;
```

---

## 🔐 Security & Privacy

### Email Validation

Enhance `backend/functions/capture.js`:

```javascript
import { serve } from "std/server";
import { createClient } from "@supabase/supabase-js";

// Strict email validation regex
const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

// Rate limiting (in-memory, for production use Redis)
const rateLimiter = new Map();
const RATE_LIMIT = 5; // 5 submissions per hour per IP
const RATE_WINDOW = 3600000; // 1 hour in ms

serve(async (req) => {
  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  };

  // Handle OPTIONS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { email } = await req.json();
    const ip = req.headers.get('x-forwarded-for') || 'unknown';

    // 1. Validate email format
    if (!EMAIL_REGEX.test(email)) {
      return new Response(
        JSON.stringify({ error: 'Invalid email format' }),
        { status: 400, headers: corsHeaders }
      );
    }

    // 2. Rate limiting
    const key = `${ip}_${Math.floor(Date.now() / RATE_WINDOW)}`;
    const count = (rateLimiter.get(key) || 0) + 1;

    if (count > RATE_LIMIT) {
      return new Response(
        JSON.stringify({ error: 'Rate limit exceeded' }),
        { status: 429, headers: corsHeaders }
      );
    }
    rateLimiter.set(key, count);

    // 3. Check for duplicates
    const supabase = createClient(
      Den.env.get('SUPABASE_URL')!,
      Den.env.get('SUPABASE_ANON_KEY')!
    );

    const { data: existing } = await supabase
      .from('leads')
      .select('email')
      .eq('email', email)
      .single();

    if (existing) {
      return new Response(
        JSON.stringify({ status: 'already_exists' }),
        { status: 200, headers: corsHeaders }
      );
    }

    // 4. Insert lead
    const { error } = await supabase
      .from('leads')
      .insert([{ email, source: 'landing_page' }]);

    if (error) throw error;

    return new Response(
      JSON.stringify({ status: 'ok' }),
      { status: 200, headers: corsHeaders }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: corsHeaders }
    );
  }
});
```

### GDPR Compliance

```javascript
// Add consent management to frontend
function checkConsent() {
  const consent = localStorage.getItem('consent');
  if (!consent) {
    showConsentBanner();
  }
}

function showConsentBanner() {
  const banner = document.createElement('div');
  banner.innerHTML = `
    <div style="position: fixed; bottom: 0; left: 0; right: 0; background: #000; color: #fff; padding: 1rem; z-index: 9999;">
      <p>We use cookies to track usage. <button onclick="acceptConsent()">Accept</button></p>
    </div>
  `;
  document.body.appendChild(banner);
}

function acceptConsent() {
  localStorage.setItem('consent', 'accepted');
  document.querySelector('[style*="position: fixed"]').remove();
  // Initialize analytics
  initializeAnalytics();
}
```

---

## 🚀 Scaling to 100+ Ideas

### Batch Processing Pipeline

```bash
#!/bin/bash
# batch-validate.sh

VIDEOS_FILE="playlist.txt"
MAX_PARALLEL=5

# Read all URLs
mapfile -t URLS < "$VIDEOS_FILE"

# Process in batches
for ((i=0; i<${#URLS[@]}; i+=MAX_PARALLEL)); do
  BATCH=("${URLS[@]:i:MAX_PARALLEL}")

  for url in "${BATCH[@]}"; do
    IDEA_NAME="Idea-$(date +%s)-$((RANDOM % 1000))"
    ./validate.sh "$IDEA_NAME" "$url" &
  done

  # Wait for batch to complete
  wait
done

echo "✅ Batch complete: ${#URLS[@]} ideas deployed"
```

### Centralized Dashboard

```sql
-- Multi-project tracking
CREATE TABLE projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  url text,
  youtube_url text,
  deployed_at timestamptz,
  status text DEFAULT 'active'
);

CREATE TABLE project_leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id),
  email text NOT NULL,
  timestamp timestamptz NOT NULL DEFAULT now()
);

-- Performance summary
SELECT
  p.name,
  p.url,
  COUNT(pl.id) as leads,
  COUNT(DISTINCT DATE(pl.timestamp)) as days_active,
  ROUND(COUNT(pl.id)::numeric / NULLIF(COUNT(DISTINCT DATE(pl.timestamp)), 0), 2) as leads_per_day
FROM projects p
LEFT JOIN project_leads pl ON p.id = pl.project_id
GROUP BY p.id, p.name, p.url
ORDER BY leads DESC;
```

---

## 🔌 Integrations

### Slack Notifications

```javascript
// Add to capture.js
async function notifySlack(email) {
  const webhookUrl = Den.env.get('SLACK_WEBHOOK_URL');

  await fetch(webhookUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      text: `🎉 New lead: ${email}`,
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*New Signup*\nEmail: ${email}\nTime: ${new Date().toISOString()}`
          }
        }
      ]
    })
  });
}
```

### Google Sheets Export

```javascript
// scripts/export-to-sheets.js
const { GoogleSpreadsheet } = require('google-spreadsheet');
const { supabase } = require('@supabase/supabase-js');

async function exportToSheet() {
  const doc = new GoogleSpreadsheet(process.env.GOOGLE_SHEET_ID);
  await doc.useServiceAccountAuth({
    client_email: process.env.GOOGLE_CLIENT_EMAIL,
    private_key: process.env.GOOGLE_PRIVATE_KEY,
  });
  await doc.loadInfo();

  const sheet = doc.sheetsByIndex[0];

  // Fetch leads from Supabase
  const { data: leads } = await supabase
    .from('leads')
    .select('email, timestamp')
    .order('timestamp', { ascending: false });

  // Clear existing rows
  await sheet.clearRows();

  // Add new rows
  const rows = leads.map(lead => ({
    email: lead.email,
    timestamp: lead.timestamp,
    date: new Date(lead.timestamp).toLocaleDateString()
  }));

  await sheet.addRows(rows);
  console.log(`✅ Exported ${rows.length} leads to Google Sheets`);
}

exportToSheet();
```

### Zapier Integration

1. Create Zapier account
2. Create new Zap: **Webhooks by Zapier** → **Google Sheets**
3. Use webhook URL: `https://hooks.zapier.com/hooks/catch/xxx/yyy/`
4. Add to capture.js:

```javascript
await fetch('https://hooks.zapier.com/hooks/catch/xxx/yyy/', {
  method: 'POST',
  body: JSON.stringify({ email, timestamp: new Date().toISOString() })
});
```

---

## 🧠 Anti-Hallucination Techniques

### Fact-Checking Pipeline

```bash
#!/bin/bash
# fact-check.sh

SUMMARY_FILE="$1"

# 1. Extract claims
echo "Extracting factual claims..."
claims=$(grep -E "^[0-9]+\." "$SUMMARY_FILE" | wc -l)

# 2. Cross-reference with Google (manual step)
echo "⚠️  Please verify these $claims claims manually:"
grep -E "^[0-9]+\." "$SUMMARY_FILE"

# 3. Flag uncertain claims
echo "\n🔍 Flagging uncertain phrases..."
grep -i -E "(approximately|roughly|about|around|likely|probably)" "$SUMMARY_FILE"

# 4. Output report
cat > fact-check-report.md <<EOF
# Fact Check Report

**Date**: $(date)
**Total Claims**: $claims
**Requires Verification**: $(grep -i -E "(approximately|roughly|about)" "$SUMMARY_FILE" | wc -l)

## Action Items
- [ ] Verify statistics with primary sources
- [ ] Update claims with specific data
- [ ] Add citations to source material
EOF
```

### Source Citation System

Modify prompts to require citations:

```
Add citations to every claim using this format:
[Source: YouTube video, timestamp]
[Source: Research paper, URL]
[Source: Industry report, year]

If no source is available, mark as:
[Source: Unverified - requires fact-checking]
```

---

## 🐛 Debugging & Monitoring

### Logging System

```javascript
// scripts/logger.js
const fs = require('fs');
const path = require('path');

class Logger {
  constructor(logDir = './logs') {
    this.logDir = logDir;
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
  }

  log(level, message, data = {}) {
    const timestamp = new Date().toISOString();
    const logEntry = {
      timestamp,
      level,
      message,
      ...data
    };

    const logFile = path.join(this.logDir, `${level}.log`);
    fs.appendFileSync(logFile, JSON.stringify(logEntry) + '\n');

    // Console output
    console[level.toLowerCase()](`[${timestamp}] ${message}`, data);
  }

  info(message, data) { this.log('INFO', message, data); }
  error(message, data) { this.log('ERROR', message, data); }
  warn(message, data) { this.log('WARN', message, data); }
}

module.exports = new Logger();
```

### Health Checks

```bash
# scripts/health-check.sh
#!/bin/bash

check_service() {
  local name=$1
  local url=$2

  if curl -s -f "$url" > /dev/null; then
    echo "✅ $name is healthy"
    return 0
  else
    echo "❌ $name is unhealthy"
    return 1
  fi
}

echo "Running health checks..."

check_service "Vercel Deployment" "https://$1.vercel.app"
check_service "Supabase API" "$SUPABASE_URL/rest/v1/"
check_service "Email Capture" "$SUPABASE_URL/functions/v1/capture"

echo "Health check complete!"
```

---

## 📈 Performance Optimization

### Caching Strategy

```javascript
// Add to frontend/main.js
const cacheVersion = 'v1';

// Cache static assets
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js', {
    scope: '/'
  });
}

// sw.js (Service Worker)
const CACHE_NAME = `landing-page-${cacheVersion}`;
const urlsToCache = [
  '/',
  '/main.css',
  '/main.js',
  '/logo.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});
```

### Database Optimization

```sql
-- Add indexes for common queries
CREATE INDEX idx_leads_email ON leads(email);
CREATE INDEX idx_leads_timestamp ON leads(timestamp DESC);
CREATE INDEX idx_leads_email_timestamp ON leads(email, timestamp);

-- Partition by month for large tables
CREATE TABLE leads_partitioned (
  id uuid,
  email text,
  timestamp timestamptz
) PARTITION BY RANGE (timestamp);

CREATE TABLE leads_2024_01 PARTITION OF leads_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

---

## 🎓 Best Practices

### 1. Prompt Engineering
- Always specify output format (JSON/CSV)
- Add uncertainty guards ("If unsure, say 'I don't know'")
- Use temperature=0 for deterministic outputs
- Include examples in prompts

### 2. Version Control
```bash
# Tag each deployment
git tag -a "deploy-$(date +%Y%m%d)" -m "Deploy $(date)"

# Rollback if needed
git checkout deploy-20240115
```

### 3. Testing
```bash
# Run Lighthouse CI
npx @lhci/cli autorun --collect.url="https://your-app.vercel.app"

# Test email capture
for email in "test1@example.com" "test2@example.com"; do
  curl -X POST https://your-project.supabase.co/functions/v1/capture \
    -d "{\"email\":\"$email\"}"
done
```

### 4. Monitoring
```bash
# Set up uptime monitoring
upptime deploy

# Supabase daily backups
supabase db dump --project-ref "$SUPABASE_URL" > backup-$(date +%Y%m%d).sql
```

---

## 🚦 Decision Frameworks

### Pivot vs Persevere

```python
def should_pivot(visitors, signups, days_active):
    """Determine if idea should be pivoted or persevered"""

    conversion_rate = signups / visitors
    leads_per_day = signups / days_active

    # Kill criteria
    if conversion_rate < 0.02:
        return "KILL - Below 2% conversion"

    # Pivot criteria
    if conversion_rate < 0.05:
        return "PIVOT - Between 2-5%, iterate copy/design"

    # Persevere criteria
    if leads_per_day < 0.5:
        return "PIVOT - Good conversion but low traffic, improve marketing"

    # Success criteria
    if conversion_rate >= 0.05 and leads_per_day >= 1.0:
        return "BUILD - Strong validation, proceed to MVP"

    return "ANALYZE - More data needed"
```

---

This advanced guide provides everything you need to customize, scale, and optimize your validation pipeline. Experiment with these techniques and find what works best for your specific use cases.
