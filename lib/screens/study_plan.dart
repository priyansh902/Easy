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
  // View mode: grid or flashcard
  bool _flashcardMode = false;
  int _cardIndex = 0;
  bool _flipped = false;
  final Set<int> _mastered = {};

  // Grid filter
  String _filter = 'all'; // all / mastered / remaining

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
        return widget.kanji
            .where((k) => _mastered.contains(widget.kanji.indexOf(k)))
            .toList();
      case 'remaining':
        return widget.kanji
            .where((k) => !_mastered.contains(widget.kanji.indexOf(k)))
            .toList();
      default:
        return widget.kanji;
    }
  }

  void _flipCard() {
    setState(() => _flipped = !_flipped);
    HapticFeedback.selectionClick();
  }

  void _nextCard() {
    setState(() {
      _flipped = false;
      _cardIndex = (_cardIndex + 1) % widget.kanji.length;
    });
  }

  void _prevCard() {
    setState(() {
      _flipped = false;
      _cardIndex =
          (_cardIndex - 1 + widget.kanji.length) % widget.kanji.length;
    });
  }

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
          onPressed: () => Navigator.of(context).pop(
            _mastered.length == widget.kanji.length,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
        actions: [
          // Toggle grid / flashcard
          IconButton(
            icon: Icon(
              _flashcardMode ? Icons.grid_view_rounded : Icons.style_rounded,
              size: 22,
            ),
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
          Expanded(
            child: _flashcardMode
                ? _buildFlashcard()
                : _buildGrid(),
          ),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _jlptLabel,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: widget.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$mastered / $total mastered',
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: AppTheme.inkLight),
              ),
              const Spacer(),
              if (mastered == total && total > 0)
                Row(children: [
                  const Icon(Icons.check_circle,
                      color: AppTheme.success, size: 16),
                  const SizedBox(width: 4),
                  Text('Done!',
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
              valueColor:
                  AlwaysStoppedAnimation(widget.accentColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  // ── GRID MODE ───────────────────────────────────────────────

  Widget _buildGrid() {
    final kanji = widget.kanji;
    final isKanjiHeavy = kanji.any((k) => k.jlpt <= 2);

    return Column(
      children: [
        // Filter tabs
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
                    color: active
                        ? widget.accentColor
                        : AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: active
                            ? widget.accentColor
                            : AppTheme.border),
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
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isKanjiHeavy ? 3 : 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: isKanjiHeavy ? 0.78 : 0.72,
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
                    color: isMastered
                        ? AppTheme.successLight
                        : AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMastered
                          ? AppTheme.success.withOpacity(0.4)
                          : AppTheme.border,
                      width: isMastered ? 1.5 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Center(
                              child: Text(
                                k.k,
                                style: GoogleFonts.notoSans(
                                  fontSize: isKanjiHeavy ? 34 : 30,
                                  color: isMastered
                                      ? AppTheme.success
                                      : widget.accentColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            if (isMastered)
                              const Icon(Icons.check_circle,
                                  size: 14, color: AppTheme.success),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          k.en.split(',')[0].trim(),
                          style: GoogleFonts.notoSans(
                            fontSize: 9.5,
                            color: AppTheme.inkLight,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (k.on.isNotEmpty)
                          Text(
                            k.on.split('、')[0].trim(),
                            style: GoogleFonts.notoSans(
                              fontSize: 8.5,
                              color: AppTheme.inkLight.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (k.frame != null)
                          Text(
                            '#${k.frame}',
                            style: GoogleFonts.notoSans(
                              fontSize: 7.5,
                              color: widget.accentColor.withOpacity(0.5),
                            ),
                          ),
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
    final isMastered = _mastered.contains(idx);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _KanjiDetailSheet(
        k: k,
        isMastered: isMastered,
        accentColor: widget.accentColor,
        onToggle: () {
          _toggleMastered(idx);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── FLASHCARD MODE ──────────────────────────────────────────

  Widget _buildFlashcard() {
    final k = widget.kanji[_cardIndex];
    final isMastered = _mastered.contains(_cardIndex);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        children: [
          // Progress dots
          Text(
            'Card ${_cardIndex + 1} of ${widget.kanji.length}',
            style: GoogleFonts.notoSans(
                fontSize: 12, color: AppTheme.inkLight),
          ),
          const SizedBox(height: 16),
          // The card
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: _flipped
                    ? _FlashcardBack(
                        key: const ValueKey('back'),
                        k: k,
                        accentColor: widget.accentColor,
                        isMastered: isMastered,
                      )
                    : _FlashcardFront(
                        key: const ValueKey('front'),
                        k: k,
                        accentColor: widget.accentColor,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Navigation row
          Row(
            children: [
              IconButton(
                onPressed: _prevCard,
                icon: const Icon(Icons.arrow_back_ios_new),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.white,
                  foregroundColor: AppTheme.ink,
                  side: const BorderSide(color: AppTheme.border),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _toggleMastered(_cardIndex);
                    _nextCard();
                  },
                  icon: Icon(
                    isMastered ? Icons.close : Icons.check,
                    size: 18,
                  ),
                  label: Text(isMastered ? 'Unmark' : 'Got it!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isMastered ? AppTheme.border : AppTheme.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    textStyle: GoogleFonts.notoSans(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _nextCard,
                icon: const Icon(Icons.arrow_forward_ios),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.white,
                  foregroundColor: AppTheme.ink,
                  side: const BorderSide(color: AppTheme.border),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap card to flip  ·  Long-press grid cells to mark mastered',
            style: GoogleFonts.notoSans(
                fontSize: 10, color: AppTheme.inkLight),
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
        icon: Icon(
            allDone ? Icons.check_circle : Icons.arrow_back,
            size: 18),
        label: Text(allDone
            ? 'Mark Day ${widget.dayNumber} Complete ✓'
            : 'Back to Plan'),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              allDone ? AppTheme.success : widget.accentColor,
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

// ── Flashcard widgets ──────────────────────────────────────────

class _FlashcardFront extends StatelessWidget {
  final KanjiEntry k;
  final Color accentColor;
  const _FlashcardFront({super.key, required this.k, required this.accentColor});

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
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            k.k,
            style: GoogleFonts.notoSans(
              fontSize: 120,
              color: accentColor,
              fontWeight: FontWeight.w300,
            ),
          ),
          if (k.frame != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'RTK #${k.frame}',
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: accentColor),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Tap to reveal',
            style: GoogleFonts.notoSans(
                fontSize: 13, color: AppTheme.inkLight),
          ),
        ],
      ),
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  final KanjiEntry k;
  final Color accentColor;
  final bool isMastered;
  const _FlashcardBack(
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
          color: isMastered
              ? AppTheme.success.withOpacity(0.4)
              : AppTheme.border,
          width: isMastered ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6)),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              k.k,
              style: GoogleFonts.notoSans(
                fontSize: 72,
                color: isMastered ? AppTheme.success : accentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            // Heisig keyword — the mnemonic anchor
            if (k.kw.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '"${k.kw}"',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Heisig keyword',
                style: GoogleFonts.notoSans(
                    fontSize: 10, color: AppTheme.inkLight),
              ),
            ],
            const SizedBox(height: 16),
            // Meaning
            Text(
              k.en,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppTheme.ink,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            _ReadingRow(label: 'On', value: k.on, color: accentColor),
            const SizedBox(height: 6),
            _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
            const SizedBox(height: 14),
            // JLPT + category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Pill(
                  text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                _Pill(
                  text: categoryIcon(k.cat.toLowerCase()) +
                      ' ' +
                      k.cat.split('_')[0],
                  color: AppTheme.inkLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReadingRow(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(4),
          ),
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
          child: Text(
            value,
            style: GoogleFonts.notoSans(
                fontSize: 13, color: AppTheme.ink),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSans(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Kanji detail bottom sheet ──────────────────────────────────

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
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Kanji big
              Text(
                k.k,
                style: GoogleFonts.notoSans(
                  fontSize: 80,
                  color: accentColor,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // Heisig keyword
              if (k.kw.isNotEmpty) ...[
                Text(
                  '"${k.kw}"',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (k.frame != null)
                  Text(
                    'RTK Frame #${k.frame}',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppTheme.inkLight),
                  ),
              ],
              const SizedBox(height: 12),
              Text(
                k.en,
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: AppTheme.ink,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (k.on.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _ReadingRow(
                      label: 'On', value: k.on, color: accentColor),
                ),
              if (k.kun.isNotEmpty)
                _ReadingRow(
                    label: 'Kun', value: k.kun, color: accentColor),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Pill(
                    text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    text: categoryIcon(k.cat.toLowerCase()) +
                        ' ' +
                        k.cat.split('_')[0],
                    color: AppTheme.inkLight,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  isMastered ? Icons.close : Icons.check,
                  size: 18,
                ),
                label:
                    Text(isMastered ? 'Remove mastered' : 'Mark mastered'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isMastered ? AppTheme.border : AppTheme.success,
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
