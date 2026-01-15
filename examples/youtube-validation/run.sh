#!/usr/bin/env bash
# Example 1: YouTube Video Validation
#
# This example shows how to extract insights from a YouTube video
# and generate a complete landing page.

# Source environment
source ../../.env

# Video to extract from
YOUTUBE_URL="https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Idea name
IDEA_NAME="AI-Email-Categorizer"

# Run validation
../../scripts/validate.sh "$IDEA_NAME" "$YOUTUBE_URL"

# Output will be in ./$IDEA_NAME/
# - summary.md (extracted insights)
# - outline.json (landing page structure)
# - frontend/ (HTML/CSS/JS)
# - backend/ (Supabase config)

echo "✅ Landing page created for: $IDEA_NAME"
echo "📁 Location: ./$IDEA_NAME/"
echo "🚀 Next: Check ./$IDEA_NAME/deployment.log for URL"
