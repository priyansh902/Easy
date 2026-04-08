

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/j_char.dart';
import 'script.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Two-step quiz:
//   Step 1 → type ROMAJI  (e.g. "nichi" for 日)
//   Step 2 → type ENGLISH (e.g. "sun" or "day" for 日)
// Both must be correct for the card to count as ✓.
// Wrong romaji: shake + stay on step 1.
// Correct romaji: slide English field in, move focus.
// Wrong English: shake + show correct answer + "Next" button.
// Correct English: bounce + auto-advance after 0.9s.
// ─────────────────────────────────────────────────────────────────────────────

enum _Step  { romaji, english }
enum _Field { idle, correct, wrong }

class QuizScreen extends StatefulWidget {
  final List<JChar> chars;
  final ScriptType scriptType;
  final Color accentColor;

  const QuizScreen({
    super.key,
    required this.chars,
    required this.scriptType,
    required this.accentColor,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<JChar> _shuffled;
  int _index = 0;

  final TextEditingController _romajiCtrl  = TextEditingController();
  final TextEditingController _englishCtrl = TextEditingController();
  final FocusNode _romajiFocus  = FocusNode();
  final FocusNode _englishFocus = FocusNode();

  _Step  _step         = _Step.romaji;
  _Field _romajiField  = _Field.idle;
  _Field _englishField = _Field.idle;
  bool   _cardDone     = false;   // both steps completed this round

  int _correct = 0;
  int _total   = 0;
  final Set<int> _practiced     = {};
  final Set<int> _correctIdx    = {};

  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;
  late AnimationController _slideCtrl;   // English field slide-in
  late Animation<double>   _shakeAnim;
  late Animation<double>   _bounceAnim;
  late Animation<double>   _slideAnim;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _shuffled = List.from(widget.chars)..shuffle(Random());

    _shakeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _slideCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));

