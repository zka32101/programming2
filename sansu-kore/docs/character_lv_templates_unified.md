# 小学コレ！キャラクター レベルアップ 統一テンプレート

**バージョン**: v5.0 (算数コレ・国語コレ統一版)  
**対応アプリ**: sansu-kore（算数コレ） + kokugo-kore（国語コレ）  
**テンプレート数**: 5段階 × キャラパラメータで統一生成  
**推奨ツール**: Leonardo AI Phoenix 1.0 (Image Guidance機能必須)

---

## 📋 統一Lvシステム

```
Lv.1 (基本) → 1画像
  ├─ コスト: 0（初期入手）
  └─ 内容: 通常立ち絵（正面向き）

Lv.2 (表情1種) → 1画像
  ├─ コスト: 50コイン
  └─ 内容: 表情（Smile/Sad/Surprise のいずれか）

Lv.3 (表情2種) → 1画像
  ├─ コスト: 100コイン
  └─ 内容: 表情（Smile/Sad/Surprise のいずれか）

Lv.4 (ポーズ) → 1画像
  ├─ コスト: 200コイン
  └─ 内容: ポーズ（Guts/Jump/Bow のいずれか）

Lv.5 (MAX) → 1画像
  ├─ コスト: 500コイン
  └─ 内容: きらきら版（Lv.1と同ポーズ + 光エフェクト）

━━━━━━━━━━━━━━━━━━
合計コスト: 850コイン/キャラ
合計画像: 5枚/キャラ
```

---

## 🎯 レベルアップ プロンプト テンプレート（5段階版）

### Template 1: Lv.1 Normal（基本立ち絵）

