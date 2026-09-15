# 算数コレ！キャラクター レベルアップ プロンプト テンプレート集

**バージョン**: v4.0 (テンプレート統一版)  
**生成方法**: テンプレート + キャラパラメータで80プロンプト自動生成  
**推奨ツール**: Leonardo AI Phoenix 1.0 (Image Guidance機能必須)

---

## 📋 キャラクター基本パラメータ

```json
{
  "tier1": [
    {
      "id": "ichiko",
      "name": "イチコ",
      "animal": "一角ウサギ",
      "colors": "golden yellow",
      "concept": "たし算・最初の一歩",
      "lv1_description": "adorable golden rabbit with single spiral horn, big bright curious eyes, gentle smile, fluffy soft fur, simple light collar with + symbol",
      "personality": "kind and encouraging"
    },
    {
      "id": "niniko",
      "name": "ニニコ",
      "animal": "双子キツネ",
      "colors": "soft pink and turquoise",
      "concept": "ひき算・バランス",
      "lv1_description": "twin foxes perfectly mirrored, pink on left and turquoise on right, both with bright sparkling eyes and warm smiles, fluffy tails, matching ribbons",
      "personality": "harmonious and balanced"
    },
    {
      "id": "trai",
      "name": "トライ",
      "animal": "三頭龍",
      "colors": "warm red-orange and golden",
      "concept": "かけ算・反復",
      "lv1_description": "adorable three-headed baby dragon, three cute heads with big bright eyes and gentle expressions, fluffy soft fur texture, stubby cute legs, small golden crowns on each head",
      "personality": "strong yet gentle"
    },
    {
      "id": "fouku",
      "name": "フォーク",
      "animal": "四足小鹿",
      "colors": "soft purple-pink",
      "concept": "わり算・公平",
      "lv1_description": "adorable young deer with four slender cute legs perfectly balanced, big gentle sparkling eyes, warm soft expression, soft fluffy tail, small delicate antlers with soft glow",
      "personality": "kind and generous"
    }
  ],
  "tier2": [
    {
      "id": "gogo",
      "name": "ゴーゴ",
      "animal": "五足ウサギ",
      "colors": "bright blue and vivid purple",
      "concept": "分数・小数",
      "lv1_description": "energetic five-legged bunny-like creature with soft blue-purple fur, large bright sparkling eyes, fluffy soft body, five cute flexible legs, cheerful happy expression",
      "personality": "energetic and playful"
    },
    {
      "id": "multiko",
      "name": "マルティプル",
      "animal": "四翼子虎",
      "colors": "metallic red-orange and golden",
      "concept": "かけ算・力",
      "lv1_description": "adorable young tiger with warm red-orange striped fur and golden accents, bright playful eyes, four soft feathery wings in red and gold, compact muscular form",
      "personality": "powerful yet cute"
    },
    {
      "id": "divido",
      "name": "ディバイド",
      "animal": "六尾キツネ",
      "colors": "deep royal purple and warm gold",
      "concept": "わり算・調和",
      "lv1_description": "elegant six-tailed fox with soft purple and gold colored fur, kind gentle eyes, six fluffy tails arranged in perfect symmetry, graceful refined body proportions",
      "personality": "wise and elegant"
    }
  ],
  "tier3": [
    {
      "id": "geome",
      "name": "ジオメ",
      "animal": "ユニコーン",
      "colors": "shimmering cyan and gold",
      "concept": "図形・美学",
      "lv1_description": "beautiful graceful unicorn with shimmering cyan and gold colored coat, spiraling horn glowing with geometric patterns, entire body covered with intricate geometric designs, large kind intelligent eyes",
      "personality": "elegant and artistic"
    },
    {
      "id": "calcuku",
      "name": "カルキュ",
      "animal": "知恵のフクロウ",
      "colors": "deep emerald green and warm golden",
      "concept": "算数・知恵",
      "lv1_description": "wise ancient owl with deep emerald green and warm golden plumage, large round knowing eyes expressing centuries of understanding, soft fluffy body, peaceful serene expression",
      "personality": "wise and compassionate"
    }
  ],
  "tier4": [
    {
      "id": "plus_minus",
      "name": "プラスマイナス",
      "animal": "陰陽龍",
      "colors": "gold and silver",
      "concept": "全操作・完成",
      "lv1_description": "magnificent legendary dragon with scales that shimmer in gold and silver representing + and − principles in balance, large wise dragon eyes, graceful elegant form, flowing body",
      "personality": "transcendent and compassionate"
    }
  ]
}
```

