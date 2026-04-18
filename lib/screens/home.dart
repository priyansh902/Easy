
import 'package:essy/screens/particle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/hiragana.dart';
import '../data/katakana.dart';
import '../data/kanji.dart';
import '../models/j_char.dart';
import '../data/kanji_db.dart' show allKanji;
import 'script.dart';
import 'study_plan.dart';

import '../data/particles.dart' show particleList;
import '../services/progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ProgressStore.instance.addListener(_onProgress);
  }

  @override
  void dispose() {
    ProgressStore.instance.removeListener(_onProgress);
    super.dispose();
  }

  void _onProgress() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const _ReminderBanner(),
                      _ModeCard(
                        japanese: 'ひらがな',
                        label: 'Hiragana',
                        subtitle: '${hiraganaList.length} characters',
                        emoji: '🌸',
                        color: AppTheme.red,
                        chars: hiraganaList,
                        scriptType: ScriptType.hiragana,
                      ),
                      const SizedBox(height: 14),
                      _ModeCard(
                        japanese: 'カタカナ',
                        label: 'Katakana',
                        subtitle: '${katakanaList.length} characters',
                        emoji: '⚡',
                        color: const Color(0xFF1A1A2E),
                        chars: katakanaList,
                        scriptType: ScriptType.katakana,
                      ),
                      const SizedBox(height: 14),
                      _ModeCard(
                        japanese: '漢字',
                        label: 'Kanji',
                        subtitle: '${kanjiList.length} JLPT N5 characters',
                        emoji: '🏯',
                        color: const Color(0xFF6B3A2A),
                        chars: kanjiList,
                        scriptType: ScriptType.kanji,
                      ),
                      const SizedBox(height: 14),
                      const _ParticlesCard(),
                      const SizedBox(height: 14),  // Removed Spacer()
                      const _StudyPlanBanner(),
                      _buildFooter(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('日', style: GoogleFonts.notoSansJp(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                
              )),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Essy', style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              )),
              Text('Learn Japanese', style: GoogleFonts.notoSansJp(
                fontSize: 13,
                color: AppTheme.inkLight,
              )),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.redFaint,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.red.withOpacity(0.2)),
            ),
            child: Text('N5', style: GoogleFonts.notoSansJp(
              fontSize: 12,
              color: AppTheme.red,
              fontWeight: FontWeight.w600,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.redFaint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.red.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Each script has two modes: read in Japanese or write by connecting dots.',
              style: GoogleFonts.notoSansJp(
                fontSize: 12.5,
                color: AppTheme.inkLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String japanese;
  final String label;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<JChar> chars;
  final ScriptType scriptType;

  const _ModeCard({
    required this.japanese,
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.chars,
    required this.scriptType,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScriptScreen(
              chars: chars,
              scriptType: scriptType,
              color: color,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.15)),
                ),
                child: Center(
                  child: Text(japanese[0], style: GoogleFonts.notoSansJp(
                    fontSize: 30,
                    color: color,
                    fontWeight: FontWeight.bold,
                    // fontFamilyFallback: const ['NotoSansCJK','NotoSansJP','sans-serif'],
                  )),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('$emoji ', style: const TextStyle(fontSize: 16)),
                        Text(label, style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        )),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(japanese, style: GoogleFonts.notoSansJp(
                      fontSize: 13,
                      color: color.withOpacity(0.7),
                    )),
                    const SizedBox(height: 6),
                    Text(subtitle, style: GoogleFonts.notoSansJp(
                      fontSize: 12,
                      color: AppTheme.inkLight,
                    )),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.inkLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyPlanBanner extends StatefulWidget {
  const _StudyPlanBanner();
  @override
  State<_StudyPlanBanner> createState() => _StudyPlanBannerState();
}

class _StudyPlanBannerState extends State<_StudyPlanBanner> {
  int _mastered = 0;
  int _completed = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final store = ProgressStore.instance;
    setState(() {
      _mastered  = store.totalMasteredKanji;
      _completed = store.completedDays.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pct = allKanji.isNotEmpty ? _mastered / allKanji.length : 0.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudyPlanScreen()),
          );
          _loadStats(); // refresh on return
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF2D1B4E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A1A2E).withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('📚 ', style: TextStyle(fontSize: 16)),
                        Text(
                          'Kanji Study Plan',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 3),
                      Text(
                        _mastered > 0
                            ? '$_mastered / ${allKanji.length} mastered · $_completed days done'
                            : '${allKanji.length} kanji · RTK + JLPT · 10–100/day',
                        style: GoogleFonts.notoSansJp(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _mastered > 0 ? 'Continue →' : 'Start →',
                      style: GoogleFonts.notoSansJp(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (_mastered > 0) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.success),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(pct * 100).toStringAsFixed(1)}% of all kanji mastered',
                  style: GoogleFonts.notoSansJp(
                      fontSize: 10, color: Colors.white38),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticlesCard extends StatelessWidget {
  const _ParticlesCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParticlesScreen()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: AppTheme.red.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppTheme.red.withOpacity(0.18)),
                ),
                child: Center(
                  child: Text('は',
                      style: AppTheme.kanjiStyle(
                          fontSize: 24, color: AppTheme.red,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('✦ ', style: TextStyle(color: AppTheme.red, fontSize: 13)),
                      Text('Particles',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 17, fontWeight: FontWeight.w700,
                              color: AppTheme.ink)),
                    ]),
                    const SizedBox(height: 3),
                    Text(
                      '${particleList.length} particles · は が を に で の も と や から',
                      style: GoogleFonts.notoSansJp(
                          fontSize: 12, color: AppTheme.inkLight),
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      _Tag('15 examples each'),
                      const SizedBox(width: 6),
                      _Tag('15 quiz questions each'),
                    ]),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 15, color: AppTheme.inkLight),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
        color: AppTheme.red.withOpacity(0.07),
        borderRadius: BorderRadius.circular(5)),
    child: Text(label,
        style: GoogleFonts.notoSansJp(
            fontSize: 9.5, color: AppTheme.red.withOpacity(0.8),
            fontWeight: FontWeight.w500)),
  );
}


