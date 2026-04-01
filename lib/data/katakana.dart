import '../models/j_char.dart';

// Katakana has clean geometric strokes — dots follow the actual stroke paths.

const List<JChar> katakanaList = [
  // ── ア行 ──
  JChar(japanese: 'ア', romaji: 'a', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.30, connectsTo: -1),
    // stroke 2: left-down diagonal
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.30, y: 0.82, connectsTo: -1),
    // stroke 3: right-down short
    DotPoint(id: 5, x: 0.52, y: 0.48, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'イ', romaji: 'i', dots: [
    // stroke 1: left diagonal
    DotPoint(id: 1, x: 0.38, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.62, y: 0.80, connectsTo: -1),
    // stroke 2: right vertical
    DotPoint(id: 3, x: 0.68, y: 0.20, connectsTo: 4),
    DotPoint(id: 4, x: 0.68, y: 0.80, connectsTo: -1),
  ]),
  JChar(japanese: 'ウ', romaji: 'u', dots: [
    // stroke 1: top tick
    DotPoint(id: 1, x: 0.42, y: 0.15, connectsTo: 2),
    DotPoint(id: 2, x: 0.58, y: 0.22, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.22, y: 0.35, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.35, connectsTo: -1),
    // stroke 3: vertical down
    DotPoint(id: 5, x: 0.50, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'エ', romaji: 'e', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: vertical center
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
    // stroke 3: bottom horizontal
    DotPoint(id: 5, x: 0.18, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.82, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'オ', romaji: 'o', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: left vertical
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
    // stroke 3: right diagonal
    DotPoint(id: 5, x: 0.52, y: 0.55, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.78, connectsTo: -1),
  ]),

  // ── カ行 ──
  JChar(japanese: 'カ', romaji: 'ka', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.32, connectsTo: -1),
    // stroke 2: left diagonal down
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.30, y: 0.82, connectsTo: -1),
    // stroke 3: right short diagonal
    DotPoint(id: 5, x: 0.52, y: 0.50, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'キ', romaji: 'ki', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.52, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.52, connectsTo: -1),
    // stroke 3: vertical
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ク', romaji: 'ku', dots: [
    // stroke 1: short top hook
    DotPoint(id: 1, x: 0.40, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.68, y: 0.20, connectsTo: -1),
    // stroke 2: angled down-left
    DotPoint(id: 3, x: 0.65, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.50, connectsTo: 5),
    DotPoint(id: 5, x: 0.65, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ケ', romaji: 'ke', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: left diagonal
    DotPoint(id: 3, x: 0.48, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 3: right short
    DotPoint(id: 5, x: 0.55, y: 0.48, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.75, connectsTo: -1),
  ]),
  JChar(japanese: 'コ', romaji: 'ko', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.25, y: 0.25, connectsTo: 2),
    DotPoint(id: 2, x: 0.75, y: 0.25, connectsTo: -1),
    // stroke 2: right vertical
    DotPoint(id: 3, x: 0.75, y: 0.22, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.75, connectsTo: -1),
    // stroke 3: bottom horizontal
    DotPoint(id: 5, x: 0.25, y: 0.75, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.75, connectsTo: -1),
  ]),

  // ── サ行 ──
  JChar(japanese: 'サ', romaji: 'sa', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.52, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.52, connectsTo: -1),
    // stroke 3: left diagonal down
    DotPoint(id: 5, x: 0.50, y: 0.18, connectsTo: 6),
    DotPoint(id: 6, x: 0.35, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'シ', romaji: 'shi', dots: [
    // stroke 1: top-left short tick
    DotPoint(id: 1, x: 0.22, y: 0.35, connectsTo: 2),
    DotPoint(id: 2, x: 0.35, y: 0.45, connectsTo: -1),
    // stroke 2: middle tick
    DotPoint(id: 3, x: 0.42, y: 0.25, connectsTo: 4),
    DotPoint(id: 4, x: 0.55, y: 0.38, connectsTo: -1),
    // stroke 3: long curve right to bottom
    DotPoint(id: 5, x: 0.28, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.22, connectsTo: 7),
    DotPoint(id: 7, x: 0.75, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ス', romaji: 'su', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: diagonal curve down-left then hook right
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.35, y: 0.55, connectsTo: 5),
    DotPoint(id: 5, x: 0.48, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.65, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'セ', romaji: 'se', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: left vertical
    DotPoint(id: 3, x: 0.40, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.40, y: 0.72, connectsTo: -1),
    // stroke 3: bottom horizontal + right hook
    DotPoint(id: 5, x: 0.22, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.72, connectsTo: 7),
    DotPoint(id: 7, x: 0.78, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ソ', romaji: 'so', dots: [
    // stroke 1: left downward tick
    DotPoint(id: 1, x: 0.32, y: 0.22, connectsTo: 2),
    DotPoint(id: 2, x: 0.38, y: 0.42, connectsTo: -1),
    // stroke 2: right tick curving down-left
    DotPoint(id: 3, x: 0.62, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.35, y: 0.78, connectsTo: -1),
  ]),

  // ── タ行 ──
  JChar(japanese: 'タ', romaji: 'ta', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: left diagonal
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 3: right short diagonal
    DotPoint(id: 5, x: 0.52, y: 0.48, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.80, connectsTo: -1),
  ]),
  JChar(japanese: 'チ', romaji: 'chi', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.50, connectsTo: -1),
    // stroke 3: vertical
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ツ', romaji: 'tsu', dots: [
    // stroke 1: left tick
    DotPoint(id: 1, x: 0.25, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.35, y: 0.48, connectsTo: -1),
    // stroke 2: middle tick
    DotPoint(id: 3, x: 0.45, y: 0.22, connectsTo: 4),
    DotPoint(id: 4, x: 0.55, y: 0.42, connectsTo: -1),
    // stroke 3: long arc right to bottom
    DotPoint(id: 5, x: 0.22, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.22, connectsTo: 7),
    DotPoint(id: 7, x: 0.72, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'テ', romaji: 'te', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.25, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.25, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.48, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.48, connectsTo: -1),
    // stroke 3: vertical from center
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ト', romaji: 'to', dots: [
    // stroke 1: vertical
    DotPoint(id: 1, x: 0.40, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.40, y: 0.82, connectsTo: -1),
    // stroke 2: right diagonal tick
    DotPoint(id: 3, x: 0.40, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.72, y: 0.65, connectsTo: -1),
  ]),

  // ── ナ行 ──
  JChar(japanese: 'ナ', romaji: 'na', dots: [
    // stroke 1: horizontal
    DotPoint(id: 1, x: 0.20, y: 0.40, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.40, connectsTo: -1),
    // stroke 2: vertical
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ニ', romaji: 'ni', dots: [
    // stroke 1: shorter top horizontal
    DotPoint(id: 1, x: 0.28, y: 0.35, connectsTo: 2),
    DotPoint(id: 2, x: 0.72, y: 0.35, connectsTo: -1),
    // stroke 2: longer bottom horizontal
    DotPoint(id: 3, x: 0.18, y: 0.65, connectsTo: 4),
    DotPoint(id: 4, x: 0.82, y: 0.65, connectsTo: -1),
  ]),
  JChar(japanese: 'ヌ', romaji: 'nu', dots: [
    // stroke 1: horizontal
    DotPoint(id: 1, x: 0.20, y: 0.35, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.35, connectsTo: -1),
    // stroke 2: X cross left
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.25, y: 0.78, connectsTo: -1),
    // stroke 3: X cross right
    DotPoint(id: 5, x: 0.50, y: 0.18, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.78, connectsTo: -1),
  ]),
  JChar(japanese: 'ネ', romaji: 'ne', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.30, connectsTo: -1),
    // stroke 2: vertical
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
    // stroke 3: left diagonal
    DotPoint(id: 5, x: 0.50, y: 0.58, connectsTo: 6),
    DotPoint(id: 6, x: 0.25, y: 0.75, connectsTo: -1),
    // stroke 4: right diagonal
    DotPoint(id: 7, x: 0.50, y: 0.58, connectsTo: 8),
    DotPoint(id: 8, x: 0.75, y: 0.75, connectsTo: -1),
  ]),
  JChar(japanese: 'ノ', romaji: 'no', dots: [
    // single stroke: diagonal
    DotPoint(id: 1, x: 0.65, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.35, y: 0.82, connectsTo: -1),
  ]),

  // ── ハ行 ──
  JChar(japanese: 'ハ', romaji: 'ha', dots: [
    // stroke 1: left diagonal
    DotPoint(id: 1, x: 0.38, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.25, y: 0.78, connectsTo: -1),
    // stroke 2: right diagonal
    DotPoint(id: 3, x: 0.58, y: 0.28, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.78, connectsTo: -1),
  ]),
  JChar(japanese: 'ヒ', romaji: 'hi', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 2: upper horizontal
    DotPoint(id: 3, x: 0.26, y: 0.40, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.40, connectsTo: -1),
    // stroke 3: lower horizontal
    DotPoint(id: 5, x: 0.26, y: 0.68, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.68, connectsTo: -1),
  ]),
  JChar(japanese: 'フ', romaji: 'fu', dots: [
    // stroke 1: horizontal top then curve down
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: 3),
    DotPoint(id: 3, x: 0.78, y: 0.48, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ヘ', romaji: 'he', dots: [
    // single stroke: ^ shape
    DotPoint(id: 1, x: 0.20, y: 0.55, connectsTo: 2),
    DotPoint(id: 2, x: 0.50, y: 0.25, connectsTo: 3),
    DotPoint(id: 3, x: 0.80, y: 0.55, connectsTo: -1),
  ]),
  JChar(japanese: 'ホ', romaji: 'ho', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.32, connectsTo: -1),
    // stroke 2: vertical
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.82, connectsTo: -1),
    // stroke 3: left diagonal
    DotPoint(id: 5, x: 0.50, y: 0.60, connectsTo: 6),
    DotPoint(id: 6, x: 0.25, y: 0.78, connectsTo: -1),
    // stroke 4: right diagonal
    DotPoint(id: 7, x: 0.50, y: 0.60, connectsTo: 8),
    DotPoint(id: 8, x: 0.75, y: 0.78, connectsTo: -1),
  ]),

  // ── マ行 ──
  JChar(japanese: 'マ', romaji: 'ma', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.28, connectsTo: -1),
    // stroke 2: left diagonal
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 3: right short diagonal
    DotPoint(id: 5, x: 0.52, y: 0.45, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ミ', romaji: 'mi', dots: [
    // stroke 1: short top horizontal
    DotPoint(id: 1, x: 0.32, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.72, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.25, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.50, connectsTo: -1),
    // stroke 3: longer bottom horizontal
    DotPoint(id: 5, x: 0.18, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.82, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'ム', romaji: 'mu', dots: [
    // stroke 1: left-up diagonal to top
    DotPoint(id: 1, x: 0.22, y: 0.55, connectsTo: 2),
    DotPoint(id: 2, x: 0.50, y: 0.18, connectsTo: 3),
    // stroke 2: continue down right into bottom loop
    DotPoint(id: 3, x: 0.78, y: 0.55, connectsTo: 4),
    DotPoint(id: 4, x: 0.60, y: 0.75, connectsTo: 5),
    DotPoint(id: 5, x: 0.38, y: 0.75, connectsTo: 6),
    DotPoint(id: 6, x: 0.22, y: 0.55, connectsTo: -1),
    // stroke 3: bottom tail
    DotPoint(id: 7, x: 0.50, y: 0.75, connectsTo: 8),
    DotPoint(id: 8, x: 0.50, y: 0.88, connectsTo: -1),
  ]),
  JChar(japanese: 'メ', romaji: 'me', dots: [
    // stroke 1: left diagonal \
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.72, connectsTo: -1),
    // stroke 2: right diagonal /
    DotPoint(id: 3, x: 0.78, y: 0.30, connectsTo: 4),
    DotPoint(id: 4, x: 0.22, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'モ', romaji: 'mo', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.50, connectsTo: -1),
    // stroke 3: vertical
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: -1),
  ]),

  // ── ヤ行 ──
  JChar(japanese: 'ヤ', romaji: 'ya', dots: [
    // stroke 1: horizontal
    DotPoint(id: 1, x: 0.20, y: 0.38, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.38, connectsTo: -1),
    // stroke 2: left diagonal down
    DotPoint(id: 3, x: 0.38, y: 0.25, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 3: right short diagonal
    DotPoint(id: 5, x: 0.62, y: 0.25, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ユ', romaji: 'yu', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.25, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.75, y: 0.28, connectsTo: -1),
    // stroke 2: vertical
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.72, connectsTo: -1),
    // stroke 3: bottom horizontal
    DotPoint(id: 5, x: 0.18, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.82, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'ヨ', romaji: 'yo', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.26, y: 0.25, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.25, connectsTo: -1),
    // stroke 3: middle horizontal
    DotPoint(id: 5, x: 0.26, y: 0.50, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.50, connectsTo: -1),
    // stroke 4: bottom horizontal
    DotPoint(id: 7, x: 0.26, y: 0.75, connectsTo: 8),
    DotPoint(id: 8, x: 0.75, y: 0.75, connectsTo: -1),
  ]),

  // ── ラ行 ──
  JChar(japanese: 'ラ', romaji: 'ra', dots: [
    // stroke 1: horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: diagonal down-left
    DotPoint(id: 3, x: 0.55, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.35, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'リ', romaji: 'ri', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.35, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.35, y: 0.78, connectsTo: -1),
    // stroke 2: right vertical
    DotPoint(id: 3, x: 0.65, y: 0.20, connectsTo: 4),
    DotPoint(id: 4, x: 0.65, y: 0.78, connectsTo: -1),
  ]),
  JChar(japanese: 'ル', romaji: 'ru', dots: [
    // stroke 1: left vertical + bottom foot right
    DotPoint(id: 1, x: 0.32, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.30, y: 0.62, connectsTo: 3),
    DotPoint(id: 3, x: 0.50, y: 0.82, connectsTo: -1),
    // stroke 2: right vertical + bottom foot right
    DotPoint(id: 4, x: 0.65, y: 0.20, connectsTo: 5),
    DotPoint(id: 5, x: 0.62, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'レ', romaji: 're', dots: [
    // single stroke: vertical + diagonal foot right
    DotPoint(id: 1, x: 0.40, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.38, y: 0.65, connectsTo: 3),
    DotPoint(id: 3, x: 0.65, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ロ', romaji: 'ro', dots: [
    // rectangle
    DotPoint(id: 1, x: 0.25, y: 0.22, connectsTo: 2),
    DotPoint(id: 2, x: 0.75, y: 0.22, connectsTo: 3),
    DotPoint(id: 3, x: 0.75, y: 0.78, connectsTo: 4),
    DotPoint(id: 4, x: 0.25, y: 0.78, connectsTo: 5),
    DotPoint(id: 5, x: 0.25, y: 0.22, connectsTo: -1),
  ]),

  // ── ワ行 ──
  JChar(japanese: 'ワ', romaji: 'wa', dots: [
    // stroke 1: horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: right vertical down
    DotPoint(id: 3, x: 0.75, y: 0.25, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.82, connectsTo: -1),
    // stroke 3: left diagonal
    DotPoint(id: 5, x: 0.42, y: 0.18, connectsTo: 6),
    DotPoint(id: 6, x: 0.35, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ヲ', romaji: 'wo', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.20, y: 0.45, connectsTo: 4),
    DotPoint(id: 4, x: 0.80, y: 0.45, connectsTo: -1),
    // stroke 3: left diagonal down
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.35, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'ン', romaji: 'n', dots: [
    // stroke 1: left short tick down
    DotPoint(id: 1, x: 0.30, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.40, y: 0.45, connectsTo: -1),
    // stroke 2: right diagonal down-left
    DotPoint(id: 3, x: 0.68, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.75, connectsTo: -1),
  ]),
];
