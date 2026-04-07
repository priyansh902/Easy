import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/kanji_db.dart';

class StudyDayScreen extends StatefulWidget {
  final int dayNumber;
  final List<KanjiEntry> kanji;
  final Color accentColor;
  final bool isCompleted;

  const StudyDayScreen({
    super.key,
    required this.dayNumber,
    required this.kanji,
    required this.accentColor,
    required this.isCompleted,
  });

  @override
  State<StudyDayScreen> createState() => _StudyDayScreenState();
}

class _StudyDayScreenState extends State<StudyDayScreen> {
  bool _flashcardMode = false;
  int _cardIndex = 0;
  bool _flipped = false;
  final Set<int> _mastered = {};
  String _filter = 'all';

  String get _jlptLabel {
    final levels = widget.kanji.map((k) => k.jlpt).toSet().toList()..sort();
    if (levels.length == 1) {
      final l = levels[0];
      return l == 0 ? 'Beyond JLPT' : 'JLPT N$l';
    }
    return levels.map((l) => l == 0 ? 'N0' : 'N$l').join(' · ');
  }

  List<KanjiEntry> get _filteredKanji {
    switch (_filter) {
      case 'mastered':
        return [
          for (int i = 0; i < widget.kanji.length; i++)
            if (_mastered.contains(i)) widget.kanji[i]
        ];
      case 'remaining':
        return [
          for (int i = 0; i < widget.kanji.length; i++)
            if (!_mastered.contains(i)) widget.kanji[i]
        ];
      default:
        return widget.kanji;
    }
  }

  void _flipCard() {
    setState(() => _flipped = !_flipped);
    HapticFeedback.selectionClick();
  }

  void _nextCard() => setState(() {
        _flipped = false;
        _cardIndex = (_cardIndex + 1) % widget.kanji.length;
      });

  void _prevCard() => setState(() {
        _flipped = false;
        _cardIndex =
            (_cardIndex - 1 + widget.kanji.length) % widget.kanji.length;
      });

