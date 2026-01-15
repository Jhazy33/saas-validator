import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'SaaS Validator - Validate Your Ideas in Days, Not Months',
  description: 'Generate landing pages from any content using AI. Transform your ideas into validated products with real analytics.',
  keywords: ['SaaS validation', 'landing page generator', 'AI startup', 'idea validation'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
