#!/bin/bash
# Ensure Firebase app is registered for a given GCP project
# Usage: ./ensure-firebase-app.sh <gcp_project_id> <package_name> <app_name>
# Example: ./ensure-firebase-app.sh shougakukore com.yourwish.shougakukore.kokugo "kokugo-kore"

set -e

GCP_PROJECT="${1}"
PACKAGE_NAME="${2}"
APP_NAME="${3:-}"
PLATFORM="${4:-ANDROID}"

if [ -z "$GCP_PROJECT" ] || [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: $0 <gcp_project_id> <package_name> [app_name] [platform]"
  echo "Example: $0 shougakukore com.yourwish.shougakukore.kokugo kokugo-kore ANDROID"
  exit 1
fi

if [ -z "$APP_NAME" ]; then
  APP_NAME=$(echo "$PACKAGE_NAME" | sed 's/com\.yourwish\.shougakukore\.//' | sed 's/\./-/g')
fi

echo "🔥 Firebase App Registration Check"
echo "  Project: $GCP_PROJECT"
echo "  Package: $PACKAGE_NAME"
echo "  App Name: $APP_NAME"
echo "  Platform: $PLATFORM"
echo ""

# Get Firebase project number
PROJECT_NUMBER=$(gcloud projects describe "$GCP_PROJECT" --format='value(projectNumber)' 2>/dev/null)
if [ -z "$PROJECT_NUMBER" ]; then
  echo "❌ Failed to get project number for $GCP_PROJECT"
  exit 1
fi

echo "✓ Project Number: $PROJECT_NUMBER"

# Check if Firebase app already exists
EXISTING_APPS=$(gcloud firebase apps list --project="$GCP_PROJECT" --filter="displayName:$APP_NAME" --format="value(appId)" 2>/dev/null || echo "")

if [ ! -z "$EXISTING_APPS" ]; then
  echo "✓ Firebase app already registered:"
  echo "  App ID: $EXISTING_APPS"
  echo ""
  echo "❓ Keep existing configuration? (y/n)"
  read -r RESPONSE
  if [ "$RESPONSE" != "y" ] && [ "$RESPONSE" != "Y" ]; then
    echo "⚠️  Please manually delete and re-register the app in Firebase Console"
    exit 0
  fi
  exit 0
fi

# Register new Android app
if [ "$PLATFORM" = "ANDROID" ]; then
  echo ""
  echo "📱 Creating Android app: $APP_NAME"

  RESULT=$(gcloud firebase apps create \
    --project="$GCP_PROJECT" \
    --display-name="$APP_NAME" \
    android \
    --package-name="$PACKAGE_NAME" 2>&1)

  APP_ID=$(echo "$RESULT" | grep -oP "(?<=appId: )[^ ]+" || echo "")

  if [ ! -z "$APP_ID" ]; then
    echo "✅ Android app created successfully"
    echo "  App ID: $APP_ID"
  else
    echo "⚠️  Create command executed but app ID not extracted"
    echo "$RESULT"
  fi
fi

# Register new iOS app
if [ "$PLATFORM" = "IOS" ] || [ "$PLATFORM" = "ALL" ]; then
  echo ""
  echo "🍎 Creating iOS app: ${APP_NAME}-ios"

  # iOS requires bundle ID instead of package name
  IOS_BUNDLE_ID=$(echo "$PACKAGE_NAME" | sed 's/com\.yourwish\.shougakukore/com.yourwish.ios/' || echo "$PACKAGE_NAME")

  RESULT=$(gcloud firebase apps create \
    --project="$GCP_PROJECT" \
    --display-name="${APP_NAME}-ios" \
    ios \
    --bundle-id="$IOS_BUNDLE_ID" 2>&1)

  APP_ID=$(echo "$RESULT" | grep -oP "(?<=appId: )[^ ]+" || echo "")

  if [ ! -z "$APP_ID" ]; then
    echo "✅ iOS app created successfully"
    echo "  App ID: $APP_ID"
  else
    echo "⚠️  Create command executed but app ID not extracted"
    echo "$RESULT"
  fi
fi

echo ""
echo "✓ Firebase app registration check complete"
