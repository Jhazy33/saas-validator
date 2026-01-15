export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-center font-mono text-sm">
        <h1 className="text-4xl font-bold text-center mb-4">
          SaaS Validator 🚀
        </h1>
        <p className="text-center text-gray-600 mb-8">
          Validate your SaaS ideas in days, not months.
        </p>
        <div className="text-center">
          <a
            href="/auth/sign-up"
            className="bg-primary-500 hover:bg-primary-600 text-white font-semibold py-2 px-6 rounded-lg transition-colors"
          >
            Get Started Free
          </a>
        </div>
      </div>
    </main>
  )
}
