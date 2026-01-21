// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';  // ← Comment
// import 'firebase_options.dart';  // ← Comment
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen_vibrant.dart';
import 'screens/habit_tracker_screen_vibrant.dart';
import 'screens/camera_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/social_forest_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/privacy_screen.dart';
import 'models/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Comment Firebase initialization
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } catch (e) {
  //   print('Firebase initialization error: $e');
  // }
  
  // Set portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(EcoPetApp());
  });
}

class EcoPetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      child: MaterialApp(
        title: 'EcoPet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Color(0xFFF5F9F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/onboarding': (context) => OnboardingScreen(),
          '/home': (context) => HomeScreen(),
          '/habits': (context) => HabitTrackerScreen(),
          '/camera': (context) => CameraScreen(),
          '/statistics': (context) => StatisticsScreen(),
          '/social': (context) => SocialForestScreen(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen(),
          '/privacy': (context) => PrivacyScreen(),
        },
      ),
    );
  }
}