// ─────────────────────────────────────────────────────────────────────────────
// Reminder Banner — shown on home when user hasn't studied today
// ─────────────────────────────────────────────────────────────────────────────
class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner();

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 2) return '${diff.inDays} days ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'a little while ago';
  }

  String _streakEmoji(int streak) {
    if (streak >= 30) return '🔥🔥🔥';
    if (streak >= 14) return '🔥🔥';
    if (streak >= 7)  return '🔥';
    if (streak >= 3)  return '⚡';
    return '✨';
  }

  @override
  Widget build(BuildContext context) {
    final store   = ProgressStore.instance;
    final remind  = store.shouldRemind;
    final studied = store.studiedToday;
    final dayNum  = store.lastStudiedDayNum;
    final last    = store.lastStudiedDate;
    final streak  = store.streakDays;

    // Nothing to show if never studied
    if (dayNum == 0) return const SizedBox.shrink();

    if (studied) {
      // ── Already studied today — show a small congrats chip ──
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.success.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Text(_streakEmoji(streak),
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Great job! You studied today 🎉',
                    style: GoogleFonts.notoSansJp(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                  if (streak > 1)
                    Text(
                      '$streak-day streak — keep it up!',
                      style: GoogleFonts.notoSansJp(
                          fontSize: 11, color: AppTheme.success.withOpacity(0.75)),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (remind) {
      // ── Reminder — hasn't studied today ──
      final timeStr = last != null ? _timeAgo(last) : '';
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudyPlanScreen()),
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFBC002D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.red.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text('⏰', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time to study! 📖',
                      style: GoogleFonts.notoSansJp(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'You last studied Day $dayNum — $timeStr. Continue where you left off!',
                      style: GoogleFonts.notoSansJp(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    if (streak > 1) ...[
                      const SizedBox(height: 3),
                      Text(
                        '${_streakEmoji(streak)} $streak-day streak at risk!',
                        style: GoogleFonts.notoSansJp(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Resume →',
                  style: GoogleFonts.notoSansJp(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
