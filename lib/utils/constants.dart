import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Hackathon Admin';

  // Firebase collection names
  static const String teamsCollection = 'teams';
  static const String eventsCollection = 'events';

  // QR scan status types
  static const List<String> scanTypes = [
    'checkin',
    'lunch',
    'dinner',
    'checkout',
  ];

  // App padding and spacing
  static const double defaultPadding = 16.0;
}

class AppColors {
  static const Color success = Colors.green;
  static const Color danger = Colors.red;
  static const Color primary = Colors.blueAccent;
  static const Color background = Color(0xFFF5F5F5);
}