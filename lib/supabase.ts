import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export type Database = {
  public: {
    Tables: {
      landing_pages: {
        Row: {
          id: string
          user_id: string
          title: string
          slug: string
          content: string
          status: 'draft' | 'generating' | 'published' | 'archived'
          analytics: {
            views: number
            conversions: number
            last_updated: string
          }
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          slug: string
          content?: string
          status?: 'draft' | 'generating' | 'published' | 'archived'
          analytics?: {
            views?: number
            conversions?: number
            last_updated?: string
          }
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          slug?: string
          content?: string
          status?: 'draft' | 'generating' | 'published' | 'archived'
          analytics?: {
            views?: number
            conversions?: number
            last_updated?: string
          }
          created_at?: string
          updated_at?: string
        }
      }
      users: {
        Row: {
          id: string
          email: string
          full_name: string | null
          avatar_url: string | null
          plan: 'free' | 'pro' | 'team'
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          email: string
          full_name?: string | null
          avatar_url?: string | null
          plan?: 'free' | 'pro' | 'team'
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          avatar_url?: string | null
          plan?: 'free' | 'pro' | 'team'
          created_at?: string
          updated_at?: string
        }
      }
    }
  }
}
