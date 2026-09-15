# 邂玲焚繧ｳ繝ｬ・≫・iOS繝薙Ν繝芽ｨｭ螳壹ぎ繧､繝・

**迴ｾ迥ｶ**: Windows迺ｰ蠅・・縺溘ａ螳滓ｩ溽畑 .ipa 縺ｯ逕滓・荳榊庄・・code蠢・茨ｼ峨・
GitHub Actions 縺ｮ macOS 繝ｩ繝ｳ繝翫・縺ｧ莉｣譖ｿ讀懆ｨｼ縺吶ｋ菴灘宛繧呈紛蛯呎ｸ医∩縲・

---

## 莉雁屓縺ｮ蟇ｾ蠢懷・螳ｹ

### 1. 逋ｺ隕九＠縺滉ｸ榊・蜷医・菫ｮ豁｣

| 蝠城｡・| 蜀・ｮｹ | 蟇ｾ蠢・|
|------|------|------|
| Info.plist陦ｨ遉ｺ蜷崎ｪ､繧・| `CFBundleDisplayName` 縺・"Kokugo Kore"・亥嵜隱槭さ繝ｬ縺九ｉ縺ｮ繧ｳ繝斐・谿矩ｪｸ・・| 縲檎ｮ玲焚繧ｳ繝ｬ・√阪↓菫ｮ豁｣貂医∩ 笨・|
| **繝悶Λ繝ｳ繝∝錐荳堺ｸ閾ｴ・域怙驥崎ｦ・ｼ・* | 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ縺ｮ襍ｷ蜍墓擅莉ｶ縺・`branches: [main]` 縺縺｣縺溘′縲√％縺ｮ繝ｪ繝昴ず繝医Μ縺ｫ `main` 繝悶Λ繝ｳ繝√・蟄伜惠縺帙★螳滄圀縺ｯ `master` 縺ｮ縺ｿ縲・*縺薙ｌ縺ｾ縺ｧ縺ｮpush縺ｧActions縺ｯ荳蠎ｦ繧りｵｷ蜍輔＠縺ｦ縺・↑縺九▲縺・* | `master` 縺ｫ菫ｮ豁｣貂医∩ 笨・|
| GitHub Actions 繝代せ繝舌げ | 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ縺・`cd sansu-kore` 縺励※縺・◆縺後√Μ繝昴ず繝医Μ逶ｴ荳九′Flutter繝励Ο繧ｸ繧ｧ繧ｯ繝医・縺溘ａ蟄伜惠縺励↑縺・ョ繧｣繝ｬ繧ｯ繝医Μ繧貞盾辣ｧ縺励※縺・◆ | 菫ｮ豁｣貂医∩ 笨・|
| CI縺ｮFlutter繝舌・繧ｸ繝ｧ繝ｳ縺悟商縺吶℃繧・| `flutter-version: '3.24.0'` 謖・ｮ壹□縺ｨ縲｜undle縺輔ｌ繧汽art SDK縺・`pubspec.yaml` 縺ｮ `sdk: ^3.11.5` 蛻ｶ邏・ｒ貅縺溘○縺・`pub get` 縺悟､ｱ謨励☆繧・| 莉悶・繝ｭ繧ｸ繧ｧ繧ｯ繝茨ｼ域律譛ｬ縺ｮ譛ｪ譚･繝槭ャ繝暦ｼ峨〒螳溽ｸｾ縺ｮ縺ゅｋ `3.44.0` 縺ｫ邨ｱ荳 笨・|
| iOS Firebase譛ｪ險ｭ螳・| `firebase_options.dart` 縺景OS蜷代￠縺ｫ譛ｪ險ｭ螳夲ｼ・UnsupportedError`繧呈兜縺偵ｋ迥ｶ諷具ｼ・| 荳玖ｨ倥悟ｿ・ｦ√↑霑ｽ蜉菴懈･ｭ縲榊盾辣ｧ |
| Podfile荳榊惠 | iOS縺ｧ荳蠎ｦ繧ゅン繝ｫ繝峨＆繧後◆縺薙→縺後↑縺・`ios/Podfile` 縺檎函謌舌＆繧後※縺・↑縺九▲縺・| 譌･譛ｬ縺ｮ譛ｪ譚･繝槭ャ繝暦ｼ・irebase蜷梧｢ｱ繝ｻ螳溽ｸｾ縺ゅｊ・峨・Podfile繧呈ｵ∫畑縺励※譁ｰ隕丈ｽ懈・ 笨・|

### 2. GitHub Actions 繧・螻､讒区・縺ｫ蛻ｷ譁ｰ・医さ繧ｹ繝域怙驕ｩ蛹厄ｼ・

macOS繝ｩ繝ｳ繝翫・縺ｯLinux縺ｮ**10蛟・*縺ｮActions蛻・焚繧呈ｶ郁ｲｻ縺吶ｋ縺溘ａ縲∽ｻ･荳九・3螻､讒区・縺ｫ蛻ｷ譁ｰ・井ｻ悶・繝ｭ繧ｸ繧ｧ繧ｯ繝医〒縺ｮ螳滄圀縺ｮ繧ｳ繧ｹ繝郁ｶ・℃繧､繝ｳ繧ｷ繝・Φ繝医ｒ雕上∪縺医◆蟇ｾ蠢懶ｼ会ｼ・

| 繧ｸ繝ｧ繝・| 螳溯｡檎腸蠅・| 襍ｷ蜍墓擅莉ｶ |
|--------|---------|---------|
| `test`・・nalyze・・| ubuntu-latest | push / PR / 謇句虚 |
| `build-android`・・PK+AAB・・| ubuntu-latest | push / PR / 謇句虚 |
| `build-ios`・育ｽｲ蜷阪↑縺暦ｼ・| macos-latest | **PR譎・or 謇句虚縺ｮ縺ｿ**・・ush縺ｧ縺ｯ襍ｷ蜍輔＠縺ｪ縺・ｼ・|
| `build-ios-signed`・・estFlight驟榊ｸ・ｼ・| macos-latest | **謇句虚縺ｮ縺ｿ**・・ecrets譛ｪ險ｭ螳壹・縺溘ａ迴ｾ譎らせ縺ｧ縺ｯ螟ｱ謨励☆繧区Φ螳夲ｼ・|

### 3. Podfile 繧呈眠隕丈ｽ懈・・・RPC/BoringSSL譌｢遏･蝠城｡後∈縺ｮ蟇ｾ遲冶ｾｼ縺ｿ・・

Firebase邉ｻ繝代ャ繧ｱ繝ｼ繧ｸ・・irebase_core/cloud_firestore遲会ｼ峨′譁ｰ縺励＞Xcode縺ｧ繝薙Ν繝牙､ｱ謨励☆繧区里遏･縺ｮ蝠城｡鯉ｼ・-G`繝輔Λ繧ｰ繝ｻgRPC-Core縺ｮ繝・Φ繝励Ξ繝ｼ繝域ｧ区枚繧ｨ繝ｩ繝ｼ・峨↓蟇ｾ縺吶ｋ`post_install`繝輔ャ繧ｯ繧貞ｮ溽ｸｾ縺ｮ縺ゅｋ繝・Φ繝励Ξ繝ｼ繝医°繧臥ｧｻ讀肴ｸ医∩縲・

