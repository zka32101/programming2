# GitHub Actions 閾ｪ蜍輔ン繝ｫ繝芽ｨｭ螳・

**繝ｪ繝昴ず繝医Μ**: `sansu-kore` (繝励Λ繧､繝吶・繝・  
**繧｢繧ｫ繧ｦ繝ｳ繝・*: `appsdev-hash`  
**閾ｪ蜍募喧**: main push 竊・APK 閾ｪ蜍慕函謌・

---

## 搭 繧ｻ繝・ヨ繧｢繝・・謇矩・

### Step 1: GitHub 縺ｧ繝励Λ繧､繝吶・繝医Μ繝昴ず繝医Μ菴懈・

1. **GitHub 縺ｫ繝ｭ繧ｰ繧､繝ｳ**
   ```
   https://github.com/appsdev-hash
   ```

2. **譁ｰ隕上Μ繝昴ず繝医Μ繧剃ｽ懈・**
   - 繝懊ち繝ｳ: `New`・亥承荳奇ｼ・
   - 繝ｪ繝昴ず繝医Μ蜷・ `sansu-kore`
   - 隱ｬ譏・ `邂玲焚繧ｳ繝ｬ・・ Flutter Math Education App`
   - **Visibility: Private** 笨・
   - Initialize: 繝√ぉ繝・け縺ｪ縺・
   - **Create repository**

---

### Step 2: 繝ｭ繝ｼ繧ｫ繝ｫ繧ｳ繝ｼ繝峨ｒ push

```bash
cd H:/繝槭う繝峨Λ繧､繝・apps/sansu-kore

# 繝ｪ繝｢繝ｼ繝医・蜑企勁
git remote remove origin

# 譁ｰ縺励＞繝ｪ繝｢繝ｼ繝医ｒ霑ｽ蜉
git remote add origin https://github.com/appsdev-hash/sansu-kore.git

# 繝・ヵ繧ｩ繝ｫ繝医ヶ繝ｩ繝ｳ繝√ｒ main 縺ｫ螟画峩
git branch -M main

# 蛻晏屓 push
git push -u origin main
```

**繝ｭ繧ｰ繧､繝ｳ譎・*:
- 繝｡繝ｼ繝ｫ: dev@gmail.com
- 繝代せ繝ｯ繝ｼ繝・ [GitHub 繝代せ繝ｯ繝ｼ繝云

縺ｾ縺溘・ **Personal Access Token** 繧剃ｽｿ逕ｨ

---

### Step 3: GitHub Actions 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ菴懈・

1. **繝ｭ繝ｼ繧ｫ繝ｫ縺ｧ莉･荳九ヵ繧｡繧､繝ｫ繧剃ｽ懈・**

**繝輔ぃ繧､繝ｫ繝代せ**:
```
H:\繝槭う繝峨Λ繧､繝暴apps\sansu-kore\.github\workflows\build-apk.yml
```

**蜀・ｮｹ**:
```yaml
name: Build APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Install dependencies
      run: |
        cd sansu-kore
        flutter pub get

    - name: Build APK
      run: |
        cd sansu-kore
        flutter build apk --release --no-tree-shake-icons

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: sansu-kore-apk
        path: sansu-kore/build/app/outputs/flutter-apk/app-release.apk

    - name: Create Release
      if: startsWith(github.ref, 'refs/tags/')
      uses: softprops/action-gh-release@v1
      with:
        files: sansu-kore/build/app/outputs/flutter-apk/app-release.apk
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

2. **git 縺ｧ霑ｽ蜉縺励※ commit**

```bash
cd H:/繝槭う繝峨Λ繧､繝・apps/sansu-kore

git add .github/workflows/build-apk.yml
git commit -m "Add GitHub Actions workflow for APK build"
git push origin main
```

---

### Step 4: 閾ｪ蜍輔ン繝ｫ繝臥｢ｺ隱・

1. **GitHub 縺ｧ繝ｪ繝昴ず繝医Μ繧帝幕縺・*
   ```
   https://github.com/appsdev-hash/sansu-kore
   ```

2. **Actions 繧ｿ繝悶ｒ繧ｯ繝ｪ繝・け**
   - 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ縺悟ｮ溯｡御ｸｭ縺狗｢ｺ隱・
   - 笨・繝薙Ν繝画・蜉溘°遒ｺ隱・

3. **繧｢繝ｼ繝・ぅ繝輔ぃ繧ｯ繝育｢ｺ隱・*
   - Build 螳御ｺ・竊・`Artifacts` 竊・`sansu-kore-apk` 繝繧ｦ繝ｳ繝ｭ繝ｼ繝・
   - APK 縺後ム繧ｦ繝ｳ繝ｭ繝ｼ繝牙庄閭ｽ縺狗｢ｺ隱・

---

## 逃 豈主屓縺ｮ譖ｴ譁ｰ繝輔Ο繝ｼ

**繝ｭ繝ｼ繧ｫ繝ｫ縺ｧ髢狗匱** 竊・**commit** 竊・**push to main**

```bash
# 菫ｮ豁｣/霑ｽ蜉
vim lib/screens/quest_screen.dart

# 遒ｺ隱・
git status

# 繧ｳ繝溘ャ繝・
git add .
git commit -m "Fix: [隱ｬ譏讃"

# 繝励ャ繧ｷ繝･
git push origin main

# GitHub Actions 縺瑚・蜍慕噪縺ｫ APK 繧偵ン繝ｫ繝・
# 竊・Actions 繧ｿ繝悶〒遒ｺ隱・
# 竊・Artifacts 縺九ｉ APK 繧偵ム繧ｦ繝ｳ繝ｭ繝ｼ繝・
```

---

## 柏 Personal Access Token・域耳螂ｨ・・

**繝代せ繝ｯ繝ｼ繝我ｻ｣繧上ｊ縺ｫ PAT 繧剃ｽｿ逕ｨ**:

1. GitHub 竊・Settings 竊・Developer settings 竊・Personal access tokens
2. **Generate new token**
3. Name: `sansu-kore-build`
4. Scopes: `repo` (full control of private repositories)
5. **Generate token**
6. 繝医・繧ｯ繝ｳ繧偵さ繝斐・・井ｺ悟ｺｦ縺ｨ隕九∴縺ｾ縺帙ｓ・・

**git 縺ｧ菴ｿ逕ｨ**:
```bash
git push origin main
# Username: appsdev-hash
# Password: [Personal Access Token 繧偵・繝ｼ繧ｹ繝・
```

---

## 搭 繝√ぉ繝・け繝ｪ繧ｹ繝・

- [ ] GitHub 繝ｪ繝昴ず繝医Μ菴懈・・医・繝ｩ繧､繝吶・繝茨ｼ・
- [ ] 繝ｭ繝ｼ繧ｫ繝ｫ繧ｳ繝ｼ繝・push
- [ ] .github/workflows/build-apk.yml 菴懈・
- [ ] GitHub Actions 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ螳溯｡檎｢ｺ隱・
- [ ] APK 繧｢繝ｼ繝・ぅ繝輔ぃ繧ｯ繝育｢ｺ隱・
- [ ] 豈主屓縺ｮ push 縺ｧ閾ｪ蜍輔ン繝ｫ繝牙虚菴懃｢ｺ隱・

---

## 菅 繝医Λ繝悶Ν繧ｷ繝･繝ｼ繝・ぅ繝ｳ繧ｰ

### 繝ｯ繝ｼ繧ｯ繝輔Ο繝ｼ螟ｱ謨玲凾

**GitHub 縺ｮ Actions 繧ｿ繝・* 竊・螟ｱ謨励＠縺溘Ρ繝ｼ繧ｯ繝輔Ο繝ｼ 竊・繝ｭ繧ｰ遒ｺ隱・

繧医￥縺ゅｋ蜴溷屏:
- `flutter pub get` 螟ｱ謨・竊・`pubspec.yaml` 遒ｺ隱・
- `flutter build apk` 螟ｱ謨・竊・繝ｭ繝ｼ繧ｫ繝ｫ縺ｧ繝薙Ν繝臥｢ｺ隱・
- `shared_core` 繝代せ蝠城｡・竊・繝ｪ繝昴ず繝医Μ讒区・遒ｺ隱・

---

**閾ｪ蜍輔ン繝ｫ繝芽ｨｭ螳壼ｮ御ｺ・ｾ・*: 螳滓ｩ溘ユ繧ｹ繝医↓謌ｻ繧・


