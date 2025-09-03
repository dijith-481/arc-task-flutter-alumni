import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/nord_theme.dart';
import 'pages/alumni_list_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AlumniApp());
}

class AlumniApp extends StatelessWidget {
  const AlumniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        final systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,

          systemNavigationBarColor: Colors.transparent,

          statusBarIconBrightness: isDarkMode
              ? Brightness.light
              : Brightness.dark,

          systemNavigationBarIconBrightness: isDarkMode
              ? Brightness.light
              : Brightness.dark,
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle,
          child: MaterialApp(
            title: 'Alumni List',
            theme: nordLightTheme,
            darkTheme: nordDarkTheme,
            themeMode: ThemeMode.system,
            home: const AlumniListPage(),
          ),
        );
      },
    );
  }
}