---

## 繝ｦ繝ｼ繧ｶ繝ｼ蛛ｴ縺ｧ蠢・ｦ√↑霑ｽ蜉菴懈･ｭ

### A. Firebase Console 縺ｧ iOS 繧｢繝励Μ繧堤匳骭ｲ・亥ｿ・茨ｼ・

迴ｾ蝨ｨ Firebase 繝励Ο繧ｸ繧ｧ繧ｯ繝・`your-wish-education` 縺ｫ縺ｯ
Android 繧｢繝励Μ・・com.apps.shougakukore.sansu`・峨・縺ｿ逋ｻ骭ｲ縺輔ｌ縺ｦ縺翫ｊ縲・
iOS 繧｢繝励Μ縺ｮ逋ｻ骭ｲ縺後≠繧翫∪縺帙ｓ縲・

**謇矩・*:
1. https://console.firebase.google.com/project/your-wish-education/settings/general
2. 縲後い繝励Μ繧定ｿｽ蜉縲坂・ iOS 繧帝∈謚・
3. 繝舌Φ繝峨ΝID: `jp..SansuKore`
4. 縲隈oogleService-Info.plist縲阪ｒ繝繧ｦ繝ｳ繝ｭ繝ｼ繝・
5. `H:\繝槭う繝峨Λ繧､繝暴apps\sansu-kore\ios\Runner\GoogleService-Info.plist` 縺ｫ驟咲ｽｮ
6. Xcode縺ｧ髢九＞縺ｦRunner繧ｿ繝ｼ繧ｲ繝・ヨ縺ｫ霑ｽ蜉縺吶ｋ蠢・ｦ√′縺ゅｋ縺溘ａ縲∝ｮ滄圀縺ｫ縺ｯMac縺ｧ縺ｮ荳蠎ｦ縺ｮ菴懈･ｭ縺悟ｿ・ｦ・
   ・医∪縺溘・CI蛛ｴ縺ｧ閾ｪ蜍暮・鄂ｮ縺吶ｋ繧医≧GitHub Secrets縺ｫ base64蛹悶＠縺ｦ逋ｻ骭ｲ縺吶ｋ譁ｹ豕輔ｂ縺ゅｊ・・
7. `flutterfire configure` 繧貞ｮ溯｡後☆繧九→ `lib/firebase_options.dart` 縺ｫiOS險ｭ螳壹′閾ｪ蜍募渚譏縺輔ｌ繧・

### B. Apple Developer Program 逋ｻ骭ｲ・亥ｮ滓ｩ滄・蟶・・App Store逕ｳ隲九↓蠢・茨ｼ・

- 蟷ｴ莨夊ｲｻ $99/蟷ｴ
- https://developer.apple.com/programs/enroll/
- 逋ｻ骭ｲ蠕後。undle ID `jp..SansuKore` 繧但pple Developer Portal縺ｧ繧ら匳骭ｲ

### C. 螳滓ｩ溘ン繝ｫ繝峨・TestFlight驟榊ｸ・↓縺ｯMac螳滓ｩ・or 繧ｯ繝ｩ繧ｦ繝窺ac縺悟ｿ・ｦ・

Windows蜊倅ｽ薙〒縺ｯ莉･荳九′縺ｧ縺阪∪縺帙ｓ・・
- 繧ｳ繝ｼ繝臥ｽｲ蜷搾ｼ・rovisioning Profile / Certificate・・
- 螳滓ｩ溘う繝ｳ繧ｹ繝医・繝ｫ
- App Store Connect 縺ｸ縺ｮ繧｢繝・・繝ｭ繝ｼ繝・

**驕ｸ謚櫁い**:
1. **Mac螳滓ｩ溘ｒ逕ｨ諢・*・井ｸｭ蜿､Mac mini縺ｪ縺ｩ縲∵怙繧ら｢ｺ螳滂ｼ・
2. **Codemagic / Bitrise 遲峨・繧ｯ繝ｩ繧ｦ繝窺ac CI**・育┌譁呎棧縺ゅｊ縲；itHub騾｣謳ｺ蜿ｯ閭ｽ・・
3. **GitHub Actions + fastlane match**・育ｽｲ蜷阪・閾ｪ蜍募喧縲∽ｸ顔ｴ夊・髄縺托ｼ・

---

## 迴ｾ譎らせ縺ｧ縺ｧ縺阪ｋ縺薙→繝ｻ縺ｧ縺阪↑縺・％縺ｨ

```
笨・縺ｧ縺阪ｋ・・indows + GitHub Actions 縺ｮ縺ｿ・・
- Dart繧ｳ繝ｼ繝峨・繧ｳ繝ｳ繝代う繝ｫ繧ｨ繝ｩ繝ｼ讀懆ｨｼ・・lutter build ios --no-codesign・・
- Info.plist / Xcode繝励Ο繧ｸ繧ｧ繧ｯ繝郁ｨｭ螳壹・髱咏噪縺ｪ遒ｺ隱阪・菫ｮ豁｣
- pubspec.yaml 縺ｮiOS蟇ｾ蠢懊ヱ繝・こ繝ｼ繧ｸ遒ｺ隱・

