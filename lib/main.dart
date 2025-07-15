// File: lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tripstick/screens/login_screen.dart';
import 'package:tripstick/screens/main_screen.dart';
import 'package:tripstick/screens/signup_screen.dart';
import 'package:tripstick/screens/profile_screen.dart';
import 'package:tripstick/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/routes.dart';
import 'utils/constants.dart';

/// A global notifier to switch between light and dark themes.
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDRz95XrsM_YDDcNZAiW6qiT_biOJpxEeo",
        authDomain: "tripstick-615ef.firebaseapp.com",
        projectId: "tripstick-615ef",
        storageBucket: "tripstick-615ef.appspot.com",
        messagingSenderId: "1082138852451",
        appId: "1:1082138852451:web:your_web_app_id", // placeholder
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const TripstickApp());
}

class TripstickApp extends StatelessWidget {
  const TripstickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.indigo,
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.indigo,
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          initialRoute: Routes.welcome,
          routes: {
            Routes.welcome: (_) => const WelcomeScreen(),
            Routes.signup: (_) => const SignupScreen(),
            Routes.login: (_) => const LoginScreen(),
            Routes.home: (_) => const MainScreen(),
            Routes.profile: (_) => const ProfileScreen(),
          },
        );
      },
    );
  }
}
