import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/j_char.dart';
import 'quiz_screen.dart';
import 'connect_dot.dart';

enum ScriptType { hiragana, katakana, kanji }

class ScriptScreen extends StatelessWidget {
  final List<JChar> chars;
  final ScriptType scriptType;
  final Color color;

  const ScriptScreen({
    super.key,
    required this.chars,
    required this.scriptType,
    required this.color,
  });

  String get title {
    switch (scriptType) {
      case ScriptType.hiragana:
        return 'Hiragana';
      case ScriptType.katakana:
        return 'Katakana';
      case ScriptType.kanji:
        return 'Kanji';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Choose a Mode',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'How do you want to practice today?',
                style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.inkLight),
              ),
              const SizedBox(height: 28),
              _ModeOptionCard(
                icon: '🔤',
                title: 'Read & Type',
                subtitle: 'Japanese → English',
                description: 'See a Japanese character, type its romaji reading.',
                color: color,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      chars: chars,
                      scriptType: scriptType,
                      accentColor: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ModeOptionCard(
                icon: '✏️',
                title: 'Connect & Draw',
                subtitle: 'English → Japanese',
                description:
                    'See the English hint, drag to connect the dots and build the character.',
                color: color,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConnectDotsScreen(
                      chars: chars,
                      scriptType: scriptType,
                      accentColor: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _buildCharacterGrid(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGrid() {
    final isKanji = scriptType == ScriptType.kanji;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Text(
                'Characters in this set',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.inkLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${chars.length} total',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isKanji ? 4 : 6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: isKanji ? 0.85 : 0.90,
            ),
            itemCount: chars.length,
            itemBuilder: (context, i) {
              final c = chars[i];
              return Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      c.japanese,
                      style: GoogleFonts.notoSans(
                        fontSize: isKanji ? 28 : 30,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c.romaji,
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        color: AppTheme.inkLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isKanji && c.meaning.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          c.meaning,
                          style: GoogleFonts.notoSans(
                            fontSize: 8.5,
                            color: AppTheme.inkLight.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ModeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 8,
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
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.notoSans(
                        fontSize: 12.5,
                        color: AppTheme.inkLight,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 15, color: AppTheme.inkLight),
            ],
          ),
        ),
      ),
    );
  }
}
