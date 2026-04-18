import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/particles.dart';

class ParticlesScreen extends StatelessWidget {
  const ParticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: const Text('Particles'),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Japanese Particles',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 20, fontWeight: FontWeight.w700,
                            color: AppTheme.ink)),
                    const SizedBox(height: 4),
                    Text(
                        '${particleList.length} particles · 15 examples + 15 quiz questions each',
                        style: GoogleFonts.notoSansJp(
                            fontSize: 12, color: AppTheme.inkLight)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: AppTheme.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('${particleList.length}',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppTheme.red)),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: particleList.length,
              itemBuilder: (context, i) {
                final p = particleList[i];
                return _ParticleCard(particle: p);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Particle list card ────────────────────────────────────────────────────────
class _ParticleCard extends StatelessWidget {
  final Particle particle;
  const _ParticleCard({required this.particle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(color: AppTheme.red.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ParticleDetailScreen(particle: particle))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              // Big particle symbol
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                    color: AppTheme.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.red.withOpacity(0.2))),
                child: Center(
                  child: Text(particle.symbol,
                      style: AppTheme.kanjiStyle(
                          fontSize: particle.symbol.contains('・') ? 16 : 26,
                          color: AppTheme.red,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(particle.reading,
                          style: GoogleFonts.notoSansJp(
                              fontSize: 14, color: AppTheme.red,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                            color: AppTheme.offWhite,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: AppTheme.border)),
                        child: Text(particle.role,
                            style: GoogleFonts.notoSansJp(
                                fontSize: 10, color: AppTheme.inkLight,
                                fontWeight: FontWeight.w500)),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(particle.explanation,
                        style: GoogleFonts.notoSansJp(
                            fontSize: 11.5, color: AppTheme.inkLight,
                            height: 1.4),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      _MiniTag(label: '15 examples', icon: Icons.menu_book_rounded),
                      const SizedBox(width: 6),
                      _MiniTag(label: '15 quizzes', icon: Icons.edit_note_rounded),
                    ]),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.inkLight),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MiniTag({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
        color: AppTheme.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(6)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: AppTheme.red.withOpacity(0.7)),
      const SizedBox(width: 3),
      Text(label, style: GoogleFonts.notoSansJp(
          fontSize: 10, color: AppTheme.red.withOpacity(0.8),
          fontWeight: FontWeight.w500)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Particle Detail Screen — examples + quiz tabs
// ─────────────────────────────────────────────────────────────────────────────
class ParticleDetailScreen extends StatefulWidget {
  final Particle particle;
  const ParticleDetailScreen({super.key, required this.particle});
  @override
  State<ParticleDetailScreen> createState() => _ParticleDetailScreenState();
}

class _ParticleDetailScreenState extends State<ParticleDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final p = widget.particle;
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(p.symbol,
              style: AppTheme.kanjiStyle(
                  fontSize: p.symbol.contains('・') ? 14 : 20,
                  color: AppTheme.red, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text('(${p.reading})',
              style: GoogleFonts.notoSansJp(
                  fontSize: 15, color: AppTheme.ink,
                  fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppTheme.red,
          unselectedLabelColor: AppTheme.inkLight,
          indicatorColor: AppTheme.red,
          indicatorWeight: 2.5,
          labelStyle: GoogleFonts.notoSansJp(
              fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '📖  Learn'),
            Tab(text: '✏️  Quiz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _LearnTab(particle: p),
          _QuizTab(particle: p),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Learn Tab
// ─────────────────────────────────────────────────────────────────────────────
class _LearnTab extends StatelessWidget {
  final Particle particle;
  const _LearnTab({required this.particle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Explanation card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.red.withOpacity(0.15)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(particle.symbol,
                    style: AppTheme.kanjiStyle(
                        fontSize: particle.symbol.contains('・') ? 18 : 32,
                        color: AppTheme.red, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(particle.reading,
                        style: GoogleFonts.notoSansJp(
                            fontSize: 16, color: AppTheme.red,
                            fontWeight: FontWeight.w700)),
                    Text(particle.role,
                        style: GoogleFonts.notoSansJp(
                            fontSize: 12, color: AppTheme.inkLight)),
                  ],
                ),
              ]),
              const SizedBox(height: 12),
              Text(particle.explanation,
                  style: GoogleFonts.notoSansJp(
                      fontSize: 13.5, color: AppTheme.ink, height: 1.6)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.3))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(particle.tip,
                          style: GoogleFonts.notoSansJp(
                              fontSize: 12.5, color: AppTheme.ink,
                              fontStyle: FontStyle.italic, height: 1.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('15 Example Sentences',
            style: GoogleFonts.playfairDisplay(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink)),
        const SizedBox(height: 10),
        ...particle.examples.asMap().entries.map((e) {
          return _ExampleCard(
              number: e.key + 1, example: e.value, particle: particle.symbol);
        }),
      ],
    );
  }
}

class _ExampleCard extends StatefulWidget {
  final int number;
  final ParticleExample example;
  final String particle;
  const _ExampleCard({required this.number, required this.example,
      required this.particle});
  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard> {
  bool _showReading = false;

  @override
  Widget build(BuildContext context) {
    // Highlight the particle in the sentence
    final sentence = widget.example.japanese;
    final spans = _highlightParticle(sentence, widget.particle);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.1),
                shape: BoxShape.circle),
            child: Center(
              child: Text('${widget.number}',
                  style: GoogleFonts.notoSansJp(
                      fontSize: 11, color: AppTheme.red,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(children: spans)),
                const SizedBox(height: 4),
                if (_showReading)
                  Text(widget.example.reading,
                      style: GoogleFonts.notoSansJp(
                          fontSize: 11, color: AppTheme.inkLight)),
                const SizedBox(height: 4),
                Text(widget.example.english,
                    style: GoogleFonts.notoSansJp(
                        fontSize: 13, color: AppTheme.inkLight,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showReading = !_showReading),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  color: AppTheme.offWhite,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppTheme.border)),
              child: Text(_showReading ? 'Hide' : 'Reading',
                  style: GoogleFonts.notoSansJp(
                      fontSize: 9, color: AppTheme.inkLight)),
            ),
          ),
        ]),
      ]),
    );
  }

  List<TextSpan> _highlightParticle(String sentence, String particle) {
    // Handle combined particles like から・まで
    final parts = particle.split('・');
    final spans = <TextSpan>[];
    final baseStyle = TextStyle(
      fontFamily: 'NotoSansJP', fontSize: 16, color: AppTheme.ink,
      fontFamilyFallback: const ['NotoSansCJK', 'sans-serif'],
    );
    final highlightStyle = TextStyle(
      fontFamily: 'NotoSansJP', fontSize: 16,
      color: AppTheme.red, fontWeight: FontWeight.w700,
      fontFamilyFallback: const ['NotoSansCJK', 'sans-serif'],
    );

    String remaining = sentence;
    while (remaining.isNotEmpty) {
      int earliest = remaining.length;
      String? found;
      for (final p in parts) {
        final idx = remaining.indexOf(p);
        if (idx != -1 && idx < earliest) {
          earliest = idx;
          found = p;
        }
      }
      if (found == null) {
        spans.add(TextSpan(text: remaining, style: baseStyle));
        break;
      }
      if (earliest > 0) {
        spans.add(TextSpan(
            text: remaining.substring(0, earliest), style: baseStyle));
      }
      spans.add(TextSpan(text: found, style: highlightStyle));
      remaining = remaining.substring(earliest + found.length);
    }
    return spans;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quiz Tab
// ─────────────────────────────────────────────────────────────────────────────
class _QuizTab extends StatefulWidget {
  final Particle particle;
  const _QuizTab({required this.particle});
  @override
  State<_QuizTab> createState() => _QuizTabState();
}

enum _State { idle, correct, wrong }

class _QuizTabState extends State<_QuizTab> with TickerProviderStateMixin {
  late List<ParticleQuiz> _shuffled;
  int _index = 0;
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();

  
  _State _state = _State.idle;
  int _correct = 0;
  int _total   = 0;

  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double>   _shakeAnim;
  late Animation<double>   _bounceAnim;

  @override
  void initState() {
    super.initState();
    _shuffled = List.from(widget.particle.quizzes)..shuffle(Random());
    _shakeCtrl  = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 380));
    _bounceCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 300));
    _shakeAnim  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn));
    _bounceAnim = Tween(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _ctrl.dispose(); _focus.dispose();
    _shakeCtrl.dispose(); _bounceCtrl.dispose();
    super.dispose();
  }

  ParticleQuiz get _current => _shuffled[_index];

  bool _check(String input) {
    final typed = input.trim().toLowerCase();
    // Accept the particle or は reading 'wa' for は, etc.
    final ans = _current.answer;
    if (typed == ans) return true;
    // Accept romaji equivalents
    const romajiMap = {'は': 'wa', 'が': 'ga', 'を': 'wo', 'に': 'ni',
      'で': 'de', 'の': 'no', 'も': 'mo', 'と': 'to', 'や': 'ya',
      'から': 'kara', 'まで': 'made', 'へ': 'he'};
    return typed == romajiMap[ans] || typed == (romajiMap[ans] ?? '');
  }

  void _submit() {
    if (_state != _State.idle) return;
    final ok = _check(_ctrl.text);
    setState(() {
      _state = ok ? _State.correct : _State.wrong;
      _total++;
      if (ok) _correct++;
    });
    if (ok) {
      HapticFeedback.lightImpact();
      _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
      Future.delayed(const Duration(milliseconds: 900), _next);
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _next() {
    if (!mounted) return;
    setState(() {
      _index = (_index + 1) % _shuffled.length;
      _ctrl.clear();
      _state = _State.idle;
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_index + 1) / _shuffled.length;
    return GestureDetector(
      onTap: _focus.requestFocus,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Progress
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Q ${_index + 1} / ${_shuffled.length}',
                style: GoogleFonts.notoSansJp(
                    fontSize: 12, color: AppTheme.inkLight)),
            Text('$_correct / $_total ✓',
                style: GoogleFonts.notoSansJp(
                    fontSize: 12, color: AppTheme.red,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation(AppTheme.red),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 16),

          // Question card
          AnimatedBuilder(
            animation: Listenable.merge([_shakeAnim, _bounceAnim]),
            builder: (ctx, child) {
              final dx = _shakeCtrl.isAnimating
                  ? sin(_shakeAnim.value * pi * 8) * 10.0 : 0.0;
              final sc = _bounceCtrl.isAnimating ? _bounceAnim.value : 1.0;
              return Transform.translate(
                  offset: Offset(dx, 0),
                  child: Transform.scale(scale: sc, child: child));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _state == _State.correct
                    ? AppTheme.successLight
                    : _state == _State.wrong
                        ? AppTheme.redFaint
                        : AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _state == _State.correct
                      ? AppTheme.success.withOpacity(0.4)
                      : _state == _State.wrong
                          ? AppTheme.red.withOpacity(0.35)
                          : AppTheme.border,
                  width: _state != _State.idle ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(color: AppTheme.red.withOpacity(0.06),
                      blurRadius: 12, offset: const Offset(0, 4))
                ],
              ),
              child: Column(children: [
                // Instruction
                Text('Fill in the blank with the correct particle:',
                    style: GoogleFonts.notoSansJp(
                        fontSize: 12, color: AppTheme.inkLight)),
                const SizedBox(height: 14),
                // Question sentence with blank
                _buildQuestionText(_current.question),
                const SizedBox(height: 12),
                // English translation
                Text(_current.english,
                    style: GoogleFonts.notoSansJp(
                        fontSize: 13, color: AppTheme.inkLight,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 14),
                // Result feedback
                if (_state == _State.correct)
                  _Feedback(
                    icon: Icons.check_circle_rounded,
                    color: AppTheme.success,
                    text: 'Correct!  Answer: ${_current.answer}',
                    sub: _current.fullSentence,
                  )
                else if (_state == _State.wrong)
                  _Feedback(
                    icon: Icons.close,
                    color: AppTheme.red,
                    text: 'Correct answer: ${_current.answer}',
                    sub: _current.fullSentence,
                  )
                else
                  Text('Type the particle (hiragana or romaji)',
                      style: GoogleFonts.notoSansJp(
                          fontSize: 12, color: AppTheme.inkLight)),
              ]),
            ),
          ),
          const SizedBox(height: 14),

          // Input
          TextField(
            controller: _ctrl,
            focusNode: _focus,
            autofocus: true,
            enabled: _state == _State.idle,
            textCapitalization: TextCapitalization.none,
            onSubmitted: (_) => _submit(),
            style: GoogleFonts.notoSansJp(fontSize: 20, color: AppTheme.ink),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'は / が / を / に …',
              hintStyle: GoogleFonts.notoSansJp(
                  color: AppTheme.inkLight, fontSize: 14),
              filled: true,
              fillColor: _state == _State.correct
                  ? AppTheme.successLight
                  : _state == _State.wrong
                      ? AppTheme.redFaint
                      : AppTheme.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: _state == _State.correct
                          ? AppTheme.success.withOpacity(0.5)
                          : AppTheme.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppTheme.red, width: 2)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: _state == _State.correct
                          ? AppTheme.success.withOpacity(0.4)
                          : AppTheme.border.withOpacity(0.4))),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 14),
              suffixIcon: _state == _State.idle
                  ? IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppTheme.red),
                      onPressed: _submit)
                  : _state == _State.correct
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppTheme.success)
                      : null,
            ),
          ),
          const SizedBox(height: 10),
          // Next / Skip
          if (_state == _State.wrong)
            ElevatedButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.notoSansJp(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            )
          else if (_state == _State.idle)
            TextButton(
              onPressed: _next,
              child: Text('Skip',
                  style: GoogleFonts.notoSansJp(color: AppTheme.inkLight)),
            ),
        ]),
      ),
    );
  }

  Widget _buildQuestionText(String q) {
    // Replace ___ with styled blank
    final parts = q.split('___');
    if (parts.length == 1) {
      return Text(q, style: AppTheme.kanjiStyle(
          fontSize: 20, color: AppTheme.ink));
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(text: parts[0],
            style: TextStyle(
                fontFamily: 'NotoSansJP', fontSize: 20, color: AppTheme.ink,
                fontFamilyFallback: const ['NotoSansCJK', 'sans-serif'])),
        WidgetSpan(child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: _state == _State.correct
                ? AppTheme.success.withOpacity(0.15)
                : _state == _State.wrong
                    ? AppTheme.red.withOpacity(0.12)
                    : AppTheme.red.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _state == _State.correct
                  ? AppTheme.success.withOpacity(0.5)
                  : AppTheme.red.withOpacity(0.3),
            ),
          ),
          child: Text(
            _state == _State.correct
                ? _current.answer
                : _state == _State.wrong
                    ? _current.answer
                    : '  ?  ',
            style: GoogleFonts.notoSansJp(
                fontSize: 18,
                color: _state == _State.correct
                    ? AppTheme.success
                    : AppTheme.red,
                fontWeight: FontWeight.w700),
          ),
        )),
        if (parts.length > 1)
          TextSpan(text: parts.sublist(1).join(''),
              style: TextStyle(
                  fontFamily: 'NotoSansJP', fontSize: 20, color: AppTheme.ink,
                  fontFamilyFallback: const ['NotoSansCJK', 'sans-serif'])),
      ]),
    );
  }
}

class _Feedback extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String sub;
  const _Feedback({required this.icon, required this.color,
      required this.text, required this.sub});
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 6),
      Text(text, style: GoogleFonts.notoSansJp(
          color: color, fontWeight: FontWeight.w700, fontSize: 14)),
    ]),
    const SizedBox(height: 4),
    Text(sub, style: TextStyle(
        fontFamily: 'NotoSansJP', fontSize: 14,
        color: color.withOpacity(0.8),
        fontFamilyFallback: const ['NotoSansCJK', 'sans-serif'])),
  ]);
}
