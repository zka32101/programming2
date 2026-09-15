# 国語コレ！ AI画像生成プロンプト集
## Canva + Leonardo AI 最適化版

**最終更新**: 2026-06-11  
**対象**: 国語コレ v1.2 ショップアイテムデザイン（帽子・背景・フレーム）

---

## 🎨 Canva 使用ガイド

### テンプレート活用
- **背景画像**: 1080 × 1920px（縦型モバイル）
- **フレーム**: カスタムサイズ（プロフィールカード用）
- **帽子**: 正方形 512 × 512px（アイコンサイズ）
- **推奨**: 「Kids illustration」「Educational design」テンプレート活用

### Canva内での作業フロー
1. Leonardo で生成した画像をダウンロード
2. Canva にアップロード → 背景レイヤーに配置
3. 装飾素材（フレーム、テキスト、エモジ要素）をCanva素材から追加
4. 書き出し形式: **PNG (transparent background)**

---

## 🤖 Leonardo AI 画像生成プロンプト

### 📋 Leonardo プロンプト作成のコツ
- **簡潔さ重視**: 50-80単語が最適（多すぎるとスタイル崩れ）
- **スタイル指定**: `illustration style`, `kawaii`, `children's book` など明示
- **色指定**: RGB値より名前で指定（`golden yellow`, `soft pink`）
- **推奨設定**: 
  - **Model**: Leonardo Vision XL（高品質）
  - **Guidance Scale**: 7-9（指示への従順性）
  - **Steps**: 60-80

---

## 🎩 帽子デザイン（Leonardo プロンプト）

### 1️⃣ 金のおうかん（hat_crown）
```
Golden crown with 5 sparkly spikes and gem details. Bright yellow-gold color, 
shiny metallic finish. Cute, hand-drawn illustration style for kids. 
Isolated on transparent background. Children's educational app design.
```

**生成設定**: 
- Guidance: 8
- Steps: 60
- **Canva後処理**: キラキラ効果を追加、背景を保証してから切り抜き

---

### 2️⃣ クマ耳（hat_bear）
```
Adorable brown bear ears with soft fuzzy texture, pink inner ear. 
Kawaii style, warm brown tones. Hand-drawn illustration for children's app. 
Transparent background, cute and friendly design.
```

**生成設定**: Guidance: 8, Steps: 60

---

### 3️⃣ 本の博士帽（hat_book）
```
Scholar's mortarboard cap with tiny open book symbol on top. 
Gold and deep brown colors, knowledge-themed. Hand-drawn style for kids. 
Sophisticated yet playful. Transparent background.
```

**生成設定**: Guidance: 7, Steps: 70

---

### 4️⃣ 花かんむり（hat_flowerCrown）- 春期間限定
```
Spring flower crown with colorful blossoms - cherry pink, white daisy, 
soft pastels. Delicate kawaii style. Hand-drawn illustration for children. 
Warm, joyful spring feeling. Transparent background.
```

**生成設定**: Guidance: 8, Steps: 60

---

### 5️⃣ 麦わら帽子（hat_sunhat）- 夏期間限定
```
Classic straw hat in natural tan color with light blue ribbon band. 
Hand-woven texture, summery feeling. Simple cute design for kids' app. 
Hand-drawn illustration style. Transparent background.
```

**生成設定**: Guidance: 7, Steps: 60

---

### 6️⃣ キノコ帽子（hat_mushroom）- 秋期間限定
```
Red and white spotted mushroom hat, toadstool style. Forest fantasy aesthetic, 
warm autumn colors. Cute kawaii design for children. Hand-drawn style. 
Transparent background, playful and whimsical.
```

**生成設定**: Guidance: 8, Steps: 65

---

### 7️⃣ サンタ帽（hat_santa）- 冬期間限定
```
Traditional red Santa hat with fluffy white trim and pom-pom. 
Cheerful Christmas theme, hand-drawn illustration. Warm and friendly. 
Perfect for children's learning app. Transparent background.
```

**生成設定**: Guidance: 7, Steps: 60

---

## 🌅 背景デザイン（Leonardo プロンプト）

