import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home.dart';

void main() {
  runApp(const NihongoApp());
}

class NihongoApp extends StatelessWidget {
  const NihongoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essy — Learn Japanese',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