    _shakeAnim  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _shakeCtrl,  curve: Curves.elasticIn));
    _bounceAnim = Tween(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
    _slideAnim  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _slideCtrl,  curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _romajiCtrl.dispose();
    _englishCtrl.dispose();
    _romajiFocus.dispose();
    _englishFocus.dispose();
    _shakeCtrl.dispose();
    _bounceCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  JChar get _current => _shuffled[_index];

  // ── Validation helpers ─────────────────────────────────────────────────────

  bool _checkRomaji(String input) {
    final typed = input.trim().toLowerCase();
    if (typed.isEmpty) return false;
    final accepted = _current.romaji
        .toLowerCase()
        .split(RegExp(r'[,/]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);
    return accepted.contains(typed);
  }

  bool _checkEnglish(String input) {
    final typed = input.trim().toLowerCase();
    if (typed.isEmpty) return false;

    // Build accepted list from meaning field (and romaji as fallback for kana)
    final raw = _current.meaning.isEmpty ? _current.romaji : _current.meaning;
    final accepted = raw
        .toLowerCase()
        .split(RegExp(r'[,;/]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Exact match
    if (accepted.contains(typed)) return true;

    // Partial: user typed ≥3 chars that starts any accepted answer, or vice-versa
    if (typed.length >= 3) {
      for (final a in accepted) {
        if (a.startsWith(typed) || typed.startsWith(a)) return true;
      }
    }
    return false;
  }

  // ── Submit handlers ────────────────────────────────────────────────────────

  void _submitRomaji() {
    if (_step != _Step.romaji || _romajiField == _Field.correct) return;
    final input = _romajiCtrl.text;
    if (input.trim().isEmpty) return;

    final ok = _checkRomaji(input);
    setState(() => _romajiField = ok ? _Field.correct : _Field.wrong);

    if (ok) {
      HapticFeedback.selectionClick();
      _slideCtrl.forward();
      Future.delayed(const Duration(milliseconds: 220), () {
        if (!mounted) return;
        setState(() => _step = _Step.english);
        _englishFocus.requestFocus();
      });
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _submitEnglish() {
    if (_step != _Step.english || _cardDone) return;
    final input = _englishCtrl.text;
    if (input.trim().isEmpty) return;

    final ok = _checkEnglish(input);
    setState(() {
      _englishField = ok ? _Field.correct : _Field.wrong;
      _cardDone     = true;
      _total++;
      _practiced.add(_index);
      if (ok) {
        _correct++;
        _correctIdx.add(_index);
      }
    });

    if (ok) {
      HapticFeedback.lightImpact();
      _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
      Future.delayed(const Duration(milliseconds: 950), _nextCard);
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _nextCard() {
    if (!mounted) return;
    setState(() {
      _index = (_index + 1) % _shuffled.length;
      _romajiCtrl.clear();
      _englishCtrl.clear();
      _step         = _Step.romaji;
      _romajiField  = _Field.idle;
      _englishField = _Field.idle;
      _cardDone     = false;
    });
    _slideCtrl.reset();
    _romajiFocus.requestFocus();
  }

  void _skip() {
    setState(() {
      _total++;
      _practiced.add(_index);
    });
    _nextCard();
  }

  void _jumpToChar(int originalIndex) {
    final char = widget.chars[originalIndex];
    final idx  = _shuffled.indexWhere((c) => c.japanese == char.japanese);
    if (idx == -1) return;
    Navigator.pop(context);
    setState(() {
      _index = idx;
      _romajiCtrl.clear();
      _englishCtrl.clear();
      _step         = _Step.romaji;
      _romajiField  = _Field.idle;
      _englishField = _Field.idle;
      _cardDone     = false;
    });
    _slideCtrl.reset();
    Future.delayed(const Duration(milliseconds: 200), _romajiFocus.requestFocus);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isKanji = widget.scriptType == ScriptType.kanji;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.offWhite,
      endDrawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text('Read & Type'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: Text(
                '$_correct / $_total',
                style: GoogleFonts.notoSans(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 22),
            tooltip: 'All characters',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_step == _Step.romaji) {
            _romajiFocus.requestFocus();
          } else {
            _englishFocus.requestFocus();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                _buildProgress(),
                const SizedBox(height: 18),
                Expanded(child: _buildCard(isKanji)),
                const SizedBox(height: 16),
                _buildInputArea(),
                const SizedBox(height: 10),
                _buildBottomRow(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Progress bar ───────────────────────────────────────────────────────────

  Widget _buildProgress() {
    final pct = (_index + 1) / _shuffled.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Card ${_index + 1} of ${_shuffled.length}',
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: AppTheme.inkLight)),
            Text('${(pct * 100).round()}%',
                style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: widget.accentColor,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
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
    );
  }

  // ── Kanji card ─────────────────────────────────────────────────────────────

  Widget _buildCard(bool isKanji) {
    // Card background colour based on overall result
    Color bg = AppTheme.white;
    Color borderCol = AppTheme.border;
    double borderW = 1;

    if (_cardDone) {
      final allOk = _romajiField == _Field.correct && _englishField == _Field.correct;
      bg        = allOk ? AppTheme.successLight : AppTheme.redFaint;
      borderCol = allOk ? AppTheme.success.withOpacity(0.4) : AppTheme.red.withOpacity(0.3);
      borderW   = 2;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnim, _bounceAnim]),
      builder: (ctx, child) {
        final dx = _shakeCtrl.isAnimating ? sin(_shakeAnim.value * pi * 8) * 10.0 : 0.0;
        final sc = _bounceCtrl.isAnimating ? _bounceAnim.value : 1.0;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.scale(scale: sc, child: child),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderCol, width: borderW),
          boxShadow: [
            BoxShadow(
                color: widget.accentColor.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Kanji character ──
            Text(
              _current.japanese,
              style: AppTheme.kanjiStyle(
                fontSize: isKanji ? 96 : 110,
                color: _cardDone && _englishField == _Field.wrong
                    ? AppTheme.red
                    : widget.accentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),

            // ── Step indicators ──
            _buildStepIndicators(),

            const SizedBox(height: 10),

            // ── Feedback / hint text ──
            _buildCardHint(isKanji),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StepDot(
          label: 'Romaji',
          state: _romajiField,
          active: _step == _Step.romaji,
          accentColor: widget.accentColor,
        ),
        Container(
          width: 28,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          color: _step == _Step.english || _romajiField == _Field.correct
              ? widget.accentColor.withOpacity(0.4)
              : AppTheme.border,
        ),
        _StepDot(
          label: 'English',
          state: _englishField,
          active: _step == _Step.english,
          accentColor: widget.accentColor,
        ),
      ],
    );
  }

  Widget _buildCardHint(bool isKanji) {
    // Not started yet
    if (_romajiField == _Field.idle) {
      return Text(
        isKanji ? 'Type the romaji reading' : 'Type the romaji',
        style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.inkLight),
      );
    }

    // Romaji correct, waiting for English
    if (_romajiField == _Field.correct && _englishField == _Field.idle) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
              const SizedBox(width: 5),
              Text(
                '${_current.romaji}  ✓',
                style: GoogleFonts.notoSans(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Now type the English meaning',
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.inkLight)),
        ],
      );
    }

    // Both correct
    if (_romajiField == _Field.correct && _englishField == _Field.correct) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.success, size: 20),
              const SizedBox(width: 6),
              Text('Perfect!',
                  style: GoogleFonts.playfairDisplay(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 18)),
            ],
          ),
          const SizedBox(height: 4),
          Text('${_current.romaji}  ·  ${_current.meaning}',
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.success.withOpacity(0.8))),
        ],
      );
    }

    // English wrong — show correct answers
    if (_englishField == _Field.wrong) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: AppTheme.red, size: 18),
              const SizedBox(width: 5),
              Text('Not quite!',
                  style: GoogleFonts.notoSans(
                      color: AppTheme.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.redFaint,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.red.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text('Romaji: ${_current.romaji}',
                    style: GoogleFonts.notoSans(
                        fontSize: 12, color: AppTheme.inkLight)),
                const SizedBox(height: 2),
                Text('English: ${_current.meaning}',
                    style: GoogleFonts.notoSans(
                        fontSize: 13,
                        color: AppTheme.red,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      );
    }

    // Romaji wrong
    if (_romajiField == _Field.wrong) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.close, color: AppTheme.red, size: 18),
              const SizedBox(width: 5),
              Text('Romaji: ${_current.romaji}',
                  style: GoogleFonts.notoSans(
                      color: AppTheme.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Try again or skip',
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppTheme.inkLight)),
        ],
      );
    }

    return const SizedBox();
  }

  // ── Input area (two fields) ────────────────────────────────────────────────

  Widget _buildInputArea() {
    return Column(
      children: [
        // ── Field 1: Romaji ──
        _InputField(
          controller: _romajiCtrl,
          focusNode: _romajiFocus,
          hint: 'Type romaji  (e.g. nichi)',
          label: '1  Romaji',
          fieldState: _romajiField,
          accentColor: widget.accentColor,
          enabled: _romajiField != _Field.correct && !_cardDone,
          autofocus: true,
          onSubmit: _submitRomaji,
          onSend: _submitRomaji,
        ),

        // ── Field 2: English — slides in after romaji correct ──
        AnimatedBuilder(
          animation: _slideAnim,
          builder: (ctx, child) {
            return ClipRect(
              child: Align(
                heightFactor: _slideAnim.value,
                child: Opacity(
                  opacity: _slideAnim.value,
                  child: child,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _InputField(
              controller: _englishCtrl,
              focusNode: _englishFocus,
              hint: 'Type English meaning  (e.g. day)',
              label: '2  English',
              fieldState: _englishField,
              accentColor: widget.accentColor,
              enabled: _step == _Step.english && !_cardDone,
              autofocus: false,
              onSubmit: _submitEnglish,
              onSend: _submitEnglish,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom action row ──────────────────────────────────────────────────────

  Widget _buildBottomRow() {
    // After wrong English: show Next button prominently
    if (_cardDone && _englishField == _Field.wrong) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _nextCard,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('Next card',
                style: GoogleFonts.notoSans(fontWeight: FontWeight.w600)),
            style: TextButton.styleFrom(foregroundColor: AppTheme.inkLight),
          ),
        ],
      );
    }

    // After wrong romaji: retry + skip
    if (_romajiField == _Field.wrong && !_cardDone) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _romajiField = _Field.idle;
                _romajiCtrl.clear();
              });
              _romajiFocus.requestFocus();
            },
            child: Text('Retry',
                style: GoogleFonts.notoSans(
                    color: AppTheme.inkLight,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: _skip,
            child: Text('Skip',
                style:
                    GoogleFonts.notoSans(color: AppTheme.inkLight)),
          ),
        ],
      );
    }

    // Default: Skip
    return TextButton(
      onPressed: _skip,
      child: Text('Skip',
          style: GoogleFonts.notoSans(color: AppTheme.inkLight)),
    );
  }

  // ── Character reference drawer ─────────────────────────────────────────────

  Widget _buildDrawer() {
    final isKanji = widget.scriptType == ScriptType.kanji;
    return Drawer(
      width: 220,
      backgroundColor: AppTheme.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppTheme.border))),
              child: Row(
                children: [
                  Expanded(
                    child: Text('All Characters',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink)),
                  ),
                  Text('${widget.chars.length}',
                      style: GoogleFonts.notoSans(
                          fontSize: 12, color: AppTheme.inkLight)),
                ],
              ),
            ),
            // Legend
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                children: [
                  _LegendDot(color: AppTheme.success),
                  const SizedBox(width: 4),
                  Text('Correct',
                      style: GoogleFonts.notoSans(
                          fontSize: 10, color: AppTheme.inkLight)),
                  const SizedBox(width: 12),
                  _LegendDot(color: AppTheme.red.withOpacity(0.5)),
                  const SizedBox(width: 4),
                  Text('Practiced',
                      style: GoogleFonts.notoSans(
                          fontSize: 10, color: AppTheme.inkLight)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isKanji ? 3 : 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: isKanji ? 0.82 : 0.90,
                ),
                itemCount: widget.chars.length,
                itemBuilder: (ctx, i) {
                  final c = widget.chars[i];
                  final sIdx =
                      _shuffled.indexWhere((s) => s.japanese == c.japanese);
                  final isCurrent  = sIdx == _index;
                  final isCorrect  = _correctIdx.contains(sIdx);
                  final isPracticed =
                      _practiced.contains(sIdx) && !isCorrect;

                  Color bg  = AppTheme.offWhite;
                  Color bdr = AppTheme.border;
                  if (isCurrent) {
                    bg  = widget.accentColor.withOpacity(0.10);
                    bdr = widget.accentColor;
                  } else if (isCorrect) {
                    bg  = AppTheme.successLight;
                    bdr = AppTheme.success.withOpacity(0.4);
                  } else if (isPracticed) {
                    bg  = AppTheme.redFaint;
                    bdr = AppTheme.red.withOpacity(0.25);
                  }

                  return GestureDetector(
                    onTap: () => _jumpToChar(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: bdr)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(c.japanese,
                              style: AppTheme.kanjiStyle(
                                fontSize: isKanji ? 17 : 18,
                                color: isCurrent
                                    ? widget.accentColor
                                    : AppTheme.ink,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              )),
                          Text(c.romaji,
                              style: GoogleFonts.notoSans(
                                  fontSize: 8,
                                  color: AppTheme.inkLight)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step dot indicator
// ─────────────────────────────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final String label;
  final _Field state;
  final bool  active;
  final Color accentColor;

  const _StepDot({
    required this.label,
    required this.state,
    required this.active,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color labelColor;
    Widget icon;

    if (state == _Field.correct) {
      bg         = AppTheme.success;
      labelColor = AppTheme.success;
      icon       = const Icon(Icons.check, color: Colors.white, size: 12);
    } else if (state == _Field.wrong) {
      bg         = AppTheme.red;
      labelColor = AppTheme.red;
      icon       = const Icon(Icons.close, color: Colors.white, size: 12);
    } else if (active) {
      bg         = accentColor;
      labelColor = accentColor;
      icon       = Icon(Icons.edit, color: Colors.white, size: 11);
    } else {
      bg         = AppTheme.border;
      labelColor = AppTheme.inkLight;
      icon       = Container(width: 6, height: 6,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle));
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 26, height: 26,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(child: icon),
        ),
        const SizedBox(height: 3),
        Text(label,
            style: GoogleFonts.notoSans(
                fontSize: 9,
                color: labelColor,
                fontWeight: active || state != _Field.idle
                    ? FontWeight.w700
                    : FontWeight.w400)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable styled input field
// ─────────────────────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String label;
  final _Field fieldState;
  final Color  accentColor;
  final bool   enabled;
  final bool   autofocus;
  final VoidCallback onSubmit;
  final VoidCallback onSend;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.label,
    required this.fieldState,
    required this.accentColor,
    required this.enabled,
    required this.autofocus,
    required this.onSubmit,
    required this.onSend,
  });

  Color get _borderColor {
    if (fieldState == _Field.correct) return AppTheme.success;
    if (fieldState == _Field.wrong)   return AppTheme.red;
    return accentColor;
  }

  Color get _fillColor {
    if (fieldState == _Field.correct) return AppTheme.successLight;
    if (fieldState == _Field.wrong)   return AppTheme.redFaint;
    return AppTheme.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: fieldState == _Field.correct
                    ? AppTheme.success
                    : fieldState == _Field.wrong
                        ? AppTheme.red
                        : enabled
                            ? accentColor
                            : AppTheme.border,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: GoogleFonts.notoSans(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            if (fieldState == _Field.correct) ...[
              const SizedBox(width: 6),
              Text(controller.text,
                  style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600)),
            ],
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.text,
          onSubmitted: (_) => onSubmit(),
          style: GoogleFonts.notoSans(
              fontSize: 18,
              color: fieldState == _Field.wrong ? AppTheme.red : AppTheme.ink,
              letterSpacing: 0.5),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.notoSans(
                color: AppTheme.inkLight, fontSize: 14),
            filled: true,
            fillColor: _fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: fieldState == _Field.correct
                      ? AppTheme.success.withOpacity(0.5)
                      : fieldState == _Field.wrong
                          ? AppTheme.red.withOpacity(0.5)
                          : AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _borderColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: fieldState == _Field.correct
                      ? AppTheme.success.withOpacity(0.4)
                      : AppTheme.border.withOpacity(0.5)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            suffixIcon: enabled
                ? IconButton(
                    icon: Icon(Icons.send_rounded, color: accentColor),
                    onPressed: onSend,
                  )
                : fieldState == _Field.correct
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppTheme.success)
                    : null,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tiny legend dot for sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
      width: 8, height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
