import { cn, formatDate, formatNumber, slugify, truncate } from '../lib/utils'

describe('Utility Functions', () => {
  describe('cn', () => {
    it('should merge class names correctly', () => {
      expect(cn('px-4', 'py-2')).toBe('px-4 py-2')
    })

    it('should handle conditional classes', () => {
      expect(cn('base-class', true && 'conditional-class', false && 'hidden-class'))
        .toBe('base-class conditional-class')
    })

    it('should handle empty input', () => {
      expect(cn()).toBe('')
    })
  })

  describe('formatDate', () => {
    it('should format date string correctly', () => {
      const date = '2024-01-15'
      const formatted = formatDate(date)
      expect(formatted).toMatch(/January/)
      expect(formatted).toMatch(/15/)
      expect(formatted).toMatch(/2024/)
    })

    it('should format Date object correctly', () => {
      const date = new Date('2024-01-15')
      const formatted = formatDate(date)
      expect(formatted).toMatch(/January/)
    })
  })

  describe('formatNumber', () => {
    it('should format numbers with commas', () => {
      expect(formatNumber(1000)).toBe('1,000')
      expect(formatNumber(1000000)).toBe('1,000,000')
    })

    it('should handle decimal numbers', () => {
      expect(formatNumber(1000.5)).toBe('1,000.5')
    })
  })

  describe('slugify', () => {
    it('should convert text to slug format', () => {
      expect(slugify('Hello World')).toBe('hello-world')
      expect(slugify('Test Multiple   Spaces')).toBe('test-multiple-spaces')
    })

    it('should remove special characters', () => {
      expect(slugify('Hello! @World #Test')).toBe('hello-world-test')
    })

    it('should handle empty string', () => {
      expect(slugify('')).toBe('')
    })
  })

  describe('truncate', () => {
    it('should truncate text to specified length', () => {
      const text = 'This is a very long text that should be truncated'
      expect(truncate(text, 20)).toBe('This is a very lo...')
    })

    it('should not truncate if text is shorter than length', () => {
      const text = 'Short text'
      expect(truncate(text, 20)).toBe('Short text')
    })
  })
})
