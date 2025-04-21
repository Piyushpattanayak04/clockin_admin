import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final DateTime date;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
  });

  // Factory to create Event from Firestore doc
  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  // Convert Event to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }
}
