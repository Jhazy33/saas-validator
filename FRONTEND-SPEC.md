# Frontend Specification - SaaS Validator Platform
## For Google Stitch UI Generation

**Project:** SaaS Validator Web Application
**Version:** 1.0
**Date:** January 14, 2025
**Status:** Ready for Design

---

## 🎯 Overview

**Stitch Assignment:** Generate a modern, conversion-optimized web application UI for the SaaS Validator platform.

**Application Type:** Web-based SaaS platform
**Target Users:** Solo founders, indie hackers, marketing teams
**Primary Goal:** Transform any content (video, text, audio) into a validated landing page

---

## 🎨 Design Philosophy

### **Visual Style**
- **Modern & Clean** - Think Linear, Vercel, Notion aesthetics
- **Professional but Approachable** - Not intimidating, not childish
- **Conversion-Focused** - Every element drives users to action
- **Trust-Building** - Use design to establish credibility

### **Core Design Principles**
1. **Simplicity First** - Complex tasks should feel simple
2. **Speed** - Fast loading, instant feedback
3. **Clarity** - No confusion about what to do next
4. **Trust** - Professional, polished, reliable
5. **Delight** - Small moments of joy and surprise

---

## 🏗️ Application Structure

### **Page Hierarchy**

```
├── Landing Page (public)
│   └── Hero, features, pricing, testimonials
│
├── Authentication (public)
│   ├── Sign Up (/auth/sign-up)
│   ├── Sign In (/auth/sign-in)
│   └── Forgot Password (/auth/forgot-password)
│
├── Dashboard (authenticated)
│   ├── Overview (/dashboard)
│   ├── My Landing Pages (/dashboard/landing-pages)
│   └── Analytics (/dashboard/analytics)
│
├── Generator Flow (authenticated)
│   ├── New Generation (/generate/new)
│   ├── Progress (/generate/:id/progress)
│   └── Customization (/generate/:id/edit)
│
├── Landing Page Detail (authenticated)
│   └── Page View (/landing-pages/:id)
│
├── Settings (authenticated)
│   ├── Profile (/settings/profile)
│   ├── Billing (/settings/billing)
│   └── Account (/settings/account)
│
└── Pricing (public)
    └── Pricing Plans (/pricing)
```

---

## 🎨 Design System

### **Color Palette**

#### **Primary Colors**
```css
/* Brand Colors */
--primary-50: #EEF2FF;   /* Light accent */
--primary-100: #E0E7FF;  /* Subtle highlight */
--primary-500: #3B82F6;  /* Main brand color (blue) */
--primary-600: #2563EB;  /* Darker blue for hover */
--primary-700: #1D4ED8;  /* Active state */

/* Secondary */
--secondary-500: #8B5CF6; /* Purple for accents */
--accent-500: #10B981;     /* Green for success */
--warning-500: #F59E0B;     /* Orange for warnings */
--danger-500: #EF4444;      /* Red for errors */
```

#### **Neutral Colors**
```css
/* Light Mode */
--background: #FFFFFF;
--surface: #F9FAFB;
--border: #E5E7EB;
--text-primary: #111827;
--text-secondary: #6B7280;
--text-muted: #9CA3AF;

/* Dark Mode (future) */
--background-dark: #111827;
--surface-dark: #1F2937;
--border-dark: #374151;
--text-primary-dark: #F9FAFB;
```

### **Typography**

#### **Font Families**
```css
/* Primary */
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* Monospace (for code) */
--font-mono: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
```

