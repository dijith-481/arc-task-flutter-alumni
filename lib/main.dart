import 'package:flutter/material.dart';
import 'theme/nord_theme.dart';
import 'pages/alumni_list_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AlumniApp());
}

class AlumniApp extends StatelessWidget {
  const AlumniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alumni List',

      theme: nordLightTheme,
      darkTheme: nordDarkTheme,
      themeMode: ThemeMode.system,
      home: const AlumniListPage(),
    );
  }
}
