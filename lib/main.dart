import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'themes/dark_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // AdminHomeScreen
import 'screens/event_screen.dart'; // EventSelectionScreen
import 'screens/dashboard_screen.dart'; // DashboardScreen
import 'screens/qr_scanner_screen.dart'; // QRScannerScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clockin Admin',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => AdminHomeScreen());
          case '/events':
            return MaterialPageRoute(
                builder: (_) => EventSelectionScreen(eventName: ''));
          case '/dashboard':
            final eventName = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => DashboardScreen(eventName: eventName));
          case '/scanner':
            final eventName = settings.arguments as String;
            return MaterialPageRoute(
                builder: (_) => QRScannerScreen(eventName: eventName));
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}'))),
            );
        }
      },
    );
  }
}