#### **Type Scale**
```css
/* Headings */
--text-4xl: 2.25rem;    /* 36px - Hero title */
--text-3xl: 1.875rem;   /* 30px - Section title */
--text-2xl: 1.5rem;     /* 24px - Page title */
--text-xl: 1.25rem;      /* 20px - Card title */
--text-lg: 1.125rem;     /* 18px - Subheading */
--text-base: 1rem;       /* 16px - Body */
--text-sm: 0.875rem;     /* 14px - Small text */
--text-xs: 0.75rem;      /* 12px - Captions */

/* Weights */
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

### **Spacing System**

```css
/* Scale */
--spacing-1: 0.25rem;  /* 4px */
--spacing-2: 0.5rem;   /* 8px */
--spacing-3: 0.75rem;  /* 12px */
--spacing-4: 1rem;     /* 16px */
--spacing-5: 1.25rem;  /* 20px */
--spacing-6: 1.5rem;   /* 24px */
--spacing-8: 2rem;     /* 32px */
--spacing-10: 2.5rem;  /* 40px */
--spacing-12: 3rem;    /* 48px */
--spacing-16: 4rem;    /* 64px */
```

### **Border Radius**

```css
--radius-sm: 0.25rem;  /* 4px - Small elements */
--radius-md: 0.375rem; /* 6px - Buttons, inputs */
--radius-lg: 0.5rem;   /* 8px - Cards */
--radius-xl: 0.75rem;  /* 12px - Modals */
--radius-2xl: 1rem;     /* 16px - Hero */
```

### **Shadows**

```css
/* Elevation */
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
```

---

## 📱 Page-by-Page Design Specs

### **1. Landing Page (/)**

**Purpose:** Convert visitors into users

**Layout:**
```
┌─────────────────────────────────────────────┐
│  [Logo]  Features  Pricing  Login  Sign Up  │  <- Header
├─────────────────────────────────────────────┤
│                                               │
│        Hero Section                          │
│   ┌─────────────────────────────────────┐   │
│   │  Validate Ideas in Minutes         │   │
│   │  Generate landing pages from any   │   │
│   │  content with AI. No coding needed.│   │
│   │                                    │   │
│   │  [Get Started Free] [Watch Demo]    │   │
│   └─────────────────────────────────────┘   │
│                                               │
│        Social Proof                          │
│   "10,000+ landing pages generated"        │
│   [Trusted by] logos                        │
│                                               │
│        Features (3 cards)                    │
│   ┌──────┐ ┌──────┐ ┌──────┐            │
│   │ AI   │ │ Fast │ │ Analytics│            │
│   └──────┘ └──────┘ └──────┘            │
│                                               │
│        How It Works (3 steps)               │
│   1. Paste URL → 2. AI Generates → 3. Deploy│
│                                               │
│        Testimonials Carousel                  │
│   "Validated my idea in 5 minutes"         │
│                                               │
│        Pricing (3 cards)                     │
│   Free  |  Pro $29  |  Team $99            │
│                                               │
│        Final CTA                              │
│   [Start Validating for Free]               │
│                                               │
├─────────────────────────────────────────────┤
│  Footer: About  Blog  Support  Terms       │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Hero:** Bold headline, subheadline, dual CTAs
- **Social Proof:** User count, testimonials, logos
- **Pricing:** Clear 3-tier structure
- **CTA:** Always visible, above fold

---

### **2. Sign Up Page (/auth/sign-up)**

**Purpose:** Convert visitors into users

**Layout:**
```
┌─────────────────────────────────────────────┐
│         ← Back to Home                      │
├─────────────────────────────────────────────┤
│                                               │
│           Create Your Account                │
│   Start validating ideas in minutes         │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │ Email                                │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │ Password                             │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   Or continue with:                        │
│   [Google] [GitHub]                         │
│                                               │
│   By signing up, you agree to our Terms    │
│   [Create Account]                           │
│                                               │
│   Already have an account? [Sign In]       │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Centered card:** 400px width, clean focus
- **Social proof:** Trusted by Google/GitHub
- **Clear value:** Why sign up today?

---

### **3. Dashboard (/dashboard)**

**Purpose:** Show all landing pages at a glance

**Layout:**
```
┌─────────────────────────────────────────────┐
│  [Search] [Filter] [+ New Landing Page]     │  <- Top bar
├─────────────────────────────────────────────┤
│                                               │
│   Overview  |  Landing Pages  |  Analytics  │  <- Tabs
├─────────────────────────────────────────────┤
│                                               │
│   ┌────────────────────────────────────┐    │
│   │  Total Generated: 5                │    │
│   │  Total Signups: 124                │    │
│   │  Avg Conversion: 4.1%               │    │
│   └────────────────────────────────────┘    │
│                                               │
│   Recent Landing Pages                      │
│   ┌─────────────────────────────────────┐   │
│   │ AI Invoice Validator                 │   │
│   │ Visitors: 234  Signups: 12  Conv: 5%│   │
│   │ Status: ✅ Published               │   │
│   │ [View] [Edit] [Analytics] [Delete]  │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │ Email Categorizer                   │   │
│   │ Visitors: 56   Signups: 1   Conv: 2%│   │
│   │ Status: 📝 Draft                   │   │
│   │ [View] [Edit] [Publish] [Delete]  │   │
│   └─────────────────────────────────────┘   │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Metrics at top:** Quick overview
- **Card-based layout:** Each page is a card
- **Status badges:** Draft, Published, Archived
- **Quick actions:** One-click to common tasks

