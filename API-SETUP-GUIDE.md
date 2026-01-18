# 🔑 API Keys Setup Guide

## Quick Setup (5 Minutes)

You need **2 API keys** to get started. Both are free.

---

## 1️⃣ Supabase (Required - 3 minutes)

**What it's for:** Database, authentication, user management

**Free tier:** 500MB database, 50,000 users/month

### Step-by-Step:

1. **Go to:** https://supabase.com
2. **Click:** "Start your project"
3. **Sign up:** Use Google/GitHub account (fastest)
4. **Create new project:**
   - Click "New Project"
   - Name: `saas-validator`
   - Database Password: (generate one, save it!)
   - Region: Choose closest to you
   - **Pricing:** Select "Free" plan
   - Click "Create new project"
5. **Wait ~2 minutes** for project to be ready
6. **Get your credentials:**
   - Go to: Project Settings (gear icon) → API
   - Find **Project URL** → Copy it
   - Find **anon/public** key → Copy it

### Add to your `.env` file:

```bash
# Open .env
nano .env

# Replace these lines:
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key_here
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here

# With your actual values (paste them):
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Save:** Ctrl+O, Enter, Ctrl+X

---

## 2️⃣ Google Gemini (Required - 2 minutes)

**What it's for:** AI processing, landing page generation

**Free tier:** 15 requests/minute (plenty for development)

### Step-by-Step:

1. **Go to:** https://ai.google.dev
2. **Click:** "Get API Key"
3. **Sign in:** With your Google account
4. **Create API key:**
   - Click "Create API key"
   - Name it: "SaaS Validator Dev"
   - Click "Copy" button
   - (Optional) Add restrictions for security

### Add to your `.env` file:

```bash
# Open .env
nano .env

# Replace this line:
GOOGLE_API_KEY=AIzayour_google_gemini_api_key_here

# With your actual key (paste it):
GOOGLE_API_KEY=AIzaSyD7...your_actual_key_here
```

**Save:** Ctrl+O, Enter, Ctrl+X

---

## ✅ Verify Your Setup

Run the security check:
```bash
./scripts/verify-security.sh
```

Expected output:
```
✅ Security check passed!
✅ .env is ignored by git
✅ API keys are protected
```

---

## 🚀 Start the Application

Now you can start the app:

```bash
./docker-setup.sh start
```

**Access at:**
- 🌐 Web App: http://localhost:3000
- 📧 Email Test: http://localhost:8025
- 🗄️ Database: http://localhost:5050

---

## ⏳ Optional (Can Add Later)

### Stripe (Payments)

**When to add:** When you're ready to accept payments

**Setup:**
1. Go to: https://dashboard.stripe.com/register
2. Get test keys from: Developers → API keys
3. Add to `.env`:
   ```bash
   STRIPE_PUBLISHABLE_KEY=pk_test_...
   STRIPE_SECRET_KEY=sk_test_...
   ```

### Resend (Email)

**When to add:** When you want real email delivery (not just testing)

**Setup:**
1. Go to: https://resend.com/api-keys
2. Create API key
3. Add to `.env`:
   ```bash
   RESEND_API_KEY=re_...
   ```

---

## 🔒 Security Best Practices

✅ **DO:**
- Use test API keys for development
- Keep your API keys secret
- Rotate keys if accidentally exposed
- Use different keys for dev/production

❌ **DON'T:**
- Commit `.env` to git (it's .gitignored though!)
- Share your API keys
- Use production keys in development
- Post keys in public forums/chats

---

## 🆘 Troubleshooting

### Supabase issues:

**"Project not ready"**
- Wait 2-3 minutes after creating project
- Refresh the page

**"Invalid API key"**
- Copy the ENTIRE key (it's long!)
- Make sure you copied the `anon` key, not `service_role`

### Google Gemini issues:

**"API key not working"**
- Make sure you enabled the API
- Check you're using the correct key (starts with `AIza`)

**"Quota exceeded"**
- Free tier: 15 requests/minute
- Wait a minute and try again

---

## 📚 Need Help?

- **Supabase Docs:** https://supabase.com/docs
- **Google Gemini Docs:** https://ai.google.dev/docs
- **GitHub Issues:** https://github.com/Jhazy33/saas-validator/issues

---

**Next:** Run `./docker-setup.sh start` to launch the app! 🚀
