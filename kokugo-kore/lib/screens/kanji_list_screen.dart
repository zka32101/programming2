// lib/screens/kanji_list_screen.dart
// Kanji list screen: みる(複数読み+使い方ダイアログ) / おぼえる / かく (進捗保存)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/kanji_data.dart';
import '../providers/drawing_progress_provider.dart';
import '../providers/sound_provider.dart';
import '../screens/drawing_canvas_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/stroke_order_view.dart';

class KanjiListScreen extends ConsumerStatefulWidget {
  const KanjiListScreen({super.key});

  @override
  ConsumerState<KanjiListScreen> createState() => _KanjiListScreenState();
}

class _KanjiListScreenState extends ConsumerState<KanjiListScreen> {
  int _selectedGrade = 1;

  List<KanjiItem> get _items => getKanjiByGrade(_selectedGrade);
  List<int> get _grades => availableGrades;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'かんじいちらん',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(88),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: _grades.map((g) {
                      final selected = g == _selectedGrade;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text('${g}年生'),
                          selected: selected,
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.18),
                          side: BorderSide(
                            color: selected ? Colors.white : Colors.white60,
                            width: 1.2,
                          ),
                          labelStyle: TextStyle(
                            color: selected ? kPrimaryColor : const Color(0xFFFFCC80),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (_) =>
                              setState(() => _selectedGrade = g),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'みる'),
                    Tab(text: 'おぼえる'),
                    Tab(text: 'かく'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _MiruTab(items: _items),
            _OboeeruTab(items: _items),
            _KakuTab(items: _items, grade: _selectedGrade),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1: みる — kanji + multiple readings, tap → usage dialog + sound
// ---------------------------------------------------------------------------

class _MiruTab extends ConsumerWidget {
  final List<KanjiItem> items;
  const _MiruTab({required this.items});

  void _showUsage(BuildContext context, WidgetRef ref, KanjiItem item) {
    ref.read(soundProvider.notifier).speak(item.kunYomi.isNotEmpty ? item.kunYomi : item.onYomi);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(
              item.kanji,
              style: const TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold, color: kPrimaryColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.kunYomi.isNotEmpty)
                  Text('訓読み: ${item.kunYomi}',
                      style: const TextStyle(fontSize: 12, color: kTextDark)),
                if (item.onYomi.isNotEmpty)
                  Text('音読み: ${item.onYomi}',
                      style: const TextStyle(fontSize: 12, color: kTextMuted)),
              ],
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 書き順
              const Text('かきじゅん（書き順）',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              const SizedBox(height: 8),
              Center(child: StrokeOrderPanel(character: item.kanji)),
              const SizedBox(height: 12),
              // 使い方
              const Text('つかいかた',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: kAccentGreen)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBgLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.example,
                  style: const TextStyle(fontSize: 14, color: kTextDark, height: 1.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'よみかた: ${item.exampleReading}',
                style: const TextStyle(fontSize: 11, color: kTextMuted),
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('データがありません'));
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _MiruCard(
        item: items[i],
        onTap: () => _showUsage(context, ref, items[i]),
      ),
    );
  }
}

class _MiruCard extends StatelessWidget {
  final KanjiItem item;
  final VoidCallback onTap;
  const _MiruCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Text(
                  item.kanji,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: kTextDark),
                ),
                Positioned(
                  top: -6,
                  child: Text(
                    item.kunYomi.isNotEmpty ? item.kunYomi : item.onYomi,
                    style: const TextStyle(fontSize: 7, color: kPrimaryColor, height: 1.2),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (item.kunYomi.isNotEmpty)
              Text(
                item.kunYomi,
                style: const TextStyle(fontSize: 9, color: kPrimaryColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (item.onYomi.isNotEmpty)
              Text(
                item.onYomi,
                style: const TextStyle(fontSize: 8, color: kTextMuted),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const Icon(Icons.info_outline, size: 10, color: kTextMuted),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2: おぼえる — show kanji, tap to reveal reading + sound
// ---------------------------------------------------------------------------

class _OboeeruTab extends ConsumerWidget {
  final List<KanjiItem> items;
  const _OboeeruTab({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('データがありません'));
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _MemorizeCard(key: ValueKey(items[i].kanji), item: items[i]),
    );
  }
}

class _MemorizeCard extends ConsumerStatefulWidget {
  final KanjiItem item;
  const _MemorizeCard({super.key, required this.item});

  @override
  ConsumerState<_MemorizeCard> createState() => _MemorizeCardState();
}

class _MemorizeCardState extends ConsumerState<_MemorizeCard> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final reading = widget.item.kunYomi.isNotEmpty
        ? widget.item.kunYomi
        : widget.item.onYomi;

    return GestureDetector(
      onTap: () {
        setState(() => _revealed = !_revealed);
        if (_revealed) {
          ref.read(soundProvider.notifier).speak(reading);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _revealed ? kAccentGreen.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 読みを問題として表示
            Text(
              reading,
              style: const TextStyle(
                  fontSize: 11, color: kPrimaryColor, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // 漢字をタップで表示
            _revealed
                ? Text(
                    widget.item.kanji,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: kAccentGreen),
                  )
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kBgLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        '？',
                        style: TextStyle(
                            fontSize: 16, color: kTextMuted, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 3: かく — tap card → canvas → persist score
// ---------------------------------------------------------------------------

class _KakuTab extends ConsumerWidget {
  final List<KanjiItem> items;
  final int grade;
  const _KakuTab({required this.items, required this.grade});

  String _mode(int grade) => 'kanji_g$grade';

  Future<void> _openCanvas(BuildContext context, WidgetRef ref, int index) async {
    final item = items[index];
    final score = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => DrawingCanvasScreen(
          character: item.kanji,
          prompt: item.kunYomi.isNotEmpty ? item.kunYomi : item.onYomi,
        ),
      ),
    );
    if (score != null) {
      await ref.read(drawingProgressProvider.notifier).saveScore(_mode(grade), index, score);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) return const Center(child: Text('データがありません'));
    final progress = ref.watch(drawingProgressProvider);
    final mode = _mode(grade);
    final cleared =
        List.generate(items.length, (i) => progress.isCleared(mode, i))
            .where((v) => v)
            .length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: kPrimaryColor.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: kPrimaryColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'クリア: $cleared / ${items.length}',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final score = progress.getScore(mode, index);
              final passed = score != null && score >= 80;
              final attempted = score != null;
              return GestureDetector(
                onTap: () => _openCanvas(context, ref, index),
                child: Container(
                  decoration: BoxDecoration(
                    color: passed
                        ? kAccentGreen.withOpacity(0.08)
                        : (attempted ? kAccentRed.withOpacity(0.05) : Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: passed
                          ? kAccentGreen
                          : (attempted ? kAccentRed : Colors.transparent),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 漢字を大きく表示（書く文字を明示）
                      Text(
                        item.kanji,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: passed ? kAccentGreen : kTextDark,
                        ),
                      ),
                      Text(
                        item.kunYomi.isNotEmpty ? item.kunYomi : item.onYomi,
                        style: const TextStyle(fontSize: 8, color: kTextMuted),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (passed)
                        const Icon(Icons.check_circle, color: kAccentGreen, size: 14)
                      else if (attempted)
                        Text('$score',
                            style: const TextStyle(
                                fontSize: 10, color: kAccentRed, fontWeight: FontWeight.bold))
                      else
                        const Icon(Icons.edit_outlined, size: 12, color: kTextMuted),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
