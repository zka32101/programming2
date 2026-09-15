# -*- coding: utf-8 -*-
"""
キャラクター画像を assets/character_levels/ に整理・コピー
ファイル名例:
  "1 ホンホン（本）Lv.2-1 集中顔（読書）.jpg" → "01_honhon_lv2_1.jpg"
  "10 ワラウん（笑う） Lv.2-1.jpg" → "10_waraun_lv2_1.jpg"
"""

import os
import shutil
from pathlib import Path

# キャラクターID マッピング（番号 → ID）
CHAR_MAP = {
    '1': 'honhon',           # ホンホン
    '2': 'penpen',           # ペンペン
    '3': 'jishin',           # ジション
    '4': 'shinbun',          # シンブン
    '5': 'kikukun',          # キクくん
    '6': 'yomukun',          # ヨムくん
    '7': 'kakuchan',         # カクちゃん
    '8': 'hanasun',          # ハナすん
    '9': 'kangaeru',         # カンガエル
    '10': 'waraun',          # ワラウん
    '11': 'nakuchan',        # ナクちゃん
    '12': 'odorokukunn',     # オドロクん
    '13': 'maruchan',        # マルちゃん
    '14': 'mojiin',          # モジーン
    '15': 'kagikun',         # カギくん
    '16': 'kuesu_chan',      # クエスちゃん
}

SRC_DIR = Path("H:/マイドライブ/images/小学コレ！/国語キャラ")
DST_DIR = Path("H:/マイドライブ/apps/kokugo-kore/assets/character_levels")

def extract_char_id(filename: str) -> str:
    """ファイル名からキャラクター番号を抽出"""
    parts = filename.split()
    if parts[0].isdigit():
        return parts[0]
    # ファイル名が "2_ペンペン_Lv2-1_集中顔.jpg" 形式の場合
    if parts[0][0].isdigit():
        return parts[0].split('_')[0]
    return None

def extract_level_variant(filename: str) -> str:
    """ファイル名からレベルとバリアント（Lv.2-1 など）を抽出"""
    # "Lv.2-1", "Lv2-1" などのパターン
    import re
    match = re.search(r'Lv\.?(\d+)[_-](\d+)', filename)
    if match:
        level = match.group(1)
        variant = match.group(2)
        return f"lv{level}_{variant}"
    # "Lvmax" などのパターン
    if 'Lvmax' in filename or 'Lv.max' in filename or 'LVmax' in filename:
        return 'lvmax'
    return None

def process_images():
    lv2_lv3_dir = SRC_DIR / "Lv2_Lv3"
    lvmax_dir = SRC_DIR / "Lvmax"

    copied = 0
    failed = []

    # Lv.2-Lv.3 画像をコピー
    if lv2_lv3_dir.exists():
        for src_file in sorted(lv2_lv3_dir.glob("*.jpg")):
            char_id_num = extract_char_id(src_file.name)
            lv_variant = extract_level_variant(src_file.name)

            if not char_id_num or not lv_variant:
                failed.append((src_file.name, f"char_id={char_id_num}, lv={lv_variant}"))
                continue

            char_id = CHAR_MAP.get(char_id_num)
            if not char_id:
                failed.append((src_file.name, f"unknown char_id {char_id_num}"))
                continue

            # 出力ファイル名: "01_honhon_lv2_1.jpg"
            dst_filename = f"{int(char_id_num):02d}_{char_id}_{lv_variant}.jpg"
            dst_path = DST_DIR / dst_filename

            try:
                shutil.copy2(src_file, dst_path)
                print(f"✓ {src_file.name} → {dst_filename}")
                copied += 1
            except Exception as e:
                failed.append((src_file.name, str(e)))

    # Lvmax 画像をコピー
    if lvmax_dir.exists():
        for src_file in sorted(lvmax_dir.glob("*.jpg")):
            # ファイル名から "1 ホンホン（本）.jpg" の形式で番号抽出
            parts = src_file.stem.split()
            char_id_num = parts[0] if parts and parts[0].isdigit() else None

            if not char_id_num:
                failed.append((src_file.name, "cannot extract char_id"))
                continue

            char_id = CHAR_MAP.get(char_id_num)
            if not char_id:
                failed.append((src_file.name, f"unknown char_id {char_id_num}"))
                continue

            dst_filename = f"{int(char_id_num):02d}_{char_id}_lvmax.jpg"
            dst_path = DST_DIR / dst_filename

            try:
                shutil.copy2(src_file, dst_path)
                print(f"✓ {src_file.name} → {dst_filename}")
                copied += 1
            except Exception as e:
                failed.append((src_file.name, str(e)))

    print(f"\n=== Summary ===")
    print(f"Copied: {copied}")
    print(f"Failed: {len(failed)}")
    if failed:
        print("\nFailed files:")
        for fname, reason in failed:
            print(f"  - {fname}: {reason}")

if __name__ == "__main__":
    process_images()
