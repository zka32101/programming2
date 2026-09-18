# Firebase & RevenueCat App Registration Scripts

Automatic app registration and validation for Firebase and RevenueCat.

## Files

- `ensure-firebase-app.sh`: Firebase Management API integration
- `ensure-revenuecat-app.sh`: RevenueCat REST API v2 integration

## Prerequisites

### Firebase Script
- `gcloud` CLI installed and authenticated
- GCP project with Firebase enabled

### RevenueCat Script
- `gcloud` CLI installed and authenticated
- RevenueCat Secret API Key: `export REVENUECAT_SECRET_API_KEY="sk_live_..."`

## Usage

### Firebase App Registration

```bash
./ensure-firebase-app.sh <gcp_project_id> <package_name> [app_name] [platform]
```

**Examples:**
```bash
# Create/check Android app
./ensure-firebase-app.sh shougakukore com.yourwish.shougakukore.kokugo kokugo-kore ANDROID

# Create/check iOS app
./ensure-firebase-app.sh shougakukore com.yourwish.shougakukore.kokugo kokugo-kore iOS

# Check both platforms
./ensure-firebase-app.sh shougakukore com.yourwish.shougakukore.kokugo kokugo-kore ALL
```

**Output:**
```
🔥 Firebase App Registration Check
  Project: shougakukore
  Package: com.yourwish.shougakukore.kokugo
  App Name: kokugo-kore
  Platform: ANDROID

✓ Project Number: 123456789
✓ Firebase app already registered:
  App ID: 1:123456789:android:abc123def456...
```

### RevenueCat App Registration

```bash
export REVENUECAT_SECRET_API_KEY="sk_live_..."
./ensure-revenuecat-app.sh <app_name> <gcp_project_id> <store_type> <package_or_bundle_id>
```

**Examples:**
```bash
# Check/create Android app
./ensure-revenuecat-app.sh kokugo-kore shougakukore play_store com.yourwish.shougakukore.kokugo

# Check/create iOS app
./ensure-revenuecat-app.sh kokugo-kore shougakukore app_store com.yourwish.shougakukore.kokugo
```

**Output (app already registered):**
```
💳 RevenueCat App Registration Check
  App Name: kokugo-kore
  GCP Project: shougakukore
  Store Type: play_store
  Package/Bundle ID: com.yourwish.shougakukore.kokugo

✓ RevenueCat Project ID: proj_abc123...
✓ RevenueCat app already registered: kokugo-kore
  App ID: app_xyz789...
✓ SDK API key found in Secret Manager: revenuecat-sdk-kokugo-kore
```

**Output (app not registered, will auto-create):**
```
📱 Creating RevenueCat app: kokugo-kore
✅ RevenueCat app created successfully
  App ID: app_new123...

📝 Next steps:
  1. Go to RevenueCat Dashboard: https://dashboard.revenuecat.com
  2. Navigate to your app settings
  3. Copy the Public SDK API Key
  4. Store it in Secret Manager:
     ...
```

## Behavior

### Existing App
- ✅ App already registered → Display current configuration
- ⚠️ Ask user: "Keep existing configuration? (y/n)"
- If "n" → Exit (user must manually delete and re-register)

### New App
- ✅ Auto-create via API
- For RevenueCat: Prompt user to store SDK API key in Secret Manager

## RevenueCat API Status

⚠️ **VALIDATION REQUIRED** (script implemented without live API testing)

The `ensure-revenuecat-app.sh` script uses RevenueCat REST API v2, but was implemented without network access to test against the live API. 

**Validation checklist:**
- [ ] API endpoint paths (`/v2/projects`, `/v2/projects/{id}/apps`)
- [ ] Request JSON field names (`name`, `type`, `package_name`)
- [ ] Response structure and ID extraction patterns
- [ ] Error handling and edge cases

**How to validate:**
1. Obtain RevenueCat Secret API Key from dashboard
2. Run script: `REVENUECAT_SECRET_API_KEY="..." ./ensure-revenuecat-app.sh ...`
3. Check actual API response against https://www.revenuecat.com/docs/api-v2
4. If curl commands or JSON fields don't match, fix script and push directly to shared_core

## Integration Examples

### CI/CD Pipeline
```yaml
- name: Ensure Firebase and RevenueCat Apps
  run: |
    export REVENUECAT_SECRET_API_KEY=${{ secrets.REVENUECAT_SECRET_API_KEY }}
    
    # Firebase
    ./shared_core/infrastructure/scripts/ensure-firebase-app.sh \
      ${{ env.GCP_PROJECT }} \
      com.yourwish.shougakukore.kokugo \
      kokugo-kore ANDROID
    
    # RevenueCat
    ./shared_core/infrastructure/scripts/ensure-revenuecat-app.sh \
      kokugo-kore \
      ${{ env.GCP_PROJECT }} \
      play_store \
      com.yourwish.shougakukore.kokugo
```

### Local Setup
```bash
# All apps in yourwish series
APPS=(kokugo-kore sansu-kore shokollen-science)
GCP_PROJECT=shougakukore
export REVENUECAT_SECRET_API_KEY="sk_live_..."

for APP in "${APPS[@]}"; do
  PACKAGE="com.yourwish.shougakukore.$APP"
  
  ./ensure-firebase-app.sh "$GCP_PROJECT" "$PACKAGE" "$APP" ANDROID
  ./ensure-revenuecat-app.sh "$APP" "$GCP_PROJECT" play_store "$PACKAGE"
done
```

## Support

For issues:
1. Check script output for detailed error messages
2. Verify API credentials (gcloud auth, RevenueCat API key)
3. Consult official API documentation:
   - https://cloud.google.com/firebase/docs/projects/api/reference
   - https://www.revenuecat.com/docs/api-v2
