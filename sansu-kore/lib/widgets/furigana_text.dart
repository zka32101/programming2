import 'package:flutter/material.dart';

class _Seg {
  final String text;
  final String? ruby;
  const _Seg(this.text, [this.ruby]);
}

/// テキスト内の {漢字|ふりがな} マークアップをルビ付きで描画するウィジェット。
/// マークアップなしの文字列は通常の Text として描画する。
class FuriganaText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const FuriganaText(
    this.text, {
    super.key,
    this.fontSize = 14.0,
    this.color = const Color(0xFF2C3E50),
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
  });

  static final _pattern = RegExp(r'\{([^|{]+)\|([^}]+)\}');

  List<_Seg> _parse() {
    final out = <_Seg>[];
    int pos = 0;
    for (final m in _pattern.allMatches(text)) {
      if (m.start > pos) out.add(_Seg(text.substring(pos, m.start)));
      out.add(_Seg(m.group(1)!, m.group(2)));
      pos = m.end;
    }
    if (pos < text.length) out.add(_Seg(text.substring(pos)));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final segs = _parse();
    if (segs.every((s) => s.ruby == null)) {
      return Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
        textAlign: textAlign,
      );
    }

    final rubySize = (fontSize * 0.45).clamp(8.0, 12.0);
    final rubyLineH = rubySize * 1.5;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: segs.map((s) {
        if (s.ruby == null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: rubyLineH),
              Text(
                s.text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: color,
                  fontWeight: fontWeight,
                  height: 1.2,
                ),
              ),
            ],
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              s.ruby!,
              style: TextStyle(
                fontSize: rubySize,
                color: color.withAlpha(180),
                height: rubyLineH / rubySize,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              s.text,
              style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
                height: 1.2,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
