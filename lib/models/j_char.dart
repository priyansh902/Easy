

class JChar {
  final String japanese;
  final String romaji;
  final String meaning; // used for kanji
  final List<DotPoint> dots; // for connect-the-dots mode

  const JChar({
    required this.japanese,
    required this.romaji,
    this.meaning = '',
    this.dots = const [],
  });
}

class DotPoint {
  final int id;
  final double x; // 0.0 – 1.0 normalized
  final double y;
  final int connectsTo; // next dot id (-1 = end of stroke)

  const DotPoint({
    required this.id,
    required this.x,
    required this.y,
    required this.connectsTo,
  });
}
