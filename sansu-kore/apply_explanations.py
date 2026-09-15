import json
import re

with open('H:/マイドライブ/apps/sansu-kore/explanations_patch.json', 'r', encoding='utf-8') as f:
    patches = json.load(f)

with open('H:/マイドライブ/apps/sansu-kore/lib/data/stage_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

count = 0
for patch in patches:
    old_exp = patch['old'].replace("'", "’")
    new_exp = patch['new'].replace("'", "’")
    old_line = f"explanation: '{old_exp}'"
    new_line = f"explanation: '{new_exp}'"
    if old_line in content:
        content = content.replace(old_line, new_line, 1)
        count += 1
    else:
        # バックスラッシュ対応
        print(f"WARNING: not found: {patch['id']} -> {old_exp[:40]}")

with open('H:/マイドライブ/apps/sansu-kore/lib/data/stage_data.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Applied {count}/{len(patches)} replacements")
