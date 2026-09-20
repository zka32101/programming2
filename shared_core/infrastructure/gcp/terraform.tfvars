gcp_project_id = "shougakukore"
service_account_email = "kokugo-kore-ci-bot@shougakukore.iam.gserviceaccount.com"

# kokugo-kore は既に GCP 上にシークレットが存在するため apps から除外
# (Terraform で管理すると既存リソースと衝突するため。実際の構成は10キー:
#  revenuecat-api-key, admob-app-id, admob-banner-ad-unit-id,
#  admob-interstitial-ad-unit-id, admob-rewarded-ad-unit-id,
#  android-keystore-base64, android-keystore-password, android-key-password,
#  play-console-sa-key, firebase-admin-key)
apps = {
  "sansu-kore" = [
    "revenuecat-api-key",
    "android-keystore-base64",
    "android-keystore-password",
    "android-key-password",
    "play-console-sa-key",
    "firebase-admin-key",
  ]
}
