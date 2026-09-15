# 算数コレ — 画像生成プロンプト集

**目的**: AI（DALL-E, Leonardo AI等）で不足する画像を生成  
**対象**: 算数コレ v3.1+ UI/ゲーム要素  
**フォーマット**: PNG 1024×1024px（推奨）、背景透過  
**更新**: 2026-06-23

---

## 📊 優先度

- **🔴 優先度A（今すぐ必要）**: トピックアイコン、UIフレーム
- **🟡 優先度B（近日中）**: ステージサムネイル
- **🔵 優先度C（あると良い）**: 背景素材、ローディング

---

## 🔴 優先度A: 即実装必要

### 1️⃣ トピックアイコン（8種）

**用途**: home_screen の「算数ガイド」セクション、quest_screen のトピック表示

#### Prompt テンプレート
```
Cute math icon for elementary school children. 
Colorful, playful, simple design.
No text or numbers.
Transparent background.
1024×1024px, PNG format.
```

#### 各トピック別プロンプト

| No. | トピック | プロンプト |
|-----|---------|----------|
| 1 | **たし算** | `Addition math icon: two smiling numbers "2" and "3" floating together with a plus sign between them, merging into number "5". Warm yellow and orange colors. Cute, kawaii style.` |
| 2 | **ひき算** | `Subtraction math icon: number "8" with a gentle smile, number "3" floating away with a minus sign. Soft blue and purple colors. Friendly expression.` |
| 3 | **かけ算** | `Multiplication math icon: three rows of cute objects (stars, hearts, or apples) arranged in a grid pattern. "3×4" concept. Golden and pink colors.` |
| 4 | **わり算** | `Division math icon: one pizza or pie being divided into equal slices by cute lines. Number "8÷2" concept. Orange and cream colors.` |
| 5 | **分数** | `Fraction icon: rectangular cake or chocolate bar divided into equal pieces. One piece highlighted. Purple and brown colors. Simple, clear.` |
| 6 | **小数** | `Decimal point icon: large dot surrounded by smaller dots, showing decimal progression. Blue gradient. Elegant, mathematical feel.` |
| 7 | **図形** | `Geometry icon: collection of cute shape characters (triangle, square, circle) with faces and expressions. Rainbow colors. Playful.` |
| 8 | **文章問題** | `Word problem icon: cute character thinking, speech bubble with equation, lightbulb idea above head. Green and light blue colors.` |

---

### 2️⃣ UIフレーム（4種）

**用途**: result_screen 背景、achievement カード等

#### Prompt テンプレート
```
Cute decorative frame border for elementary school children's app.
Kawaii style, vibrant colors.
Transparent background except for frame.
Square format, 1024×1024px.
```

#### 各フレーム別プロンプト

| No. | フレーム名 | プロンプト |
|-----|----------|----------|
| 1 | **リボン** | `Cute pink and white ribbon bow frame. Decorative bows at corners, ribbons flowing along edges. Kawaii style. Celebration theme. Transparent center.` |
| 2 | **虹** | `Rainbow frame border. Pastel rainbow colors (red, orange, yellow, green, blue, purple) forming decorative border. Cute clouds at corners. Dreamy style.` |
| 3 | **スター** | `Sparkling star frame. Glowing golden and silver stars of different sizes forming border. Sparkle effects around stars. Magical, shimmering theme.` |
| 4 | **パーティー** | `Celebration party frame. Confetti, balloons, streamers around edges. Festive colors (gold, pink, purple, blue). Happy, celebratory mood.` |

---

## 🟡 優先度B: 近日中

### 3️⃣ ステージサムネイル（92種パターン化）

**用途**: stage_select_screen のステージアイコン表示

**戦略**: 92種個別生成ではなく、パターン化 → 学年別6パターン × テーマ

#### パターン化提案

```
Grade 1-2: 基本的な数字・指・数え棒を使ったビジュアル
Grade 3-4: グループ・グリッド・ピザなど
Grade 5-6: グラフ・方程式・図形
```

#### Prompt テンプレート（1個例）

```
Stage thumbnail for elementary school math app.
Theme: Addition (Grade 1).
Visual: Two cute cartoon characters or mascots holding numbers, adding together.
Warm colors (yellow, orange, red).
Clear, simple, cute style.
Transparent background, 512×512px.
```

---

## 🔵 優先度C: あると良い

### 4️⃣ 背景素材（4種）

**用途**: home_screen, quest_screen, result_screen のページ背景

- **Soft Gradient**: パステルカラー（青→紫）
- **Nature Theme**: 草、花、太陽モチーフ
- **Educational Grid**: 微細な方眼紙パターン
- **Celebration Confetti**: 薄いキラキラパターン

---

## 📝 生成手順

### Leonardo AI を使う場合

1. **Model**: Phoenix 1.0
2. **Style**: Illustration, Cute, Kawaii
3. **Guidance**: 8.0-8.5
4. **Alchemy**: ON（品質向上）
5. **Negative Prompt**: 
   ```
   realistic, photorealistic, 3D, text, watermark, 
   Japanese characters, writing, numbers, unsafe content
   ```

### DALL-E を使う場合

1. **Model**: DALL-E 3
2. **Size**: 1024x1024
3. **Quality**: HD
4. **Style**: Playful, cute, illustration

### Midjourney を使う場合

```
/imagine [prompt] --ar 1:1 --niji 6 --q 2
```

---

## ✅ 納品チェックリスト

- [ ] PNG 形式（JPEG ❌）
- [ ] 背景透過（透明度ある）
- [ ] 1024×1024px 以上
- [ ] 日本語テキスト ❌
- [ ] 著作権クリア
- [ ] ファイル名: `[category]_[name].png`
  - 例: `topic_addition.png`, `frame_ribbon.png`

---

## 📂 保存場所

生成後は以下に配置してください：

```
H:\マイドライブ\images\小学コレ！\
├─ 共通画面\
│  ├─ UIフレーム\          ← 4フレーム
│  ├─ トピックアイコン\    ← 8個（新規）
│  └─ ステージサムネイル\  ← 92個（後日）
└─ 算数キャラ\
```

---

## 🔗 参考リンク

- **デザイン参考**: Your Wish 共通ガイドライン
- **色相**: 小学コレシリーズ統一カラー
  - Primary: #E74C3C (赤)
  - Accent Green: #27AE60
  - Accent Blue: #3498DB
  - Accent Orange: #E67E22

---

**最終更新**: 2026-06-23  
**次回更新**: ステージサムネイル納品時

