import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _eventsCollection = _firestore.collection('events');

  // Fetch all events
  static Future<List<Event>> fetchEvents() async {
    try {
      final snapshot = await _eventsCollection.get();
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  // Fetch a single event by ID
  static Future<Event?> fetchEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return Event.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  // Add or update an event
  static Future<void> saveEvent(Event event) async {
    try {
      await _eventsCollection.doc(event.id).set(event.toMap());
    } catch (e) {
      print('Error saving event: $e');
    }
  }
}