---

### **4. New Generation Flow (/generate/new)**

**Purpose:** Guide user to generate landing page

**Layout:**
```
┌─────────────────────────────────────────────┐
│         ← Back to Dashboard                  │
├─────────────────────────────────────────────┤
│                                               │
│   Step 1 of 2: Content Source               │
│   ████████████░░░░░░░░░░░░░░░░             │  <- Progress
│                                               │
│   Where should we extract content from?      │
│                                               │
│   ┌─────────────┐ ┌─────────────┐            │
│   │ [YouTube]   │ │ [Text]      │            │
│   │ Paste URL   │ │ Type idea   │            │
│   │             │ │             │            │
│   │ [Video]     │ │ [Document]  │            │
│   │             │ │ [Audio]     │            │
│   └─────────────┘ └─────────────┘            │
│                                               │
│   Selected: YouTube                          │
│   ┌─────────────────────────────────────┐   │
│   │ https://youtube.com/watch?v=...    │   │
│   │ [Paste URL]                           │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │ [Preview Thumbnail]                   │   │
│   │ AI Invoice Validator - Stop Losing  │   │
│   │ Money to Billing Errors              │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   [Back]  [Continue →]                     │
│                                               │
└─────────────────────────────────────────────┘
```

**Second Screen (Template Selection):**
```
┌─────────────────────────────────────────────┐
│   Step 2 of 2: Choose Template              │
│   ████████████████████░░░░░░               │  <- Progress
│                                               │
│   How should it look?                       │
│                                               │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐      │
│   │Minimal  │ │Startup  │ │Corporate│      │
│   │ Clean   │ │Bold     │ │Trust    │      │
│   │ Simple  │ │Modern   │ │Professional│   │
│   └─────────┘ └─────────┘ └─────────┘      │
│                                               │
│   Selected: Minimal                           │
│   ┌─────────────────────────────────────┐   │
│   │ [Live Preview]                        │   │
│   │   Your landing page will look like   │   │
│   │   this...                              │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   [← Back]  [Generate Landing Page →]      │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Progress indicator:** Shows where user is
- **Visual selection:** Cards, not radio buttons
- **Live preview:** See what you'll get
- **Clear CTAs:** Back and Continue buttons

---

### **5. Generation Progress (/generate/:id/progress)**

**Purpose:** Show generation progress

**Layout:**
```
┌─────────────────────────────────────────────┐
│         ← Cancel Generation                  │
├─────────────────────────────────────────────┤
│                                               │
│   Generating Your Landing Page...           │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │  ████████████████░░░░░░░░░           │   │
│   │  Extracting content (30%)              │   │
│   │  Estimated time: 2 minutes remaining   │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   Steps:                                    │
│   ✅ Extract video content                   │
│   ✅ Generate outline with AI               │
│   🔄 Create design (in progress...)         │
│   ⏳ Generate HTML/CSS/JS                    │
│   ⏳ Deploy to Vercel                        │
│   ⏳ Configure analytics                     │
│                                               │
│   This usually takes 3-5 minutes.          │
│   You'll be redirected when complete.       │
│                                               │
│   [Email me when done ☐]                   │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Progress bar:** Visual feedback
- **Step list:** Checkmarks for completed
- **Time estimate:** Set expectations
- **Email notification:** Optional
- **Auto-redirect:** When complete

---

### **6. Landing Page Detail (/landing-pages/:id)**

**Purpose:** View and manage single landing page

