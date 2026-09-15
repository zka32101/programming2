# 算数コレ！キャラクター画像生成 ドキュメント

**最新版**: v5.0 統一テンプレート（2026-06-16）

---

## 📚 ファイル一覧

### 🎯 **推奨・使用中**

#### [`character_lv_templates_unified.md`](character_lv_templates_unified.md) ⭐ **v5.0 最新版**
- **対応**: 算数コレ（sansu-kore）+ 国語コレ対応テンプレート
- **Lvシステム**: Lv.1→2→3→4→5 (5段階、各1画像)
- **コスト**: 50→100→200→500コイン（合計850）
- **テンプレート数**: 5パターン（全キャラ共通）
- **算数コレ**: 10キャラ × 5Lv = **50画像**（完全パラメータ記載）
- **国語コレ**: 16キャラ × 5Lv = 80画像（テンプレート対応）
- **推奨使用**: ✅ **このファイルを使用してください**

---

### 📦 **アーカイブ・参考資料**

#### `character_ai_prompts.md` (v3.1)
- 旧版：擬人化なし動物モチーフキャラ（Tier 1-4）
- Midjourney/DALL-E/Stable Diffusion 対応
- **用途**: 背景参考のみ（使用不要）

#### `character_level_up_templates.md` (v4.0)
- 旧版：8段階テンプレート（Lv.1,2×3,3×3,5）
- 算数コレ専用（国語コレ未対応）
- **用途**: 設計参考のみ（使用不要）

---

## 🚀 クイックスタート

### Step 1: テンプレート確認
```
character_lv_templates_unified.md を開く
↓
Tier 1-4 各キャラのパラメータを確認
```

### Step 2: Leonardo AI で生成
```
各キャラごと：
1. Lv.1 Normal → 生成 → {id}_lv1_normal.png 保存
2. Lv.2 表情 → Image Guidance使用 → {id}_lv2_*.png 保存
3. Lv.3 表情 → Image Guidance使用 → {id}_lv3_*.png 保存
4. Lv.4 ポーズ → Image Guidance使用 → {id}_lv4_*.png 保存
5. Lv.5 Sparkle → Image Guidance使用 → {id}_lv5_sparkle.png 保存

1キャラ = 5画像
```

### Step 3: ファイル保存
```
H:\マイドライブ\apk\sansu-kore-characters\
├─ tier1\
│  ├─ ichiko\
│  │  ├─ lv1_normal.png
│  │  ├─ lv2_smile.png
│  │  ├─ lv3_surprise.png
│  │  ├─ lv4_guts.png
│  │  └─ lv5_sparkle.png
│  ├─ niniko\
│  └─ ...
├─ tier2\
├─ tier3\
└─ tier4\
```

---

## 📊 画像生成統計

```
【算数コレ】
Tier 1: 4キャラ × 5画像 = 20画像
Tier 2: 3キャラ × 5画像 = 15画像
Tier 3: 2キャラ × 5画像 = 10画像
Tier 4: 1キャラ × 5画像 = 5画像
━━━━━━━━━━━━━━━━━━━━
合計: 10キャラ × 5画像 = 50画像

推定生成時間: 1キャラ = 3-5分（5画像連続生成）
推定総時間: 50-100分（全10キャラ）
```

---

## 🎨 Leonardo AI 設定（推奨）

```
【共通設定】
Model: Phoenix 1.0
Style: Illustration
Guidance Scale: 8.0-8.5
Alchemy: ON推奨（品質向上）

【Lv別設定】
Lv.1: Guidance 8.0, Alchemy OFF（初期形）
Lv.2-4: Guidance 8.5, Alchemy ON（詳細度確保）
Lv.5: Guidance 9.0, Alchemy ON（エフェクト強調）

【Image Guidance】
Lv.2-5: {id}_lv1_normal.png を参照
→ 同一キャラの一貫性を確保
```

---

## ✅ チェックリスト（生成完了時）

```
□ 50画像すべて生成完了
□ ファイル名統一（{id}_lv{x}_{type}.png）
□ Image Guidanceで一貫性確保
□ 背景透過PNG形式（RGBA 8bit）
□ 解像度確認（1080×1440px）
□ ファイルサイズ確認（1枚500KB以下推奨）
□ Google Drive にバックアップ保存
□ Lv.1→2→3→4→5の進化感がある
□ キャラの個性が保持されている
□ 完成後アプリに統合テスト
```

---

## 📞 トラブルシューティング

**Q: Lv.2-5で「別キャラに見える」**
- A: Image Guidance の参照画像を確認。Lv.1の画像をしっかり指定しているか確認

**Q: Image Guidance が機能しない**
- A: Leonardo AI の設定で「Image Guidance」機能が有効か確認。PNG形式の参照画像を使用

**Q: 表情の差が小さい**
- A: プロンプトの「{lv2_expression_detail}」の詳細度を上げるか、Guidance Scale を 9.0 に上げる

**Q: エフェクトが強すぎる（Lv.5）**
- A: Sparkle版は「Lv.1と完全同じ + エフェクトのみ」なので、背景エフェクトを調整

---

## 📝 バージョン履歴

| バージョン | 日時 | 内容 |
|-----------|------|------|
| **v5.0** | 2026-06-16 | 統一テンプレート（Lv.1→2→3→4→5、算数・国語両対応） |
| v4.0 | 2026-06-16 | 8段階テンプレート（算数専用） |
| v3.1 | 2026-06-16 | 小学生向けキャラクター化（動物モチーフ） |
| v3.0 | 2026-06-16 | 架空生命体キャラクター化 |
| v2.0 | 2026-06-16 | Leonardo Phoenix 1.0対応 |
| v1.0 | 2026-06-16 | 初版（Midjourney/DALL-E対応） |

---

**最終更新**: 2026-06-16  
**推奨テンプレート**: `character_lv_templates_unified.md` (v5.0)  
**対応アプリ**: 算数コレ（完成）/ 国語コレ（テンプレート対応可）  
**ステータス**: ✅ 算数コレ実装準備完了
