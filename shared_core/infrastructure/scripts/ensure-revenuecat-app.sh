#!/bin/bash
# Ensure RevenueCat app is registered and SDK key is in Secret Manager
# Usage: ./ensure-revenuecat-app.sh <app_name> <gcp_project_id> <store_type> <package_or_bundle_id>
# Example: ./ensure-revenuecat-app.sh kokugo-kore shougakukore play_store com.yourwish.shougakukore.kokugo

set -e

APP_NAME="${1}"
GCP_PROJECT="${2}"
STORE_TYPE="${3}"  # play_store, app_store, stripe, etc.
PACKAGE_ID="${4}"

if [ -z "$APP_NAME" ] || [ -z "$GCP_PROJECT" ] || [ -z "$STORE_TYPE" ] || [ -z "$PACKAGE_ID" ]; then
  echo "Usage: $0 <app_name> <gcp_project_id> <store_type> <package_or_bundle_id>"
  echo "Example: $0 kokugo-kore shougakukore play_store com.yourwish.shougakukore.kokugo"
  exit 1
fi

if [ -z "$REVENUECAT_SECRET_API_KEY" ]; then
  echo "❌ REVENUECAT_SECRET_API_KEY environment variable not set"
  exit 1
fi

echo "💳 RevenueCat App Registration Check"
echo "  App Name: $APP_NAME"
echo "  GCP Project: $GCP_PROJECT"
echo "  Store Type: $STORE_TYPE"
echo "  Package/Bundle ID: $PACKAGE_ID"
echo ""

# RevenueCat API base URL
RC_API="https://api.revenuecat.com/v2"

# Check if app already exists in RevenueCat
echo "🔍 Checking RevenueCat for existing app: $APP_NAME"

# First, get list of projects
PROJECTS=$(curl -s \
  -H "Authorization: Bearer $REVENUECAT_SECRET_API_KEY" \
  "$RC_API/projects" 2>/dev/null || echo "{}")

# Try to extract first project (RevenueCat typically has one project per organization)
PROJECT_ID=$(echo "$PROJECTS" | grep -oP '(?<="id":\s*")[^"]+' | head -1 || echo "")

if [ -z "$PROJECT_ID" ]; then
  echo "⚠️  Could not find RevenueCat project"
  echo "Response: $PROJECTS"
  exit 1
fi

echo "✓ RevenueCat Project ID: $PROJECT_ID"

# List existing apps in the project
APPS=$(curl -s \
  -H "Authorization: Bearer $REVENUECAT_SECRET_API_KEY" \
  "$RC_API/projects/$PROJECT_ID/apps" 2>/dev/null || echo "{}")

# Check if app with matching name exists
EXISTING_APP=$(echo "$APPS" | grep -oP "\"name\":\s*\"$APP_NAME\"" || echo "")

if [ ! -z "$EXISTING_APP" ]; then
  echo "✓ RevenueCat app already registered: $APP_NAME"

  # Extract app ID from response
  APP_ID=$(echo "$APPS" | grep -B 5 "\"name\":\s*\"$APP_NAME\"" | grep -oP '(?<="id":\s*")[^"]+' | head -1 || echo "")
  echo "  App ID: $APP_ID"

  # Check if SDK key is in Secret Manager
  echo ""
  echo "🔐 Checking Secret Manager for SDK API key..."

  SECRET_NAME="revenuecat-sdk-${APP_NAME//\-/_}"
  if gcloud secrets describe "$SECRET_NAME" --project="$GCP_PROJECT" >/dev/null 2>&1; then
    echo "✓ SDK API key found in Secret Manager: $SECRET_NAME"
  else
    echo "⚠️  SDK API key NOT found in Secret Manager"
    echo "  Expected secret name: $SECRET_NAME"
    echo ""
    echo "❓ Create secret and populate with public SDK API key? (y/n)"
    read -r RESPONSE
    if [ "$RESPONSE" = "y" ] || [ "$RESPONSE" = "Y" ]; then
      echo "Please provide the public SDK API key (from RevenueCat Dashboard):"
      read -r SDK_KEY
      if [ ! -z "$SDK_KEY" ]; then
        echo -n "$SDK_KEY" | gcloud secrets create "$SECRET_NAME" \
          --replication-policy='automatic' \
          --data-file=- \
          --project="$GCP_PROJECT" 2>/dev/null || \
        echo -n "$SDK_KEY" | gcloud secrets versions add "$SECRET_NAME" \
          --data-file=- \
          --project="$GCP_PROJECT"
        echo "✓ SDK API key stored in Secret Manager: $SECRET_NAME"
      fi
    fi
  fi

  exit 0
fi

# Create new app in RevenueCat
echo ""
echo "📱 Creating RevenueCat app: $APP_NAME"

CREATE_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $REVENUECAT_SECRET_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$APP_NAME\",
    \"type\": \"$STORE_TYPE\",
    \"package_name\": \"$PACKAGE_ID\"
  }" \
  "$RC_API/projects/$PROJECT_ID/apps" 2>/dev/null || echo "{}")

# Extract app ID from response
NEW_APP_ID=$(echo "$CREATE_RESPONSE" | grep -oP '(?<="id":\s*")[^"]+' | head -1 || echo "")

if [ ! -z "$NEW_APP_ID" ]; then
  echo "✅ RevenueCat app created successfully"
  echo "  App ID: $NEW_APP_ID"
  echo ""
  echo "📝 Next steps:"
  echo "  1. Go to RevenueCat Dashboard: https://dashboard.revenuecat.com"
  echo "  2. Navigate to your app settings"
  echo "  3. Copy the Public SDK API Key"
  echo "  4. Store it in Secret Manager:"
  echo ""
  echo "     export REVENUECAT_SDK_KEY='<your-public-sdk-api-key>'"
  echo "     gcloud secrets create revenuecat-sdk-$APP_NAME \\"
  echo "       --replication-policy='automatic' \\"
  echo "       --data-file=- --project=$GCP_PROJECT <<< \$REVENUECAT_SDK_KEY"
else
  echo "❌ Failed to create RevenueCat app"
  echo "Response: $CREATE_RESPONSE"
  exit 1
fi

echo ""
echo "✓ RevenueCat app registration check complete"