**Layout:**
```
┌─────────────────────────────────────────────┐
│  ← Back    [Edit] [Duplicate] [Archive]    │
├─────────────────────────────────────────────┤
│                                               │
│   AI Invoice Validator                       │
│   Created: 2 days ago                        │
│   Status: ✅ Published                       │
│   URL: saas-validator.vercel.app/abc123    │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │  Metrics                               │   │
│   │  ┌──────┐ ┌──────┐ ┌──────┐        │   │
│   │  │234   │ │12    │ │ 5.1% │        │   │
│   │  │Views │ │Signups│ │Conv │        │   │
│   │  └──────┘ └──────┘ └──────┘        │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │  Live Preview                          │   │
│   │  ┌──────────────────────────────┐  │   │
│   │  │ [iframe: landing page]      │  │   │
│   │  │                              │  │   │
│   │  │                              │  │   │
│   │  └──────────────────────────────┘  │   │
│   │              [Open in new tab ↗]    │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │  Analytics                             │   │
│   │  [Chart: Visitors over time]         │   │
│   │  [Chart: Signups over time]          │   │
│   └─────────────────────────────────────┘   │
│                                               │
│   ┌─────────────────────────────────────┐   │
│   │  Recent Leads (12)                    │   │
│   │  john@example.com - 2 min ago        │   │
│   │  jane@company.com - 15 min ago       │   │
│   │  [Export to CSV]                      │   │
│   └─────────────────────────────────────┘   │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **Live preview:** See the actual page
- **Metrics cards:** Key stats at top
- **Analytics charts:** Visual data
- **Leads table:** Recent signups
- **Quick actions:** Edit, duplicate, archive

---

### **7. Pricing Page (/pricing)**

**Purpose:** Convert free users to paid

**Layout:**
```
┌─────────────────────────────────────────────┐
│  Pricing                                    │
├─────────────────────────────────────────────┤
│                                               │
│   Simple pricing for every stage           │
│   Start free, upgrade as you grow          │
│                                               │
│   ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│   │ Free     │ │ Pro      │ │ Team     │ │
│   ├──────────┤ ├──────────┤ ├──────────┤ │
│   │ $0/mo    │ │ $29/mo   │ │ $99/mo   │ │
│   │          │ │          │ │          │ │
│   │ 3 ideas  │ │ Unlimited│ │ 10 users │ │
│   │/mo      │ │ ideas    │ │          │ │
│   │          │ │          │ │          │ │
│   │ Basic    │ │ Analytics│ │ Teams    │ │
│   │templates │ │ A/B test │ │ Priority │ │
│   │          │ │          │ │ support │ │
│   │          │ │ GitHub   │ │ White    │ │
│   │          │ │ integration│  │ label   │ │
│   │          │ │          │ │          │ │
│   │ [Sign Up]│ │ [Upgrade]│ │ Contact  │ │
│   └──────────┘ └──────────┘ └──────────┘ │
│                                               │
│   Feature Comparison                         │
│   [Table: Free vs Pro vs Team]              │
│                                               │
│   FAQ                                         │
│   [Accordion: Common questions]              │
│                                               │
│   Trusted by 10,000+ founders                │
│   [Logos of companies]                       │
│                                               │
└─────────────────────────────────────────────┘
```

**Key Elements:**
- **3 tiers:** Clear progression
- **Feature comparison:** Table showing what you get
- **FAQ:** Address objections
- **Social proof:** Trust indicators
- **Annual billing:** Save 20% (optional)

---

## 🎯 Component Library

### **Buttons**

```css
/* Primary Button */
.btn-primary {
  background: var(--primary-500);
  color: white;
  padding: var(--spacing-3) var(--spacing-6);
  border-radius: var(--radius-md);
  font-weight: var(--font-semibold);
  transition: all 0.2s;
}

.btn-primary:hover {
  background: var(--primary-600);
  transform: translateY(-1px);
}

/* Secondary Button */
.btn-secondary {
  background: white;
  color: var(--primary-500);
  padding: var(--spacing-3) var(--spacing-6);
  border-radius: var(--radius-md);
  font-weight: var(--font-semibold);
  border: 1px solid var(--border);
  transition: all 0.2s;
}

/* Ghost Button */
.btn-ghost {
  background: transparent;
  color: var(--text-primary);
  padding: var(--spacing-3) var(--spacing-6);
  font-weight: var(--font-medium);
}
```

### **Input Fields**

```css
/* Text Input */
.input {
  width: 100%;
  padding: var(--spacing-3) var(--spacing-4);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  font-size: var(--text-base);
  transition: all 0.2s;
}

.input:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Text Area */
.textarea {
  min-height: 120px;
  resize: vertical;
}

/* Select */
.select {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor'%3e%3cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right var(--spacing-4) center;
  background-size: 1.5em 1.5em;
}
```

### **Cards**

```css
.card {
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: var(--spacing-6);
  box-shadow: var(--shadow-sm);
  transition: all 0.2s;
}

.card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.card-header {
  border-bottom: 1px solid var(--border);
  padding-bottom: var(--spacing-4);
  margin-bottom: var(--spacing-4);
}

