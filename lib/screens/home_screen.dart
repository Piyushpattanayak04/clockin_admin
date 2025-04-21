import 'package:flutter/material.dart';
import 'event_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  final List<String> events = ["Hack-o-Clock", "CodeFest", "Bug Bash"];

  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hackathon Hub')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(events[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventSelectionScreen(eventName: events[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
