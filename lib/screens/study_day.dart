
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../theme.dart';
// import '../data/kanji_db.dart';

// // ─── View modes ───────────────────────────────────────────────────────────────
// enum _ViewMode { grid, flashcard, quiz }

// // ─── Quiz answer state ────────────────────────────────────────────────────────
// enum _AnswerState { idle, correct, wrong }

// class StudyDayScreen extends StatefulWidget {
//   final int dayNumber;
//   final List<KanjiEntry> kanji;
//   final Color accentColor;
//   final bool isCompleted;

//   const StudyDayScreen({
//     super.key,
//     required this.dayNumber,
//     required this.kanji,
//     required this.accentColor,
//     required this.isCompleted,
//   });

//   @override
//   State<StudyDayScreen> createState() => _StudyDayScreenState();
// }

// class _StudyDayScreenState extends State<StudyDayScreen>
//     with TickerProviderStateMixin {
//   // ── shared ──────────────────────────────────────────────────
//   _ViewMode _mode      = _ViewMode.grid;
//   int       _cardIndex = 0;
//   final Set<int> _mastered = {};
//   String _filter = 'all';

//   // ── flashcard ────────────────────────────────────────────────
//   bool _flipped = false;

//   // ── quiz ──────────────────────────────────────────────────────
//   final TextEditingController _romajiCtrl  = TextEditingController();
//   final TextEditingController _englishCtrl = TextEditingController();
//   final FocusNode             _romajiFocus  = FocusNode();
//   final FocusNode             _englishFocus = FocusNode();

//   _AnswerState _romajiAns  = _AnswerState.idle;
//   _AnswerState _englishAns = _AnswerState.idle;
//   bool _quizSubmitted = false;   // both answers checked
//   bool _romajiPassed  = false;   // romaji step done correctly

//   int _quizCorrect = 0;
//   int _quizTotal   = 0;

//   // animations
//   late AnimationController _shakeCtrl;
//   late AnimationController _bounceCtrl;
//   late AnimationController _slideCtrl;
//   late Animation<double>   _shakeAnim;
//   late Animation<double>   _bounceAnim;
//   late Animation<double>   _slideAnim;

//   @override
//   void initState() {
//     super.initState();
//     _shakeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
//     _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
//     _slideCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
//     _shakeAnim  = Tween(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(parent: _shakeCtrl,  curve: Curves.elasticIn));
//     _bounceAnim = Tween(begin: 1.0, end: 1.08)
//         .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
//     _slideAnim  = Tween(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(parent: _slideCtrl,  curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _romajiCtrl.dispose();
//     _englishCtrl.dispose();
//     _romajiFocus.dispose();
//     _englishFocus.dispose();
//     _shakeCtrl.dispose();
//     _bounceCtrl.dispose();
//     _slideCtrl.dispose();
//     super.dispose();
//   }

//   // ── helpers ──────────────────────────────────────────────────
//   KanjiEntry get _current => widget.kanji[_cardIndex];

//   String get _jlptLabel {
//     final levels = widget.kanji.map((k) => k.jlpt).toSet().toList()..sort();
//     if (levels.length == 1) {
//       final l = levels[0];
//       return l == 0 ? 'Beyond JLPT' : 'JLPT N$l';
//     }
//     return levels.map((l) => l == 0 ? 'N0' : 'N$l').join(' · ');
//   }

//   List<KanjiEntry> get _filteredKanji {
//     switch (_filter) {
//       case 'mastered':
//         return [for (int i = 0; i < widget.kanji.length; i++)
//           if (_mastered.contains(i)) widget.kanji[i]];
//       case 'remaining':
//         return [for (int i = 0; i < widget.kanji.length; i++)
//           if (!_mastered.contains(i)) widget.kanji[i]];
//       default: return widget.kanji;
//     }
//   }

//   void _toggleMastered(int idx) {
//     setState(() {
//       if (_mastered.contains(idx)) {
//         _mastered.remove(idx);
//       } else { _mastered.add(idx); HapticFeedback.lightImpact(); }
//     });
//   }

//   // ── mode switching ────────────────────────────────────────────
//   void _setMode(_ViewMode m) {
//     setState(() {
//       _mode      = m;
//       _cardIndex = 0;
//       _flipped   = false;
//       _resetQuiz();
//     });
//     if (m == _ViewMode.quiz) {
//       Future.delayed(const Duration(milliseconds: 150), _romajiFocus.requestFocus);
//     }
//   }

//   // ── quiz logic ────────────────────────────────────────────────
//   void _resetQuiz() {
//     _romajiCtrl.clear();
//     _englishCtrl.clear();
//     _romajiAns    = _AnswerState.idle;
//     _englishAns   = _AnswerState.idle;
//     _quizSubmitted = false;
//     _romajiPassed  = false;
//     _slideCtrl.reset();
//   }

//   bool _checkRomaji(String input) {
//     final typed = input.trim().toLowerCase();
//     if (typed.isEmpty) return false;
//     return _current.on
//         .toLowerCase()
//         .split(RegExp(r'[、,/\s]+'))
//         .map((s) => s.replaceAll(RegExp(r'[^a-z]'), '').trim())
//         .followedBy(
//           _current.kun
//               .toLowerCase()
//               .split(RegExp(r'[、,/\s]+'))
//               .map((s) => s.replaceAll(RegExp(r'[^a-z]'), '').trim()),
//         )
//         .followedBy([_current.rom.split('/')[0].trim().toLowerCase()])
//         .where((s) => s.isNotEmpty)
//         .any((a) => a == typed || (typed.length >= 3 && (a.startsWith(typed) || typed.startsWith(a))));
//   }

//   bool _checkEnglish(String input) {
//     final typed = input.trim().toLowerCase();
//     if (typed.isEmpty) return false;
//     final answers = _current.en
//         .toLowerCase()
//         .split(RegExp(r'[,;/]'))
//         .map((s) => s.trim())
//         .where((s) => s.isNotEmpty)
//         .toList();
//     return answers.any((a) =>
//         a == typed ||
//         (typed.length >= 3 && (a.startsWith(typed) || typed.startsWith(a))));
//   }

//   void _submitRomaji() {
//     if (_romajiPassed || _quizSubmitted) return;
//     final ok = _checkRomaji(_romajiCtrl.text);
//     setState(() => _romajiAns = ok ? _AnswerState.correct : _AnswerState.wrong);
//     if (ok) {
//       HapticFeedback.selectionClick();
//       setState(() => _romajiPassed = true);
//       _slideCtrl.forward();
//       Future.delayed(const Duration(milliseconds: 220), () {
//         if (mounted) _englishFocus.requestFocus();
//       });
//     } else {
//       HapticFeedback.heavyImpact();
//       _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
//     }
//   }

//   void _submitEnglish() {
//     if (!_romajiPassed || _quizSubmitted) return;
//     final ok = _checkEnglish(_englishCtrl.text);
//     final bothOk = _romajiAns == _AnswerState.correct && ok;
//     setState(() {
//       _englishAns   = ok ? _AnswerState.correct : _AnswerState.wrong;
//       _quizSubmitted = true;
//       _quizTotal++;
//       if (bothOk) {
//         _quizCorrect++;
//         _mastered.add(_cardIndex);
//       }
//     });
//     if (bothOk) {
//       HapticFeedback.lightImpact();
//       _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
//       Future.delayed(const Duration(milliseconds: 950), _quizNext);
//     } else {
//       HapticFeedback.heavyImpact();
//       _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
//     }
//   }

//   void _quizNext() {
//     if (!mounted) return;
//     setState(() {
//       _cardIndex = (_cardIndex + 1) % widget.kanji.length;
//       _resetQuiz();
//     });
//     Future.delayed(const Duration(milliseconds: 100), _romajiFocus.requestFocus);
//   }

//   void _quizSkip() {
//     setState(() { _quizTotal++; });
//     _quizNext();
//   }

//   // ── flashcard helpers ─────────────────────────────────────────
//   void _nextCard() {
//     setState(() {
//       _flipped   = false;
//       _cardIndex = (_cardIndex + 1) % widget.kanji.length;
//     });
//   }

//   void _prevCard() {
//     setState(() {
//       _flipped   = false;
//       _cardIndex = (_cardIndex - 1 + widget.kanji.length) % widget.kanji.length;
//     });
//   }