---

## 🎯 レベルアップ プロンプト テンプレート

### Template 1: Lv.1 Normal（基本立ち絵）

**用途**: 初期入手時  
**Image Guidance**: なし  
**ポイント**: キャラクター個性を最大限表現

```
{CHARACTER_NAME} Lv.1 - Normal Standing Pose, {lv1_description}. 
Standing upright, front-facing pose, relaxed natural position. 
{personality} expression. Surrounded by soft {colors} sparkles 
and warm glow. Perfect for first encounter. Illustration: kawaii 
{animal}, {colors} tones, {personality} expression, soft rounded 
shapes, inviting friendly, 4k quality.
```

**ネガティブプロンプト共通**:
```
angry sad, jumping active, bowing bent, scary, realistic, photorealistic, 
humanoid, distorted, low quality, text, watermark
```

---

### Template 2: Lv.2 Smile（喜び顔）

**用途**: 50コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と完全同じ・表情だけ変化

```
{CHARACTER_NAME} Lv.2 Smile version - SAME {lv1_description} 
as Lv.1, EXACT same pose and body, but EXPRESSION CHANGED to: 
big open joyful smile, mouth laughing broadly, eyes sparkling 
with brightness and joy, eyebrows raised upward showing happiness. 
All other details IDENTICAL to Lv.1. Only the FACE shows pure joy. 
Illustration: kawaii {animal}, same {colors} color, joyful bright 
expression, happy celebration mood, 4k quality.
```

**ネガティブプロンプト共通**:
```
sad frown, worried expression, neutral face, jumping, bowing, 
multiple poses, realistic, low quality, distorted features
```

---

### Template 3: Lv.2 Sad（悲しみ顔）

**用途**: 50コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と同じ・表情だけ悲しみに

```
{CHARACTER_NAME} Lv.2 Sad version - SAME {lv1_description} as Lv.1, 
IDENTICAL pose and body, but EXPRESSION CHANGED to: sad worried face, 
mouth formed as く字 (small frown), eyes showing concern or gentle 
sadness, small teardrops might be glistening on cheeks, eyebrows 
angled down showing worry. All other aspects UNCHANGED from Lv.1. 
Only face shows vulnerability. Illustration: kawaii {animal}, same 
{colors}, sad worried expression, gentle sympathy mood, 4k quality.
```

**ネガティブプロンプト共通**:
```
happy smile, excited expression, angry fierce, jumping, bowing, 
neutral face, realistic, low quality, distorted
```

---

### Template 4: Lv.2 Surprise（驚き顔）

**用途**: 50コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と同じ・驚き表情

```
{CHARACTER_NAME} Lv.2 Surprise version - SAME {lv1_description} 
as Lv.1, EXACT same body and pose, but EXPRESSION CHANGED to: 
surprised amazed face, mouth O-shaped in amazement, eyes opened 
VERY WIDE showing shock and wonder, eyebrows raised high above 
eyes, expression shows delight and astonishment. Every other detail 
PRESERVED from Lv.1. Only face expresses surprise and discovery. 
Illustration: kawaii {animal}, same {colors}, wide-eyed surprised 
expression, amazement discovery mood, 4k quality.
```

**ネガティブプロンプト共通**:
```
calm neutral, smiling happy, sad frown, angry, jumping, bowing, 
realistic, low quality, distorted expression
```

---

### Template 5: Lv.3 Guts（ガッツポーズ）

**用途**: 100コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: 喜び表情 + 右拳上げ勝利ポーズ

```
{CHARACTER_NAME} Lv.3 Guts Pose - SAME {lv1_description}, SAME kind 
happy face as Lv.1, but BODY POSE CHANGED to: dynamic victory pose, 
RIGHT PAWS/LIMBS RAISED HIGH in the air above showing strength and 
determination, left arm at side or raised differently showing asymmetry, 
body turned slightly forward in powerful confident stance, entire posture 
radiates achievement and confidence. Face shows determination and pride. 
Illustration: kawaii {animal}, same {colors}, powerful guts victory pose, 
confident achievement, dynamic action, 4k quality.
```

**ネガティブプロンプト共通**:
```
relaxed standing, jumping, bowing, sad expression, weak posture, 
both hands up equally, lazy slouch, realistic, low quality, distorted
```

---

### Template 6: Lv.3 Jump（ジャンプ）

**用途**: 100コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: 喜び表情 + 両足浮くジャンプ

