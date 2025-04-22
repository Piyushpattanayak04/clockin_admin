import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String eventName;
  const DashboardScreen({required this.eventName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedTeam; // filter by team

  Color getColor(bool status) => status ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    final teamsRef = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventName)
        .collection('teams');

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventName} Dashboard'),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: teamsRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final teamNames = snapshot.data!.docs.map((doc) => doc.id).toList()
                ..sort();

              return DropdownButton<String>(
                value: selectedTeam,
                hint: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("Filter by team", style: const TextStyle(color: Colors.white)),
                ),
                dropdownColor: Colors.grey[900],
                underline: const SizedBox(),
                onChanged: (value) => setState(() => selectedTeam = value == 'ALL_TEAMS' ? null : value),
                items: [
                  const DropdownMenuItem(
                    value: 'ALL_TEAMS',
                    child: Text("All teams"),
                  ),
                  ...teamNames.map((name) => DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  )),
                ],
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teamsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final teamDocs = snapshot.data!.docs;

          List<Widget> memberCards = [];

          for (var teamDoc in teamDocs) {
            final teamName = teamDoc.id;
            if (selectedTeam != null && teamName != selectedTeam) continue;

            final membersRef = teamsRef.doc(teamName).collection('members');

            memberCards.add(
              StreamBuilder<QuerySnapshot>(
                stream: membersRef.orderBy(FieldPath.documentId).snapshots(),
                builder: (context, memberSnapshot) {
                  if (!memberSnapshot.hasData) return const SizedBox();

                  final members = memberSnapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: members.map((memberDoc) {
                      final data = memberDoc.data() as Map<String, dynamic>;
                      final memberName = memberDoc.id;

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$memberName - $teamName",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatusIndicator("Check-in", data['checkin'] ?? false),
                                  _buildStatusIndicator("Lunch", data['lunch'] ?? false),
                                  _buildStatusIndicator("Dinner", data['dinner'] ?? false),
                                  _buildStatusIndicator("Checkout", data['checkout'] ?? false),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: memberCards,
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool status) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: getColor(status),
          radius: 10,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