.card-title {
  font-size: var(--text-xl);
  font-weight: var(--font-semibold);
}
```

### **Badges**

```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: var(--spacing-1) var(--spacing-3);
  border-radius: 9999px;
  font-size: var(--text-xs);
  font-weight: var(--font-medium);
}

.badge-success {
  background: #DCFCE7;
  color: #166534;
}

.badge-warning {
  background: #FEF3C7;
  color: #92400E;
}

.badge-error {
  background: #FEE2E2;
  color: #991B1B;
}
```

---

## 📱 Responsive Design

### **Breakpoints**

```css
/* Mobile First Approach */
/* Mobile: < 640px (default) */
/* Tablet: 640px - 1024px */
/* Desktop: 1024px - 1280px */
/* Wide: > 1280px */

@media (min-width: 640px) {
  /* Tablet styles */
}

@media (min-width: 1024px) {
  /* Desktop styles */
}
```

### **Mobile Considerations**

- **Touch targets:** Minimum 44x44px
- **Font sizes:** Readable without zoom
- **Navigation:** Hamburger menu
- **Tables:** Horizontal scroll or cards
- **Forms:** Full width inputs

---

## ⚡ Micro-interactions

### **Loading States**

```css
.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid var(--border);
  border-top-color: var(--primary-500);
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

### **Hover Effects**

```css
/* Button lift */
.btn:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

/* Card hover */
.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-xl);
}

/* Link underline animation */
.link {
  position: relative;
}

.link::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--primary-500);
  transition: width 0.3s;
}

.link:hover::after {
  width: 100%;
}
```

### **Success/Error States**

```css
/* Success message */
.success {
  padding: var(--spacing-4);
  background: #F0FDF4;
  border: 1px solid #86EFAC;
  border-radius: var(--radius-lg);
  color: #166534;
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}

/* Error message */
.error {
  padding: var(--spacing-4);
  background: #FEF2F2;
  border: 1px solid #FECACA;
  border-radius: var(--radius-lg);
  color: #991B1B;
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}
```

---

## 🎨 Animation & Transitions

### **Page Transitions**

```css
/* Fade in */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.4s ease-out;
}

/* Slide up */
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.slide-up {
  animation: slideUp 0.5s ease-out;
}
```

### **Skeleton Loading**

```html
<div class="skeleton-card">
  <div class="skeleton-header"></div>
  <div class="skeleton-body"></div>
</div>
```

```css
.skeleton-card {
  background: white;
  border-radius: var(--radius-lg);
  padding: var(--spacing-6);
  border: 1px solid var(--border);
}

.skeleton-header {
  height: 24px;
  background: linear-gradient(
    90deg,
    var(--surface) 0%,
    var(--border) 50%,
    var(--surface) 100%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: var(--radius-md);
  margin-bottom: var(--spacing-4);
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

## 🎯 Icon Set

Use **Lucide React** (consistent with shadcn/ui)

### **Primary Icons**
- **Logo:** `zap` (for brand)
- **Navigation:** `home`, `layout-dashboard`, `settings`, `user`
- **Actions:** `plus`, `edit`, `trash`, `copy`, `download`
- **Status:** `check-circle`, `alert-circle`, `clock`, `loading`
- **Social:** `github`, `twitter`, `linkedin`

### **Feature Icons**
- **Generation:** `video`, `file-text`, `mic`, `image`
- **Analytics:** `bar-chart-2`, `line-chart`, `pie-chart`
- **Email:** `mail`, `send`
- **GitHub:** `github`, `git-branch`, `pull-request`

---

## 📐 Layout Grid System

```css
.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-4);
}

.grid {
  display: grid;
  gap: var(--spacing-6);
}

.grid-cols-1 { grid-template-columns: repeat(1, 1fr); }
.grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
.grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
.grid-cols-4 { grid-template-columns: repeat(4, 1fr); }

