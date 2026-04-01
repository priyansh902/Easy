import '../models/j_char.dart';

// Dots trace the actual visual shape of each character.
// connectsTo: -1 means lift pen (new stroke).
// Coordinates are 0.0–1.0 within the canvas.

const List<JChar> hiraganaList = [
  // ── あ行 ──
  JChar(japanese: 'あ', romaji: 'a', dots: [
    // stroke 1: horizontal top bar
    DotPoint(id: 1, x: 0.20, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.28, connectsTo: -1),
    // stroke 2: vertical down then curve right
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.48, connectsTo: -1),
    // stroke 3: loop bottom-left to bottom-right
    DotPoint(id: 5, x: 0.32, y: 0.52, connectsTo: 6),
    DotPoint(id: 6, x: 0.22, y: 0.70, connectsTo: 7),
    DotPoint(id: 7, x: 0.38, y: 0.85, connectsTo: 8),
    DotPoint(id: 8, x: 0.62, y: 0.85, connectsTo: 9),
    DotPoint(id: 9, x: 0.75, y: 0.68, connectsTo: 10),
    DotPoint(id: 10, x: 0.60, y: 0.52, connectsTo: -1),
  ]),
  JChar(japanese: 'い', romaji: 'i', dots: [
    // stroke 1: left curve down
    DotPoint(id: 1, x: 0.32, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.30, y: 0.55, connectsTo: 3),
    DotPoint(id: 3, x: 0.38, y: 0.78, connectsTo: -1),
    // stroke 2: right line down
    DotPoint(id: 4, x: 0.65, y: 0.20, connectsTo: 5),
    DotPoint(id: 5, x: 0.62, y: 0.55, connectsTo: 6),
    DotPoint(id: 6, x: 0.55, y: 0.78, connectsTo: -1),
  ]),
  JChar(japanese: 'う', romaji: 'u', dots: [
    // stroke 1: top dot/tick
    DotPoint(id: 1, x: 0.42, y: 0.15, connectsTo: 2),
    DotPoint(id: 2, x: 0.58, y: 0.22, connectsTo: -1),
    // stroke 2: arch top, down, loop
    DotPoint(id: 3, x: 0.35, y: 0.32, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.25, connectsTo: 5),
    DotPoint(id: 5, x: 0.65, y: 0.32, connectsTo: 6),
    DotPoint(id: 6, x: 0.68, y: 0.52, connectsTo: 7),
    DotPoint(id: 7, x: 0.55, y: 0.72, connectsTo: 8),
    DotPoint(id: 8, x: 0.38, y: 0.72, connectsTo: 9),
    DotPoint(id: 9, x: 0.28, y: 0.58, connectsTo: -1),
  ]),
  JChar(japanese: 'え', romaji: 'e', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: vertical down from center
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.48, connectsTo: -1),
    // stroke 3: lower left sweep
    DotPoint(id: 5, x: 0.25, y: 0.55, connectsTo: 6),
    DotPoint(id: 6, x: 0.45, y: 0.50, connectsTo: 7),
    DotPoint(id: 7, x: 0.68, y: 0.60, connectsTo: 8),
    DotPoint(id: 8, x: 0.55, y: 0.80, connectsTo: 9),
    DotPoint(id: 9, x: 0.30, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'お', romaji: 'o', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.32, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.30, y: 0.82, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.18, y: 0.32, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.32, connectsTo: -1),
    // stroke 3: right side loop
    DotPoint(id: 5, x: 0.58, y: 0.32, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.50, connectsTo: 7),
    DotPoint(id: 7, x: 0.60, y: 0.68, connectsTo: 8),
    DotPoint(id: 8, x: 0.40, y: 0.72, connectsTo: 9),
    DotPoint(id: 9, x: 0.30, y: 0.58, connectsTo: -1),
  ]),

  // ── か行 ──
  JChar(japanese: 'か', romaji: 'ka', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.30, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 2: horizontal crossing left
    DotPoint(id: 3, x: 0.20, y: 0.42, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.42, connectsTo: -1),
    // stroke 3: right branch down-right
    DotPoint(id: 5, x: 0.58, y: 0.42, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.65, connectsTo: 7),
    DotPoint(id: 7, x: 0.60, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'き', romaji: 'ki', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.25, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.25, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.48, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.48, connectsTo: -1),
    // stroke 3: vertical down
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.55, connectsTo: -1),
    // stroke 4: bottom sweep
    DotPoint(id: 7, x: 0.28, y: 0.62, connectsTo: 8),
    DotPoint(id: 8, x: 0.50, y: 0.58, connectsTo: 9),
    DotPoint(id: 9, x: 0.72, y: 0.68, connectsTo: 10),
    DotPoint(id: 10, x: 0.60, y: 0.85, connectsTo: -1),
  ]),
  JChar(japanese: 'く', romaji: 'ku', dots: [
    // single stroke: angle pointing left
    DotPoint(id: 1, x: 0.68, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.50, connectsTo: 3),
    DotPoint(id: 3, x: 0.68, y: 0.80, connectsTo: -1),
  ]),
  JChar(japanese: 'け', romaji: 'ke', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 2: horizontal bar
    DotPoint(id: 3, x: 0.24, y: 0.38, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.38, connectsTo: -1),
    // stroke 3: right vertical down with flick
    DotPoint(id: 5, x: 0.65, y: 0.38, connectsTo: 6),
    DotPoint(id: 6, x: 0.68, y: 0.68, connectsTo: 7),
    DotPoint(id: 7, x: 0.55, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'こ', romaji: 'ko', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: bottom horizontal connecting back left
    DotPoint(id: 3, x: 0.78, y: 0.70, connectsTo: 4),
    DotPoint(id: 4, x: 0.22, y: 0.70, connectsTo: -1),
  ]),

  // ── さ行 ──
  JChar(japanese: 'さ', romaji: 'sa', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: vertical from top
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.50, connectsTo: -1),
    // stroke 3: lower loop
    DotPoint(id: 5, x: 0.28, y: 0.58, connectsTo: 6),
    DotPoint(id: 6, x: 0.48, y: 0.52, connectsTo: 7),
    DotPoint(id: 7, x: 0.70, y: 0.62, connectsTo: 8),
    DotPoint(id: 8, x: 0.62, y: 0.80, connectsTo: 9),
    DotPoint(id: 9, x: 0.38, y: 0.85, connectsTo: -1),
  ]),
  JChar(japanese: 'し', romaji: 'shi', dots: [
    // single stroke: curve down then hook right
    DotPoint(id: 1, x: 0.45, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.42, y: 0.55, connectsTo: 3),
    DotPoint(id: 3, x: 0.45, y: 0.78, connectsTo: 4),
    DotPoint(id: 4, x: 0.62, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'す', romaji: 'su', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: vertical then loop
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.50, connectsTo: 5),
    DotPoint(id: 5, x: 0.68, y: 0.62, connectsTo: 6),
    DotPoint(id: 6, x: 0.52, y: 0.78, connectsTo: 7),
    DotPoint(id: 7, x: 0.35, y: 0.72, connectsTo: 8),
    DotPoint(id: 8, x: 0.30, y: 0.55, connectsTo: -1),
  ]),
  JChar(japanese: 'せ', romaji: 'se', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.82, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.24, y: 0.32, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.32, connectsTo: -1),
    // stroke 3: middle horizontal + right hook
    DotPoint(id: 5, x: 0.24, y: 0.55, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.55, connectsTo: 7),
    DotPoint(id: 7, x: 0.78, y: 0.68, connectsTo: 8),
    DotPoint(id: 8, x: 0.65, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'そ', romaji: 'so', dots: [
    // stroke 1: top arch
    DotPoint(id: 1, x: 0.25, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.75, y: 0.28, connectsTo: -1),
    // stroke 2: S-curve body
    DotPoint(id: 3, x: 0.55, y: 0.28, connectsTo: 4),
    DotPoint(id: 4, x: 0.72, y: 0.45, connectsTo: 5),
    DotPoint(id: 5, x: 0.38, y: 0.55, connectsTo: 6),
    DotPoint(id: 6, x: 0.62, y: 0.72, connectsTo: 7),
    DotPoint(id: 7, x: 0.50, y: 0.85, connectsTo: -1),
  ]),

  // ── た行 ──
  JChar(japanese: 'た', romaji: 'ta', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: left vertical
    DotPoint(id: 3, x: 0.45, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.42, y: 0.82, connectsTo: -1),
    // stroke 3: right side curve
    DotPoint(id: 5, x: 0.60, y: 0.28, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.45, connectsTo: 7),
    DotPoint(id: 7, x: 0.65, y: 0.65, connectsTo: 8),
    DotPoint(id: 8, x: 0.42, y: 0.68, connectsTo: -1),
  ]),
  JChar(japanese: 'ち', romaji: 'chi', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: vertical then round loop
    DotPoint(id: 3, x: 0.52, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.50, connectsTo: 5),
    DotPoint(id: 5, x: 0.32, y: 0.65, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.80, connectsTo: 7),
    DotPoint(id: 7, x: 0.70, y: 0.65, connectsTo: -1),
  ]),
  JChar(japanese: 'つ', romaji: 'tsu', dots: [
    // single stroke: arc from top-left sweeping right and curling back
    DotPoint(id: 1, x: 0.28, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.68, y: 0.22, connectsTo: 3),
    DotPoint(id: 3, x: 0.80, y: 0.42, connectsTo: 4),
    DotPoint(id: 4, x: 0.72, y: 0.65, connectsTo: 5),
    DotPoint(id: 5, x: 0.48, y: 0.78, connectsTo: 6),
    DotPoint(id: 6, x: 0.28, y: 0.68, connectsTo: -1),
  ]),
  JChar(japanese: 'て', romaji: 'te', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: cross vertical then hook down-left
    DotPoint(id: 3, x: 0.52, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.60, connectsTo: 5),
    DotPoint(id: 5, x: 0.55, y: 0.75, connectsTo: 6),
    DotPoint(id: 6, x: 0.42, y: 0.85, connectsTo: -1),
  ]),
  JChar(japanese: 'と', romaji: 'to', dots: [
    // stroke 1: short vertical
    DotPoint(id: 1, x: 0.40, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.38, y: 0.48, connectsTo: -1),
    // stroke 2: hook right and curve back
    DotPoint(id: 3, x: 0.28, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.42, y: 0.42, connectsTo: 5),
    DotPoint(id: 5, x: 0.70, y: 0.48, connectsTo: 6),
    DotPoint(id: 6, x: 0.75, y: 0.68, connectsTo: 7),
    DotPoint(id: 7, x: 0.55, y: 0.82, connectsTo: -1),
  ]),

  // ── な行 ──
  JChar(japanese: 'な', romaji: 'na', dots: [
    // stroke 1: left vertical short
    DotPoint(id: 1, x: 0.28, y: 0.22, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.65, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.22, y: 0.35, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.35, connectsTo: -1),
    // stroke 3: right vertical
    DotPoint(id: 5, x: 0.58, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.56, y: 0.52, connectsTo: 7),
    // loops
    DotPoint(id: 7, x: 0.38, y: 0.60, connectsTo: 8),
    DotPoint(id: 8, x: 0.52, y: 0.75, connectsTo: 9),
    DotPoint(id: 9, x: 0.70, y: 0.65, connectsTo: -1),
  ]),
  JChar(japanese: 'に', romaji: 'ni', dots: [
    // stroke 1: left short vertical
    DotPoint(id: 1, x: 0.28, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.58, connectsTo: -1),
    // stroke 2: middle horizontal bar
    DotPoint(id: 3, x: 0.22, y: 0.38, connectsTo: 4),
    DotPoint(id: 4, x: 0.68, y: 0.38, connectsTo: -1),
    // stroke 3: right vertical short
    DotPoint(id: 5, x: 0.62, y: 0.20, connectsTo: 6),
    DotPoint(id: 6, x: 0.60, y: 0.58, connectsTo: -1),
    // stroke 4: bottom long horizontal
    DotPoint(id: 7, x: 0.18, y: 0.72, connectsTo: 8),
    DotPoint(id: 8, x: 0.82, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'ぬ', romaji: 'nu', dots: [
    // stroke 1: left curve
    DotPoint(id: 1, x: 0.28, y: 0.22, connectsTo: 2),
    DotPoint(id: 2, x: 0.25, y: 0.55, connectsTo: 3),
    DotPoint(id: 3, x: 0.32, y: 0.72, connectsTo: -1),
    // stroke 2: right loop (ね-like)
    DotPoint(id: 4, x: 0.58, y: 0.22, connectsTo: 5),
    DotPoint(id: 5, x: 0.55, y: 0.48, connectsTo: 6),
    DotPoint(id: 6, x: 0.38, y: 0.60, connectsTo: 7),
    DotPoint(id: 7, x: 0.55, y: 0.75, connectsTo: 8),
    DotPoint(id: 8, x: 0.72, y: 0.62, connectsTo: 9),
    DotPoint(id: 9, x: 0.68, y: 0.78, connectsTo: 10),
    DotPoint(id: 10, x: 0.78, y: 0.88, connectsTo: -1),
  ]),
  JChar(japanese: 'ね', romaji: 'ne', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.68, connectsTo: -1),
    // stroke 2: horizontal then loop
    DotPoint(id: 3, x: 0.22, y: 0.36, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.36, connectsTo: -1),
    // stroke 3: right loop then tail
    DotPoint(id: 5, x: 0.58, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.56, y: 0.52, connectsTo: 7),
    DotPoint(id: 7, x: 0.38, y: 0.64, connectsTo: 8),
    DotPoint(id: 8, x: 0.55, y: 0.78, connectsTo: 9),
    DotPoint(id: 9, x: 0.72, y: 0.66, connectsTo: 10),
    DotPoint(id: 10, x: 0.68, y: 0.82, connectsTo: 11),
    DotPoint(id: 11, x: 0.52, y: 0.90, connectsTo: -1),
  ]),
  JChar(japanese: 'の', romaji: 'no', dots: [
    // single stroke: oval loop
    DotPoint(id: 1, x: 0.40, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.65, y: 0.32, connectsTo: 3),
    DotPoint(id: 3, x: 0.72, y: 0.55, connectsTo: 4),
    DotPoint(id: 4, x: 0.55, y: 0.75, connectsTo: 5),
    DotPoint(id: 5, x: 0.32, y: 0.72, connectsTo: 6),
    DotPoint(id: 6, x: 0.22, y: 0.50, connectsTo: 7),
    DotPoint(id: 7, x: 0.35, y: 0.32, connectsTo: -1),
  ]),

  // ── は行 ──
  JChar(japanese: 'は', romaji: 'ha', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.22, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.20, y: 0.82, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.18, y: 0.42, connectsTo: 4),
    DotPoint(id: 4, x: 0.80, y: 0.42, connectsTo: -1),
    // stroke 3: right bump
    DotPoint(id: 5, x: 0.60, y: 0.28, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.42, connectsTo: 7),
    DotPoint(id: 7, x: 0.80, y: 0.62, connectsTo: 8),
    DotPoint(id: 8, x: 0.65, y: 0.80, connectsTo: -1),
  ]),
  JChar(japanese: 'ひ', romaji: 'hi', dots: [
    // single stroke: left hook then rightward arch back
    DotPoint(id: 1, x: 0.25, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.42, y: 0.42, connectsTo: 3),
    DotPoint(id: 3, x: 0.32, y: 0.65, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.78, connectsTo: 5),
    DotPoint(id: 5, x: 0.72, y: 0.65, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.42, connectsTo: 7),
    DotPoint(id: 7, x: 0.65, y: 0.28, connectsTo: -1),
  ]),
  JChar(japanese: 'ふ', romaji: 'fu', dots: [
    // stroke 1: top horizontal tick
    DotPoint(id: 1, x: 0.38, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.62, y: 0.18, connectsTo: -1),
    // stroke 2: center down
    DotPoint(id: 3, x: 0.50, y: 0.12, connectsTo: 4),
    DotPoint(id: 4, x: 0.50, y: 0.40, connectsTo: -1),
    // stroke 3: left bottom curve
    DotPoint(id: 5, x: 0.22, y: 0.52, connectsTo: 6),
    DotPoint(id: 6, x: 0.35, y: 0.68, connectsTo: 7),
    DotPoint(id: 7, x: 0.50, y: 0.75, connectsTo: -1),
    // stroke 4: right bottom curve
    DotPoint(id: 8, x: 0.78, y: 0.52, connectsTo: 9),
    DotPoint(id: 9, x: 0.65, y: 0.68, connectsTo: 10),
    DotPoint(id: 10, x: 0.50, y: 0.75, connectsTo: -1),
  ]),
  JChar(japanese: 'へ', romaji: 'he', dots: [
    // single stroke: ^ shape
    DotPoint(id: 1, x: 0.20, y: 0.55, connectsTo: 2),
    DotPoint(id: 2, x: 0.50, y: 0.25, connectsTo: 3),
    DotPoint(id: 3, x: 0.80, y: 0.55, connectsTo: -1),
  ]),
  JChar(japanese: 'ほ', romaji: 'ho', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.82, connectsTo: -1),
    // stroke 2: top horizontal
    DotPoint(id: 3, x: 0.22, y: 0.32, connectsTo: 4),
    DotPoint(id: 4, x: 0.75, y: 0.32, connectsTo: -1),
    // stroke 3: right vertical down then bump
    DotPoint(id: 5, x: 0.62, y: 0.22, connectsTo: 6),
    DotPoint(id: 6, x: 0.65, y: 0.82, connectsTo: -1),
    // stroke 4: right bump
    DotPoint(id: 7, x: 0.62, y: 0.55, connectsTo: 8),
    DotPoint(id: 8, x: 0.78, y: 0.65, connectsTo: 9),
    DotPoint(id: 9, x: 0.65, y: 0.75, connectsTo: -1),
  ]),

  // ── ま行 ──
  JChar(japanese: 'ま', romaji: 'ma', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.30, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.30, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.50, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.50, connectsTo: -1),
    // stroke 3: vertical then loop
    DotPoint(id: 5, x: 0.50, y: 0.18, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.58, connectsTo: 7),
    DotPoint(id: 7, x: 0.32, y: 0.70, connectsTo: 8),
    DotPoint(id: 8, x: 0.50, y: 0.83, connectsTo: 9),
    DotPoint(id: 9, x: 0.68, y: 0.70, connectsTo: -1),
  ]),
  JChar(japanese: 'み', romaji: 'mi', dots: [
    // stroke 1: left hook
    DotPoint(id: 1, x: 0.22, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.55, y: 0.32, connectsTo: 3),
    DotPoint(id: 3, x: 0.50, y: 0.52, connectsTo: 4),
    DotPoint(id: 4, x: 0.28, y: 0.60, connectsTo: 5),
    DotPoint(id: 5, x: 0.22, y: 0.78, connectsTo: -1),
    // stroke 2: right arch
    DotPoint(id: 6, x: 0.65, y: 0.20, connectsTo: 7),
    DotPoint(id: 7, x: 0.78, y: 0.48, connectsTo: 8),
    DotPoint(id: 8, x: 0.62, y: 0.68, connectsTo: 9),
    DotPoint(id: 9, x: 0.48, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'む', romaji: 'mu', dots: [
    // stroke 1: left short bar
    DotPoint(id: 1, x: 0.22, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.45, y: 0.32, connectsTo: -1),
    // stroke 2: big loop body
    DotPoint(id: 3, x: 0.45, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.45, y: 0.52, connectsTo: 5),
    DotPoint(id: 5, x: 0.28, y: 0.65, connectsTo: 6),
    DotPoint(id: 6, x: 0.45, y: 0.78, connectsTo: 7),
    DotPoint(id: 7, x: 0.68, y: 0.65, connectsTo: 8),
    DotPoint(id: 8, x: 0.75, y: 0.48, connectsTo: 9),
    DotPoint(id: 9, x: 0.72, y: 0.72, connectsTo: 10),
    DotPoint(id: 10, x: 0.82, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'め', romaji: 'me', dots: [
    // stroke 1: left side
    DotPoint(id: 1, x: 0.25, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.22, y: 0.68, connectsTo: -1),
    // stroke 2: right loop cross
    DotPoint(id: 3, x: 0.55, y: 0.22, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.38, connectsTo: 5),
    DotPoint(id: 5, x: 0.72, y: 0.60, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.72, connectsTo: 7),
    DotPoint(id: 7, x: 0.32, y: 0.60, connectsTo: 8),
    DotPoint(id: 8, x: 0.38, y: 0.42, connectsTo: 9),
    DotPoint(id: 9, x: 0.60, y: 0.52, connectsTo: -1),
  ]),
  JChar(japanese: 'も', romaji: 'mo', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.32, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.32, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.22, y: 0.52, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.52, connectsTo: -1),
    // stroke 3: vertical into loop
    DotPoint(id: 5, x: 0.50, y: 0.18, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.58, connectsTo: 7),
    DotPoint(id: 7, x: 0.32, y: 0.70, connectsTo: 8),
    DotPoint(id: 8, x: 0.50, y: 0.82, connectsTo: 9),
    DotPoint(id: 9, x: 0.68, y: 0.70, connectsTo: -1),
  ]),

  // ── や行 ──
  JChar(japanese: 'や', romaji: 'ya', dots: [
    // stroke 1: left curve down
    DotPoint(id: 1, x: 0.25, y: 0.38, connectsTo: 2),
    DotPoint(id: 2, x: 0.50, y: 0.25, connectsTo: 3),
    DotPoint(id: 3, x: 0.50, y: 0.58, connectsTo: 4),
    DotPoint(id: 4, x: 0.32, y: 0.70, connectsTo: 5),
    DotPoint(id: 5, x: 0.50, y: 0.82, connectsTo: 6),
    DotPoint(id: 6, x: 0.68, y: 0.70, connectsTo: 7),
    DotPoint(id: 7, x: 0.75, y: 0.85, connectsTo: -1),
  ]),
  JChar(japanese: 'ゆ', romaji: 'yu', dots: [
    // stroke 1: left loop
    DotPoint(id: 1, x: 0.22, y: 0.38, connectsTo: 2),
    DotPoint(id: 2, x: 0.36, y: 0.25, connectsTo: 3),
    DotPoint(id: 3, x: 0.36, y: 0.58, connectsTo: 4),
    DotPoint(id: 4, x: 0.22, y: 0.68, connectsTo: -1),
    // stroke 2: right side
    DotPoint(id: 5, x: 0.55, y: 0.35, connectsTo: 6),
    DotPoint(id: 6, x: 0.78, y: 0.35, connectsTo: 7),
    DotPoint(id: 7, x: 0.78, y: 0.62, connectsTo: 8),
    DotPoint(id: 8, x: 0.55, y: 0.62, connectsTo: -1),
    DotPoint(id: 9, x: 0.66, y: 0.62, connectsTo: 10),
    DotPoint(id: 10, x: 0.66, y: 0.82, connectsTo: -1),
  ]),
  JChar(japanese: 'よ', romaji: 'yo', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.35, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.35, y: 0.52, connectsTo: 4),
    DotPoint(id: 4, x: 0.78, y: 0.52, connectsTo: -1),
    // stroke 3: right vertical into bottom loop
    DotPoint(id: 5, x: 0.58, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.58, y: 0.60, connectsTo: 7),
    DotPoint(id: 7, x: 0.40, y: 0.72, connectsTo: 8),
    DotPoint(id: 8, x: 0.58, y: 0.85, connectsTo: 9),
    DotPoint(id: 9, x: 0.75, y: 0.72, connectsTo: -1),
  ]),

  // ── ら行 ──
  JChar(japanese: 'ら', romaji: 'ra', dots: [
    // stroke 1: short top horizontal
    DotPoint(id: 1, x: 0.25, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.75, y: 0.28, connectsTo: -1),
    // stroke 2: vertical then hook right
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.48, y: 0.52, connectsTo: 5),
    DotPoint(id: 5, x: 0.32, y: 0.68, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.82, connectsTo: 7),
    DotPoint(id: 7, x: 0.70, y: 0.68, connectsTo: -1),
  ]),
  JChar(japanese: 'り', romaji: 'ri', dots: [
    // stroke 1: left curve down
    DotPoint(id: 1, x: 0.30, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.28, y: 0.62, connectsTo: 3),
    DotPoint(id: 3, x: 0.38, y: 0.78, connectsTo: -1),
    // stroke 2: right vertical
    DotPoint(id: 4, x: 0.65, y: 0.20, connectsTo: 5),
    DotPoint(id: 5, x: 0.62, y: 0.68, connectsTo: -1),
  ]),
  JChar(japanese: 'る', romaji: 'ru', dots: [
    // stroke 1: top bar
    DotPoint(id: 1, x: 0.30, y: 0.20, connectsTo: 2),
    DotPoint(id: 2, x: 0.65, y: 0.20, connectsTo: -1),
    // stroke 2: vertical then loop
    DotPoint(id: 3, x: 0.48, y: 0.12, connectsTo: 4),
    DotPoint(id: 4, x: 0.46, y: 0.48, connectsTo: 5),
    DotPoint(id: 5, x: 0.28, y: 0.60, connectsTo: 6),
    DotPoint(id: 6, x: 0.48, y: 0.75, connectsTo: 7),
    DotPoint(id: 7, x: 0.70, y: 0.62, connectsTo: 8),
    DotPoint(id: 8, x: 0.65, y: 0.80, connectsTo: 9),
    DotPoint(id: 9, x: 0.50, y: 0.88, connectsTo: -1),
  ]),
  JChar(japanese: 'れ', romaji: 're', dots: [
    // stroke 1: left vertical
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.68, connectsTo: -1),
    // stroke 2: horizontal then right side loop
    DotPoint(id: 3, x: 0.22, y: 0.38, connectsTo: 4),
    DotPoint(id: 4, x: 0.72, y: 0.38, connectsTo: -1),
    DotPoint(id: 5, x: 0.58, y: 0.25, connectsTo: 6),
    DotPoint(id: 6, x: 0.72, y: 0.38, connectsTo: 7),
    DotPoint(id: 7, x: 0.75, y: 0.58, connectsTo: 8),
    DotPoint(id: 8, x: 0.60, y: 0.72, connectsTo: 9),
    DotPoint(id: 9, x: 0.42, y: 0.78, connectsTo: -1),
  ]),
  JChar(japanese: 'ろ', romaji: 'ro', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.22, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.78, y: 0.28, connectsTo: -1),
    // stroke 2: loop body (like る without first bar)
    DotPoint(id: 3, x: 0.50, y: 0.15, connectsTo: 4),
    DotPoint(id: 4, x: 0.48, y: 0.52, connectsTo: 5),
    DotPoint(id: 5, x: 0.28, y: 0.65, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.80, connectsTo: 7),
    DotPoint(id: 7, x: 0.72, y: 0.65, connectsTo: -1),
  ]),

  // ── わ行 ──
  JChar(japanese: 'わ', romaji: 'wa', dots: [
    // stroke 1: left vertical with hook
    DotPoint(id: 1, x: 0.28, y: 0.18, connectsTo: 2),
    DotPoint(id: 2, x: 0.26, y: 0.62, connectsTo: 3),
    DotPoint(id: 3, x: 0.32, y: 0.78, connectsTo: -1),
    // stroke 2: right arch then curve
    DotPoint(id: 4, x: 0.55, y: 0.22, connectsTo: 5),
    DotPoint(id: 5, x: 0.75, y: 0.40, connectsTo: 6),
    DotPoint(id: 6, x: 0.60, y: 0.60, connectsTo: 7),
    DotPoint(id: 7, x: 0.44, y: 0.72, connectsTo: -1),
  ]),
  JChar(japanese: 'を', romaji: 'wo', dots: [
    // stroke 1: top horizontal
    DotPoint(id: 1, x: 0.20, y: 0.28, connectsTo: 2),
    DotPoint(id: 2, x: 0.80, y: 0.28, connectsTo: -1),
    // stroke 2: middle horizontal
    DotPoint(id: 3, x: 0.20, y: 0.45, connectsTo: 4),
    DotPoint(id: 4, x: 0.80, y: 0.45, connectsTo: -1),
    // stroke 3: vertical + bottom loop
    DotPoint(id: 5, x: 0.50, y: 0.15, connectsTo: 6),
    DotPoint(id: 6, x: 0.50, y: 0.52, connectsTo: 7),
    DotPoint(id: 7, x: 0.32, y: 0.65, connectsTo: 8),
    DotPoint(id: 8, x: 0.50, y: 0.80, connectsTo: 9),
    DotPoint(id: 9, x: 0.68, y: 0.65, connectsTo: -1),
  ]),
  JChar(japanese: 'ん', romaji: 'n', dots: [
    // single stroke: small arch then tail
    DotPoint(id: 1, x: 0.38, y: 0.22, connectsTo: 2),
    DotPoint(id: 2, x: 0.62, y: 0.22, connectsTo: -1),
    DotPoint(id: 3, x: 0.50, y: 0.18, connectsTo: 4),
    DotPoint(id: 4, x: 0.52, y: 0.55, connectsTo: 5),
    DotPoint(id: 5, x: 0.36, y: 0.70, connectsTo: 6),
    DotPoint(id: 6, x: 0.52, y: 0.82, connectsTo: 7),
    DotPoint(id: 7, x: 0.68, y: 0.70, connectsTo: -1),
  ]),
];
