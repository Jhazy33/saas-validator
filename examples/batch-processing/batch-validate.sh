#!/usr/bin/env bash
# Example 4: Batch Processing Playlist
#
# Process multiple videos from a playlist and create
# landing pages for each idea automatically.

# Source environment
source ../../.env

# Create playlist file
cat > playlist.txt << 'EOF'
https://www.youtube.com/watch?v=video1
https://www.youtube.com/watch?v=video2
https://www.youtube.com/watch?v=video3
EOF

MAX_PARALLEL=3  # Process 3 at a time
COUNTER=0

# Read all URLs
mapfile -t URLS < playlist.txt

echo "🚀 Batch processing ${#URLS[@]} videos..."
echo "⚙️  Parallel limit: $MAX_PARALLEL"
echo ""

# Process in batches
for ((i=0; i<${#URLS[@]}; i+=MAX_PARALLEL)); do
  BATCH=("${URLS[@]:i:MAX_PARALLEL}")

  echo "📦 Processing batch $((i/MAX_PARALLEL + 1))..."

  for url in "${BATCH[@]}"; do
    IDEA_NAME="Idea-$(date +%s)-$((RANDOM % 1000))"
    ../../scripts/validate.sh "$IDEA_NAME" "$url" &
    ((COUNTER++))
  done

  # Wait for batch to complete
  wait
done

echo ""
echo "✅ Batch complete: $COUNTER ideas deployed"
echo ""
echo "📊 Results:"
echo "   - Check each Idea-*/deployment.log for URLs"
echo "   - Monitor leads in Supabase dashboard"
echo "   - Compare conversion rates after 100 visits each"
echo ""
echo "📈 Export all leads:"
echo "   supabase db query \"SELECT * FROM leads ORDER BY timestamp DESC;\" --project-ref \"$SUPABASE_URL\" --output all-leads.csv"
