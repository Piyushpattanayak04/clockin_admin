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
      appBar: AppBar(
        title: Text('$eventName Dashboard'),
      ),
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
              final teamName = teamData['teamName'] ?? 'Unnamed Team';
              final members = (teamData['members'] as List?)?.join(', ') ??
                  'No members';

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teamName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 4),
                      Text("Members: $members",
                          style: const TextStyle(fontSize: 14,
                              color: Colors.grey)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatusIndicator(
                              "Check-in", teamData['checkin'] ?? false),
                          _buildStatusIndicator(
                              "Lunch", teamData['lunch'] ?? false),
                          _buildStatusIndicator(
                              "Dinner", teamData['dinner'] ?? false),
                          _buildStatusIndicator(
                              "Checkout", teamData['checkout'] ?? false),
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

  Widget _buildStatusIndicator(String label, bool status) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: status ? Colors.green : Colors.red,
          radius: 10,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
