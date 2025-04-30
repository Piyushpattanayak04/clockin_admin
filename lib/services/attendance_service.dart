// attendance_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Marks a single sub-event (like 'checkin') as true for a member
  static Future<void> markAttendance({
    required String eventName,
    required String teamName,
    required String memberName,
    required String field,
  }) async {
    final docRef = _firestore
        .collection('tickets')
        .doc(eventName)
        .collection('teams')
        .doc(teamName)
        .collection('members')
        .doc(memberName);

    await docRef.update({field: true});
  }

  /// Resets all sub-events to false, based on event config
  static Future<void> resetAttendance({
    required String eventName,
    required String teamName,
    required String memberName,
  }) async {
    final subEvents = await _getSubEvents(eventName);

    if (subEvents.isEmpty) return;

    final resetMap = {for (var field in subEvents) field: false};

    final docRef = _firestore
        .collection('tickets')
        .doc(eventName)
        .collection('teams')
        .doc(teamName)
        .collection('members')
        .doc(memberName);

    await docRef.update(resetMap);
  }

  /// Gets the list of sub-event fields configured for a given event
  static Future<List<String>> _getSubEvents(String eventName) async {
    final docSnapshot = await _firestore.collection('skeleton').doc(eventName).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      if (data['subEvents'] is List) {
        return List<String>.from(data['subEvents']);
      }
    }
    return [];
  }
}
