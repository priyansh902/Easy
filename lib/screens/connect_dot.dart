import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/j_char.dart';
import 'script.dart';

class ConnectDotsScreen extends StatefulWidget {
  final List<JChar> chars;
  final ScriptType scriptType;
  final Color accentColor;

  const ConnectDotsScreen({
    super.key,
    required this.chars,
    required this.scriptType,
    required this.accentColor,
  });

  @override
  State<ConnectDotsScreen> createState() => _ConnectDotsScreenState();
}

class _ConnectDotsScreenState extends State<ConnectDotsScreen>
    with TickerProviderStateMixin {
  late List<JChar> _shuffled;
  int _index = 0;
  int _correct = 0;
  int _total = 0;
  bool _revealed = false;
  bool _completed = false;
  bool _showAnswer = false; // right panel: show actual character

  // Dragging state
  int? _dragFromId;
  Offset? _dragCurrentPos;
  List<_Connection> _userConnections = [];
  final GlobalKey _canvasKey = GlobalKey();

  late AnimationController _successCtrl;
  late Animation<double> _successAnim;

  @override
  void initState() {
    super.initState();
    _shuffled = List.from(widget.chars)..shuffle(Random());
    _successCtrl = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _successAnim =
        CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    super.dispose();
  }

  JChar get _current => _shuffled[_index];
  List<DotPoint> get _dots => _current.dots;

  Offset _dotOffset(DotPoint dot, Size size) =>
      Offset(dot.x * size.width, dot.y * size.height);

  int? _hitTest(Offset localPos, Size size) {
    for (final dot in _dots) {
      final center = _dotOffset(dot, size);
      if ((localPos - center).distance < 26) return dot.id;
    }
    return null;
  }

  bool _connectionExists(int fromId, int toId) => _userConnections.any(
      (c) => (c.fromId == fromId && c.toId == toId) ||
          (c.fromId == toId && c.toId == fromId));

  void _onPanStart(DragStartDetails details) {
    if (_completed) return;
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final hit = _hitTest(local, box.size);
    if (hit != null) setState(() { _dragFromId = hit; _dragCurrentPos = local; });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dragFromId == null) return;
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    setState(() => _dragCurrentPos = box.globalToLocal(details.globalPosition));
  }

  void _onPanEnd(DragEndDetails _) {
    if (_dragFromId == null) return;
    final box = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && _dragCurrentPos != null) {
      final hit = _hitTest(_dragCurrentPos!, box.size);
      if (hit != null && hit != _dragFromId && !_connectionExists(_dragFromId!, hit)) {
        setState(() => _userConnections.add(_Connection(fromId: _dragFromId!, toId: hit)));
        _checkCompletion();
      }
    }
    setState(() { _dragFromId = null; _dragCurrentPos = null; });
  }

  void _checkCompletion() {
    final required = _dots
        .where((d) => d.connectsTo != -1)
        .map((d) => _Connection(fromId: d.id, toId: d.connectsTo))
        .toList();
    final allMade = required.every((r) => _userConnections.any(
        (u) => (u.fromId == r.fromId && u.toId == r.toId) ||
            (u.fromId == r.toId && u.toId == r.fromId)));
    if (allMade) {
      setState(() { _completed = true; _showAnswer = true; });
      _correct++;
      _total++;
      HapticFeedback.mediumImpact();
      _successCtrl.forward();
    }
  }

  void _clearConnections() {
    setState(() { _userConnections.clear(); _completed = false; });
    _successCtrl.reset();
  }

  void _reveal() {
    setState(() {
      _revealed = true;
      _showAnswer = true;
      _userConnections.clear();
      for (final dot in _dots) {
        if (dot.connectsTo != -1) {
          _userConnections.add(_Connection(fromId: dot.id, toId: dot.connectsTo));
        }
      }
      _completed = true;
    });
    _successCtrl.forward();
    if (!_revealed) _total++;
  }

  void _nextCard() {
    setState(() {
      if (_revealed && !_completed) _total++;
      _index = (_index + 1) % _shuffled.length;
      _userConnections.clear();
      _completed = false;
      _revealed = false;
      _showAnswer = false;
      _dragFromId = null;
      _dragCurrentPos = null;
    });
    _successCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isKanji = widget.scriptType == ScriptType.kanji;
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: const Text('Connect & Draw'),
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
            padding: const EdgeInsets.only(right: 16),
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
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            children: [
              _buildProgress(),
              const SizedBox(height: 12),
              _buildHintCard(isKanji),
              const SizedBox(height: 12),
              // Two-panel row
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: connect the dots canvas
                    Expanded(
                      flex: 3,
                      child: _buildDotsPanel(),
                    ),
                    const SizedBox(width: 10),
                    // Right: actual character reveal
                    SizedBox(
                      width: 100,
                      child: _buildCharacterPanel(isKanji),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildBottomBar(),
            ],
          ),
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
            Text('Card ${_index + 1} of ${_shuffled.length}',
                style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.inkLight)),
            Text('${(progress * 100).round()}%',
                style: GoogleFonts.notoSans(
                    fontSize: 12, color: widget.accentColor, fontWeight: FontWeight.w600)),
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

  Widget _buildHintCard(bool isKanji) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Text('🔍', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Draw this character:',
                    style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.inkLight)),
                Text(
                  isKanji
                      ? '"${_current.meaning}" (${_current.romaji})'
                      : '"${_current.romaji}"',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.ink),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${_dots.length} dots',
                style: GoogleFonts.notoSans(
                    fontSize: 11, color: widget.accentColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDotsPanel() {
    return AnimatedBuilder(
      animation: _successAnim,
      builder: (context, child) => Transform.scale(
        scale: _completed ? (0.98 + 0.02 * _successAnim.value) : 1.0,
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _completed && !_revealed
              ? AppTheme.successLight
              : _revealed
                  ? AppTheme.redFaint
                  : AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _completed && !_revealed
                ? AppTheme.success.withOpacity(0.4)
                : _revealed
                    ? AppTheme.red.withOpacity(0.3)
                    : AppTheme.border,
            width: _completed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: widget.accentColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              key: _canvasKey,
              painter: _DotsPainter(
                dots: _dots,
                connections: _userConnections,
                dragFromId: _dragFromId,
                dragCurrentPos: _dragCurrentPos,
                accentColor: widget.accentColor,
                completed: _completed,
                revealed: _revealed,
              ),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterPanel(bool isKanji) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showAnswer) ...[
            Text(
              _current.japanese,
              style: GoogleFonts.notoSans(
                fontSize: isKanji ? 52 : 62,
                color: _revealed ? AppTheme.red : widget.accentColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _current.romaji,
              style: GoogleFonts.notoSans(
                fontSize: 11,
                color: AppTheme.inkLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isKanji && _current.meaning.isNotEmpty) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  _current.meaning,
                  style: GoogleFonts.notoSans(
                    fontSize: 9,
                    color: AppTheme.inkLight.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (_completed && !_revealed)
              const Icon(Icons.check_circle, color: AppTheme.success, size: 20)
            else if (_revealed)
              const Icon(Icons.visibility, color: AppTheme.red, size: 18),
          ] else ...[
            Icon(Icons.lock_outline, color: AppTheme.border, size: 28),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Draw to\nreveal',
                style: GoogleFonts.notoSans(
                  fontSize: 11,
                  color: AppTheme.inkLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _clearConnections,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Clear'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.inkLight,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.notoSans(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _reveal,
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Show'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.inkLight,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.notoSans(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _nextCard,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              textStyle: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _Connection {
  final int fromId;
  final int toId;
  const _Connection({required this.fromId, required this.toId});
}

class _DotsPainter extends CustomPainter {
  final List<DotPoint> dots;
  final List<_Connection> connections;
  final int? dragFromId;
  final Offset? dragCurrentPos;
  final Color accentColor;
  final bool completed;
  final bool revealed;

  _DotsPainter({
    required this.dots,
    required this.connections,
    required this.dragFromId,
    required this.dragCurrentPos,
    required this.accentColor,
    required this.completed,
    required this.revealed,
  });

  Offset _pos(int id, Size size) {
    final dot = dots.firstWhere((d) => d.id == id);
    return Offset(dot.x * size.width, dot.y * size.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final lineColor = completed && !revealed
        ? AppTheme.success
        : revealed
            ? AppTheme.red
            : accentColor;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dragPaint = Paint()
      ..color = accentColor.withOpacity(0.45)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw connections
    for (final conn in connections) {
      canvas.drawLine(_pos(conn.fromId, size), _pos(conn.toId, size), linePaint);
    }

    // Draw drag line
    if (dragFromId != null && dragCurrentPos != null) {
      canvas.drawLine(_pos(dragFromId!, size), dragCurrentPos!, dragPaint);
    }

    // Draw dots
    for (final dot in dots) {
      final center = Offset(dot.x * size.width, dot.y * size.height);
      final isActive = dot.id == dragFromId;
      final isConnected =
          connections.any((c) => c.fromId == dot.id || c.toId == dot.id);

      final dotColor = isActive
          ? accentColor
          : isConnected
              ? lineColor
              : AppTheme.inkLight;

      final fillPaint = Paint()
        ..color = isActive
            ? accentColor.withOpacity(0.18)
            : isConnected
                ? lineColor.withOpacity(0.12)
                : Colors.white
        ..style = PaintingStyle.fill;

      final ringPaint = Paint()
        ..color = dotColor
        ..strokeWidth = isActive ? 2.5 : 1.8
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, 14, fillPaint);
      canvas.drawCircle(center, 14, ringPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: dot.id.toString(),
          style: TextStyle(
            color: dotColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => true;
}
