import { supabase } from '../lib/supabase'

// Mock environment variables
process.env.NEXT_PUBLIC_SUPABASE_URL = 'http://localhost:3000'
process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'test-anon-key'

describe('Supabase Client', () => {
  it('should create supabase client', () => {
    expect(supabase).toBeDefined()
    expect(supabase.auth).toBeDefined()
    expect(supabase.from).toBeDefined()
  })

  it('should have correct configuration', () => {
    const client = supabase as any
    expect(client.supabaseUrl).toBe('http://localhost:3000')
  })
})