**用途**: 初期入手時  
**コスト**: 0（初期状態）  
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
angry sad, jumping active, bowing bent, scared, realistic, photorealistic, 
humanoid, distorted, low quality, text, watermark, multiple expressions
```

---

### Template 2: Lv.2 表情（50コイン育成後）

**用途**: Lv.2到達  
**コスト**: 50コイン  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と完全同じ・{lv2_expression} 表情だけ変化  
**個性別表情**: 各キャラから `lv2_expression` を選択（以下参照）

```
{CHARACTER_NAME} Lv.2 {lv2_emotion} version - SAME {lv1_description} 
as Lv.1, EXACT same pose and body, but EXPRESSION CHANGED to: 
{lv2_expression_detail}. All other details IDENTICAL to Lv.1. 
Only the FACE shows {lv2_emotion}. Illustration: kawaii {animal}, 
same {colors} color, {lv2_emotion} expression, {lv2_emotion} mood, 4k quality.
```

**表情パターン選択肢**（各キャラから1つ選ぶ）:

**Smile（大喜び）**:
```
big open joyful smile, mouth laughing broadly, eyes sparkling 
with brightness and joy, eyebrows raised upward showing happiness
```

**Sad（悲しみ・心配）**:
```
sad worried face, mouth formed as く字 (small frown), eyes showing 
concern or gentle sadness, small teardrops glistening on cheeks, 
eyebrows angled down showing worry
```

**Surprise（驚き・感動）**:
```
surprised amazed face, mouth O-shaped in amazement, eyes opened 
VERY WIDE showing shock and wonder, eyebrows raised high, expression 
shows delight and astonishment
```

**ネガティブプロンプト共通**:
```
multiple expressions, neutral face, jumping, bowing, other emotions, 
realistic, low quality, distorted features, text, watermark
```

---

### Template 3: Lv.3 表情（100コイン育成後）

**用途**: Lv.3到達  
**コスト**: 100コイン  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と完全同じ・{lv3_expression} 表情だけ変化  
**個性別表情**: 各キャラから `lv3_expression` を選択（Lv.2と異なるもの）

```
{CHARACTER_NAME} Lv.3 {lv3_emotion} version - SAME {lv1_description} 
as Lv.1, IDENTICAL pose and body, but EXPRESSION CHANGED to: 
{lv3_expression_detail}. All other aspects UNCHANGED from Lv.1. 
Only face expresses {lv3_emotion} and discovery. Illustration: 
kawaii {animal}, same {colors}, {lv3_emotion} expression, 
{lv3_emotion} mood, 4k quality.
```

**表情パターン選択肢**（Lv.2と異なるものを選ぶ）:
Smile / Sad / Surprise から、Lv.2で使わなかった1つを選択

**ネガティブプロンプト共通**:
```
same expression as lv2, neutral face, jumping, bowing, other emotions, 
realistic, low quality, distorted, text, watermark
```

---

### Template 4: Lv.4 ポーズ（200コイン育成後）

**用途**: Lv.4到達  
**コスト**: 200コイン  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1の優しい表情 + {lv4_pose} ポーズ  
**個性別ポーズ**: 各キャラから `lv4_pose` を選択（以下参照）

```
{CHARACTER_NAME} Lv.4 {lv4_pose_name} Pose - SAME {lv1_description}, 
SAME kind happy face as Lv.1, but BODY POSE CHANGED to: 
{lv4_pose_detail}. Face shows {lv4_emotion}. Illustration: kawaii 
{animal}, same {colors}, {lv4_pose_name} pose, {lv4_emotion} expression, 
dynamic {lv4_pose_name}, 4k quality.
```

**ポーズパターン選択肢**（各キャラから1つ選ぶ）:

**Guts（ガッツポーズ・勝利）**:
```
dynamic victory pose, RIGHT PAWS/LIMBS RAISED HIGH in the air showing 
strength and determination, left arm at side, body turned slightly forward 
in powerful confident stance, posture radiates achievement and confidence
```

**Jump（ジャンプ・喜び）**:
```
energetic jumping pose, BOTH FEET/LEGS LIFTED OFF GROUND mid-jump, 
arms spread open or raised in celebration, body leaning slightly forward 
from jump momentum, radiates happiness and celebration
```

**Bow（お辞儀・感謝）**:
```
grateful respectful bow, HEAD BENT DOWN showing gratitude and humility, 
torso leaning forward 45-90 degree angle, arms at sides or slightly forward, 
feet in wide stance, posture shows thanks and courtesy
```

**ネガティブプロンプト共通**:
```
standing still upright, other poses, sad expression, weak lazy, 
realistic, low quality, distorted motion, text, watermark
```

---

### Template 5: Lv.5 Sparkle（500コイン育成後・MAX）

**用途**: Lv.5 MAX到達  
**コスト**: 500コイン  
**Image Guidance**: {id}_lv1_normal.png  
**ポイント**: Lv.1と完全同じ + 光エフェクト全面追加

```
{CHARACTER_NAME} Lv.5 Sparkle MAX version - SAME {lv1_description} 
in EXACT Lv.1 standing pose with {personality} expression, but WITH 
ADDED VISUAL EFFECTS: body surrounded by bright sparkling star particles 
constantly twinkling, soft rainbow light aura around entire figure, 
shimmer effect on fur/scales making it gleam and shine brilliantly, 
horn/distinguishing features glow more intensely with multiple colors, 
light rays emanating outward from body suggesting MAX power achievement, 
background subtle glow effect emphasizing specialness. Everything else 
IDENTICAL to Lv.1. Perfect for MAX level celebration and figure display. 
Illustration: kawaii {animal}, same {colors}, sparkle effects stars rainbows, 
maximum power glow, celebratory MAX version, 4k quality.
```

**ネガティブプロンプト共通**:
```
dark colors, no sparkles, plain version, sad expression, damaged look, 
simple flat design, realistic, low quality, static no effects, text, watermark
```

---

## 📝 キャラクター別パラメータ（算数コレ）

### Tier 1

#### イチコ
```json
{
  "app": "sansu-kore",
  "id": "ichiko",
  "name": "イチコ",
  "animal": "rabbit",
  "colors": "soft warm golden yellow",
  "concept": "たし算・最初の一歩",
  "personality": "kind and encouraging",
  "lv1_description": "adorable golden rabbit with single spiral horn, big bright curious eyes, gentle smile, fluffy soft golden fur, simple light collar with + symbol",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Surprise",
  "lv3_emotion": "Surprise",
  "lv3_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder, eyebrows raised high, expression shows delight and astonishment",
  "lv4_pose": "Guts",
  "lv4_pose_name": "Guts",
  "lv4_emotion": "determination and pride",
  "lv4_pose_detail": "dynamic victory pose, RIGHT PAWS/LIMBS RAISED HIGH in the air showing strength and determination, left arm at side, body turned slightly forward in powerful confident stance"
}
```

#### ニニコ
```json
{
  "app": "sansu-kore",
  "id": "niniko",
  "name": "ニニコ",
  "animal": "twin foxes",
  "colors": "soft pink and turquoise",
  "concept": "ひき算・バランス",
  "personality": "harmonious and balanced",
  "lv1_description": "twin foxes perfectly mirrored, pink on left and turquoise on right, both with bright sparkling eyes and warm smiles, fluffy tails, matching ribbons",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Sad",
  "lv3_emotion": "Sad",
  "lv3_expression_detail": "sad worried face, mouth formed as く字 (small frown), eyes showing concern or gentle sadness, small teardrops glistening on cheeks, eyebrows angled down showing worry",
  "lv4_pose": "Bow",
  "lv4_pose_name": "Bow",
  "lv4_emotion": "thanks and courtesy",
  "lv4_pose_detail": "grateful respectful bow, HEAD BENT DOWN showing gratitude and humility, torso leaning forward 45-90 degree angle, arms at sides, feet in wide stance"
}
```

#### トライ
```json
{
  "app": "sansu-kore",
  "id": "trai",
  "name": "トライ",
  "animal": "three-headed dragon",
  "colors": "warm red-orange and golden",
  "concept": "かけ算・反復",
  "personality": "strong yet gentle",
  "lv1_description": "adorable three-headed baby dragon, three cute heads with big bright eyes and gentle expressions, fluffy soft fur texture, stubby cute legs, small golden crowns on each head",
  "lv2_expression": "Surprise",
  "lv2_emotion": "Surprise",
  "lv2_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder, eyebrows raised high, expression shows delight and astonishment",
  "lv3_expression": "Smile",
  "lv3_emotion": "Smile",
  "lv3_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv4_pose": "Guts",
  "lv4_pose_name": "Guts",
  "lv4_emotion": "strength and power",
  "lv4_pose_detail": "dynamic victory pose, RIGHT PAWS/LIMBS RAISED HIGH in the air showing strength and determination, body turned slightly forward in powerful confident stance"
}
```

#### フォーク
```json
{
  "app": "sansu-kore",
  "id": "fouku",
  "name": "フォーク",
  "animal": "young deer",
  "colors": "soft purple-pink",
  "concept": "わり算・公平",
  "personality": "kind and generous",
  "lv1_description": "adorable young deer with four slender cute legs perfectly balanced, big gentle sparkling eyes, warm soft expression, soft fluffy tail, small delicate antlers with soft glow",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Sad",
  "lv3_emotion": "Sad",
  "lv3_expression_detail": "sad worried face, mouth formed as く字 (small frown), eyes showing concern or gentle sadness, small teardrops glistening on cheeks, eyebrows angled down showing worry",
  "lv4_pose": "Bow",
  "lv4_pose_name": "Bow",
  "lv4_emotion": "kindness and generosity",
  "lv4_pose_detail": "grateful respectful bow, HEAD BENT DOWN showing gratitude and humility, torso leaning forward 45-90 degree angle, arms at sides"
}
```

### Tier 2

#### ゴーゴ
```json
{
  "app": "sansu-kore",
  "id": "gogo",
  "name": "ゴーゴ",
  "animal": "five-legged bunny",
  "colors": "bright blue and vivid purple",
  "concept": "分数・小数",
  "personality": "energetic and playful",
  "lv1_description": "energetic five-legged bunny-like creature with soft blue-purple fur, large bright sparkling eyes, fluffy soft body, five cute flexible legs, cheerful happy expression",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Surprise",
  "lv3_emotion": "Surprise",
  "lv3_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder, eyebrows raised high",
  "lv4_pose": "Jump",
  "lv4_pose_name": "Jump",
  "lv4_emotion": "joy and energy",
  "lv4_pose_detail": "energetic jumping pose, BOTH FEET/LEGS LIFTED OFF GROUND mid-jump, arms spread open in celebration, body leaning slightly forward"
}
```

#### マルティプル
```json
{
  "app": "sansu-kore",
  "id": "multiko",
  "name": "マルティプル",
  "animal": "winged tiger cub",
  "colors": "metallic red-orange and golden",
  "concept": "かけ算・力",
  "personality": "powerful yet cute",
  "lv1_description": "adorable young tiger with warm red-orange striped fur and golden accents, bright playful eyes, four soft feathery wings in red and gold, compact muscular form",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Surprise",
  "lv3_emotion": "Surprise",
  "lv3_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder",
  "lv4_pose": "Guts",
  "lv4_pose_name": "Guts",
  "lv4_emotion": "power and victory",
  "lv4_pose_detail": "dynamic victory pose, RIGHT PAWS RAISED HIGH showing strength and determination, body turned forward in powerful confident stance"
}
```

#### ディバイド
```json
{
  "app": "sansu-kore",
  "id": "divido",
  "name": "ディバイド",
  "animal": "six-tailed fox",
  "colors": "deep royal purple and warm gold",
  "concept": "わり算・調和",
  "personality": "wise and elegant",
  "lv1_description": "elegant six-tailed fox with soft purple and gold colored fur, kind gentle eyes, six fluffy tails arranged in perfect symmetry, graceful refined body proportions",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Sad",
  "lv3_emotion": "Sad",
  "lv3_expression_detail": "sad worried face, mouth formed as く字 (small frown), eyes showing concern or gentle sadness, small teardrops glistening on cheeks",
  "lv4_pose": "Bow",
  "lv4_pose_name": "Bow",
  "lv4_emotion": "wisdom and gratitude",
  "lv4_pose_detail": "grateful respectful bow, HEAD BENT DOWN showing gratitude and humility, torso leaning forward in refined elegant manner"
}
```

### Tier 3

#### ジオメ
```json
{
  "app": "sansu-kore",
  "id": "geome",
  "name": "ジオメ",
  "animal": "geometric unicorn",
  "colors": "shimmering cyan and gold",
  "concept": "図形・美学",
  "personality": "elegant and artistic",
  "lv1_description": "beautiful graceful unicorn with shimmering cyan and gold colored coat, spiraling horn glowing with geometric patterns, entire body covered with intricate geometric designs, large kind intelligent eyes",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Surprise",
  "lv3_emotion": "Surprise",
  "lv3_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder, eyebrows raised high",
  "lv4_pose": "Guts",
  "lv4_pose_name": "Guts",
  "lv4_emotion": "pride in artistry",
  "lv4_pose_detail": "dynamic victory pose, RIGHT PAWS RAISED HIGH in artistic triumphant stance, body turned forward with graceful power"
}
```

#### カルキュ
```json
{
  "app": "sansu-kore",
  "id": "calcuku",
  "name": "カルキュ",
  "animal": "wise owl",
  "colors": "deep emerald green and warm golden",
  "concept": "算数・知恵",
  "personality": "wise and compassionate",
  "lv1_description": "wise ancient owl with deep emerald green and warm golden plumage, large round knowing eyes expressing centuries of understanding, soft fluffy body, peaceful serene expression",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Sad",
  "lv3_emotion": "Sad",
  "lv3_expression_detail": "sad worried face, mouth formed as く字 (small frown), eyes showing concern or gentle sadness, small teardrops glistening on cheeks",
  "lv4_pose": "Bow",
  "lv4_pose_name": "Bow",
  "lv4_emotion": "compassion and respect",
  "lv4_pose_detail": "grateful respectful bow, HEAD BENT DOWN showing gratitude and wisdom, torso leaning forward with dignified compassion"
}
```

### Tier 4

#### プラスマイナス
```json
{
  "app": "sansu-kore",
  "id": "plus_minus",
  "name": "プラスマイナス",
  "animal": "yin-yang dragon",
  "colors": "gold and silver",
  "concept": "全操作・完成",
  "personality": "transcendent and compassionate",
  "lv1_description": "magnificent legendary dragon with scales that shimmer in gold and silver representing + and − principles in balance, large wise dragon eyes, graceful elegant form, flowing body",
  "lv2_expression": "Smile",
  "lv2_emotion": "Smile",
  "lv2_expression_detail": "big open joyful smile, mouth laughing broadly, eyes sparkling with brightness and joy, eyebrows raised upward showing happiness",
  "lv3_expression": "Surprise",
  "lv3_emotion": "Surprise",
  "lv3_expression_detail": "surprised amazed face, mouth O-shaped in amazement, eyes opened VERY WIDE showing shock and wonder, eyebrows raised high",
  "lv4_pose": "Guts",
  "lv4_pose_name": "Guts",
  "lv4_emotion": "ultimate mastery",
  "lv4_pose_detail": "dynamic victory pose, RIGHT PAWS RAISED HIGH in transcendent triumphant stance, body radiating ultimate harmony"
}
```

---

## 🔄 使用フロー（Leonardo AI）

```
【Step 1】Lv.1 Normal 生成
→ Template 1 + キャラパラメータで生成
→ {id}_lv1_normal.png 保存