```
{CHARACTER_NAME} Lv.3 Jump Pose - SAME {lv1_description}, SAME happy 
joyful face, but BODY POSE CHANGED to: energetic jumping pose, BOTH 
FEET/LEGS LIFTED OFF GROUND showing mid-jump motion, arms spread open 
or raised in celebration, body leaning slightly forward from jump momentum, 
face shows pure joy and energy. Radiates happiness and celebration. 
Illustration: kawaii {animal}, same {colors}, mid-jump dynamic pose, 
happy joyful energy, celebratory motion, 4k quality.
```

**ネガティブプロンプト共通**:
```
standing still, bowing, guts pose, sad expression, feet on ground, 
weak lazy pose, realistic, low quality, distorted motion
```

---

### Template 7: Lv.3 Bow（お辞儀）

**用途**: 100コイン育成後  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: 優しい表情 + 頭を下げるお辞儀

```
{CHARACTER_NAME} Lv.3 Bow Pose - SAME {lv1_description}, SAME kind 
expression, but BODY POSE CHANGED to: grateful respectful bow, HEAD 
BENT DOWN showing gratitude and humility, torso leaning forward in 
45-90 degree angle, arms at sides or slightly forward, feet in wide 
stance for balance, entire posture shows thanks and courtesy. Face 
shows peaceful appreciation. Illustration: kawaii {animal}, same 
{colors}, respectful bowing pose, grateful humble mood, peaceful 
appreciation, 4k quality.
```

**ネガティブプロンプト共通**:
```
standing upright, jumping, guts pose, proud expression, head raised, 
angry fierce, realistic, low quality, distorted posture
```

---

### Template 8: Lv.5 Sparkle（きらきら版）

**用途**: 500コイン育成後 + MAX到達  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と完全同じ + 光エフェクト全面追加

```
{CHARACTER_NAME} Lv.5 Sparkle version - SAME {lv1_description} in 
EXACT Lv.1 standing pose with {personality} expression, but WITH 
ADDED VISUAL EFFECTS: body surrounded by bright sparkling star 
particles constantly twinkling, soft rainbow light aura around 
entire figure, shimmer effect on fur/scales making it gleam and 
shine brilliantly, horn/distinguishing features glow more intensely 
with multiple colors, light rays emanating outward from body 
suggesting MAX power achievement, background subtle glow effect 
emphasizing specialness. Everything else IDENTICAL to Lv.1. Perfect 
for MAX level celebration and figure display. Illustration: kawaii 
{animal}, same {colors}, sparkle effects stars rainbows, maximum 
power glow, celebratory MAX version, 4k quality.
```

**ネガティブプロンプト共通**:
```
dark colors, no sparkles, plain version, sad expression, damaged look, 
simple flat design, realistic, low quality, static no effects
```

---

## 📝 キャラクター別プロンプト生成ガイド

### Tier 1: イチコ
```
CHARACTER_NAME: イチコ
lv1_description: adorable golden rabbit with single spiral horn, big bright curious eyes, gentle smile, fluffy soft golden fur, simple light collar with + symbol
animal: rabbit
colors: soft warm golden yellow
personality: kind and encouraging
image_guidance: ichiko_lv1_normal.png
```

**8個プロンプト生成**:
- Lv.1 Normal
- Lv.2 Smile (Image Guidance: ichiko_lv1_normal.png)
- Lv.2 Sad (Image Guidance: ichiko_lv1_normal.png)
- Lv.2 Surprise (Image Guidance: ichiko_lv1_normal.png)
- Lv.3 Guts (Image Guidance: ichiko_lv1_normal.png)
- Lv.3 Jump (Image Guidance: ichiko_lv1_normal.png)
- Lv.3 Bow (Image Guidance: ichiko_lv1_normal.png)
- Lv.5 Sparkle (Image Guidance: ichiko_lv1_normal.png)

---

### Tier 1: ニニコ
```
CHARACTER_NAME: ニニコ
lv1_description: twin foxes perfectly mirrored, pink on left and turquoise on right, both with bright sparkling eyes and warm smiles, fluffy tails, matching ribbons
animal: twin foxes
colors: soft pink and turquoise
personality: harmonious and balanced
image_guidance: niniko_lv1_normal.png
```

---

### Tier 1: トライ
```
CHARACTER_NAME: トライ
lv1_description: adorable three-headed baby dragon, three cute heads with big bright eyes and gentle expressions, fluffy soft fur texture, stubby cute legs, small golden crowns on each head
animal: three-headed dragon
colors: warm red-orange and golden
personality: strong yet gentle
image_guidance: trai_lv1_normal.png
```