### 背景共通設定
- **解像度**: 1080 × 1920px（Leonardo では max resolution 選択）
- **Format**: PNG
- **Guidance**: 8-9（背景なので高めで確実性向上）

---

### 1️⃣ 宇宙の背景（bg_space）
```
Magical space background with floating stars, distant nebulas, and galaxies. 
Deep purple and blue gradient with golden star accents. Dreamy, peaceful, 
suitable for children's study. High quality digital illustration. 
Vertical portrait format 1080x1920px.
```

**Canva後処理**: グラデーション調整、学習用ロゴ配置

---

### 2️⃣ 図書館の背景（bg_library）
```
Cozy library interior with wooden bookshelves filled with colorful books, 
warm golden lighting, comfortable reading nook. Peaceful study atmosphere 
for children. Hand-drawn warmth. Vertical 1080x1920px, high quality.
```

**Canva後処理**: テクスチャ追加、本のタイトルはCanvaで編集可能に

---

### 3️⃣ 深海の背景（bg_ocean）
```
Serene underwater scene with coral reefs, bioluminescent creatures, 
turquoise and deep blue water, floating bubbles and gentle fish. Calm, 
beautiful, safe for children's learning app. Vertical 1080x1920px.
```

**Canva後処理**: 光の効果追加、泡要素の微調整

---

### 4️⃣ 桜の背景（bg_sakura）- 春期間限定
```
Full bloom cherry blossom garden with pink and white blossoms, soft petals falling, 
traditional Japanese aesthetic, peaceful spring vibe. Warm golden light. 
Perfect for children's learning. Vertical portrait 1080x1920px.
```

**Canva後処理**: フレーム（春の飾り）追加

---

### 5️⃣ 花火の背景（bg_fireworks）- 夏期間限定
```
Summer night sky with vibrant fireworks bursting in reds, golds, blues, greens. 
Dark starry sky, festive yet calm enough for learning. Japanese summer festival. 
Beautiful, joyful. Vertical 1080x1920px high quality illustration.
```

**Canva後処理**: グロー効果追加、フェスティバル要素デコレーション

---

### 6️⃣ 紅葉の背景（bg_leaves）- 秋期間限定
```
Autumn forest with vibrant red and orange maple leaves, golden sunlight, 
peaceful landscape, cozy reading atmosphere. Warm fall colors, traditional 
Japanese autumn aesthetic. Vertical 1080x1920px, calming and beautiful.
```

**Canva後処理**: 読書ラウンジ要素追加

---

### 7️⃣ 雪の背景（bg_snow）- 冬期間限定
```
Winter wonderland with gently falling snow, frost-covered trees, soft white 
and cool blue tones. Peaceful, magical, quiet study atmosphere for children. 
Serene and beautiful. Vertical portrait 1080x1920px.
```

**Canva後処理**: スノーフレーク装飾、温かみの光追加

---

## 🖼️ フレーム（プロフィールカード枠）

### フレーム共通設定
- **Canva内での制作推奨**: Leonardo は複雑なデコレーティブ要素が弱い
- **Leonardo の活用**: 背景テクスチャのみ生成 → Canva で枠線・装飾追加
- **推奨アプローチ**: 
  1. Leonardo で背景パターン生成
  2. Canva で枠線・テクスチャ合成
  3. PNG で透明背景書き出し

---

### 1️⃣ 虹色フレーム（frame_rainbow）

**Leonardo プロンプト（背景用）**:
```
Rainbow gradient texture with soft blending, colorful spectrum flowing smoothly. 
Vibrant but not harsh. For decorative frame background. 
Square format, transparent, kawaii aesthetic.
```

**Canva での仕上げ**:
- 背景 → 虹グラデーション加工
- フレーム線 → 金色または白色の太い枠
- 装飾 → 星⭐、スパークル✨ ステッカー追加
- **書き出し**: PNG transparent

---

### 2️⃣ 本のフレーム（frame_book）

**Leonardo プロンプト（テクスチャ用）**:
```
Wooden book texture with aged paper look, gold and brown tones. 
Literary feel for children's educational app. Square format.
```

