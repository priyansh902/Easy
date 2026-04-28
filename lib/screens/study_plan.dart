
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/kanji_db.dart';
import '../services/progress.dart';
import 'study_day.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  int _perDay = 25;
  final List<int> _paceOptions = [10, 25, 50, 100];
  late List<List<KanjiEntry>> _plan;
  
  Set<int> _completedDays = {};

  @override
  void initState() {
    super.initState();
    final store = ProgressStore.instance;
    _perDay = store.studyPace;
    _completedDays = store.completedDays;
    _plan = buildDayPlan(_perDay);
    

    ProgressStore.instance.addListener(_onProgressChanged);
  }

  @override
  void dispose() {
    ProgressStore.instance.removeListener(_onProgressChanged);
    super.dispose();
  }

  void _onProgressChanged() {
    if (mounted) {
      setState(() {
        _completedDays = ProgressStore.instance.completedDays;
      });
    }
  }

  void _setPace(int pace) {
    ProgressStore.instance.setStudyPace(pace);
    setState(() {
      _perDay = pace;
      _completedDays = ProgressStore.instance.completedDays;
      _plan = buildDayPlan(pace);
    });
  }

  // Reset progress with
  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset Progress?',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        content: Text(
            'This will clear all mastered kanji and completed days stored on this device. Nothing is sent anywhere.',
            style: GoogleFonts.notoSansJp(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.notoSansJp()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red, foregroundColor: Colors.white),
            child: Text('Reset', style: GoogleFonts.notoSansJp(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ProgressStore.instance.resetAll();
      setState(() {
        _completedDays = {};
        _perDay = 25;
        _plan = buildDayPlan(_perDay);
      });
    }
  }

  // JLPT level color
  Color _jlptColor(int level) {
    switch (level) {
      case 5: return const Color(0xFF2D8A4E);
      case 4: return const Color(0xFF1565C0);
      case 3: return const Color(0xFF6A1B9A);
      case 2: return const Color(0xFFE65100);
      case 1: return const Color(0xFFC62828);
      default: return const Color(0xFF37474F);
    }
  }

  // Dominant JLPT level for a day
  // If there's a tie, pick the harder level to encourage focus on more difficult kanji.
  int _dominantLevel(List<KanjiEntry> day) {
    final counts = <int, int>{};
    for (final k in day) {
      counts[k.jlpt] = (counts[k.jlpt] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String _levelLabel(int level) =>
      level == 0 ? 'Beyond JLPT' : 'JLPT N$level';

  // Progress stats
  int get _totalDays => _plan.length;
  int get _doneDays => _completedDays.length;
  int get _totalKanji => allKanji.length;
  int get _learnedKanji => ProgressStore.instance.totalMasteredKanji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: const Text('Study Plan'),
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
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded, size: 22),
            tooltip: 'Reset all progress',
            onPressed: _confirmReset,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildPacePicker(),
          _buildStats(),
          Expanded(child: _buildDayList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📚', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All-in-One Kanji + RTK',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                    Text(
                      '${allKanji.length} kanji · Heisig keywords · JLPT N5→N0',
                      style: GoogleFonts.notoSansJp(
                          fontSize: 12, color: AppTheme.inkLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPacePicker() {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 12),
          Text(
            'Kanji per day',
            style: GoogleFonts.notoSansJp(
              fontSize: 12,
              color: AppTheme.inkLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _paceOptions.map((pace) {
              final selected = pace == _perDay;
              final days = (allKanji.length + pace - 1) ~/ pace;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _setPace(pace),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.red
                          : AppTheme.offWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppTheme.red
                            : AppTheme.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$pace',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : AppTheme.ink,
                          ),
                        ),
                        Text(
                          '${days}d',
                          style: GoogleFonts.notoSansJp(
                            fontSize: 10,
                            color: selected
                                ? Colors.white70
                                : AppTheme.inkLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final pct =
        _totalKanji > 0 ? _learnedKanji / _totalKanji : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatChip(
                  label: 'Learned',
                  value: '$_learnedKanji',
                  color: AppTheme.success),
              const SizedBox(width: 10),
              _StatChip(
                  label: 'Remaining',
                  value: '${_totalKanji - _learnedKanji}',
                  color: AppTheme.inkLight),
              const SizedBox(width: 10),
              _StatChip(
                  label: 'Days done',
                  value: '$_doneDays / $_totalDays',
                  color: AppTheme.red),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppTheme.border,
              valueColor:
                  const AlwaysStoppedAnimation(AppTheme.success),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(pct * 100).toStringAsFixed(1)}% complete',
            style: GoogleFonts.notoSansJp(
                fontSize: 11, color: AppTheme.inkLight),
          ),
        ],
      ),
    );
  }

  Widget _buildDayList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _plan.length,
      itemBuilder: (context, idx) {
        final day = _plan[idx];
        final dayNum = idx + 1;
        final level = _dominantLevel(day);
        final color = _jlptColor(level);
        final isDone = _completedDays.contains(dayNum);

        // Preview: first 5 kanji
        final preview = day.take(5).map((k) => k.k).join('  ');

        // Category summary
        final catMap = <String, int>{};
        for (final k in day) {
          final c = k.cat.split('_')[0].trim();
          catMap[c] = (catMap[c] ?? 0) + 1;
        }
        final topCats = (catMap.entries.toList()
              ..sort((a, b) => b.value - a.value))
            .take(2)
            .map((e) => e.key)
            .join(', ');

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                final completed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudyDayScreen(
                      dayNumber: dayNum,
                      kanji: day,
                      accentColor: color,
                      isCompleted: isDone,
                    ),
                  ),
                );
                if (completed != null) {
                  await ProgressStore.instance.setDayComplete(dayNum, completed);
                  if (completed) {
                    await ProgressStore.instance.recordStudySession(dayNum);
                  }
                  setState(() {
                    _completedDays = ProgressStore.instance.completedDays;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.successLight
                      : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDone
                        ? AppTheme.success.withOpacity(0.35)
                        : AppTheme.border,
                  ),
                ),
                child: Row(
                  children: [
                    // Day number badge
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.success
                            : color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 22)
                          : Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$dayNum',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                                Text(
                                  'day',
                                  style: GoogleFonts.notoSansJp(
                                    fontSize: 8,
                                    color: color.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  _levelLabel(level),
                                  style: GoogleFonts.notoSansJp(
                                    fontSize: 10,
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${day.length} kanji',
                                style: GoogleFonts.notoSansJp(
                                  fontSize: 11,
                                  color: AppTheme.inkLight,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                categoryIcon(topCats.toLowerCase()),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preview,
                            style: AppTheme.kanjiStyle(
                              fontSize: 18,
                              color: isDone
                                  ? AppTheme.success
                                  : AppTheme.ink,
                              fontWeight: FontWeight.w500,
                            ).copyWith(height: 1.2),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            topCats,
                            style: GoogleFonts.notoSansJp(
                              fontSize: 11,
                              color: AppTheme.inkLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppTheme.inkLight),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color)),
            Text(label,
                style: GoogleFonts.notoSansJp(
                    fontSize: 10, color: AppTheme.inkLight)),
          ],
        ),
      ),
    );
  }
}
