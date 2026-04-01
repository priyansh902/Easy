import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/j_char.dart';
import 'script.dart';

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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  _AnswerState _answerState = _AnswerState.idle;
  int _correct = 0;
  int _total = 0;
  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double> _shakeAnim;
  late Animation<double> _bounceAnim;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track which chars were practiced for sidebar highlight
  final Set<int> _practiced = {};
  final Set<int> _correctIndices = {};

  @override
  void initState() {
    super.initState();
    _shuffled = List.from(widget.chars)..shuffle(Random());
    _shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bounceCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
    _bounceAnim = Tween<double>(begin: 1, end: 1.12).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  JChar get _current => _shuffled[_index];

  void _submit() {
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    final correct = _current.romaji.toLowerCase();
    final isCorrect = input == correct;

    setState(() {
      _answerState = isCorrect ? _AnswerState.correct : _AnswerState.wrong;
      _total++;
      _practiced.add(_index);
      if (isCorrect) {
        _correct++;
        _correctIndices.add(_index);
      }
    });

    if (isCorrect) {
      HapticFeedback.lightImpact();
      _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
      Future.delayed(const Duration(milliseconds: 800), _nextCard);
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _nextCard() {
    if (!mounted) return;
    setState(() {
      _index = (_index + 1) % _shuffled.length;
      _controller.clear();
      _answerState = _AnswerState.idle;
    });
    _focusNode.requestFocus();
  }

  void _skip() {
    setState(() {
      _total++;
      _practiced.add(_index);
      _controller.clear();
      _answerState = _AnswerState.idle;
      _index = (_index + 1) % _shuffled.length;
    });
    _focusNode.requestFocus();
  }

  void _jumpToChar(int originalIndex) {
    // Find where this char is in the shuffled list
    final char = widget.chars[originalIndex];
    final shuffledIdx = _shuffled.indexWhere((c) => c.japanese == char.japanese);
    if (shuffledIdx == -1) return;
    Navigator.pop(context); // close drawer
    setState(() {
      _index = shuffledIdx;
      _controller.clear();
      _answerState = _AnswerState.idle;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKanji = widget.scriptType == ScriptType.kanji;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.offWhite,
      // End drawer = slides from the right
      endDrawer: _buildCharacterDrawer(),
      appBar: AppBar(
        title: const Text('Read & Type'),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        // Let Flutter handle the back button naturally
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
        actions: [
          // Score
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: Text(
                '$_correct / $_total',
                style: GoogleFonts.notoSans(
                  color: widget.accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          // Sidebar toggle
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 22),
            tooltip: 'All characters',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildProgress(),
                const SizedBox(height: 32),
                Expanded(child: _buildCard(isKanji)),
                const SizedBox(height: 24),
                _buildInput(),
                const SizedBox(height: 12),
                _buildSkipButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterDrawer() {
    final isKanji = widget.scriptType == ScriptType.kanji;
    return Drawer(
      width: 220,
      backgroundColor: AppTheme.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Characters',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.chars.length}',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      color: AppTheme.inkLight,
                    ),
                  ),
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
                  Text('Correct', style: GoogleFonts.notoSans(fontSize: 10, color: AppTheme.inkLight)),
                  const SizedBox(width: 12),
                  _LegendDot(color: AppTheme.red.withOpacity(0.5)),
                  const SizedBox(width: 4),
                  Text('Practiced', style: GoogleFonts.notoSans(fontSize: 10, color: AppTheme.inkLight)),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isKanji ? 3 : 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: isKanji ? 0.8 : 0.9,
                ),
                itemCount: widget.chars.length,
                itemBuilder: (context, i) {
                  final c = widget.chars[i];
                  final shuffledIdx = _shuffled.indexWhere((s) => s.japanese == c.japanese);
                  final isCurrent = shuffledIdx == _index;
                  final isCorrect = shuffledIdx != -1 && _correctIndices.contains(shuffledIdx);
                  final isPracticed = shuffledIdx != -1 && _practiced.contains(shuffledIdx) && !isCorrect;

                  Color bg = AppTheme.offWhite;
                  Color border = AppTheme.border;
                  if (isCurrent) { bg = widget.accentColor.withOpacity(0.1); border = widget.accentColor; }
                  else if (isCorrect) { bg = AppTheme.successLight; border = AppTheme.success.withOpacity(0.4); }
                  else if (isPracticed) { bg = AppTheme.redFaint; border = AppTheme.red.withOpacity(0.25); }

                  return GestureDetector(
                    onTap: () => _jumpToChar(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            c.japanese,
                            style: GoogleFonts.notoSans(
                              fontSize: isKanji ? 17 : 18,
                              color: isCurrent ? widget.accentColor : AppTheme.ink,
                              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          Text(
                            c.romaji,
                            style: GoogleFonts.notoSans(
                              fontSize: 8,
                              color: AppTheme.inkLight,
                            ),
                          ),
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

  Widget _buildProgress() {
    final progress = (_index + 1) / _shuffled.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Card ${_index + 1} of ${_shuffled.length}',
              style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: widget.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation(widget.accentColor),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(bool isKanji) {
    Color cardColor = AppTheme.white;
    if (_answerState == _AnswerState.correct) cardColor = AppTheme.successLight;
    if (_answerState == _AnswerState.wrong) cardColor = AppTheme.redFaint;

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnim, _bounceAnim]),
      builder: (context, child) {
        double dx = 0;
        if (_shakeCtrl.isAnimating) {
          dx = sin(_shakeAnim.value * pi * 8) * 10;
        }
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.scale(
            scale: _bounceCtrl.isAnimating ? _bounceAnim.value : 1.0,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _answerState == _AnswerState.correct
                ? AppTheme.success.withOpacity(0.4)
                : _answerState == _AnswerState.wrong
                    ? AppTheme.red.withOpacity(0.3)
                    : AppTheme.border,
            width: _answerState != _AnswerState.idle ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _current.japanese,
              style: GoogleFonts.notoSans(
                fontSize: isKanji ? 100 : 120,
                color: _answerState == _AnswerState.wrong
                    ? AppTheme.red
                    : widget.accentColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isKanji && _answerState != _AnswerState.idle) ...[
              const SizedBox(height: 8),
              Text(
                _current.meaning,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  color: _answerState == _AnswerState.correct
                      ? AppTheme.success
                      : AppTheme.inkLight,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_answerState == _AnswerState.correct)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.success, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Correct! → ${_current.romaji}',
                    style: GoogleFonts.notoSans(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else if (_answerState == _AnswerState.wrong)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.close, color: AppTheme.red, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Answer: ${_current.romaji}',
                    style: GoogleFonts.notoSans(
                      color: AppTheme.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              Text(
                isKanji ? 'What is the reading?' : 'Type the romaji',
                style: GoogleFonts.notoSans(
                  color: AppTheme.inkLight,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      enabled: _answerState == _AnswerState.idle,
      onSubmitted: (_) => _submit(),
      style: GoogleFonts.notoSans(
        fontSize: 20,
        color: AppTheme.ink,
        letterSpacing: 1.5,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'Type romaji here...',
        hintStyle: GoogleFonts.notoSans(color: AppTheme.inkLight),
        filled: true,
        fillColor: AppTheme.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: widget.accentColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(Icons.send_rounded, color: widget.accentColor),
          onPressed: _submit,
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_answerState == _AnswerState.wrong)
          TextButton.icon(
            onPressed: _nextCard,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.inkLight),
          )
        else
          TextButton(
            onPressed: _skip,
            child: Text(
              'Skip',
              style: GoogleFonts.notoSans(color: AppTheme.inkLight),
            ),
          ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

enum _AnswerState { idle, correct, wrong }