//   // ─────────────────────────────────────────────────────────────
//   // BUILD
//   // ─────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.offWhite,
//       appBar: AppBar(
//         title: Text('Day ${widget.dayNumber}'),
//         backgroundColor: AppTheme.white,
//         foregroundColor: AppTheme.ink,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//           onPressed: () =>
//               Navigator.of(context).pop(_mastered.length == widget.kanji.length),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(height: 1, color: AppTheme.border),
//         ),
//         actions: [
//           // Quiz score shown only in quiz mode
//           if (_mode == _ViewMode.quiz)
//             Padding(
//               padding: const EdgeInsets.only(right: 4),
//               child: Center(
//                 child: Text('$_quizCorrect/$_quizTotal',
//                     style: GoogleFonts.notoSans(
//                         color: widget.accentColor,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14)),
//               ),
//             ),
//           // Mode toggle button
//           _ModeToggle(
//             current: _mode,
//             accentColor: widget.accentColor,
//             onSelect: _setMode,
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () {
//           if (_mode == _ViewMode.quiz) {
//             if (!_romajiPassed) {
//               _romajiFocus.requestFocus();
//             } else {
//               _englishFocus.requestFocus();
//             }
//           }
//         },
//         child: Column(
//           children: [
//             _buildHeader(),
//             Expanded(child: _buildBody()),
//             _buildBottomBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── header (progress bar) ─────────────────────────────────────
//   Widget _buildHeader() {
//     final mastered = _mastered.length;
//     final total    = widget.kanji.length;
//     final pct      = total > 0 ? mastered / total : 0.0;
//     return Container(
//       color: AppTheme.white,
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           _Pill(text: _jlptLabel, color: widget.accentColor, bold: true),
//           const SizedBox(width: 8),
//           Text('$mastered / $total mastered',
//               style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight)),
//           const Spacer(),
//           if (mastered == total && total > 0)
//             Row(children: [
//               const Icon(Icons.check_circle, color: AppTheme.success, size: 15),
//               const SizedBox(width: 4),
//               Text('All done!',
//                   style: GoogleFonts.notoSans(
//                       fontSize: 12, color: AppTheme.success,
//                       fontWeight: FontWeight.w600)),
//             ]),
//         ]),
//         const SizedBox(height: 8),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: pct,
//             backgroundColor: AppTheme.border,
//             valueColor: AlwaysStoppedAnimation(widget.accentColor),
//             minHeight: 5,
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _buildBody() {
//     switch (_mode) {
//       case _ViewMode.grid:      return _buildGrid();
//       case _ViewMode.flashcard: return _buildFlashcard();
//       case _ViewMode.quiz:      return _buildQuiz();
//     }
//   }

//   // ─────────────────────────────────────────────────────────────
//   // GRID
//   // ─────────────────────────────────────────────────────────────
//   Widget _buildGrid() {
//     return Column(children: [
//       // filter tabs
//       Container(
//         color: AppTheme.white,
//         padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//         child: Row(
//           children: ['all', 'remaining', 'mastered'].map((f) {
//             final active = _filter == f;
//             return GestureDetector(
//               onTap: () => setState(() => _filter = f),
//               child: Container(
//                 margin: const EdgeInsets.only(right: 8),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 decoration: BoxDecoration(
//                   color: active ? widget.accentColor : AppTheme.offWhite,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                       color: active ? widget.accentColor : AppTheme.border),
//                 ),
//                 child: Text(f[0].toUpperCase() + f.substring(1),
//                     style: GoogleFonts.notoSans(
//                         fontSize: 12,
//                         color: active ? Colors.white : AppTheme.inkLight,
//                         fontWeight: FontWeight.w600)),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//       Expanded(
//         child: GridView.builder(
//           padding: const EdgeInsets.all(10),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             childAspectRatio: 0.72,
//           ),
//           itemCount: _filteredKanji.length,
//           itemBuilder: (context, i) {
//             final k = _filteredKanji[i];
//             final globalIdx = widget.kanji.indexOf(k);
//             final isMastered = _mastered.contains(globalIdx);
//             return GestureDetector(
//               onTap: () => _showKanjiDetail(k, globalIdx),
//               onLongPress: () => _toggleMastered(globalIdx),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                   color: isMastered ? AppTheme.successLight : AppTheme.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isMastered
//                         ? AppTheme.success.withOpacity(0.4)
//                         : AppTheme.border,
//                     width: isMastered ? 1.5 : 1,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
//                   child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Stack(alignment: Alignment.topRight, children: [
//                         Center(
//                           child: Text(k.k,
//                               style: AppTheme.kanjiStyle(
//                                   fontSize: 36,
//                                   color: isMastered
//                                       ? AppTheme.success
//                                       : widget.accentColor,
//                                   fontWeight: FontWeight.w400)),
//                         ),
//                         if (isMastered)
//                           const Icon(Icons.check_circle,
//                               size: 14, color: AppTheme.success),
//                       ]),
//                       const SizedBox(height: 3),
//                       if (k.ja.isNotEmpty)
//                         Text(k.ja.split('・')[0],
//                             style: GoogleFonts.notoSans(
//                                 fontSize: 11,
//                                 color: isMastered
//                                     ? AppTheme.success.withOpacity(0.8)
//                                     : widget.accentColor.withOpacity(0.75),
//                                 fontWeight: FontWeight.w500)),
//                       const SizedBox(height: 2),
//                       if (k.rom.isNotEmpty)
//                         Text(k.rom.split('/')[0].trim(),
//                             style: GoogleFonts.notoSans(
//                                 fontSize: 9, color: AppTheme.inkLight)),
//                       Text(k.en.split(',')[0].trim(),
//                           style: GoogleFonts.notoSans(
//                               fontSize: 9,
//                               color: AppTheme.inkLight,
//                               fontWeight: FontWeight.w500),
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       if (k.frame != null)
//                         Text('#${k.frame}',
//                             style: GoogleFonts.notoSans(
//                                 fontSize: 7.5,
//                                 color: widget.accentColor.withOpacity(0.4))),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ]);
//   }

//   void _showKanjiDetail(KanjiEntry k, int idx) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => _KanjiDetailSheet(
//         k: k,
//         isMastered: _mastered.contains(idx),
//         accentColor: widget.accentColor,
//         onToggle: () { _toggleMastered(idx); Navigator.pop(context); },
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────────────────────
//   // FLASHCARD
//   // ─────────────────────────────────────────────────────────────
//   Widget _buildFlashcard() {
//     final k = widget.kanji[_cardIndex];
//     final isMastered = _mastered.contains(_cardIndex);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
//       child: Column(children: [
//         Text('Card ${_cardIndex + 1} of ${widget.kanji.length}',
//             style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight)),
//         const SizedBox(height: 12),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _flipped = !_flipped),
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 320),
//               transitionBuilder: (child, anim) =>
//                   ScaleTransition(scale: anim, child: child),
//               child: _flipped
//                   ? _CardBack(key: const ValueKey('back'), k: k,
//                       accentColor: widget.accentColor, isMastered: isMastered)
//                   : _CardFront(key: const ValueKey('front'), k: k,
//                       accentColor: widget.accentColor),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(children: [
//           IconButton(
//             onPressed: _prevCard,
//             icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//             style: IconButton.styleFrom(
//                 backgroundColor: AppTheme.white,
//                 foregroundColor: AppTheme.ink,
//                 side: const BorderSide(color: AppTheme.border)),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () { _toggleMastered(_cardIndex); _nextCard(); },
//               icon: Icon(isMastered ? Icons.close : Icons.check, size: 18),
//               label: Text(isMastered ? 'Unmark' : 'Got it!'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isMastered ? AppTheme.inkLight : AppTheme.success,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 13),
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 textStyle: GoogleFonts.notoSans(
//                     fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           IconButton(
//             onPressed: _nextCard,
//             icon: const Icon(Icons.arrow_forward_ios, size: 18),
//             style: IconButton.styleFrom(
//                 backgroundColor: AppTheme.white,
//                 foregroundColor: AppTheme.ink,
//                 side: const BorderSide(color: AppTheme.border)),
//           ),
//         ]),
//         const SizedBox(height: 6),
//         Text('Tap card to flip  ·  Long-press grid cells to mark mastered',
//             style: GoogleFonts.notoSans(fontSize: 9.5, color: AppTheme.inkLight)),
//       ]),
//     );
//   }

//   // ─────────────────────────────────────────────────────────────
//   // QUIZ MODE
//   // ─────────────────────────────────────────────────────────────
//   Widget _buildQuiz() {
//     final k = _current;
//     // overall card result colour
//     Color cardBg = AppTheme.white;
//     Color cardBorder = AppTheme.border;
//     double cardBorderW = 1;
//     if (_quizSubmitted) {
//       final allOk = _romajiAns == _AnswerState.correct &&
//           _englishAns == _AnswerState.correct;
//       cardBg     = allOk ? AppTheme.successLight : AppTheme.redFaint;
//       cardBorder = allOk
//           ? AppTheme.success.withOpacity(0.4)
//           : AppTheme.red.withOpacity(0.35);
//       cardBorderW = 2;
//     }

//     return AnimatedBuilder(
//       animation: Listenable.merge([_shakeAnim, _bounceAnim]),
//       builder: (ctx, child) {
//         final dx = _shakeCtrl.isAnimating
//             ? sin(_shakeAnim.value * pi * 8) * 10.0
//             : 0.0;
//         final sc = _bounceCtrl.isAnimating ? _bounceAnim.value : 1.0;
//         return Transform.translate(
//             offset: Offset(dx, 0),
//             child: Transform.scale(scale: sc, child: child));
//       },
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//         child: Column(children: [

//           // ── Card counter ──────────────────────────────────────
//           Text('Card ${_cardIndex + 1} of ${widget.kanji.length}',
//               style: GoogleFonts.notoSans(
//                   fontSize: 12, color: AppTheme.inkLight)),
//           const SizedBox(height: 12),

//           // ── Kanji display card ────────────────────────────────
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 240),
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
//             decoration: BoxDecoration(
//               color: cardBg,
//               borderRadius: BorderRadius.circular(22),
//               border: Border.all(color: cardBorder, width: cardBorderW),
//               boxShadow: [
//                 BoxShadow(
//                     color: widget.accentColor.withOpacity(0.07),
//                     blurRadius: 16,
//                     offset: const Offset(0, 5))
//               ],
//             ),
//             child: Column(children: [
//               // Big kanji
//               Text(k.k,
//                   style: AppTheme.kanjiStyle(
//                       fontSize: 96,
//                       color: _quizSubmitted && _englishAns == _AnswerState.wrong
//                           ? AppTheme.red
//                           : widget.accentColor,
//                       fontWeight: FontWeight.w400)),
//               const SizedBox(height: 8),

//               // RTK frame
//               if (k.frame != null)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                   decoration: BoxDecoration(
//                       color: widget.accentColor.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Text('RTK #${k.frame}',
//                       style: GoogleFonts.notoSans(
//                           fontSize: 11, color: widget.accentColor)),
//                 ),
//               const SizedBox(height: 10),

//               // Step dots
//               _buildStepDots(),
//               const SizedBox(height: 10),

//               // Feedback / instruction text
//               _buildQuizHint(k),
//             ]),
//           ),
//           const SizedBox(height: 16),

//           // ── Input 1: Romaji ───────────────────────────────────
//           _QuizField(
//             controller: _romajiCtrl,
//             focusNode: _romajiFocus,
//             stepNum: '1',
//             label: 'Romaji',
//             hint: 'e.g.  nichi  /  hi',
//             state: _romajiAns,
//             enabled: !_romajiPassed,
//             accentColor: widget.accentColor,
//             onSubmit: _submitRomaji,
//           ),
//           const SizedBox(height: 10),

//           // ── Input 2: English — slides in ─────────────────────
//           AnimatedBuilder(
//             animation: _slideAnim,
//             builder: (ctx, child) => ClipRect(
//               child: Align(
//                 heightFactor: _slideAnim.value,
//                 child: Opacity(opacity: _slideAnim.value, child: child),
//               ),
//             ),
//             child: _QuizField(
//               controller: _englishCtrl,
//               focusNode: _englishFocus,
//               stepNum: '2',
//               label: 'English meaning',
//               hint: 'e.g.  day  /  sun',
//               state: _englishAns,
//               enabled: _romajiPassed && !_quizSubmitted,
//               accentColor: widget.accentColor,
//               onSubmit: _submitEnglish,
//             ),
//           ),
//           const SizedBox(height: 14),

//           // ── Action row ────────────────────────────────────────
//           _buildQuizActions(),
//           const SizedBox(height: 8),
//         ]),
//       ),
//     );
//   }

//   Widget _buildStepDots() {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       _StepDot(
//           label: 'Romaji',
//           state: _romajiAns,
//           active: !_romajiPassed,
//           accentColor: widget.accentColor),
//       Container(
//           width: 32, height: 2,
//           margin: const EdgeInsets.symmetric(horizontal: 6),
//           color: _romajiPassed
//               ? widget.accentColor.withOpacity(0.5)
//               : AppTheme.border),
//       _StepDot(
//           label: 'English',
//           state: _englishAns,
//           active: _romajiPassed && !_quizSubmitted,
//           accentColor: widget.accentColor),
//     ]);
//   }

//   Widget _buildQuizHint(KanjiEntry k) {
//     // Not started
//     if (_romajiAns == _AnswerState.idle) {
//       return Text('Type the romaji reading',
//           style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.inkLight));
//     }
//     // Romaji wrong
//     if (_romajiAns == _AnswerState.wrong && !_romajiPassed) {
//       return Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Icon(Icons.close, color: AppTheme.red, size: 16),
//           const SizedBox(width: 4),
//           Text('Correct romaji: ${k.rom}',
//               style: GoogleFonts.notoSans(
//                   fontSize: 13, color: AppTheme.red,
//                   fontWeight: FontWeight.w600)),
//         ]),
//         const SizedBox(height: 4),
//         Text('Try again ↑ or skip',
//             style: GoogleFonts.notoSans(
//                 fontSize: 11, color: AppTheme.inkLight)),
//       ]);
//     }
//     // Romaji correct, waiting English
//     if (_romajiPassed && _englishAns == _AnswerState.idle) {
//       return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
//         const SizedBox(width: 5),
//         Text('${k.rom.split('/')[0].trim()}  ✓   Now type the English',
//             style: GoogleFonts.notoSans(
//                 fontSize: 13, color: AppTheme.success,
//                 fontWeight: FontWeight.w500)),
//       ]);
//     }
//     // Both correct
//     if (_romajiAns == _AnswerState.correct &&
//         _englishAns == _AnswerState.correct) {
//       return Column(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Icon(Icons.check_circle_rounded,
//               color: AppTheme.success, size: 22),
//           const SizedBox(width: 6),
//           Text('Perfect!',
//               style: GoogleFonts.playfairDisplay(
//                   color: AppTheme.success,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20)),
//         ]),
//         const SizedBox(height: 4),
//         Text('${k.rom.split('/')[0].trim()}  ·  ${k.en.split(',')[0].trim()}',
//             style: GoogleFonts.notoSans(
//                 fontSize: 12, color: AppTheme.success.withOpacity(0.8))),
//       ]);
//     }
//     // English wrong
//     if (_englishAns == _AnswerState.wrong) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//             color: AppTheme.redFaint,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: AppTheme.red.withOpacity(0.2))),
//         child: Column(children: [
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Icon(Icons.close, color: AppTheme.red, size: 16),
//             const SizedBox(width: 4),
//             Text('Not quite!',
//                 style: GoogleFonts.notoSans(
//                     color: AppTheme.red,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 13)),
//           ]),
//           const SizedBox(height: 4),
//           Text('Romaji: ${k.rom.split('/')[0].trim()}',
//               style: GoogleFonts.notoSans(
//                   fontSize: 12, color: AppTheme.inkLight)),
//           Text('English: ${k.en.split(',').take(3).join(', ')}',
//               style: GoogleFonts.notoSans(
//                   fontSize: 13, color: AppTheme.red,
//                   fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center),
//         ]),
//       );
//     }
//     return const SizedBox();
//   }

//   Widget _buildQuizActions() {
//     // After both submitted — wrong english
//     if (_quizSubmitted && _englishAns == _AnswerState.wrong) {
//       return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         ElevatedButton.icon(
//           onPressed: _quizNext,
//           icon: const Icon(Icons.arrow_forward_rounded, size: 18),
//           label: const Text('Next card'),
//           style: ElevatedButton.styleFrom(
//               backgroundColor: widget.accentColor,
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               textStyle: GoogleFonts.notoSans(
//                   fontSize: 14, fontWeight: FontWeight.w600)),
//         ),
//       ]);
//     }
//     // Romaji wrong — retry or skip
//     if (_romajiAns == _AnswerState.wrong && !_romajiPassed) {
//       return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         TextButton(
//           onPressed: () {
//             setState(() {
//               _romajiAns = _AnswerState.idle;
//               _romajiCtrl.clear();
//             });
//             _romajiFocus.requestFocus();
//           },
//           child: Text('Retry',
//               style: GoogleFonts.notoSans(
//                   color: widget.accentColor,
//                   fontWeight: FontWeight.w600)),
//         ),
//         const SizedBox(width: 20),
//         TextButton(
//           onPressed: _quizSkip,
//           child: Text('Skip',
//               style: GoogleFonts.notoSans(color: AppTheme.inkLight)),
//         ),
//       ]);
//     }
//     // Default — Skip
//     return TextButton(
//       onPressed: _quizSkip,
//       child: Text('Skip',
//           style: GoogleFonts.notoSans(color: AppTheme.inkLight)),
//     );
//   }

//   // ── bottom bar ────────────────────────────────────────────────
//   Widget _buildBottomBar() {
//     final allDone = _mastered.length == widget.kanji.length;
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
//       color: AppTheme.white,
//       child: ElevatedButton.icon(
//         onPressed: () => Navigator.of(context).pop(allDone),
//         icon: Icon(allDone ? Icons.check_circle : Icons.arrow_back, size: 18),
//         label: Text(allDone
//             ? 'Mark Day ${widget.dayNumber} Complete ✓'
//             : 'Back to Plan'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: allDone ? AppTheme.success : widget.accentColor,
//           foregroundColor: Colors.white,
//           minimumSize: const Size(double.infinity, 48),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12)),
//           elevation: 0,
//           textStyle: GoogleFonts.notoSans(
//               fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Mode Toggle Button (3-way: grid / flashcard / quiz)
// // ─────────────────────────────────────────────────────────────────────────────
// class _ModeToggle extends StatelessWidget {
//   final _ViewMode current;
//   final Color accentColor;
//   final void Function(_ViewMode) onSelect;
//   const _ModeToggle({
//     required this.current,
//     required this.accentColor,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<_ViewMode>(
//       icon: Icon(
//         current == _ViewMode.grid
//             ? Icons.grid_view_rounded
//             : current == _ViewMode.flashcard
//                 ? Icons.style_rounded
//                 : Icons.edit_note_rounded,
//         color: accentColor,
//         size: 24,
//       ),
//       tooltip: 'Switch mode',
//       onSelected: onSelect,
//       itemBuilder: (_) => [
//         PopupMenuItem(
//           value: _ViewMode.grid,
//           child: Row(children: [
//             Icon(Icons.grid_view_rounded,
//                 color: current == _ViewMode.grid ? accentColor : Colors.grey,
//                 size: 20),
//             const SizedBox(width: 10),
//             Text('Grid view',
//                 style: GoogleFonts.notoSans(
//                     fontWeight: current == _ViewMode.grid
//                         ? FontWeight.w700
//                         : FontWeight.w400)),
//           ]),
//         ),
//         PopupMenuItem(
//           value: _ViewMode.flashcard,
//           child: Row(children: [
//             Icon(Icons.style_rounded,
//                 color: current == _ViewMode.flashcard
//                     ? accentColor
//                     : Colors.grey,
//                 size: 20),
//             const SizedBox(width: 10),
//             Text('Flashcard',
//                 style: GoogleFonts.notoSans(
//                     fontWeight: current == _ViewMode.flashcard
//                         ? FontWeight.w700
//                         : FontWeight.w400)),
//           ]),
//         ),
//         PopupMenuItem(
//           value: _ViewMode.quiz,
//           child: Row(children: [
//             Icon(Icons.edit_note_rounded,
//                 color: current == _ViewMode.quiz ? accentColor : Colors.grey,
//                 size: 20),
//             const SizedBox(width: 10),
//             Text('Quiz  (romaji + English)',
//                 style: GoogleFonts.notoSans(
//                     fontWeight: current == _ViewMode.quiz
//                         ? FontWeight.w700
//                         : FontWeight.w400)),
//           ]),
//         ),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Quiz input field widget
// // ─────────────────────────────────────────────────────────────────────────────
// class _QuizField extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String stepNum;
//   final String label;
//   final String hint;
//   final _AnswerState state;
//   final bool enabled;
//   final Color accentColor;
//   final VoidCallback onSubmit;

//   const _QuizField({
//     required this.controller,
//     required this.focusNode,
//     required this.stepNum,
//     required this.label,
//     required this.hint,
//     required this.state,
//     required this.enabled,
//     required this.accentColor,
//     required this.onSubmit,
//   });

//   Color get _borderColor {
//     if (state == _AnswerState.correct) return AppTheme.success;
//     if (state == _AnswerState.wrong)   return AppTheme.red;
//     return accentColor;
//   }

//   Color get _fillColor {
//     if (state == _AnswerState.correct) return AppTheme.successLight;
//     if (state == _AnswerState.wrong)   return AppTheme.redFaint;
//     return AppTheme.white;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // Label chip
//       Row(children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
//           decoration: BoxDecoration(
//             color: state == _AnswerState.correct
//                 ? AppTheme.success
//                 : state == _AnswerState.wrong
//                     ? AppTheme.red
//                     : enabled
//                         ? accentColor
//                         : AppTheme.border,
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Text('$stepNum  $label',
//               style: GoogleFonts.notoSans(
//                   fontSize: 10,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700)),
//         ),
//         if (state == _AnswerState.correct) ...[
//           const SizedBox(width: 8),
//           Text(controller.text,
//               style: GoogleFonts.notoSans(
//                   fontSize: 12,
//                   color: AppTheme.success,
//                   fontWeight: FontWeight.w600)),
//         ],
//       ]),
//       const SizedBox(height: 5),
//       TextField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: enabled,
//         textCapitalization: TextCapitalization.none,
//         keyboardType: TextInputType.text,
//         onSubmitted: (_) => onSubmit(),
//         style: GoogleFonts.notoSans(
//             fontSize: 18,
//             color: state == _AnswerState.wrong ? AppTheme.red : AppTheme.ink,
//             letterSpacing: 0.4),
//         textAlign: TextAlign.center,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle:
//               GoogleFonts.notoSans(color: AppTheme.inkLight, fontSize: 14),
//           filled: true,
//           fillColor: _fillColor,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: AppTheme.border)),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(
//                   color: state == _AnswerState.correct
//                       ? AppTheme.success.withOpacity(0.5)
//                       : state == _AnswerState.wrong
//                           ? AppTheme.red.withOpacity(0.5)
//                           : AppTheme.border)),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: _borderColor, width: 2)),
//           disabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(
//                   color: state == _AnswerState.correct
//                       ? AppTheme.success.withOpacity(0.4)
//                       : AppTheme.border.withOpacity(0.4))),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//           suffixIcon: enabled
//               ? IconButton(
//                   icon: Icon(Icons.send_rounded, color: accentColor),
//                   onPressed: onSubmit)
//               : state == _AnswerState.correct
//                   ? const Icon(Icons.check_circle_rounded,
//                       color: AppTheme.success)
//                   : null,
//         ),
//       ),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Step dot indicator
// // ─────────────────────────────────────────────────────────────────────────────
// class _StepDot extends StatelessWidget {
//   final String label;
//   final _AnswerState state;
//   final bool active;
//   final Color accentColor;
//   const _StepDot(
//       {required this.label,
//       required this.state,
//       required this.active,
//       required this.accentColor});

//   @override
//   Widget build(BuildContext context) {
//     Color bg;
//     Widget icon;
//     Color labelColor;
//     if (state == _AnswerState.correct) {
//       bg = AppTheme.success;
//       icon = const Icon(Icons.check, color: Colors.white, size: 13);
//       labelColor = AppTheme.success;
//     } else if (state == _AnswerState.wrong) {
//       bg = AppTheme.red;
//       icon = const Icon(Icons.close, color: Colors.white, size: 13);
//       labelColor = AppTheme.red;
//     } else if (active) {
//       bg = accentColor;
//       icon = const Icon(Icons.edit, color: Colors.white, size: 11);
//       labelColor = accentColor;
//     } else {
//       bg = AppTheme.border;
//       icon = Container(
//           width: 6, height: 6,
//           decoration: const BoxDecoration(
//               color: Colors.white, shape: BoxShape.circle));
//       labelColor = AppTheme.inkLight;
//     }
//     return Column(children: [
//       AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           width: 26, height: 26,
//           decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//           child: Center(child: icon)),
//       const SizedBox(height: 3),
//       Text(label,
//           style: GoogleFonts.notoSans(
//               fontSize: 9,
//               color: labelColor,
//               fontWeight: active || state != _AnswerState.idle
//                   ? FontWeight.w700
//                   : FontWeight.w400)),
//     ]);
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Flashcard Front
// // ─────────────────────────────────────────────────────────────────────────────
// class _CardFront extends StatelessWidget {
//   final KanjiEntry k;
//   final Color accentColor;
//   const _CardFront({super.key, required this.k, required this.accentColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppTheme.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppTheme.border),
//         boxShadow: [
//           BoxShadow(
//               color: accentColor.withOpacity(0.08),
//               blurRadius: 20,
//               offset: const Offset(0, 6))
//         ],
//       ),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text(k.k,
//             style: AppTheme.kanjiStyle(
//                 fontSize: 110, color: accentColor,
//                 fontWeight: FontWeight.w300)),
//         if (k.frame != null) ...[
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//             decoration: BoxDecoration(
//                 color: accentColor.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(8)),
//             child: Text('RTK #${k.frame}',
//                 style: GoogleFonts.notoSans(
//                     fontSize: 12, color: accentColor)),
//           ),
//         ],
//         const SizedBox(height: 16),
//         Text('Tap to reveal',
//             style: GoogleFonts.notoSans(
//                 fontSize: 13, color: AppTheme.inkLight)),
//       ]),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Flashcard Back
// // ─────────────────────────────────────────────────────────────────────────────
// class _CardBack extends StatelessWidget {
//   final KanjiEntry k;
//   final Color accentColor;
//   final bool isMastered;
//   const _CardBack(
//       {super.key,
//       required this.k,
//       required this.accentColor,
//       required this.isMastered});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: isMastered ? AppTheme.successLight : AppTheme.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: isMastered
//               ? AppTheme.success.withOpacity(0.4)
//               : AppTheme.border,
//           width: isMastered ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//               color: accentColor.withOpacity(0.08),
//               blurRadius: 20,
//               offset: const Offset(0, 6))
//         ],
//       ),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
//         child: Column(children: [
//           // Kanji + readings
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(k.k,
//                   style: AppTheme.kanjiStyle(
//                       fontSize: 68,
//                       color: isMastered ? AppTheme.success : accentColor,
//                       fontWeight: FontWeight.w400)),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (k.ja.isNotEmpty)
//                     Text(k.ja,
//                         style: GoogleFonts.notoSans(
//                             fontSize: 16,
//                             color: accentColor,
//                             fontWeight: FontWeight.w600)),
//                   if (k.rom.isNotEmpty)
//                     Text(k.rom,
//                         style: GoogleFonts.notoSans(
//                             fontSize: 12, color: AppTheme.inkLight)),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (k.kw.isNotEmpty) ...[
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
//               decoration: BoxDecoration(
//                   color: accentColor.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Text('"${k.kw}"',
//                   style: GoogleFonts.playfairDisplay(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       color: accentColor,
//                       fontStyle: FontStyle.italic)),
//             ),
//             Text('Heisig keyword',
//                 style: GoogleFonts.notoSans(
//                     fontSize: 10, color: AppTheme.inkLight)),
//             const SizedBox(height: 10),
//           ],
//           Text(k.en,
//               style: GoogleFonts.notoSans(
//                   fontSize: 13, color: AppTheme.ink, height: 1.5),
//               textAlign: TextAlign.center),
//           const SizedBox(height: 12),
//           if (k.on.isNotEmpty) ...[
//             _ReadingRow(label: 'On', value: k.on, color: accentColor),
//             const SizedBox(height: 5),
//           ],
//           if (k.kun.isNotEmpty)
//             _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
//           const SizedBox(height: 14),
//           if (k.ex1w.isNotEmpty) ...[
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text('Examples',
//                   style: GoogleFonts.notoSans(
//                       fontSize: 10,
//                       color: AppTheme.inkLight,
//                       fontWeight: FontWeight.w600)),
//             ),
//             const SizedBox(height: 6),
//             _ExampleRow(
//                 word: k.ex1w,
//                 reading: k.ex1r,
//                 meaning: k.ex1e,
//                 color: accentColor),
//             if (k.ex2w.isNotEmpty) ...[
//               const SizedBox(height: 5),
//               _ExampleRow(
//                   word: k.ex2w,
//                   reading: k.ex2r,
//                   meaning: k.ex2e,
//                   color: accentColor),
//             ],
//             const SizedBox(height: 12),
//           ],
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             _Pill(
//                 text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
//                 color: accentColor),
//             const SizedBox(width: 8),
//             _Pill(
//                 text: '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
//                 color: AppTheme.inkLight),
//           ]),
//         ]),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Kanji detail bottom sheet
// // ─────────────────────────────────────────────────────────────────────────────
// class _KanjiDetailSheet extends StatelessWidget {
//   final KanjiEntry k;
//   final bool isMastered;
//   final Color accentColor;
//   final VoidCallback onToggle;
//   const _KanjiDetailSheet(
//       {required this.k,
//       required this.isMastered,
//       required this.accentColor,
//       required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: AppTheme.white, borderRadius: BorderRadius.circular(20)),
//       child: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Container(
//                 width: 40, height: 4,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                     color: AppTheme.border,
//                     borderRadius: BorderRadius.circular(2))),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(k.k,
//                     style: AppTheme.kanjiStyle(
//                         fontSize: 72,
//                         color: accentColor,
//                         fontWeight: FontWeight.w300)),
//                 const SizedBox(width: 14),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (k.ja.isNotEmpty)
//                       Text(k.ja,
//                           style: GoogleFonts.notoSans(
//                               fontSize: 18,
//                               color: accentColor,
//                               fontWeight: FontWeight.w600)),
//                     if (k.rom.isNotEmpty)
//                       Text(k.rom,
//                           style: GoogleFonts.notoSans(
//                               fontSize: 13, color: AppTheme.inkLight)),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (k.kw.isNotEmpty) ...[
//               Text('"${k.kw}"',
//                   style: GoogleFonts.playfairDisplay(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: accentColor,
//                       fontStyle: FontStyle.italic)),
//               if (k.frame != null)
//                 Text('RTK Frame #${k.frame}',
//                     style: GoogleFonts.notoSans(
//                         fontSize: 11, color: AppTheme.inkLight)),
//               const SizedBox(height: 8),
//             ],
//             Text(k.en,
//                 style: GoogleFonts.notoSans(
//                     fontSize: 14, color: AppTheme.ink, height: 1.5),
//                 textAlign: TextAlign.center),
//             const SizedBox(height: 12),
//             if (k.on.isNotEmpty)
//               Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: _ReadingRow(
//                       label: 'On', value: k.on, color: accentColor)),
//             if (k.kun.isNotEmpty)
//               _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
//             const SizedBox(height: 14),
//             if (k.ex1w.isNotEmpty) ...[
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                     color: AppTheme.offWhite,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: AppTheme.border)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Examples',
//                         style: GoogleFonts.notoSans(
//                             fontSize: 11,
//                             color: AppTheme.inkLight,
//                             fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 8),
//                     _ExampleRow(
//                         word: k.ex1w,
//                         reading: k.ex1r,
//                         meaning: k.ex1e,
//                         color: accentColor),
//                     if (k.ex2w.isNotEmpty) ...[
//                       const Divider(height: 12),
//                       _ExampleRow(
//                           word: k.ex2w,
//                           reading: k.ex2r,
//                           meaning: k.ex2e,
//                           color: accentColor),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 14),
//             ],
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               _Pill(
//                   text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
//                   color: accentColor),
//               const SizedBox(width: 8),
//               _Pill(
//                   text:
//                       '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
//                   color: AppTheme.inkLight),
//             ]),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: onToggle,
//               icon: Icon(isMastered ? Icons.close : Icons.check, size: 18),
//               label:
//                   Text(isMastered ? 'Remove mastered' : 'Mark mastered'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor:
//                     isMastered ? AppTheme.inkLight : AppTheme.success,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 46),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 elevation: 0,
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ─── small reusable widgets ───────────────────────────────────────────────────

// class _ReadingRow extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _ReadingRow(
//       {required this.label, required this.value, required this.color});
//   @override
//   Widget build(BuildContext context) {
//     if (value.isEmpty) return const SizedBox();
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Container(
//           width: 34,
//           padding: const EdgeInsets.symmetric(vertical: 2),
//           decoration: BoxDecoration(
//               color: color.withOpacity(0.10),
//               borderRadius: BorderRadius.circular(4)),
//           child: Center(
//               child: Text(label,
//                   style: GoogleFonts.notoSans(
//                       fontSize: 9,
//                       color: color,
//                       fontWeight: FontWeight.w700)))),
//       const SizedBox(width: 8),
//       Flexible(
//           child: Text(value,
//               style: GoogleFonts.notoSans(
//                   fontSize: 13, color: AppTheme.ink))),
//     ]);
//   }
// }

// class _ExampleRow extends StatelessWidget {
//   final String word, reading, meaning;
//   final Color color;
//   const _ExampleRow(
//       {required this.word,
//       required this.reading,
//       required this.meaning,
//       required this.color});
//   @override
//   Widget build(BuildContext context) {
//     return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//         Text(word,
//             style: AppTheme.kanjiStyle(
//                 fontSize: 20, color: color, fontWeight: FontWeight.w500)),
//         Text(reading,
//             style: GoogleFonts.notoSans(
//                 fontSize: 10, color: color.withOpacity(0.7))),
//       ]),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Text(meaning,
//               style: GoogleFonts.notoSans(
//                   fontSize: 12, color: AppTheme.inkLight, height: 1.4)),
//         ),
//       ),
//     ]);
//   }
// }

// class _Pill extends StatelessWidget {
//   final String text;
//   final Color color;
//   final bool bold;
//   const _Pill({required this.text, required this.color, this.bold = false});
//   @override
//   Widget build(BuildContext context) => Container(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         decoration: BoxDecoration(
//             color: color.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(20)),
//         child: Text(text,
//             style: GoogleFonts.notoSans(
//                 fontSize: 11,
//                 color: color,
//                 fontWeight:
//                     bold ? FontWeight.w700 : FontWeight.w600)),
//       );
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data/kanji_db.dart';
import '../services/progress.dart';

// ─── View modes ───────────────────────────────────────────────────────────────
enum _ViewMode { grid, flashcard, quiz }

// ─── Quiz answer state ────────────────────────────────────────────────────────
enum _AnswerState { idle, correct, wrong }

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

class _StudyDayScreenState extends State<StudyDayScreen>
    with TickerProviderStateMixin {
  // ── shared ──────────────────────────────────────────────────
  _ViewMode _mode      = _ViewMode.grid;
  int       _cardIndex = 0;
  late Set<int> _mastered = {};
  String _filter = 'all';

  // ── flashcard ────────────────────────────────────────────────
  bool _flipped = false;

  // ── quiz ──────────────────────────────────────────────────────
  final TextEditingController _romajiCtrl  = TextEditingController();
  final TextEditingController _englishCtrl = TextEditingController();
  final FocusNode             _romajiFocus  = FocusNode();
  final FocusNode             _englishFocus = FocusNode();

  _AnswerState _romajiAns  = _AnswerState.idle;
  _AnswerState _englishAns = _AnswerState.idle;
  bool _quizSubmitted = false;   // both answers checked
  bool _romajiPassed  = false;   // romaji step done correctly

  int _quizCorrect = 0;
  int _quizTotal   = 0;

  // animations
  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;
  late AnimationController _slideCtrl;
  late Animation<double>   _shakeAnim;
  late Animation<double>   _bounceAnim;
  late Animation<double>   _slideAnim;

  @override
  void initState() {
    super.initState();
    // Load saved mastered kanji for this day from local storage
    _mastered = ProgressStore.instance.getMasteredForDay(widget.dayNumber);
    _shakeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _slideCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
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

  // ── helpers ──────────────────────────────────────────────────
  KanjiEntry get _current => widget.kanji[_cardIndex];

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
        return [for (int i = 0; i < widget.kanji.length; i++)
          if (_mastered.contains(i)) widget.kanji[i]];
      case 'remaining':
        return [for (int i = 0; i < widget.kanji.length; i++)
          if (!_mastered.contains(i)) widget.kanji[i]];
      default: return widget.kanji;
    }
  }

  void _toggleMastered(int idx) {
    setState(() {
      if (_mastered.contains(idx)) {
        _mastered.remove(idx);
      } else { _mastered.add(idx); HapticFeedback.lightImpact(); }
    });
    // Persist immediately to local storage
    ProgressStore.instance.saveMasteredForDay(widget.dayNumber, _mastered);
  }

  // ── mode switching ────────────────────────────────────────────
  void _setMode(_ViewMode m) {
    setState(() {
      _mode      = m;
      _cardIndex = 0;
      _flipped   = false;
      _resetQuiz();
    });
    if (m == _ViewMode.quiz) {
      Future.delayed(const Duration(milliseconds: 150), _romajiFocus.requestFocus);
    }
  }

  // ── quiz logic ────────────────────────────────────────────────
  void _resetQuiz() {
    _romajiCtrl.clear();
    _englishCtrl.clear();
    _romajiAns    = _AnswerState.idle;
    _englishAns   = _AnswerState.idle;
    _quizSubmitted = false;
    _romajiPassed  = false;
    _slideCtrl.reset();
  }

  bool _checkRomaji(String input) {
    final typed = input.trim().toLowerCase();
    if (typed.isEmpty) return false;
    return _current.on
        .toLowerCase()
        .split(RegExp(r'[、,/\s]+'))
        .map((s) => s.replaceAll(RegExp(r'[^a-z]'), '').trim())
        .followedBy(
          _current.kun
              .toLowerCase()
              .split(RegExp(r'[、,/\s]+'))
              .map((s) => s.replaceAll(RegExp(r'[^a-z]'), '').trim()),
        )
        .followedBy([_current.rom.split('/')[0].trim().toLowerCase()])
        .where((s) => s.isNotEmpty)
        .any((a) => a == typed || (typed.length >= 3 && (a.startsWith(typed) || typed.startsWith(a))));
  }

  bool _checkEnglish(String input) {
    final typed = input.trim().toLowerCase();
    if (typed.isEmpty) return false;
    final answers = _current.en
        .toLowerCase()
        .split(RegExp(r'[,;/]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return answers.any((a) =>
        a == typed ||
        (typed.length >= 3 && (a.startsWith(typed) || typed.startsWith(a))));
  }

  void _submitRomaji() {
    if (_romajiPassed || _quizSubmitted) return;
    final ok = _checkRomaji(_romajiCtrl.text);
    setState(() => _romajiAns = ok ? _AnswerState.correct : _AnswerState.wrong);
    if (ok) {
      HapticFeedback.selectionClick();
      setState(() => _romajiPassed = true);
      _slideCtrl.forward();
      Future.delayed(const Duration(milliseconds: 220), () {
        if (mounted) _englishFocus.requestFocus();
      });
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _submitEnglish() {
    if (!_romajiPassed || _quizSubmitted) return;
    final ok = _checkEnglish(_englishCtrl.text);
    final bothOk = _romajiAns == _AnswerState.correct && ok;
    setState(() {
      _englishAns   = ok ? _AnswerState.correct : _AnswerState.wrong;
      _quizSubmitted = true;
      _quizTotal++;
      if (bothOk) {
        _quizCorrect++;
        _mastered.add(_cardIndex);
      }
    });
    if (bothOk) {
      HapticFeedback.lightImpact();
      _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
      Future.delayed(const Duration(milliseconds: 950), _quizNext);
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward().then((_) => _shakeCtrl.reset());
    }
  }

  void _quizNext() {
    if (!mounted) return;
    setState(() {
      _cardIndex = (_cardIndex + 1) % widget.kanji.length;
      _resetQuiz();
    });
    Future.delayed(const Duration(milliseconds: 100), _romajiFocus.requestFocus);
  }

  void _quizSkip() {
    setState(() { _quizTotal++; });
    _quizNext();
  }

  // ── flashcard helpers ─────────────────────────────────────────
  void _nextCard() {
    setState(() {
      _flipped   = false;
      _cardIndex = (_cardIndex + 1) % widget.kanji.length;
    });
  }

  void _prevCard() {
    setState(() {
      _flipped   = false;
      _cardIndex = (_cardIndex - 1 + widget.kanji.length) % widget.kanji.length;
    });
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
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
          // Quiz score shown only in quiz mode
          if (_mode == _ViewMode.quiz)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Text('$_quizCorrect/$_quizTotal',
                    style: GoogleFonts.notoSans(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ),
          // Mode toggle button
          _ModeToggle(
            current: _mode,
            accentColor: widget.accentColor,
            onSelect: _setMode,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_mode == _ViewMode.quiz) {
            if (!_romajiPassed) {
              _romajiFocus.requestFocus();
            } else {
              _englishFocus.requestFocus();
            }
          }
        },
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── header (progress bar) ─────────────────────────────────────
  Widget _buildHeader() {
    final mastered = _mastered.length;
    final total    = widget.kanji.length;
    final pct      = total > 0 ? mastered / total : 0.0;
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _Pill(text: _jlptLabel, color: widget.accentColor, bold: true),
          const SizedBox(width: 8),
          Text('$mastered / $total mastered',
              style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight)),
          const Spacer(),
          if (mastered == total && total > 0)
            Row(children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 15),
              const SizedBox(width: 4),
              Text('All done!',
                  style: GoogleFonts.notoSans(
                      fontSize: 12, color: AppTheme.success,
                      fontWeight: FontWeight.w600)),
            ]),
        ]),
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
      ]),
    );
  }

  Widget _buildBody() {
    switch (_mode) {
      case _ViewMode.grid:      return _buildGrid();
      case _ViewMode.flashcard: return _buildFlashcard();
      case _ViewMode.quiz:      return _buildQuiz();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GRID
  // ─────────────────────────────────────────────────────────────
  Widget _buildGrid() {
    return Column(children: [
      // filter tabs
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: active ? widget.accentColor : AppTheme.offWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active ? widget.accentColor : AppTheme.border),
                ),
                child: Text(f[0].toUpperCase() + f.substring(1),
                    style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: active ? Colors.white : AppTheme.inkLight,
                        fontWeight: FontWeight.w600)),
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
            childAspectRatio: 0.72,
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
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(alignment: Alignment.topRight, children: [
                        Center(
                          child: Text(k.k,
                              style: AppTheme.kanjiStyle(
                                  fontSize: 36,
                                  color: isMastered
                                      ? AppTheme.success
                                      : widget.accentColor,
                                  fontWeight: FontWeight.w400)),
                        ),
                        if (isMastered)
                          const Icon(Icons.check_circle,
                              size: 14, color: AppTheme.success),
                      ]),
                      const SizedBox(height: 3),
                      if (k.ja.isNotEmpty)
                        Text(k.ja.split('・')[0],
                            style: GoogleFonts.notoSans(
                                fontSize: 11,
                                color: isMastered
                                    ? AppTheme.success.withOpacity(0.8)
                                    : widget.accentColor.withOpacity(0.75),
                                fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      if (k.rom.isNotEmpty)
                        Text(k.rom.split('/')[0].trim(),
                            style: GoogleFonts.notoSans(
                                fontSize: 9, color: AppTheme.inkLight)),
                      Text(k.en.split(',')[0].trim(),
                          style: GoogleFonts.notoSans(
                              fontSize: 9,
                              color: AppTheme.inkLight,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (k.frame != null)
                        Text('#${k.frame}',
                            style: GoogleFonts.notoSans(
                                fontSize: 7.5,
                                color: widget.accentColor.withOpacity(0.4))),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
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
        onToggle: () { _toggleMastered(idx); Navigator.pop(context); },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FLASHCARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildFlashcard() {
    final k = widget.kanji[_cardIndex];
    final isMastered = _mastered.contains(_cardIndex);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(children: [
        Text('Card ${_cardIndex + 1} of ${widget.kanji.length}',
            style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight)),
        const SizedBox(height: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _flipped = !_flipped),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: _flipped
                  ? _CardBack(key: const ValueKey('back'), k: k,
                      accentColor: widget.accentColor, isMastered: isMastered)
                  : _CardFront(key: const ValueKey('front'), k: k,
                      accentColor: widget.accentColor),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
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
              onPressed: () { _toggleMastered(_cardIndex); _nextCard(); },
              icon: Icon(isMastered ? Icons.close : Icons.check, size: 18),
              label: Text(isMastered ? 'Unmark' : 'Got it!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isMastered ? AppTheme.inkLight : AppTheme.success,
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
        ]),
        const SizedBox(height: 6),
        Text('Tap card to flip  ·  Long-press grid cells to mark mastered',
            style: GoogleFonts.notoSans(fontSize: 9.5, color: AppTheme.inkLight)),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // QUIZ MODE
  // ─────────────────────────────────────────────────────────────
  Widget _buildQuiz() {
    final k = _current;
    // overall card result colour
    Color cardBg = AppTheme.white;
    Color cardBorder = AppTheme.border;
    double cardBorderW = 1;
    if (_quizSubmitted) {
      final allOk = _romajiAns == _AnswerState.correct &&
          _englishAns == _AnswerState.correct;
      cardBg     = allOk ? AppTheme.successLight : AppTheme.redFaint;
      cardBorder = allOk
          ? AppTheme.success.withOpacity(0.4)
          : AppTheme.red.withOpacity(0.35);
      cardBorderW = 2;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnim, _bounceAnim]),
      builder: (ctx, child) {
        final dx = _shakeCtrl.isAnimating
            ? sin(_shakeAnim.value * pi * 8) * 10.0
            : 0.0;
        final sc = _bounceCtrl.isAnimating ? _bounceAnim.value : 1.0;
        return Transform.translate(
            offset: Offset(dx, 0),
            child: Transform.scale(scale: sc, child: child));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(children: [

          // ── Card counter ──────────────────────────────────────
          Text('Card ${_cardIndex + 1} of ${widget.kanji.length}',
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppTheme.inkLight)),
          const SizedBox(height: 12),

          // ── Kanji display card ────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: cardBorder, width: cardBorderW),
              boxShadow: [
                BoxShadow(
                    color: widget.accentColor.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Column(children: [
              // Big kanji
              Text(k.k,
                  style: AppTheme.kanjiStyle(
                      fontSize: 96,
                      color: _quizSubmitted && _englishAns == _AnswerState.wrong
                          ? AppTheme.red
                          : widget.accentColor,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 8),

              // RTK frame
              if (k.frame != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('RTK #${k.frame}',
                      style: GoogleFonts.notoSans(
                          fontSize: 11, color: widget.accentColor)),
                ),
              const SizedBox(height: 10),

              // Step dots
              _buildStepDots(),
              const SizedBox(height: 10),

              // Feedback / instruction text
              _buildQuizHint(k),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Input 1: Romaji ───────────────────────────────────
          _QuizField(
            controller: _romajiCtrl,
            focusNode: _romajiFocus,
            stepNum: '1',
            label: 'Romaji',
            hint: 'e.g.  nichi  /  hi',
            state: _romajiAns,
            enabled: !_romajiPassed,
            accentColor: widget.accentColor,
            onSubmit: _submitRomaji,
          ),
          const SizedBox(height: 10),

          // ── Input 2: English — slides in ─────────────────────
          AnimatedBuilder(
            animation: _slideAnim,
            builder: (ctx, child) => ClipRect(
              child: Align(
                heightFactor: _slideAnim.value,
                child: Opacity(opacity: _slideAnim.value, child: child),
              ),
            ),
            child: _QuizField(
              controller: _englishCtrl,
              focusNode: _englishFocus,
              stepNum: '2',
              label: 'English meaning',
              hint: 'e.g.  day  /  sun',
              state: _englishAns,
              enabled: _romajiPassed && !_quizSubmitted,
              accentColor: widget.accentColor,
              onSubmit: _submitEnglish,
            ),
          ),
          const SizedBox(height: 14),

          // ── Action row ────────────────────────────────────────
          _buildQuizActions(),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _buildStepDots() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _StepDot(
          label: 'Romaji',
          state: _romajiAns,
          active: !_romajiPassed,
          accentColor: widget.accentColor),
      Container(
          width: 32, height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          color: _romajiPassed
              ? widget.accentColor.withOpacity(0.5)
              : AppTheme.border),
      _StepDot(
          label: 'English',
          state: _englishAns,
          active: _romajiPassed && !_quizSubmitted,
          accentColor: widget.accentColor),
    ]);
  }

  Widget _buildQuizHint(KanjiEntry k) {
    // Not started
    if (_romajiAns == _AnswerState.idle) {
      return Text('Type the romaji reading',
          style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.inkLight));
    }
    // Romaji wrong
    if (_romajiAns == _AnswerState.wrong && !_romajiPassed) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.close, color: AppTheme.red, size: 16),
          const SizedBox(width: 4),
          Text('Correct romaji: ${k.rom}',
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.red,
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 4),
        Text('Try again ↑ or skip',
            style: GoogleFonts.notoSans(
                fontSize: 11, color: AppTheme.inkLight)),
      ]);
    }
    // Romaji correct, waiting English
    if (_romajiPassed && _englishAns == _AnswerState.idle) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
        const SizedBox(width: 5),
        Text('${k.rom.split('/')[0].trim()}  ✓   Now type the English',
            style: GoogleFonts.notoSans(
                fontSize: 13, color: AppTheme.success,
                fontWeight: FontWeight.w500)),
      ]);
    }
    // Both correct
    if (_romajiAns == _AnswerState.correct &&
        _englishAns == _AnswerState.correct) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.success, size: 22),
          const SizedBox(width: 6),
          Text('Perfect!',
              style: GoogleFonts.playfairDisplay(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ]),
        const SizedBox(height: 4),
        Text('${k.rom.split('/')[0].trim()}  ·  ${k.en.split(',')[0].trim()}',
            style: GoogleFonts.notoSans(
                fontSize: 12, color: AppTheme.success.withOpacity(0.8))),
      ]);
    }
    // English wrong
    if (_englishAns == _AnswerState.wrong) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: AppTheme.redFaint,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.red.withOpacity(0.2))),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.close, color: AppTheme.red, size: 16),
            const SizedBox(width: 4),
            Text('Not quite!',
                style: GoogleFonts.notoSans(
                    color: AppTheme.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 4),
          Text('Romaji: ${k.rom.split('/')[0].trim()}',
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppTheme.inkLight)),
          Text('English: ${k.en.split(',').take(3).join(', ')}',
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.red,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
        ]),
      );
    }
    return const SizedBox();
  }

  Widget _buildQuizActions() {
    // After both submitted — wrong english
    if (_quizSubmitted && _englishAns == _AnswerState.wrong) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton.icon(
          onPressed: _quizNext,
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: const Text('Next card'),
          style: ElevatedButton.styleFrom(
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.notoSans(
                  fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ]);
    }
    // Romaji wrong — retry or skip
    if (_romajiAns == _AnswerState.wrong && !_romajiPassed) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          onPressed: () {
            setState(() {
              _romajiAns = _AnswerState.idle;
              _romajiCtrl.clear();
            });
            _romajiFocus.requestFocus();
          },
          child: Text('Retry',
              style: GoogleFonts.notoSans(
                  color: widget.accentColor,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: _quizSkip,
          child: Text('Skip',
              style: GoogleFonts.notoSans(color: AppTheme.inkLight)),
        ),
      ]);
    }
    // Default — Skip
    return TextButton(
      onPressed: _quizSkip,
      child: Text('Skip',
          style: GoogleFonts.notoSans(color: AppTheme.inkLight)),
    );
  }

  // ── bottom bar ────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final allDone = _mastered.length == widget.kanji.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      color: AppTheme.white,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(allDone),
        icon: Icon(allDone ? Icons.check_circle : Icons.arrow_back, size: 18),
        label: Text(allDone
            ? 'Mark Day ${widget.dayNumber} Complete ✓'
            : 'Back to Plan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: allDone ? AppTheme.success : widget.accentColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.notoSans(
              fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode Toggle Button (3-way: grid / flashcard / quiz)
// ─────────────────────────────────────────────────────────────────────────────
class _ModeToggle extends StatelessWidget {
  final _ViewMode current;
  final Color accentColor;
  final void Function(_ViewMode) onSelect;
  const _ModeToggle({
    required this.current,
    required this.accentColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ViewMode>(
      icon: Icon(
        current == _ViewMode.grid
            ? Icons.grid_view_rounded
            : current == _ViewMode.flashcard
                ? Icons.style_rounded
                : Icons.edit_note_rounded,
        color: accentColor,
        size: 24,
      ),
      tooltip: 'Switch mode',
      onSelected: onSelect,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _ViewMode.grid,
          child: Row(children: [
            Icon(Icons.grid_view_rounded,
                color: current == _ViewMode.grid ? accentColor : Colors.grey,
                size: 20),
            const SizedBox(width: 10),
            Text('Grid view',
                style: GoogleFonts.notoSans(
                    fontWeight: current == _ViewMode.grid
                        ? FontWeight.w700
                        : FontWeight.w400)),
          ]),
        ),
        PopupMenuItem(
          value: _ViewMode.flashcard,
          child: Row(children: [
            Icon(Icons.style_rounded,
                color: current == _ViewMode.flashcard
                    ? accentColor
                    : Colors.grey,
                size: 20),
            const SizedBox(width: 10),
            Text('Flashcard',
                style: GoogleFonts.notoSans(
                    fontWeight: current == _ViewMode.flashcard
                        ? FontWeight.w700
                        : FontWeight.w400)),
          ]),
        ),
        PopupMenuItem(
          value: _ViewMode.quiz,
          child: Row(children: [
            Icon(Icons.edit_note_rounded,
                color: current == _ViewMode.quiz ? accentColor : Colors.grey,
                size: 20),
            const SizedBox(width: 10),
            Text('Quiz  (romaji + English)',
                style: GoogleFonts.notoSans(
                    fontWeight: current == _ViewMode.quiz
                        ? FontWeight.w700
                        : FontWeight.w400)),
          ]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quiz input field widget
// ─────────────────────────────────────────────────────────────────────────────
class _QuizField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String stepNum;
  final String label;
  final String hint;
  final _AnswerState state;
  final bool enabled;
  final Color accentColor;
  final VoidCallback onSubmit;

  const _QuizField({
    required this.controller,
    required this.focusNode,
    required this.stepNum,
    required this.label,
    required this.hint,
    required this.state,
    required this.enabled,
    required this.accentColor,
    required this.onSubmit,
  });

  Color get _borderColor {
    if (state == _AnswerState.correct) return AppTheme.success;
    if (state == _AnswerState.wrong)   return AppTheme.red;
    return accentColor;
  }

  Color get _fillColor {
    if (state == _AnswerState.correct) return AppTheme.successLight;
    if (state == _AnswerState.wrong)   return AppTheme.redFaint;
    return AppTheme.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Label chip
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: state == _AnswerState.correct
                ? AppTheme.success
                : state == _AnswerState.wrong
                    ? AppTheme.red
                    : enabled
                        ? accentColor
                        : AppTheme.border,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('$stepNum  $label',
              style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
        ),
        if (state == _AnswerState.correct) ...[
          const SizedBox(width: 8),
          Text(controller.text,
              style: GoogleFonts.notoSans(
                  fontSize: 12,
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600)),
        ],
      ]),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.text,
        onSubmitted: (_) => onSubmit(),
        style: GoogleFonts.notoSans(
            fontSize: 18,
            color: state == _AnswerState.wrong ? AppTheme.red : AppTheme.ink,
            letterSpacing: 0.4),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.notoSans(color: AppTheme.inkLight, fontSize: 14),
          filled: true,
          fillColor: _fillColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: state == _AnswerState.correct
                      ? AppTheme.success.withOpacity(0.5)
                      : state == _AnswerState.wrong
                          ? AppTheme.red.withOpacity(0.5)
                          : AppTheme.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _borderColor, width: 2)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: state == _AnswerState.correct
                      ? AppTheme.success.withOpacity(0.4)
                      : AppTheme.border.withOpacity(0.4))),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          suffixIcon: enabled
              ? IconButton(
                  icon: Icon(Icons.send_rounded, color: accentColor),
                  onPressed: onSubmit)
              : state == _AnswerState.correct
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppTheme.success)
                  : null,
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step dot indicator
// ─────────────────────────────────────────────────────────────────────────────
class _StepDot extends StatelessWidget {
  final String label;
  final _AnswerState state;
  final bool active;
  final Color accentColor;
  const _StepDot(
      {required this.label,
      required this.state,
      required this.active,
      required this.accentColor});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Widget icon;
    Color labelColor;
    if (state == _AnswerState.correct) {
      bg = AppTheme.success;
      icon = const Icon(Icons.check, color: Colors.white, size: 13);
      labelColor = AppTheme.success;
    } else if (state == _AnswerState.wrong) {
      bg = AppTheme.red;
      icon = const Icon(Icons.close, color: Colors.white, size: 13);
      labelColor = AppTheme.red;
    } else if (active) {
      bg = accentColor;
      icon = const Icon(Icons.edit, color: Colors.white, size: 11);
      labelColor = accentColor;
    } else {
      bg = AppTheme.border;
      icon = Container(
          width: 6, height: 6,
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle));
      labelColor = AppTheme.inkLight;
    }
    return Column(children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 26, height: 26,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(child: icon)),
      const SizedBox(height: 3),
      Text(label,
          style: GoogleFonts.notoSans(
              fontSize: 9,
              color: labelColor,
              fontWeight: active || state != _AnswerState.idle
                  ? FontWeight.w700
                  : FontWeight.w400)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Flashcard Front
// ─────────────────────────────────────────────────────────────────────────────
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(k.k,
            style: AppTheme.kanjiStyle(
                fontSize: 110, color: accentColor,
                fontWeight: FontWeight.w300)),
        if (k.frame != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8)),
            child: Text('RTK #${k.frame}',
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: accentColor)),
          ),
        ],
        const SizedBox(height: 16),
        Text('Tap to reveal',
            style: GoogleFonts.notoSans(
                fontSize: 13, color: AppTheme.inkLight)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Flashcard Back
// ─────────────────────────────────────────────────────────────────────────────
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
          color: isMastered
              ? AppTheme.success.withOpacity(0.4)
              : AppTheme.border,
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
        child: Column(children: [
          // Kanji + readings
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(k.k,
                  style: AppTheme.kanjiStyle(
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
                            fontSize: 12, color: AppTheme.inkLight)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (k.kw.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
          Text(k.en,
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.ink, height: 1.5),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          if (k.on.isNotEmpty) ...[
            _ReadingRow(label: 'On', value: k.on, color: accentColor),
            const SizedBox(height: 5),
          ],
          if (k.kun.isNotEmpty)
            _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
          const SizedBox(height: 14),
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
            _ExampleRow(
                word: k.ex1w,
                reading: k.ex1r,
                meaning: k.ex1e,
                color: accentColor),
            if (k.ex2w.isNotEmpty) ...[
              const SizedBox(height: 5),
              _ExampleRow(
                  word: k.ex2w,
                  reading: k.ex2r,
                  meaning: k.ex2e,
                  color: accentColor),
            ],
            const SizedBox(height: 12),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _Pill(
                text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                color: accentColor),
            const SizedBox(width: 8),
            _Pill(
                text: '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
                color: AppTheme.inkLight),
          ]),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Kanji detail bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _KanjiDetailSheet extends StatelessWidget {
  final KanjiEntry k;
  final bool isMastered;
  final Color accentColor;
  final VoidCallback onToggle;
  const _KanjiDetailSheet(
      {required this.k,
      required this.isMastered,
      required this.accentColor,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppTheme.white, borderRadius: BorderRadius.circular(20)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(k.k,
                    style: AppTheme.kanjiStyle(
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
                              fontSize: 13, color: AppTheme.inkLight)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            Text(k.en,
                style: GoogleFonts.notoSans(
                    fontSize: 14, color: AppTheme.ink, height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (k.on.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _ReadingRow(
                      label: 'On', value: k.on, color: accentColor)),
            if (k.kun.isNotEmpty)
              _ReadingRow(label: 'Kun', value: k.kun, color: accentColor),
            const SizedBox(height: 14),
            if (k.ex1w.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppTheme.offWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border)),
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _Pill(
                  text: k.jlpt == 0 ? 'Beyond JLPT' : 'N${k.jlpt}',
                  color: accentColor),
              const SizedBox(width: 8),
              _Pill(
                  text:
                      '${categoryIcon(k.cat.toLowerCase())} ${k.cat.split('_')[0]}',
                  color: AppTheme.inkLight),
            ]),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onToggle,
              icon: Icon(isMastered ? Icons.close : Icons.check, size: 18),
              label:
                  Text(isMastered ? 'Remove mastered' : 'Mark mastered'),
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
          ]),
        ),
      ),
    );
  }
}

// ─── small reusable widgets ───────────────────────────────────────────────────

class _ReadingRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ReadingRow(
      {required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox();
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      fontWeight: FontWeight.w700)))),
      const SizedBox(width: 8),
      Flexible(
          child: Text(value,
              style: GoogleFonts.notoSans(
                  fontSize: 13, color: AppTheme.ink))),
    ]);
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
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(word,
            style: AppTheme.kanjiStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.w500)),
        Text(reading,
            style: GoogleFonts.notoSans(
                fontSize: 10, color: color.withOpacity(0.7))),
      ]),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(meaning,
              style: GoogleFonts.notoSans(
                  fontSize: 12, color: AppTheme.inkLight, height: 1.4)),
        ),
      ),
    ]);
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  final bool bold;
  const _Pill({required this.text, required this.color, this.bold = false});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: GoogleFonts.notoSans(
                fontSize: 11,
                color: color,
                fontWeight:
                    bold ? FontWeight.w700 : FontWeight.w600)),
      );
}