笶・縺ｧ縺阪↑縺・ｼ・ac/Xcode蠢・茨ｼ・
- 螳滓ｩ溘〒縺ｮ蜍穂ｽ懃｢ｺ隱・
- 繧ｳ繝ｼ繝臥ｽｲ蜷堺ｻ倥″繝薙Ν繝・.ipa)逕滓・
- TestFlight / App Store 縺ｸ縺ｮ謠仙・
```

---

## 谺｡縺ｮ繧｢繧ｯ繧ｷ繝ｧ繝ｳ・亥━蜈磯・ｼ・

1. Firebase Console 縺ｧ iOS 繧｢繝励Μ逋ｻ骭ｲ 竊・GoogleService-Info.plist 蜿門ｾ・
2. Apple Developer Program 逋ｻ骭ｲ・医∪縺縺ｮ蝣ｴ蜷茨ｼ・
3. Mac迺ｰ蠅・・遒ｺ菫晢ｼ亥ｮ滓ｩ・or 繧ｯ繝ｩ繧ｦ繝窺ac CI・・
4. `flutterfire configure` 縺ｧiOS險ｭ螳壹ｒ譛ｬ蜿肴丐
5. 鄂ｲ蜷堺ｻ倥″繝薙Ν繝臥畑縺ｮ GitHub Secrets 繧堤匳骭ｲ・・build-ios-signed`繧ｸ繝ｧ繝悶′蠢・ｦ√→縺吶ｋ蛟､・・
   - `IOS_DIST_CERT_BASE64` / `IOS_DIST_CERT_PASSWORD`・磯・蟶・ｨｼ譏取嶌 .p12・・
   - `IOS_PROVISION_PROFILE_BASE64`・医・繝ｭ繝薙ず繝ｧ繝九Φ繧ｰ繝励Ο繝輔ぃ繧､繝ｫ・・
   - `APP_STORE_CONNECT_API_KEY_BASE64` / `APP_STORE_CONNECT_KEY_ID` / `APP_STORE_CONNECT_ISSUER_ID`
   - `ios/ExportOptions.plist` 縺ｮ菴懈・
