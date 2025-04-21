import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  final String eventName;

  const DashboardScreen({required this.eventName});

  Color getColor(bool status) => status ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    final teamsRef = FirebaseFirestore.instance
        .collection('events')
        .doc(eventName)
        .collection('teams');

    return Scaffold(
      appBar: AppBar(title: Text('$eventName Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: teamsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No teams found."));
          }

          final teams = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final teamData = teams[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(teamData['teamName'] ?? 'Unnamed Team'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                              getColor(teamData['checkin'] ?? false),
                              radius: 8),
                          SizedBox(height: 4),
                          Text("Check-in", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                              getColor(teamData['lunch'] ?? false),
                              radius: 8),
                          SizedBox(height: 4),
                          Text("Lunch", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                              getColor(teamData['dinner'] ?? false),
                              radius: 8),
                          SizedBox(height: 4),
                          Text("Dinner", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                              getColor(teamData['checkout'] ?? false),
                              radius: 8),
                          SizedBox(height: 4),
                          Text("Checkout", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
