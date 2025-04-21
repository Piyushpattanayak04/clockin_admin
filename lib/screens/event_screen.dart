import 'package:flutter/material.dart';

class EventSelectionScreen extends StatelessWidget {
  final String eventName;

  const EventSelectionScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(eventName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard', arguments: eventName);
              },
              child: const Text('Dashboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanner', arguments: eventName);
              },
              child: const Text('QR Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
