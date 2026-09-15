// lib/screens/kana_list_screen.dart
// Kana study screen: みる / おぼえる / かく (3 tabs)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kana_data.dart';
import '../providers/drawing_progress_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/sound_provider.dart';
import '../screens/drawing_canvas_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/stroke_order_view.dart';

class KanaListScreen extends ConsumerWidget {
  final KanaType kanaType;

  const KanaListScreen({super.key, required this.kanaType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = getKanaList(kanaType);
    final title = getKanaTitle(kanaType);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'みる'),
              Tab(text: 'おぼえる'),
              Tab(text: 'かく'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MiruTab(items: items, kanaType: kanaType),
            _OboeeruTab(items: items, kanaType: kanaType),
            _KakuTab(items: items, kanaType: kanaType),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// helpers
// ---------------------------------------------------------------------------

/// ひらがな → カタカナ変換（Unicode オフセット利用）
String _toKatakana(String hiragana) => String.fromCharCodes(
      hiragana.runes.map((c) => (c >= 0x3041 && c <= 0x3096) ? c + 0x60 : c),
    );

String _modeName(KanaType t) {
  switch (t) {
    case KanaType.hiragana: return 'hiragana';
    case KanaType.katakana: return 'katakana';
    case KanaType.romaji:   return 'romaji';
    case KanaType.alphabet: return 'alphabet';
  }
}

int _crossAxisCount(KanaType t) => t == KanaType.romaji ? 5 : (t == KanaType.alphabet ? 5 : 5);

double _crossAxisRatio(KanaType t) => t == KanaType.romaji ? 0.9 : 0.85;

// ---------------------------------------------------------------------------
// Tab 1: みる — tap card to play sound
// ---------------------------------------------------------------------------

class _MiruTab extends ConsumerWidget {
  final List<KanaItem> items;
  final KanaType kanaType;
  const _MiruTab({required this.items, required this.kanaType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = _crossAxisCount(kanaType);
    final ratio = _crossAxisRatio(kanaType);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        childAspectRatio: ratio,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        if (item.isPlaceholder) return const SizedBox.shrink();
        final showStrokeOrder =
            kanaType == KanaType.hiragana || kanaType == KanaType.katakana;
        return _MiruCard(
          item: item,
          kanaType: kanaType,
          onTap: () => ref.read(soundProvider.notifier).speak(item.kana),
          onStrokeOrderTap: showStrokeOrder
              ? () => _showStrokeOrderDialog(context, ref, item)
              : null,
        );
      },
    );
  }
}

/// 書き順ダイアログ — かなの文字をタップして開く
void _showStrokeOrderDialog(BuildContext context, WidgetRef ref, KanaItem item) {
  ref.read(soundProvider.notifier).speak(item.kana);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Text(
            item.kana,
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(width: 10),
          Text(item.romaji, style: const TextStyle(fontSize: 14, color: kTextMuted)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('かきじゅん（書き順）',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor)),
          const SizedBox(height: 8),
          StrokeOrderPanel(character: item.kana),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('とじる'),
        ),
      ],
    ),
  );
}

class _MiruCard extends StatelessWidget {
  final KanaItem item;
  final KanaType kanaType;
  final VoidCallback onTap;
  final VoidCallback? onStrokeOrderTap;
  const _MiruCard({
    required this.item,
    required this.kanaType,
    required this.onTap,
    this.onStrokeOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final top = item.kana;
    final sub = kanaType == KanaType.romaji || kanaType == KanaType.alphabet
        ? item.reading
        : item.romaji;
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  top,
                  style: TextStyle(
                    fontSize: top.length > 3 ? 14 : (kanaType == KanaType.romaji ? 16 : 22),
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(fontSize: 9, color: kTextMuted)),
                const Icon(Icons.volume_up, size: 10, color: kTextMuted),
              ],
            ),
          ),
        ),
        if (onStrokeOrderTap != null)
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onStrokeOrderTap,
              child: const Padding(
                padding: EdgeInsets.all(3),
                child: Icon(Icons.border_color, size: 11, color: kTextMuted),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2: おぼえる — tap to reveal + play sound
// ---------------------------------------------------------------------------

class _OboeeruTab extends ConsumerWidget {
  final List<KanaItem> items;
  final KanaType kanaType;
  const _OboeeruTab({required this.items, required this.kanaType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = _crossAxisCount(kanaType);
    final ratio = _crossAxisRatio(kanaType);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        childAspectRatio: ratio,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        if (item.isPlaceholder) return const SizedBox.shrink();
        return _MemorizeCard(item: item, kanaType: kanaType);
      },
    );
  }
}

class _MemorizeCard extends ConsumerStatefulWidget {
  final KanaItem item;
  final KanaType kanaType;
  const _MemorizeCard({required this.item, required this.kanaType});

  @override
  ConsumerState<_MemorizeCard> createState() => _MemorizeCardState();
}

class _MemorizeCardState extends ConsumerState<_MemorizeCard> {
  bool _revealed = false;

  // ひらがな: 問題=ひらがな → 答え=カタカナ（対応関係を学ぶ）
  // カタカナ: 問題=ひらがな → 答え=カタカナ（変換を学ぶ）
  // ローマ字/アルファベット: 問題=reading → 答え=kana
  String get _question {
    switch (widget.kanaType) {
      case KanaType.hiragana:
        return widget.item.kana; // ひらがなを見てカタカナを答える
      case KanaType.katakana:
        return widget.item.reading; // ひらがな
      case KanaType.romaji:
      case KanaType.alphabet:
        return widget.item.reading;
    }
  }

