# 算数コレ！キャラクター Lv.1～5 プロンプト（最終版）

**バージョン**: v6.0 (簡潔統一版)  
**対応**: 算数コレ sansu-kore  
**キャラ数**: 10体（Tier 1-4）  
**Lv段階**: 5段階 × 全キャラ共通パターン  
**生成方法**: テンプレート + Image Guidance  
**推奨ツール**: Leonardo AI Phoenix 1.0

---

## 📋 Lv別 共通パターン

```
【Lv.1】基本立ち絵
→ 正面向き、{colors}色、{personality}表情
→ Image Guidance: なし

【Lv.2】Smile（喜び顔）
→ Lv.1の身体 + 大きく笑う表情
→ Image Guidance: {id}_lv1_normal.png

【Lv.3】Sad（悲しみ顔）
→ Lv.1の身体 + 悲しみ・心配顔
→ Image Guidance: {id}_lv1_normal.png

【Lv.4】Guts（ガッツポーズ）
→ Lv.1の顔 + 右拳上げ勝利ポーズ
→ Image Guidance: {id}_lv1_normal.png

【Lv.5】Sparkle（きらきら版）
→ Lv.1と完全同じ + 光エフェクト全面
→ Image Guidance: {id}_lv1_normal.png
```

---

## 🎯 シンプルなプロンプトテンプレート

### Lv.1: Normal
```
{CHARACTER_NAME} Lv.1 Normal - {lv1_description}. 
Standing upright, front-facing, {personality} expression. 
Surrounded by warm {colors} sparkles. 4k quality.
```

### Lv.2: Smile
```
{CHARACTER_NAME} Lv.2 Smile - SAME pose and body as Lv.1, 
but EXPRESSION CHANGED to: big joyful smile, eyes sparkling 
with joy, happy expression. Image Guidance: {id}_lv1_normal.png. 
4k quality.
```

### Lv.3: Sad
```
{CHARACTER_NAME} Lv.3 Sad - SAME pose and body as Lv.1, 
but EXPRESSION CHANGED to: sad worried face, teardrops, 
concerned eyes. Image Guidance: {id}_lv1_normal.png. 
4k quality.
```

### Lv.4: Guts
```
{CHARACTER_NAME} Lv.4 Guts - SAME happy face as Lv.1, 
but BODY POSE CHANGED to: right arm/paw raised HIGH in 
victory pose, powerful confident stance. Image Guidance: 
{id}_lv1_normal.png. 4k quality.
```

### Lv.5: Sparkle
```
{CHARACTER_NAME} Lv.5 Sparkle MAX - IDENTICAL to Lv.1 pose 
and face, but WITH ADDED EFFECTS: bright sparkling stars, 
rainbow light aura, gleaming shimmer throughout body, glowing 
horn/features, light rays radiating outward. Image Guidance: 
{id}_lv1_normal.png. 4k quality.
```

---

## 👥 10キャラクター パラメータ

### Tier 1

```json
[
  {
    "id": "ichiko",
    "name": "イチコ",
    "animal": "rabbit",
    "colors": "soft warm golden yellow",
    "personality": "kind and encouraging",
    "lv1_description": "adorable golden rabbit with single spiral horn, big bright eyes, gentle smile, fluffy golden fur, light collar with + symbol"
  },
  {
    "id": "niniko",
    "name": "ニニコ",
    "animal": "twin foxes",
    "colors": "soft pink and turquoise",
    "personality": "harmonious and balanced",
    "lv1_description": "twin foxes perfectly mirrored, pink and turquoise, bright sparkling eyes, warm smiles, fluffy tails, matching ribbons"
  },
  {
    "id": "trai",
    "name": "トライ",
    "animal": "three-headed dragon",
    "colors": "warm red-orange and golden",
    "personality": "strong yet gentle",
    "lv1_description": "adorable three-headed baby dragon, three cute heads with big bright eyes, gentle expressions, fluffy soft fur, stubby cute legs, golden crowns"
  },
  {
    "id": "fouku",
    "name": "フォーク",
    "animal": "young deer",
    "colors": "soft purple-pink",
    "personality": "kind and generous",
    "lv1_description": "adorable young deer with four slender cute legs perfectly balanced, big gentle eyes, warm soft expression, fluffy tail, delicate antlers with soft glow"
  }
]
```

### Tier 2

