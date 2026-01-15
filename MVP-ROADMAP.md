# MVP Roadmap - SaaS Validation Platform
## Web Application Development Plan

**Timeline:** 4-6 weeks
**Budget:** $15,000 - $25,000
**Team:** 1 Full-stack Developer, 1 Designer (part-time)
**Target Launch:** March 2025

---

## 🎯 MVP Definition

### **What MVP Includes:**
✅ User authentication (email, Google, GitHub)
✅ Landing page generation from YouTube URL
✅ Landing page generation from text input
✅ Basic dashboard (list all pages)
✅ Email capture + analytics
✅ 3 customizable templates
✅ Payment processing (Stripe)
✅ User settings

### **What MVP Does NOT Include:**
❌ A/B testing (Phase 2)
❌ Team collaboration (Phase 2)
❌ GitHub integration (Phase 2)
❌ Advanced analytics (Phase 2)
❌ Mobile app (Phase 3)
❌ API access (Phase 3)

---

## 📅 Development Timeline

### **Week 1: Foundation & Design**

#### **Day 1-2: Project Setup**
- [ ] Initialize Next.js 14 project (App Router)
- [ ] Setup Supabase (database, auth, storage)
- [ ] Configure Stripe (test mode)
- [ ] Setup Vercel (staging environment)
- [ ] Setup GitHub repo (private)
- [ ] Configure ESLint, Prettier, Husky
- [ ] Setup Figma file

**Deliverables:**
- Repo: `github.com/your-org/saas-validator-web`
- Staging URL: `saas-validator-staging.vercel.app`
- Figma: Complete design system

---

#### **Day 3-5: Authentication System**

**Backend:**
```typescript
// Implement
- User registration (email + OAuth)
- Email verification
- Password reset
- Session management (JWT)
- Protected API routes
```

**Frontend:**
```typescript
// Build pages
- /auth/sign-up
- /auth/sign-in
- /auth/forgot-password
- /auth/reset-password
```

**Database:**
```sql
-- Create tables
users
sessions
verification_tokens
```

**Acceptance Criteria:**
- [ ] Can sign up with email
- [ ] Can sign in with Google
- [ ] Can sign in with GitHub
- [ ] Can reset password
- [ ] Sessions persist across refresh
- [ ] Protected routes redirect to login

---

#### **Day 5-7: Dashboard UI**

**Figma Design:**
- [ ] Dashboard layout (sidebar + main content)
- [ ] Navigation menu
- [ ] User profile dropdown
- [ ] Landing page card component
- [ ] Empty state design

**Frontend:**
```typescript
// Build components
DashboardLayout
Sidebar
Navigation
LandingPageCard
EmptyState
UserMenu
```

**Data:**
```typescript
// Mock data for development
const mockLandingPages = [
  { id: 1, title: "AI Invoice Validator", status: "published", visitors: 245, signups: 12, conversion: 4.9 },
  { id: 2, title: "Email Categorizer", status: "draft", visitors: 0, signups: 0, conversion: 0 },
]
```

**Acceptance Criteria:**
- [ ] Dashboard shows list of landing pages
- [ ] Each card shows key metrics
- [ ] Can sort by date, visitors, conversion
- [ ] Empty state when no pages
- [ ] Mobile responsive

---

### **Week 2: Core Feature - Landing Page Generation**

#### **Day 8-10: Input Interface**

**Frontend:**
```typescript
// Build pages
/generate/new (form page)
```

**Form Fields:**
```typescript
- Input type: [YouTube URL, Text]
- YouTube URL: (validation, preview thumbnail)
- Text area: (if text selected)
- Title: (auto-generated from URL)
- Template selector: (3 options with preview)
```

**State Management:**
```typescript
// Use React Query for mutations
const generateMutation = useMutation({
  mutationFn: generateLandingPage,
  onSuccess: (data) => {
    queryClient.invalidateQueries(['landing-pages']);
    router.push(`/generate/${data.id}/progress`);
  },
});
```

**Acceptance Criteria:**
- [ ] Can paste YouTube URL
- [ ] Can type text description
- [ ] URL validation works
- [ ] Title auto-generates from URL
- [ ] Can select template
- [ ] Form validation before submit

---

#### **Day 11-14: Generation Pipeline (Backend)**

**Architecture:**
```typescript
// API Route: /api/generate
// Uses existing CLI scripts as workers

export async function POST(req: Request) {
  const { inputType, inputUrl, templateId } = await req.json();

  // 1. Extract content (Fabric)
  const summary = await extractWisdom(inputUrl);

  // 2. Generate outline (Gemini)
  const outline = await generateOutline(summary);

  // 3. Create design (template)
  const design = applyTemplate(outline, templateId);

  // 4. Generate code
  const code = generateCode(design);

  // 5. Deploy to Vercel
  const deployment = await deployToVercel(code);

  // 6. Save to database
  const landingPage = await saveLandingPage({
    title: summary.title,
    url: deployment.url,
    status: 'published',
  });

  return Response.json(landingPage);
}
```

