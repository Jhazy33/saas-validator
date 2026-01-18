import { render, screen } from '@testing-library/react'
import Home from '../app/page'

describe('Home Page', () => {
  it('should render the main heading', () => {
    render(<Home />)
    const heading = screen.getByText(/SaaS Validator/i)
    expect(heading).toBeInTheDocument()
  })

  it('should render the subheading', () => {
    render(<Home />)
    const subheading = screen.getByText(/Validate your SaaS ideas/i)
    expect(subheading).toBeInTheDocument()
  })

  it('should render the call-to-action button', () => {
    render(<Home />)
    const ctaButton = screen.getByText(/Get Started Free/i)
    expect(ctaButton).toBeInTheDocument()
    expect(ctaButton).closest('a')).toHaveAttribute('href', '/auth/sign-up')
  })
})
