import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/hiragana.dart';
import '../data/katakana.dart';
import '../data/kanji.dart';
import '../models/j_char.dart';
import 'script.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
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
                    const Spacer(),
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
              child: Text('日', style: GoogleFonts.notoSans(
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
              Text('Easy', style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              )),
              Text('Learn Japanese', style: GoogleFonts.notoSans(
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
            child: Text('N5', style: GoogleFonts.notoSans(
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
              style: GoogleFonts.notoSans(
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
                  child: Text(japanese[0], style: GoogleFonts.notoSans(
                    fontSize: 30,
                    color: color,
                    fontWeight: FontWeight.bold,
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
                    Text(japanese, style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: color.withOpacity(0.7),
                    )),
                    const SizedBox(height: 6),
                    Text(subtitle, style: GoogleFonts.notoSans(
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
