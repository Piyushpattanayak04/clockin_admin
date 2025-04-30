import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventName;

  const EventDetailsScreen({Key? key, required this.eventName}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _subEventController = TextEditingController();
  final List<String> subEvents = [];
  bool isProcessing = false;

  // Event creation function
  Future<void> createEvent() async {
    final eventName = _eventNameController.text.trim();

    // Validate event name and sub-events
    if (eventName.isEmpty || subEvents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event name and at least one sub-event.')),
      );
      return;
    }

    try {
      setState(() {
        isProcessing = true;
      });

      final eventDoc = FirebaseFirestore.instance.collection('skeleton').doc(eventName);
      await eventDoc.set({
        'eventName': eventName,
        'subEvents': subEvents,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event and sub-events created successfully!')),
      );

      Navigator.pop(context, eventName);  // Go back with event name
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  // Add sub-event logic
  void addSubEvent() {
    final subEvent = _subEventController.text.trim();
    if (subEvent.isNotEmpty && !subEvents.contains(subEvent)) {
      setState(() {
        subEvents.add(subEvent);
        _subEventController.clear();
      });
    } else if (subEvents.contains(subEvent)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duplicate sub-event not allowed.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.eventName.isNotEmpty) {
      _eventNameController.text = widget.eventName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _subEventController,
              decoration: InputDecoration(
                labelText: 'Add Sub-Event',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addSubEvent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: subEvents.map((e) {
                return Chip(
                  label: Text(e),
                  deleteIcon: const Icon(Icons.delete),
                  onDeleted: () {
                    setState(() {
                      subEvents.remove(e);
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isProcessing ? null : createEvent,  // Disable when processing
              child: isProcessing
                  ? const CircularProgressIndicator()  // Show loading indicator
                  : const Center(child: Text('Create Event')),
            ),
          ],
        ),
      ),
    );
  }
}