**Canva での仕上げ**:
- 背景 → Leonardo 木製テクスチャ
- フレーム線 → 本のページを模した波線枠
- 装飾 → 本のリボン、ページ装飾
- **書き出し**: PNG transparent

---

### 3️⃣ 入学式フレーム（frame_entrance）- 春期間限定

**Leonardo プロンプト**:
```
Spring school entrance ceremony theme: soft pink, white, gold colors. 
Cherry blossom petals, celebratory feel. For profile card frame background.
```

**Canva での仕上げ**:
- 背景 → Leonardo 春色パターン
- フレーム線 → 桜色ピンクの枠
- 装飾 → 🎒ランドセル、入学式リボン
- **書き出し**: PNG transparent

---

### 4️⃣ 読書フレーム（frame_autumn_book）- 秋期間限定

**Leonardo プロンプト**:
```
Autumn reading theme with fall leaves in red, gold, orange tones. 
Cozy, literary aesthetic. For profile card frame. Warm autumn colors.
```

**Canva での仕上げ**:
- 背景 → Leonardo 秋の落葉パターン
- フレーム線 → 深い茶色 or 金色
- 装飾 → 本📚、紅葉🍁、読書ラウンジ要素
- **書き出し**: PNG transparent

---

### 5️⃣ お正月フレーム（frame_newyear）- 冬期間限定

**Leonardo プロンプト**:
```
Traditional Japanese New Year with gold and red auspicious colors. 
Pine branches, plum flowers, festive patterns. Elegant yet celebratory.
```

**Canva での仕上げ**:
- 背景 → Leonardo 正月パターン
- フレーム線 → 金色の伝統的な枠
- 装飾 → 🎍松飾り、梅、紅白装飾
- **書き出し**: PNG transparent

---

## 📊 ワークフロー例（帽子の場合）

```
1. Leonardo で金のおうかんプロンプト実行
   → PNG ダウンロード（512x512px, transparent）

2. Canva でプロジェクト作成（512×512px）
   → Leonardo 画像をメイン要素として配置

3. Canva で装飾追加
   - キラキラ✨エフェクト
   - ドロップシャドウ
   - 背景グロー

4. 最終書き出し
   - Format: PNG (透明背景指定)
   - File: assets/images/hat_crown.png

5. Flutter コード内で参照
   - Image.asset('assets/images/hat_crown.png')
```

---

## 📝 Leonardo 生成時のチェックリスト

- [ ] **背景透明**: Transparent background を明示的に指定
- [ ] **色確認**: 実際の生成色が国語コレの黄色（#F39C12）と調和
- [ ] **子ども向け**: 複雑すぎず、親しみやすいスタイル
- [ ] **品質**: 縮小時も判別可能な明確さ
- [ ] **保存形式**: PNG（非ロッシー、透明度保持）

---

## 🔧 微調整プロンプト例

### うまくいかない場合の修正
```
❌ 色が暗すぎる
→ "brighter, more vibrant, cheerful colors"

❌ 子ども向けに見えない
→ "simple, kawaii, cute style suitable for 6-year-old children"

❌ 背景がまだついてる
→ "isolated element on transparent background, no background"

❌ スタイルがリアル過ぎる
→ "hand-drawn illustration style, not photorealistic"
```

---

## 💾 ファイル出力予定

```
assets/images/
├── hats/
│   ├── hat_crown.png
│   ├── hat_bear.png
│   ├── hat_book.png
│   ├── hat_flowerCrown.png
│   ├── hat_sunhat.png
│   ├── hat_mushroom.png
│   └── hat_santa.png
├── backgrounds/
│   ├── bg_space.png
│   ├── bg_library.png
│   ├── bg_ocean.png
│   ├── bg_sakura.png
│   ├── bg_fireworks.png
│   ├── bg_leaves.png
│   └── bg_snow.png
└── frames/
    ├── frame_rainbow.png
    ├── frame_book.png
    ├── frame_entrance.png
    ├── frame_autumn_book.png
    └── frame_newyear.png
```

---

**次ステップ**: Leonardo で帽子から開始 → Canva で装飾 → assets フォルダへ統合