【Step 2】Lv.2 表情 生成
→ Template 2 + {lv2_expression} パラメータ + Image Guidance
→ {id}_lv2_{lv2_expression_type}.png 保存

【Step 3】Lv.3 表情 生成
→ Template 3 + {lv3_expression} パラメータ + Image Guidance
→ {id}_lv3_{lv3_expression_type}.png 保存

【Step 4】Lv.4 ポーズ 生成
→ Template 4 + {lv4_pose} パラメータ + Image Guidance
→ {id}_lv4_{lv4_pose_type}.png 保存

【Step 5】Lv.5 Sparkle 生成
→ Template 5 + Image Guidance
→ {id}_lv5_sparkle.png 保存

【1キャラあたり 5画像 × 10キャラ = 50画像】
```

---

## 📊 生成統計

```
【算数コレ】
キャラ数: 10体（Tier 1-4）
Lv段階: 5段階（Lv.1→2→3→4→5）
画像/キャラ: 5枚
総画像数: 10キャラ × 5枚 = 50画像

【国語コレ】
キャラ数: 16体（Tier 1-4）
Lv段階: 5段階（Lv.1→2→3→4→5）
画像/キャラ: 5枚
総画像数: 16キャラ × 5枚 = 80画像

【合計】
両アプリ総画像数: 130画像
テンプレート効率: 5パターン × 26キャラパラメータで完全生成可能
```

---

**最終更新**: 2026-06-16 v5.0  
**対応アプリ**: sansu-kore + kokugo-kore  
**テンプレート効率**: 5パターン（Lv.1→2→3→4→5）で両アプリ統一  
**総プロンプト生成数**: 130プロンプト（50+80）
