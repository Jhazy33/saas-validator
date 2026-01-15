#!/usr/bin/env bash
# Example 2: Manual Idea Validation
#
# This example shows how to create a landing page from your own
# written idea/spec without using video content.

# Source environment
source ../../.env

# Idea name
IDEA_NAME="AI-Invoice-Validator"

# Run validation with local summary file
../../scripts/validate.sh "$IDEA_NAME" "" --summary summary.md

echo "✅ Landing page created from manual idea: $IDEA_NAME"
echo "📁 Location: ./$IDEA_NAME/"
echo "📝 Source: summary.md (this file)"
