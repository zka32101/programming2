#!/bin/bash

# GitHub にプライベートリポジトリ作成後、以下を実行

echo "=== Step 1: リモート設定 ==="
git remote remove origin
git remote add origin https://github.com/petitworksappsdev-hash/sansu-kore.git

echo "✓ リモート追加完了"
echo ""

echo "=== Step 2: ブランチ名を main に変更 ==="
git branch -M main

echo "✓ ブランチ名変更完了"
echo ""

echo "=== Step 3: GitHub に push ==="
git push -u origin main

echo "✓ Push 完了！"
echo ""
echo "=== 確認 ==="
echo "GitHub にアクセス: https://github.com/petitworksappsdev-hash/sansu-kore"
echo "Actions タブを開いて自動ビルドが開始されたか確認"