---

### Tier 1: フォーク
```
CHARACTER_NAME: フォーク
lv1_description: adorable young deer with four slender cute legs perfectly balanced, big gentle sparkling eyes, warm soft expression, soft fluffy tail, small delicate antlers with soft glow
animal: young deer
colors: soft purple-pink
personality: kind and generous
image_guidance: fouku_lv1_normal.png
```

---

### Tier 2: ゴーゴ
```
CHARACTER_NAME: ゴーゴ
lv1_description: energetic five-legged bunny-like creature with soft blue-purple fur, large bright sparkling eyes, fluffy soft body, five cute flexible legs, cheerful happy expression
animal: five-legged bunny
colors: bright blue and vivid purple
personality: energetic and playful
image_guidance: gogo_lv1_normal.png
```

---

### Tier 2: マルティプル
```
CHARACTER_NAME: マルティプル
lv1_description: adorable young tiger with warm red-orange striped fur and golden accents, bright playful eyes, four soft feathery wings in red and gold, compact muscular form
animal: winged tiger cub
colors: metallic red-orange and golden
personality: powerful yet cute
image_guidance: multiko_lv1_normal.png
```

---

### Tier 2: ディバイド
```
CHARACTER_NAME: ディバイド
lv1_description: elegant six-tailed fox with soft purple and gold colored fur, kind gentle eyes, six fluffy tails arranged in perfect symmetry, graceful refined body proportions
animal: six-tailed fox
colors: deep royal purple and warm gold
personality: wise and elegant
image_guidance: divido_lv1_normal.png
```

---

### Tier 3: ジオメ
```
CHARACTER_NAME: ジオメ
lv1_description: beautiful graceful unicorn with shimmering cyan and gold colored coat, spiraling horn glowing with geometric patterns, entire body covered with intricate geometric designs, large kind intelligent eyes
animal: geometric unicorn
colors: shimmering cyan and gold
personality: elegant and artistic
image_guidance: geome_lv1_normal.png
```

---

### Tier 3: カルキュ
```
CHARACTER_NAME: カルキュ
lv1_description: wise ancient owl with deep emerald green and warm golden plumage, large round knowing eyes expressing centuries of understanding, soft fluffy body, peaceful serene expression
animal: wise owl
colors: deep emerald green and warm golden
personality: wise and compassionate
image_guidance: calcuku_lv1_normal.png
```

---

### Tier 4: プラスマイナス
```
CHARACTER_NAME: プラスマイナス
lv1_description: magnificent legendary dragon with scales that shimmer in gold and silver representing + and − principles in balance, large wise dragon eyes, graceful elegant form, flowing body
animal: yin-yang dragon
colors: gold and silver
personality: transcendent and compassionate
image_guidance: plus_minus_lv1_normal.png
```

---

## 🔄 使用フロー

### Leonardo AIでの生成順序

```
【Step 1】Lv.1 Normal 生成
→ Template 1 + キャラパラメータで生成
→ ichiko_lv1_normal.png 保存

【Step 2-4】Lv.2 表情3種 生成
→ Template 2-4 + Image Guidance: ichiko_lv1_normal.png
→ ichiko_lv2_smile.png, sad.png, surprise.png 保存

【Step 5-7】Lv.3 ポーズ3種 生成
→ Template 5-7 + Image Guidance: ichiko_lv1_normal.png
→ ichiko_lv3_guts.png, jump.png, bow.png 保存

【Step 8】Lv.5 Sparkle 生成
→ Template 8 + Image Guidance: ichiko_lv1_normal.png
→ ichiko_lv5_sparkle.png 保存

【全10キャラ × 8Lv = 80プロンプト完成】
```

---

## 📊 生成プロンプト数

```
Tier 1: 4キャラ × 8Lv = 32プロンプト
Tier 2: 3キャラ × 8Lv = 24プロンプト
Tier 3: 2キャラ × 8Lv = 16プロンプト
Tier 4: 1キャラ × 8Lv = 8プロンプト

━━━━━━━━━━━━━━━━━━━
合計: 80プロンプト
```

---

**最終更新**: 2026-06-16 v4.0  
**作成者**: Claude Code (Haiku 4.5)  
**ライセンス**: Your Wish internal use  
**テンプレート効率化**: 8パターン + 10キャラパラメータで80プロンプト自動生成
