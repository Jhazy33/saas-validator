import { render, screen, waitFor } from '@testing-library/react'
import Home from '../../app/page'

describe('Integration Tests', () => {
  it('should render the complete page without errors', async () => {
    render(<Home />)

    await waitFor(() => {
      expect(screen.getByText(/SaaS Validator/i)).toBeInTheDocument()
    })
  })

  it('should have proper accessibility attributes', () => {
    const { container } = render(<Home />)

    // Check for proper heading hierarchy
    const headings = container.querySelectorAll('h1')
    expect(headings.length).toBeGreaterThan(0)
  })

  it('should load page within performance budget', async () => {
    const startTime = performance.now()
    render(<Home />)

    await waitFor(() => {
      expect(screen.getByText(/SaaS Validator/i)).toBeInTheDocument()
    })

    const endTime = performance.now()
    const renderTime = endTime - startTime

    // Page should render in less than 1 second
    expect(renderTime).toBeLessThan(1000)
  })
})