**Background Jobs:**
```typescript
// Use Vercel Cron or Supabase Jobs
// Status polling every 5 seconds
```

**Acceptance Criteria:**
- [ ] Generation completes in < 5 minutes
- [ ] Progress updates in real-time
- [ ] Error handling with rollback
- [ ] Database records all attempts
- [ ] Webhook notifications (Slack/email)

---

### **Week 3: Landing Page Display & Customization**

#### **Day 15-17: Landing Page Detail View**

**Frontend:**
```typescript
// Build page
/landing-pages/:id

// Components
PageHeader
MetricsCards (visitors, signups, conversion)
PreviewFrame (iframe)
LeadsTable
AnalyticsChart
```

**Data Fetching:**
```typescript
// React Query
const { data: landingPage } = useQuery(['landing-page', id], () =>
  fetchLandingPage(id)
);
```

**Acceptance Criteria:**
- [ ] Shows all page details
- [ ] Live preview in iframe
- [ ] Metrics update in real-time
- [ ] Can edit title, description
- [ ] Can duplicate page
- [ ] Can delete page

---

#### **Day 18-21: Customization Editor**

**Figma Design:**
- [ ] Editor layout (preview + controls)
- [ ] Control panel (accordion style)
- [ ] Color picker
- [ ] Text inputs (headline, CTA)
- [ ] Image uploader
- [ ] Template switcher

**Frontend:**
```typescript
// Build components
CustomizationEditor
PreviewPanel
ControlsPanel
ColorPicker
TextInput
ImageUploader
TemplateSelector
```

**State Management:**
```typescript
// Use Zustand for editor state
const useEditorStore = create((set) => ({
  headline: '',
  subheadline: '',
  ctaText: '',
  primaryColor: '#000000',
  // ... other fields

  updateField: (field, value) => set({ [field]: value }),
  saveChanges: async () => { /* API call */ },
}));
```

**Acceptance Criteria:**
- [ ] Real-time preview updates
- [ ] Can change colors
- [ ] Can edit text content
- [ ] Can upload images
- [ ] Can switch templates
- [ ] Save button persists changes
- [ ] Undo/redo support

---

### **Week 4: Analytics & Email Capture**

#### **Day 22-24: Email Capture System**

**Backend:**
```typescript
// Edge function for capture
export default async function handler(req: Request) {
  const { email, landingPageId } = await req.json();

  // Validate email
  if (!isValidEmail(email)) {
    return Response.json({ error: 'Invalid email' }, { status: 400 });
  }

  // Check for duplicates
  const existing = await db.leads.findFirst({
    where: { email, landingPageId }
  });

  if (existing) {
    return Response.json({ status: 'already_exists' });
  }

  // Save lead
  await db.leads.create({
    data: { email, landingPageId }
  });

  // Track event
  await analytics.track('email_captured', {
    landingPageId,
    email,
    timestamp: new Date(),
  });

  return Response.json({ status: 'ok' });
}
```

**Frontend Integration:**
```javascript
// Add to generated landing pages
fetch('/api/capture', {
  method: 'POST',
  body: JSON.stringify({ email, landingPageId }),
  headers: { 'Content-Type': 'application/json' },
});
```

**Acceptance Criteria:**
- [ ] Form validates email format
- [ ] Prevents duplicate submissions
- [ ] Shows success message
- [ ] Shows error message
- [ ] Stores in database
- [ ] Tracks analytics event

---

#### **Day 25-28: Analytics Dashboard**

**Backend:**
```typescript
// API route: /api/analytics/:landingPageId
export async function GET(
  req: Request,
  { params }: { params: { landingPageId: string } }
) {
  const stats = await db.analytics.aggregate({
    where: { landingPageId: params.landingPageId },
    _sum: { visitors: true, signups: true },
  });

  const events = await db.analytics_events.findMany({
    where: { landingPageId: params.landingPageId },
    orderBy: { createdAt: 'desc' },
    take: 1000,
  });

  return Response.json({
    visitors: stats._sum.visitors || 0,
    signups: stats._sum.signups || 0,
    conversion: (stats._sum.signups / stats._sum.visitors * 100).toFixed(2),
    events,
  });
}
```

**Frontend:**
```typescript
// Components
AnalyticsDashboard
MetricsCards (visitors, signups, conversion)
VisitorsChart (line chart)
SignupsChart (line chart)
SourcesTable (UTM parameters)
LeadsTable (exportable)
```

**Charts:**
```typescript
// Use Recharts or Chart.js
<LineChart data={visitorsOverTime}>
  <XAxis dataKey="date" />
  <YAxis />
  <CartesianGrid stroke="#eee" />
  <Tooltip />
  <Line type="monotone" dataKey="visitors" stroke="#8884d8" />
</LineChart>
```

