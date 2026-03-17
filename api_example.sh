#!/bin/bash

# Berezina Dogs Ambulance API Usage Example
# This script demonstrates secure API access without CSRF vulnerabilities

API_BASE="<server>/api"
EMAIL="your_email"
PASSWORD="your_secure_password"

echo "=== Berezina Dogs Ambulance API Access ==="
echo

# Step 1: Login and get token
echo "1. Authenticating with API..."
RESPONSE=$(curl -s -X POST "$API_BASE/session" \
  -H "Content-Type: application/json" \
  -d "{\"email_address\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

echo "Auth Response: $RESPONSE"

# Extract token from response (using jq if available)
if command -v jq > /dev/null 2>&1; then
  TOKEN=$(echo "$RESPONSE" | jq -r '.token')
else
  # Basic extraction without jq (less reliable)
  TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
fi

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "❌ Authentication failed!"
  exit 1
fi

echo "✅ Authentication successful! Token: $TOKEN"
echo

# Step 2: Access animals CSV data
echo "2. Downloading animals data as CSV..."
curl -s -H "Authorization: Bearer $TOKEN" \
     -H "Accept: text/csv" \
     "$API_BASE/animals.csv" \
     -o "animals_$(date +%Y%m%d).csv"

if [ $? -eq 0 ]; then
  echo "✅ CSV downloaded successfully: animals_$(date +%Y%m%d).csv"
  echo "File size: $(wc -l < "animals_$(date +%Y%m%d).csv") lines"
else
  echo "❌ CSV download failed"
fi

echo

# Step 3: Access animals JSON data  
echo "3. Getting animals data as JSON (first 3 records)..."
curl -s -H "Authorization: Bearer $TOKEN" \
     -H "Accept: application/json" \
     "$API_BASE/animals" | \
     head -c 500

echo
echo

# Step 4: Logout (optional - token will expire anyway)
echo "4. Logging out..."
curl -s -X DELETE "$API_BASE/session" \
     -H "Authorization: Bearer $TOKEN"

echo "✅ Logout successful"
echo
echo "=== API Usage Complete ==="
