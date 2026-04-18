// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   static const Color red = Color(0xFFBC002D);
//   static const Color redLight = Color(0xFFE8001A);
//   static const Color redFaint = Color(0xFFFFF0F2);
//   static const Color ink = Color(0xFF1A1A2E);
//   static const Color inkLight = Color(0xFF4A4A6A);
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color offWhite = Color(0xFFFAF9F7);
//   static const Color border = Color(0xFFE8E4E0);
//   static const Color success = Color(0xFF2D8A4E);
//   static const Color successLight = Color(0xFFE8F5ED);

//   static ThemeData get theme => ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: red,
//           primary: red,
//           background: offWhite,
//         ),
//         scaffoldBackgroundColor: offWhite,
//         textTheme: GoogleFonts.notoSansJpTextTheme().copyWith(
//           displayLarge: GoogleFonts.playfairDisplay(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: ink,
//           ),
//           titleLarge: GoogleFonts.playfairDisplay(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: ink,
//           ),
//           bodyLarge: GoogleFonts.notoSansJp(fontSize: 16, color: ink),
//           bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: inkLight),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: white,
//           foregroundColor: ink,
//           elevation: 0,
//           centerTitle: true,
//           titleTextStyle: GoogleFonts.playfairDisplay(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: ink,
//           ),
//         ),
//       );
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color red         = Color(0xFFBC002D);
  static const Color redLight    = Color(0xFFE8001A);
  static const Color redFaint    = Color(0xFFFFF0F2);
  static const Color ink         = Color(0xFF1A1A2E);
  static const Color inkLight    = Color(0xFF4A4A6A);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color offWhite    = Color(0xFFFAF9F7);
  static const Color border      = Color(0xFFE8E4E0);
  static const Color success     = Color(0xFF2D8A4E);
  static const Color successLight = Color(0xFFE8F5ED);

  // Use GoogleFonts.notoSansJP which includes the full CJK character set
  // and downloads properly on Flutter Web, Android and iOS.
  static TextStyle kanjiStyle({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.notoSansJp(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: red,
          primary: red,
          background: offWhite,
        ),
        scaffoldBackgroundColor: offWhite,
        textTheme: GoogleFonts.notoSansJpTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
              fontSize: 32, fontWeight: FontWeight.w700, color: ink),
          titleLarge: GoogleFonts.playfairDisplay(
              fontSize: 22, fontWeight: FontWeight.w600, color: ink),
          bodyLarge:  GoogleFonts.notoSansJp(fontSize: 16, color: ink),
          bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: inkLight),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: white,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
              fontSize: 20, fontWeight: FontWeight.w700, color: ink),
        ),
      );
}