```json
[
  {
    "id": "gogo",
    "name": "ゴーゴ",
    "animal": "five-legged bunny",
    "colors": "bright blue and vivid purple",
    "personality": "energetic and playful",
    "lv1_description": "energetic five-legged bunny-like creature with soft blue-purple fur, large bright sparkling eyes, fluffy body, five cute flexible legs, cheerful expression"
  },
  {
    "id": "multiko",
    "name": "マルティプル",
    "animal": "winged tiger cub",
    "colors": "metallic red-orange and golden",
    "personality": "powerful yet cute",
    "lv1_description": "adorable young tiger with warm red-orange striped fur and golden accents, bright playful eyes, four soft feathery wings in red and gold, compact muscular form"
  },
  {
    "id": "divido",
    "name": "ディバイド",
    "animal": "six-tailed fox",
    "colors": "deep royal purple and warm gold",
    "personality": "wise and elegant",
    "lv1_description": "elegant six-tailed fox with soft purple and gold colored fur, kind gentle eyes, six fluffy tails arranged in perfect symmetry, graceful refined body proportions"
  }
]
```

### Tier 3

```json
[
  {
    "id": "geome",
    "name": "ジオメ",
    "animal": "geometric unicorn",
    "colors": "shimmering cyan and gold",
    "personality": "elegant and artistic",
    "lv1_description": "beautiful graceful unicorn with shimmering cyan and gold colored coat, spiraling horn glowing with geometric patterns, intricate geometric designs, large kind intelligent eyes"
  },
  {
    "id": "calcuku",
    "name": "カルキュ",
    "animal": "wise owl",
    "colors": "deep emerald green and warm golden",
    "personality": "wise and compassionate",
    "lv1_description": "wise ancient owl with deep emerald green and warm golden plumage, large round knowing eyes expressing centuries of understanding, soft fluffy body, peaceful serene expression"
  }
]
```

### Tier 4

```json
[
  {
    "id": "plus_minus",
    "name": "プラスマイナス",
    "animal": "yin-yang dragon",
    "colors": "gold and silver",
    "personality": "transcendent and compassionate",
    "lv1_description": "magnificent legendary dragon with scales that shimmer in gold and silver representing + and − principles in balance, large wise dragon eyes, graceful elegant form, flowing body"
  }
]
```

---

## 🔄 生成フロー（Leonardo AI）

```
【各キャラごと】

Step 1: Lv.1 生成
  テンプレート: Lv.1: Normal
  参照: {キャラパラメータ}
  → {id}_lv1_normal.png 保存

Step 2: Lv.2 生成
  テンプレート: Lv.2: Smile
  Image Guidance: {id}_lv1_normal.png
  → {id}_lv2_smile.png 保存

Step 3: Lv.3 生成
  テンプレート: Lv.3: Sad
  Image Guidance: {id}_lv1_normal.png
  → {id}_lv3_sad.png 保存

Step 4: Lv.4 生成
  テンプレート: Lv.4: Guts
  Image Guidance: {id}_lv1_normal.png
  → {id}_lv4_guts.png 保存

Step 5: Lv.5 生成
  テンプレート: Lv.5: Sparkle
  Image Guidance: {id}_lv1_normal.png
  → {id}_lv5_sparkle.png 保存

【合計】
1キャラ = 5画像
10キャラ = 50画像
```

---

## 📊 統計

```
総画像数: 10キャラ × 5Lv = 50画像
テンプレート数: 5パターン（全キャラ共通）
推定生成時間: 3-5分/キャラ × 10 = 30-50分
推定Leonardo クレジット: 100-150

Leonardo設定:
  Model: Phoenix 1.0
  Guidance: 8.0-8.5
  Alchemy: ON（Lv.2-5）
  Image Guidance: Lv.2-5 で Lv.1参照
```

---

## ✅ 命名規則

```
{id}_lv1_normal.png      → ichiko_lv1_normal.png
{id}_lv2_smile.png       → ichiko_lv2_smile.png
{id}_lv3_sad.png         → ichiko_lv3_sad.png
{id}_lv4_guts.png        → ichiko_lv4_guts.png
{id}_lv5_sparkle.png     → ichiko_lv5_sparkle.png
```

---

**最終更新**: 2026-06-16 v6.0  
**テンプレート**: 5パターン（全キャラ統一）  
**Image Guidance活用**: Lv.1を参考に Lv.2～5を一貫性確保  
**ステータス**: ✅ 生成準備完了