**Acceptance Criteria:**
- [ ] Shows total visitors
- [ ] Shows total signups
- [ ] Shows conversion rate
- [ ] Line chart for visitors over time
- [ ] Line chart for signups over time
- [ ] Table of all leads
- [ ] Export to CSV
- [ ] Date range filter

---

### **Week 5: Payments & Settings**

#### **Day 29-31: Stripe Integration**

**Backend:**
```typescript
// API route: /api/stripe/create-checkout-session
export async function POST(req: Request) {
  const { tier } = await req.json();

  const session = await stripe.checkout.sessions.create({
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [
      {
        price: getPriceId(tier),
        quantity: 1,
      },
    ],
    success_url: `${origin}/dashboard?success=true`,
    cancel_url: `${origin}/pricing?canceled=true`,
    subscription_data: {
      metadata: {
        userId: session.user.id,
      },
    },
  });

  return Response.json({ url: session.url });
}

// Webhook handler
export async function POST(req: Request) {
  const sig = req.headers.get('stripe-signature');
  const event = stripe.webhooks.constructEvent(body, sig, webhookSecret);

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    await updateUserSubscription(session.metadata.userId);
  }

  return Response.json({ received: true });
}
```

**Frontend:**
```typescript
// Pricing page
/pricing

// Upgrade button
<UpgradeButton tier="pro" />

// Usage page
/usage (shows current plan, limits)
```

**Database:**
```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  stripe_subscription_id TEXT UNIQUE,
  stripe_customer_id TEXT,
  status TEXT,
  tier TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Acceptance Criteria:**
- [ ] Pricing page shows 3 tiers
- [ ] Can upgrade to Pro
- [ ] Stripe checkout works
- [ ] Webhook updates database
- [ ] Usage page shows limits
- [ ] Can cancel subscription

---

#### **Day 32-35: User Settings**

**Frontend:**
```typescript
// Build pages
/settings/profile
/settings/account
/settings/billing
/settings/notifications
```

**Components:**
```typescript
ProfileSettings (name, email, avatar)
AccountSettings (password, delete account)
BillingSettings (payment method, invoices)
NotificationSettings (email, webhooks)
```

**Acceptance Criteria:**
- [ ] Can update name
- [ ] Can change password
- [ ] Can upload avatar
- [ ] Can delete account
- [ ] Can update payment method
- [ ] Can download invoices
- [ ] Can toggle notifications

---

### **Week 6: Testing, Polish, Launch**

#### **Day 36-38: Testing**

**Unit Tests:**
```bash
# Test coverage goal: 80%
npm test -- --coverage

# Key files to test
- API routes (generate, analytics, auth)
- Database operations
- Utility functions
- Validation logic
```

**Integration Tests:**
```bash
# Test critical flows
npm run test:integration

# Scenarios
- User signup → create landing page → capture lead
- Payment flow
- Generation pipeline
```

**E2E Tests:**
```bash
# Playwright tests
npm run test:e2e

# Scenarios
- Complete user journey
- Landing page generation
- Email capture
- Analytics viewing
```

**Performance Tests:**
```bash
# Load testing
npm run test:performance

