import 'package:essy/services/progress.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
    // Init local storage — no network, no accounts, data stays on this device
  await ProgressStore.instance.init();
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