6. 螳滓ｩ溘ン繝ｫ繝峨・TestFlight驟榊ｸ・∈・・ctions繧ｿ繝・竊偵軍un workflow縲阪〒`build-ios-signed`繧呈焔蜍戊ｵｷ蜍包ｼ・

## Actions螳溯｡梧凾縺ｮ豕ｨ諢擾ｼ医さ繧ｹ繝育ｮ｡逅・ｼ・

`build-ios` / `build-ios-signed` 縺ｯ **謇句虚螳溯｡鯉ｼ・ctions繧ｿ繝・竊・Run workflow・峨ｒ驕ｸ縺ｶ縺ｾ縺ｧ閾ｪ蜍戊ｵｷ蜍輔＠縺ｾ縺帙ｓ**縲・
Podfile隱ｿ謨ｴ縺ｪ縺ｩ縺ｧ菴募ｺｦ繧りｩｦ陦碁険隱､縺吶ｋ蝣ｴ蜷医・縲√∪縺ｨ繧√※謇句虚螳溯｡後☆繧九ｈ縺・↓縺励｝ush縺ｮ縺溘・縺ｫ辟｡鬧・↑macOS隱ｲ驥代′逋ｺ逕溘＠縺ｪ縺・ｈ縺・ｳｨ諢上＠縺ｦ縺上□縺輔＞縲・