@media (min-width: 768px) {
  .md\:grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 1024px) {
  .lg\:grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
}
```

---

## 🎭 Empty States

### **No Landing Pages**

```
┌─────────────────────────────────────┐
│                                     │
│         [Illustration]            │
│                                     │
│  No landing pages yet              │
│                                     │
│  Create your first landing page    │
│  from any content in just 5 minutes │
│                                     │
│  [+ Generate Landing Page]          │
│                                     │
└─────────────────────────────────────┘
```

### **No Analytics**

```
┌─────────────────────────────────────┐
│                                     │
│         [Chart Placeholder]         │
│                                     │
│  Waiting for data...                │
│                                     │
│  Your landing page hasn't received │
│  any visitors yet. Share it and    │
│  check back soon!                   │
│                                     │
└─────────────────────────────────────┘
```

---

## 🔔 Notification System

### **Toast Notifications**

```css
.toast {
  position: fixed;
  bottom: var(--spacing-6);
  right: var(--spacing-6);
  padding: var(--spacing-4) var(--spacing-6);
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-xl);
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}
```

**Types:**
- Success: Green checkmark
- Error: Red X
- Info: Blue info icon
- Loading: Spinner

---

## ♿ Accessibility

### **WCAG 2.1 AA Compliance**

- **Color contrast:** Minimum 4.5:1 for normal text
- **Focus indicators:** Visible outline on all interactive elements
- **Keyboard navigation:** Full functionality without mouse
- **Screen reader:** ARIA labels on all icons and buttons
- **Semantic HTML:** Proper heading hierarchy
- **Alt text:** All images have descriptive alt text

### **Focus States**

```css
*:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}
```

---

## 🎨 Dark Mode Support (Future)

```css
@media (prefers-color-scheme: dark) {
  :root {
    --background: #111827;
    --surface: #1F2937;
    --border: #374151;
    --text-primary: #F9FAFB;
    --text-secondary: #D1D5DB;
  }
}
```

---

## 📱 Touch Targets

### **Mobile-Sized Interactions**

```css
/* Buttons */
.btn {
  min-height: 44px;
  min-width: 44px;
  padding: var(--spacing-3) var(--spacing-6);
}

/* Links */
.nav-link {
  display: block;
  padding: var(--spacing-3) var(--spacing-4);
}
```

---

## 🚀 Performance Targets

### **Core Web Vitals**

- **LCP (Largest Contentful Paint):** < 2.5s
- **FID (First Input Delay):** < 100ms
- **CLS (Cumulative Layout Shift):** < 0.1

### **Loading Strategy**

- **Lazy load:** Images below fold
- **Code splitting:** Route-based
- **Tree shaking:** Remove unused code
- **Image optimization:** WebP, lazy loading
- **Font optimization:** System fonts first, then custom

---

## 🎯 Deliverables for Stitch

### **What We Need:**

1. **Complete Figma File**
   - All pages designed
   - Component library
   - Design system
   - Responsive layouts (mobile, tablet, desktop)
   - Dark mode variants (optional)

2. **Style Guide**
   - Colors (hex codes)
   - Typography (fonts, sizes, weights)
   - Spacing system
   - Component states (hover, active, disabled)
   - Animation specs

3. **Icons**
   - Lucide React icon set
   - Custom icons (SVG format)

4. **Assets**
   - Logo (SVG)
   - Illustrations (empty states, success, error)
   - Images (Unsplash integration)

### **Output Format:**

- **Figma:** Complete design file
- **Export:** CSS variables for Tailwind config
- **Components:** React component code (optional)

---

## 📝 Notes for Stitch Team

1. **Reference Sites:**
   - Linear (app.linear.com) - Clean, modern
   - Vercel (vercel.com) - Professional, fast
   - Notion (notion.so) - Simple, intuitive
   - Carrd (carrd.co) - Easy builder

2. **Priority Pages:**
   - Dashboard (most important)
   - New Generation flow
   - Landing Page detail
   - Authentication

3. **Must-Have Components:**
   - Button (primary, secondary, ghost)
   - Card (landing page display)
   - Input (text, select, textarea)
   - Badge (status indicators)
   - Modal (confirmations)
   - Toast (notifications)
   - Skeleton loading

4. **Technical Requirements:**
   - Built for Next.js 14 (App Router)
   - Uses Tailwind CSS
   - Compatible with shadcn/ui
   - Responsive (mobile-first)
   - Accessibility (WCAG AA)

---

## ✅ Acceptance Criteria

Stitch will deliver:

- [ ] Complete Figma file with all pages
- [ ] Component library (buttons, inputs, cards, modals, etc.)
- [ ] Design system documentation
- [ ] Responsive layouts (mobile, tablet, desktop)
- [ ] Dark mode support (optional but recommended)
- [ ] Exportable assets (SVG icons, logo)
- [ ] Style guide (colors, typography, spacing)

---

**Ready to give to Google Stitch! 🎨**

*All specifications documented. Ready for design phase.*
