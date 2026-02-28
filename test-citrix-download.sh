#!/bin/bash
# Diagnostic script to test Citrix download URL extraction

set -euo pipefail

echo "🔍 Testing Citrix Download URL Extraction"
echo "=========================================="
echo

# Test 1: Check network connectivity to Citrix
echo "1️⃣ Testing network connectivity to Citrix..."
if timeout 10 curl -I https://www.citrix.com/downloads/ 2>&1 | head -3; then
  echo "✓ Network connectivity OK"
else
  echo "✗ Cannot reach Citrix website"
  exit 1
fi
echo

# Test 2: Download Workspace page
echo "2️⃣ Fetching Workspace download page..."
WS_PAGE=$(timeout 30 wget -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html 2>/dev/null || echo "FAILED")

if [ "$WS_PAGE" = "FAILED" ]; then
  echo "✗ Failed to fetch Workspace page"
  exit 1
else
  echo "✓ Successfully fetched Workspace page"
  echo "📄 Page size: $(echo "$WS_PAGE" | wc -c) bytes"
fi
echo

# Test 3: Try to extract Workspace URL with current pattern
echo "3️⃣ Testing Workspace URL extraction (current pattern)..."
WS_URL=$(echo "$WS_PAGE" | sed -ne '/linuxx64.*tar.gz/ s/<a .* rel="\(.*\)" id="downloadcomponent">/https:\1/p' | sed -e 's/\r//g' | head -1)

if [ -z "$WS_URL" ]; then
  echo "✗ Current pattern failed to extract URL"
  echo "   Pattern: /linuxx64.*tar.gz/ + rel attribute"
  echo
  echo "📋 Looking for alternative patterns..."
  
  # Try alternative patterns
  echo "   Option 1: Looking for tar.gz URLs..."
  ALT1=$(echo "$WS_PAGE" | grep -oP 'href="[^"]*linuxx64[^"]*\.tar\.gz"' | head -1)
  if [ -n "$ALT1" ]; then
    echo "   ✓ Found: $ALT1"
  fi
  
  echo "   Option 2: Looking for any download links..."
  ALT2=$(echo "$WS_PAGE" | grep -i download | head -3)
  if [ -n "$ALT2" ]; then
    echo "   ✓ Sample matches:"
    echo "$ALT2" | head -3 | sed 's/^/      /'
  fi
else
  echo "✓ Extracted Workspace URL"
  echo "   URL: $WS_URL"
  
  # Test 4: Try to download with the extracted URL
  echo
  echo "4️⃣ Testing download with extracted URL..."
  if timeout 30 wget --spider "$WS_URL" 2>&1 | grep -q "HTTP request sent"; then
    echo "✓ URL is accessible"
  else
    echo "✗ URL appears to be inaccessible"
  fi
fi
echo

# Test 5: Check for common blocking patterns
echo "5️⃣ Checking for access restrictions..."
HEADERS=$(timeout 30 wget -O /dev/null https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html 2>&1 || true)

if echo "$HEADERS" | grep -q "403\|401\|429"; then
  echo "⚠️  Access restriction detected (403/401/429)"
  echo "   Citrix may block automated downloads"
elif echo "$HEADERS" | grep -q "200.*OK\|2[0-9][0-9]"; then
  echo "✓ Page accessible (HTTP 2xx)"
else
  echo "⚠️  Unknown response status"
fi
echo

echo "=========================================="
echo "✓ Diagnostic complete"
echo
echo "💡 Next steps:"
echo "   1. Check if page content changed"
echo "   2. Look for alternate download methods"
echo "   3. Consider using Citrix API instead of web scraping"
