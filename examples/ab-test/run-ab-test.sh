#!/usr/bin/env bash
# Example 3: A/B Testing Framework
#
# This example shows how to deploy two landing page variants
# and compare their conversion rates.

# Source environment
source ../../.env

# Common video URL
YOUTUBE_URL="https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Deploy Variant A (conversion-focused)
../../scripts/validate.sh \
  "Test-A" \
  "$YOUTUBE_URL" \
  --theme minimal \
  --variant A \
  --prompt ../../templates/prompts/conversion-focused.txt

# Deploy Variant B (minimalist)
../../scripts/validate.sh \
  "Test-B" \
  "$YOUTUBE_URL" \
  --theme minimal \
  --variant B

echo "✅ A/B Test deployed!"
echo ""
echo "📊 Variant A: Check Test-A/deployment.log for URL"
echo "📊 Variant B: Check Test-B/deployment.log for URL"
echo ""
echo "🧪 Testing Protocol:"
echo "   1. Drive 100+ visitors to each variant"
echo "   2. Track email signups in Supabase"
echo "   3. Calculate conversion rate (signups / visitors)"
echo "   4. Run for 7 days minimum"
echo ""
echo "📈 Statistical Significance Calculator:"
echo "   Use: python ../../scripts/calculate-significance.py"
echo ""
echo "✋ Decision Criteria:"
echo "   - >95% confidence: Winner is clear"
echo "   - 80-95% confidence: Run longer"
echo "   - <80% confidence: Inconclusive, test different variants"