  String get _answer {
    switch (widget.kanaType) {
      case KanaType.hiragana:
        // ひらがなに対応するカタカナを表示
        return _toKatakana(widget.item.kana);
      default:
        return widget.item.kana;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _revealed = !_revealed);
        ref.read(soundProvider.notifier).speak(widget.item.kana);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _revealed ? kAccentGreen.withValues(alpha: 0.5) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _question,
              style: TextStyle(
                fontSize: _question.length > 3 ? 9 : 12,
                fontWeight: FontWeight.w600,
                color: kTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            _revealed
                ? Text(
                    _answer,
                    style: TextStyle(
                      fontSize: _answer.length > 2 ? 16 : 22,
                      fontWeight: FontWeight.bold,
                      color: kAccentGreen,
                    ),
                  )
                : const Icon(Icons.visibility, size: 14, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 3: かく — tap card → full-screen canvas → auto-score + persist
// ---------------------------------------------------------------------------

class _KakuTab extends ConsumerStatefulWidget {
  final List<KanaItem> items;
  final KanaType kanaType;
  const _KakuTab({required this.items, required this.kanaType});

  @override
  ConsumerState<_KakuTab> createState() => _KakuTabState();
}

class _KakuTabState extends ConsumerState<_KakuTab> {
  // Filter out placeholders for drawing (only real items)
  late final List<({KanaItem item, int originalIndex})> _realItems;

  @override
  void initState() {
    super.initState();
    _realItems = [];
    for (int i = 0; i < widget.items.length; i++) {
      if (!widget.items[i].isPlaceholder) {
        _realItems.add((item: widget.items[i], originalIndex: i));
      }
    }
  }

  Future<void> _openCanvas(KanaItem item, int storageIndex) async {
    final prompt = widget.kanaType == KanaType.hiragana
        ? item.romaji
        : widget.kanaType == KanaType.alphabet
            ? item.reading
            : item.reading;

    final score = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => DrawingCanvasScreen(
          character: item.kana,
          prompt: prompt,
        ),
      ),
    );

    if (score != null && mounted) {
      await ref
          .read(drawingProgressProvider.notifier)
          .saveScore(_modeName(widget.kanaType), storageIndex, score);
    }
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('リセットしますか？'),
        content: const Text('この一覧のかく記録をすべて消します。元に戻せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(drawingProgressProvider.notifier)
                  .resetMode(_modeName(widget.kanaType));
            },
            child: const Text('リセット', style: TextStyle(color: kAccentRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(drawingProgressProvider);
    final settings = ref.watch(drawingSettingsProvider);
    final mode = _modeName(widget.kanaType);
    const count = 5;
    final ratio = _crossAxisRatio(widget.kanaType);

    final cleared = _realItems
        .where((e) => progress.isPassed(mode, e.originalIndex, settings.passingScore))
        .length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: kPrimaryColor.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.star, color: kPrimaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'クリア: $cleared / ${_realItems.length}  (合格点: ${settings.passingScore}点)',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: kAccentRed, size: 20),
                tooltip: 'リセット',
                onPressed: () => _confirmReset(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              childAspectRatio: ratio,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: widget.items.length,
            itemBuilder: (_, index) {
              final item = widget.items[index];
              if (item.isPlaceholder) return const SizedBox.shrink();
              // カードには書く文字そのものを表示、ヒントはローマ字
              final hint = widget.kanaType == KanaType.hiragana
                  ? item.romaji
                  : item.reading;
              final score = progress.getScore(mode, index);
              final isPassed = progress.isPassed(mode, index, settings.passingScore);
              return _KakuCard(
                displayChar: item.kana, // 書く文字を表示
                hint: hint,             // ローマ字ヒント
                score: score,
                isPassed: isPassed,
                onTap: () => _openCanvas(item, index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _KakuCard extends StatelessWidget {
  final String displayChar; // 書く文字（ひらがな/カタカナ/ローマ字）
  final String hint;        // 小さなヒント
  final int? score;
  final bool isPassed;
  final VoidCallback onTap;
  const _KakuCard({
    required this.displayChar,
    required this.hint,
    this.score,
    required this.isPassed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final attempted = score != null;
    final borderColor =
        isPassed ? kAccentGreen : (attempted ? kAccentRed : Colors.transparent);
    final bgColor = isPassed
        ? kAccentGreen.withValues(alpha: 0.08)
        : (attempted ? kAccentRed.withValues(alpha: 0.05) : Colors.white);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 書く文字を大きく表示
            Text(
              displayChar,
              style: TextStyle(
                fontSize: displayChar.length > 2 ? 16 : 22,
                fontWeight: FontWeight.bold,
                color: isPassed ? kAccentGreen : kTextDark,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              hint,
              style: const TextStyle(fontSize: 8, color: kTextMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            if (isPassed)
              const Icon(Icons.check_circle, color: kAccentGreen, size: 16)
            else if (attempted)
              Text(
                '$score',
                style: const TextStyle(
                    fontSize: 11, color: kAccentRed, fontWeight: FontWeight.bold),
              )
            else
              const Icon(Icons.edit_outlined, size: 14, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}