  void _toggleMastered(int idx) {
    setState(() {
      if (_mastered.contains(idx)) {
        _mastered.remove(idx);
      } else {
        _mastered.add(idx);
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: Text('Day ${widget.dayNumber}'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () =>
              Navigator.of(context).pop(_mastered.length == widget.kanji.length),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _flashcardMode ? Icons.grid_view_rounded : Icons.style_rounded,
              size: 22,
            ),
            tooltip: _flashcardMode ? 'Grid view' : 'Flashcard mode',
            onPressed: () => setState(() {
              _flashcardMode = !_flashcardMode;
              _cardIndex = 0;
              _flipped = false;
            }),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _buildDayHeader(),
          Expanded(child: _flashcardMode ? _buildFlashcard() : _buildGrid()),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildDayHeader() {
    final mastered = _mastered.length;
    final total = widget.kanji.length;
    final pct = total > 0 ? mastered / total : 0.0;
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                  text: _jlptLabel,
                  color: widget.accentColor,
                  bold: true),
              const SizedBox(width: 8),
              Text('$mastered / $total mastered',
                  style: GoogleFonts.notoSans(
                      fontSize: 12, color: AppTheme.inkLight)),
              const Spacer(),
              if (mastered == total && total > 0)
                Row(children: [
                  const Icon(Icons.check_circle,
                      color: AppTheme.success, size: 15),
                  const SizedBox(width: 4),
                  Text('All done!',
                      style: GoogleFonts.notoSans(
                          fontSize: 12,
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600)),
                ]),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  // ── GRID ──────────────────────────────────────────────────────

  Widget _buildGrid() {
    return Column(
      children: [
        // Filter row
        Container(
          color: AppTheme.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: ['all', 'remaining', 'mastered'].map((f) {
              final active = _filter == f;
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: active ? widget.accentColor : AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            active ? widget.accentColor : AppTheme.border),
                  ),
                  child: Text(
                    f[0].toUpperCase() + f.substring(1),
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: active ? Colors.white : AppTheme.inkLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.70,
            ),
            itemCount: _filteredKanji.length,
            itemBuilder: (context, i) {
              final k = _filteredKanji[i];
              final globalIdx = widget.kanji.indexOf(k);
              final isMastered = _mastered.contains(globalIdx);
              return GestureDetector(
                onTap: () => _showKanjiDetail(k, globalIdx),
                onLongPress: () => _toggleMastered(globalIdx),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isMastered ? AppTheme.successLight : AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMastered
                          ? AppTheme.success.withOpacity(0.4)
                          : AppTheme.border,
                      width: isMastered ? 1.5 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Kanji character
                        Text(
                          k.k,
                          style: GoogleFonts.notoSans(
                            fontSize: 36,
                            color: isMastered
                                ? AppTheme.success
                                : widget.accentColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Japanese reading (hiragana)
                        if (k.ja.isNotEmpty)
                          Text(
                            k.ja.split('・')[0],
                            style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: isMastered
                                  ? AppTheme.success.withOpacity(0.8)
                                  : widget.accentColor.withOpacity(0.75),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 2),
                        // Romaji
                        if (k.rom.isNotEmpty)
                          Text(
                            k.rom.split('/')[0].trim(),
                            style: GoogleFonts.notoSans(
                              fontSize: 9,
                              color: AppTheme.inkLight,
                            ),
                          ),
                        const SizedBox(height: 2),
                        // English
                        Text(
                          k.en.split(',')[0].trim(),
                          style: GoogleFonts.notoSans(
                            fontSize: 9,
                            color: AppTheme.inkLight,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (k.frame != null)
                          Text(
                            '#${k.frame}',
                            style: GoogleFonts.notoSans(
                              fontSize: 7.5,
                              color: widget.accentColor.withOpacity(0.4),
                            ),
                          ),
                        if (isMastered)
                          const Icon(Icons.check_circle,
                              size: 13, color: AppTheme.success),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showKanjiDetail(KanjiEntry k, int idx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _KanjiDetailSheet(
        k: k,
        isMastered: _mastered.contains(idx),
        accentColor: widget.accentColor,
        onToggle: () {
          _toggleMastered(idx);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── FLASHCARD ─────────────────────────────────────────────────

  Widget _buildFlashcard() {
    final k = widget.kanji[_cardIndex];
    final isMastered = _mastered.contains(_cardIndex);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        children: [
          Text(
            'Card ${_cardIndex + 1} of ${widget.kanji.length}',
            style:
                GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _flipped
                    ? _CardBack(
                        key: const ValueKey('back'),
                        k: k,
                        accentColor: widget.accentColor,
                        isMastered: isMastered,
                      )
                    : _CardFront(
                        key: const ValueKey('front'),
                        k: k,
                        accentColor: widget.accentColor,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _prevCard,
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                style: IconButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.ink,
                    side: const BorderSide(color: AppTheme.border)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _toggleMastered(_cardIndex);
                    _nextCard();
                  },
                  icon: Icon(isMastered ? Icons.close : Icons.check,
                      size: 18),
                  label: Text(isMastered ? 'Unmark' : 'Got it!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isMastered ? AppTheme.inkLight : AppTheme.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.notoSans(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _nextCard,
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                style: IconButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.ink,
                    side: const BorderSide(color: AppTheme.border)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tap card to flip  ·  Long-press grid cells to mark mastered',
            style: GoogleFonts.notoSans(
                fontSize: 9.5, color: AppTheme.inkLight),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final allDone = _mastered.length == widget.kanji.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      color: AppTheme.white,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(allDone),
        icon: Icon(allDone ? Icons.check_circle : Icons.arrow_back, size: 18),
        label:
            Text(allDone ? 'Mark Day ${widget.dayNumber} Complete ✓' : 'Back to Plan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: allDone ? AppTheme.success : widget.accentColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.notoSans(
              fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ── Flashcard Front ────────────────────────────────────────────

class _CardFront extends StatelessWidget {
  final KanjiEntry k;
  final Color accentColor;
  const _CardFront({super.key, required this.k, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(k.k,
              style: GoogleFonts.notoSans(
                  fontSize: 110,
                  color: accentColor,
                  fontWeight: FontWeight.w300)),
          if (k.frame != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('RTK #${k.frame}',
                  style: GoogleFonts.notoSans(
                      fontSize: 12, color: accentColor)),
            ),
          const SizedBox(height: 16),
          Text('Tap to reveal',
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.inkLight)),
        ],
      ),
    );
  }
}

// ── Flashcard Back ─────────────────────────────────────────────

class _CardBack extends StatelessWidget {
  final KanjiEntry k;
  final Color accentColor;
  final bool isMastered;
  const _CardBack(
      {super.key,
      required this.k,
      required this.accentColor,
      required this.isMastered});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isMastered ? AppTheme.successLight : AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isMastered ? AppTheme.success.withOpacity(0.4) : AppTheme.border,
          width: isMastered ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          children: [
            // Kanji + Japanese reading side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(k.k,
                    style: GoogleFonts.notoSans(
                        fontSize: 68,
                        color: isMastered ? AppTheme.success : accentColor,
                        fontWeight: FontWeight.w400)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (k.ja.isNotEmpty)
                      Text(k.ja,
                          style: GoogleFonts.notoSans(
                              fontSize: 16,
                              color: accentColor,
                              fontWeight: FontWeight.w600)),
                    if (k.rom.isNotEmpty)
                      Text(k.rom,
                          style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: AppTheme.inkLight)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Heisig keyword
            if (k.kw.isNotEmpty && k.kw != k.en.split(',')[0]) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('"${k.kw}"',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontStyle: FontStyle.italic)),
              ),
              Text('Heisig keyword',
                  style: GoogleFonts.notoSans(
                      fontSize: 10, color: AppTheme.inkLight)),
              const SizedBox(height: 10),
            ],

            // English meaning
            Text(k.en,
                style: GoogleFonts.notoSans(
                    fontSize: 13, color: AppTheme.ink, height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),

            // Readings row
            if (k.on.isNotEmpty) ...[
              _ReadingRow(label: 'On', value: k.on, color: accentColor),
              const SizedBox(height: 5),
            ],
            if (k.kun.isNotEmpty)
              _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
            const SizedBox(height: 14),

            // Example words
            if (k.ex1w.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Examples',
                    style: GoogleFonts.notoSans(
                        fontSize: 10,
                        color: AppTheme.inkLight,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
              _ExampleRow(word: k.ex1w, reading: k.ex1r, meaning: k.ex1e, color: accentColor),
              if (k.ex2w.isNotEmpty) ...[
                const SizedBox(height: 5),
                _ExampleRow(word: k.ex2w, reading: k.ex2r, meaning: k.ex2e, color: accentColor),
              ],
              const SizedBox(height: 12),
            ],

            // Tags row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Pill(
                    text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                    color: accentColor),
                const SizedBox(width: 8),
                _Pill(
                    text:
                        '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
                    color: AppTheme.inkLight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Kanji Detail Bottom Sheet ──────────────────────────────────

class _KanjiDetailSheet extends StatelessWidget {
  final KanjiEntry k;
  final bool isMastered;
  final Color accentColor;
  final VoidCallback onToggle;

  const _KanjiDetailSheet({
    required this.k,
    required this.isMastered,
    required this.accentColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.white, borderRadius: BorderRadius.circular(20)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2)),
              ),

              // Kanji + Japanese reading
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(k.k,
                      style: GoogleFonts.notoSans(
                          fontSize: 72,
                          color: accentColor,
                          fontWeight: FontWeight.w300)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (k.ja.isNotEmpty)
                        Text(k.ja,
                            style: GoogleFonts.notoSans(
                                fontSize: 18,
                                color: accentColor,
                                fontWeight: FontWeight.w600)),
                      if (k.rom.isNotEmpty)
                        Text(k.rom,
                            style: GoogleFonts.notoSans(
                                fontSize: 13,
                                color: AppTheme.inkLight)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Heisig keyword
              if (k.kw.isNotEmpty) ...[
                Text('"${k.kw}"',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        fontStyle: FontStyle.italic)),
                if (k.frame != null)
                  Text('RTK Frame #${k.frame}',
                      style: GoogleFonts.notoSans(
                          fontSize: 11, color: AppTheme.inkLight)),
                const SizedBox(height: 8),
              ],

              // English
              Text(k.en,
                  style: GoogleFonts.notoSans(
                      fontSize: 14, color: AppTheme.ink, height: 1.5),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),

              // Readings
              if (k.on.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _ReadingRow(
                        label: 'On', value: k.on, color: accentColor)),
              if (k.kun.isNotEmpty)
                _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
              const SizedBox(height: 14),

              // Example words section
              if (k.ex1w.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Examples',
                          style: GoogleFonts.notoSans(
                              fontSize: 11,
                              color: AppTheme.inkLight,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _ExampleRow(
                          word: k.ex1w,
                          reading: k.ex1r,
                          meaning: k.ex1e,
                          color: accentColor),
                      if (k.ex2w.isNotEmpty) ...[
                        const Divider(height: 12),
                        _ExampleRow(
                            word: k.ex2w,
                            reading: k.ex2r,
                            meaning: k.ex2e,
                            color: accentColor),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Pill(
                      text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                      color: accentColor),
                  const SizedBox(width: 8),
                  _Pill(
                      text:
                          '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
                      color: AppTheme.inkLight),
                ],
              ),
              const SizedBox(height: 20),

              // Toggle mastered button
              ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(isMastered ? Icons.close : Icons.check, size: 18),
                label: Text(isMastered ? 'Remove mastered' : 'Mark mastered'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isMastered ? AppTheme.inkLight : AppTheme.success,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Small Widgets ───────────────────────────────────────

class _ReadingRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReadingRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(label,
                style: GoogleFonts.notoSans(
                    fontSize: 9,
                    color: color,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
            child: Text(value,
                style: GoogleFonts.notoSans(
                    fontSize: 13, color: AppTheme.ink))),
      ],
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final String word, reading, meaning;
  final Color color;
  const _ExampleRow(
      {required this.word,
      required this.reading,
      required this.meaning,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Word + reading
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(word,
                style: GoogleFonts.notoSans(
                    fontSize: 20, color: color, fontWeight: FontWeight.w500)),
            Text(reading,
                style: GoogleFonts.notoSans(
                    fontSize: 10, color: color.withOpacity(0.7))),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(meaning,
                style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppTheme.inkLight,
                    height: 1.4)),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final bool bold;
  const _Pill({required this.text, required this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: GoogleFonts.notoSans(
              fontSize: 11,
              color: color,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
    );
  }
}
