# SaaS Validator 🚀

> **Validate SaaS ideas in days, not months.** Generate landing pages from any content using AI.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Issues](https://img.shields.io/github/issues/your-org/saas-validator)](https://github.com/your-org/saas-validator/issues)

## 🎯 What Is This?

**SaaS Validator** is an AI-powered platform that transforms any idea into a validated landing page in minutes.

- 📥 **Input:** YouTube URL, text, audio, or document
- 🤖 **AI Processing:** Extracts insights, generates copy, creates design
- 🚀 **Output:** Live, data-collecting landing page
- 📊 **Validation:** Real analytics to make data-driven decisions

## ⚡ Quick Start (Docker)

### Prerequisites

- Docker Desktop (Mac/Windows) or Docker Engine (Linux)
- GitHub account (for auth)
- Supabase account (free tier works)

### 1. Clone & Setup

```bash
git clone https://github.com/your-org/saas-validator.git
cd saas-validator

# Copy environment template
cp .env.example .env

# Edit .env with your API keys
nano .env
```

### 2. Start with Docker

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down
```

### 3. Access the Application

- **Web App:** http://localhost:3000
- **Mailhog** (email testing): http://localhost:8025
- **pgAdmin** (database): http://localhost:5050 (admin@saas-validator.com / admin)

## 🛠️ Development

### Without Docker

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Run tests
npm test

# Build for production
npm run build
npm start
```

## 📚 Documentation

- [Product Overview](./PRODUCT-EXPLANATION.md)
- [Executive Summary](./EXECUTIVE-SUMMARY.md)
- [Product Requirements](./PRD.md)
- [MVP Roadmap](./MVP-ROADMAP.md)
- [Decision Guide](./DECISION-GUIDE.md)

## 🧪 Testing

```bash
# Unit tests
npm test

# E2E tests
npm run test:e2e

# Integration tests
npm run test:integration

# Performance tests
npm run test:performance
```

## 🚀 Deployment

### Local Build

```bash
docker build -t saas-validator:latest .
```

### Production (VPS)

See [DEPLOYMENT.md](./DEPLOYMENT.md) for VPS deployment instructions.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License - see [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Next.js](https://nextjs.org/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Auth with [Supabase](https://supabase.com/)
- AI Powered by [Google Gemini](https://ai.google.dev/)

---

**Made with ❤️ by founders, for founders**

*Validate faster. Build smarter. Launch confidently.*