# Targets
- 1000 concurrent users
- < 2s page load
- < 200ms API response
```

---

#### **Day 39-42: Polish & Bug Fixes**

**UI Polish:**
- [ ] Add loading states
- [ ] Add error boundaries
- [ ] Add empty states
- [ ] Add success animations
- [ ] Fix responsive issues
- [ ] Optimize images
- [ ] Add meta tags (SEO)
- [ ] Add favicon

**Performance:**
- [ ] Optimize bundle size
- [ ] Lazy load components
- [ ] Add caching headers
- [ ] Compress images
- [ ] Minify CSS/JS
- [ ] Enable CDN

**Security:**
- [ ] Rate limiting
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Content Security Policy
- [ ] HTTPS only

---

#### **Day 43-45: Beta Launch**

**Pre-Launch:**
- [ ] Set up error tracking (Sentry)
- [ ] Set up analytics (PostHog)
- [ ] Set up monitoring (Vercel Analytics)
- [ ] Create onboarding flow
- [ ] Write help docs
- [ ] Record demo video

**Beta Launch:**
- [ ] Invite 100 beta users
- [ ] Monitor error rates
- [ ] Fix critical bugs
- [ ] Gather feedback
- [ ] Iterate quickly

**Success Criteria:**
- [ ] 100 beta users signed up
- [ ] 50 landing pages created
- [ ] 10 users convert to paid
- [ ] < 5 critical bugs
- [ ] NPS > 30

---

## 🛠️ Tech Stack

### **Frontend**
- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS + shadcn/ui
- **State:** Zustand + React Query
- **Forms:** React Hook Form + Zod
- **Charts:** Recharts
- **Icons:** Lucide React

### **Backend**
- **API:** Next.js API Routes
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth
- **Storage:** Supabase Storage
- **File Processing:** Vercel Blob
- **Email:** Resend
- **Payments:** Stripe

### **Infrastructure**
- **Hosting:** Vercel
- **CI/CD:** GitHub Actions
- **Monitoring:** Sentry + Vercel Analytics
- **Analytics:** PostHog
- **Error Tracking:** Sentry
- **Uptime:** Pingdom

### **Development Tools**
- **Version Control:** Git + GitHub
- **Package Manager:** pnpm
- **Linting:** ESLint + Prettier
- **Testing:** Jest + Playwright
- **Documentation:** Notion

---

## 📊 Resource Allocation

### **Budget Breakdown**

| Category | Cost | Notes |
|----------|------|-------|
| **Development** | $12,000 | 1 developer × 6 weeks |
| **Design** | $3,000 | Designer (part-time) |
| **Infrastructure** | $500 | Vercel, Supabase, Stripe |
| **Tools** | $500 | Sentry, PostHog, etc. |
| **Contingency** | $4,000 | 20% buffer |
| **Total** | **$20,000** | **6-week timeline** |

### **Team Roles**

**Developer (Full-time):**
- Backend API development
- Frontend implementation
- Testing & debugging
- Deployment

**Designer (Part-time):**
- Design system
- UI mockups
- User flows
- Iteration based on feedback

**Product Manager:**
- Requirements
- Prioritization
- User feedback
- Stakeholder management

---

## ✅ MVP Acceptance Criteria

### **Must Have (P0)**

**Functionality:**
- [ ] Users can sign up/sign in
- [ ] Users can generate landing page from YouTube URL
- [ ] Users can generate landing page from text
- [ ] Users can view all landing pages in dashboard
- [ ] Users can see analytics for each page
- [ ] Users can capture email leads
- [ ] Users can upgrade to paid plan
- [ ] Users can customize landing page

**Performance:**
- [ ] Page load < 2 seconds
- [ ] API response < 200ms
- [ ] Generation completes in < 5 minutes
- [ ] 99.9% uptime

**Quality:**
- [ ] < 5 critical bugs
- [ ] 80% test coverage
- [ ] Mobile responsive
- [ ] Accessibility compliant

### **Should Have (P1)**

- [ ] Generate from audio file
- [ ] A/B testing UI
- [ ] Team collaboration
- [ ] GitHub integration
- [ ] Advanced analytics

### **Nice to Have (P2)**

- [ ] Generate from PDF
- [ ] White-label option
- [ ] API access
- [ ] Mobile app

---

## 🚀 Launch Checklist

### **Week Before Launch:**
- [ ] All critical bugs fixed
- [ ] Performance benchmarks met
- [ ] Security audit passed
- [ ] Load testing completed
- [ ] Documentation written
- [ ] Support process defined

### **Day Before Launch:**
- [ ] Domain configured
- [ ] SSL certificate valid
- [ ] DNS propagating
- [ ] Database backups enabled
- [ ] Monitoring configured
- [ ] Error tracking active
- [ ] Analytics installed

### **Launch Day:**
- [ ] Deploy to production
- [ ] Run smoke tests
- [ ] Monitor error rates
- [ ] Be ready for rollback
- [ ] Celebrate! 🎉

---

## 📈 Post-Launch Plan

### **Week 1-2: Stabilization**
- Monitor for bugs
- Fix critical issues
- Gather user feedback
- Release hotfixes

### **Week 3-4: Iteration**
- Add requested features
- Improve onboarding
- Optimize conversion
- Release v1.1

### **Month 2: Growth**
- Content marketing
- Product Hunt launch
- Gather testimonials
- Reach 100 paying users

### **Month 3: Scale**
- Add P1 features
- Improve retention
- Expand team
- Reach 500 paying users

---

## 🎓 Key Learnings

### **What We Know:**
- CLI tool works (proven concept)
- Market exists (indie hackers, founders)
- Tech stack is solid (Next.js + Supabase)
- Revenue model is viable ($29/mo)

### **What We'll Learn:**
- Do people want web UI over CLI?
- What's the optimal price point?
- Which features are most used?
- What's the retention rate?
- Can we acquire customers profitably?

### **Success Metrics (Month 1):**
- 100 beta users
- 50 landing pages created
- 10 paying customers
- $290 MRR
- < 5% churn
- NPS > 30

---

## 📞 Contacts

**Product:** [Your Name]
**Tech Lead:** [Developer Name]
**Design:** [Designer Name]

---

**Status:** ✅ Ready for Development

**Start Date:** [To be determined]

**Launch Target:** 6 weeks from start date

**Let's build this! 🚀**
