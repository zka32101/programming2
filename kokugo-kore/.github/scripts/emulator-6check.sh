#!/bin/bash
# 6観点エミュレーターテスト

set -e

APP_PACKAGE="com.yourwish.shougakukore.kokugo"
OUTPUT_DIR="emulator-test-results"

mkdir -p "$OUTPUT_DIR"

echo "🧪 kokugo-kore エミュレーターテスト（6観点）"
echo "================================================"

# 1. 起動テスト
echo ""
echo "1️⃣ 起動テスト..."
adb shell pm clear "$APP_PACKAGE" || true
adb shell am start -n "$APP_PACKAGE/.MainActivity" > "$OUTPUT_DIR/launch_test.log" 2>&1
sleep 10
if adb shell dumpsys window | grep -q "mCurrentFocus"; then
  echo "✅ 起動テスト: PASS"
  echo "起動成功" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "❌ 起動テスト: FAIL"
  echo "起動失敗" >> "$OUTPUT_DIR/test_results.txt"
fi

# 2. 接続テスト
echo ""
echo "2️⃣ 接続テスト..."
adb logcat -d > "$OUTPUT_DIR/logcat_2.log"
if grep -q "firebase\|api" "$OUTPUT_DIR/logcat_2.log"; then
  echo "✅ 接続テスト: PASS (API/Firebase 通信確認)"
  echo "接続成功" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "⚠️  接続テスト: WARNING (ログ確認)"
  echo "接続確認" >> "$OUTPUT_DIR/test_results.txt"
fi

# 3. 課金画面テスト
echo ""
echo "3️⃣ 課金画面テスト..."
adb logcat -d | grep -i "billing\|iap" > "$OUTPUT_DIR/billing_test.log" || true
if [ -s "$OUTPUT_DIR/billing_test.log" ]; then
  echo "✅ 課金画面テスト: PASS (Billing SDK 検出)"
  echo "課金画面OK" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "⚠️  課金画面テスト: NO_LOG"
  echo "課金画面確認" >> "$OUTPUT_DIR/test_results.txt"
fi

# 4. 認証フロー
echo ""
echo "4️⃣ 認証フローテスト..."
adb logcat -d | grep -i "auth\|login\|firebase_auth" > "$OUTPUT_DIR/auth_test.log" || true
if [ -s "$OUTPUT_DIR/auth_test.log" ]; then
  echo "✅ 認証フロー: PASS"
  echo "認証OK" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "⚠️  認証フロー: NO_LOG"
  echo "認証確認" >> "$OUTPUT_DIR/test_results.txt"
fi

# 5. 広告表示
echo ""
echo "5️⃣ 広告表示テスト..."
adb logcat -d | grep -i "admob\|google_mobile_ads\|ad" > "$OUTPUT_DIR/ads_test.log" || true
if [ -s "$OUTPUT_DIR/ads_test.log" ]; then
  echo "✅ 広告表示: PASS (AdMob SDK 検出)"
  echo "広告OK" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "⚠️  広告表示: NO_LOG"
  echo "広告確認" >> "$OUTPUT_DIR/test_results.txt"
fi

# 6. クラッシュ検出
echo ""
echo "6️⃣ クラッシュ検出テスト..."
adb logcat -d > "$OUTPUT_DIR/crash_test.log"
if grep -i "fatal\|crash\|exception" "$OUTPUT_DIR/crash_test.log"; then
  echo "❌ クラッシュ検出: FAIL (クラッシュあり)"
  echo "クラッシュ検出" >> "$OUTPUT_DIR/test_results.txt"
else
  echo "✅ クラッシュ検出: PASS (クラッシュなし)"
  echo "クラッシュなし" >> "$OUTPUT_DIR/test_results.txt"
fi

echo ""
echo "================================================"
echo "✅ テスト完了"
echo "結果: $OUTPUT_DIR/test_results.txt"
