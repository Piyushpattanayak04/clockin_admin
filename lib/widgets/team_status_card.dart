import 'package:flutter/material.dart';
import '../models/team.dart';

class TeamStatusCard extends StatelessWidget {
  final Team team;

  const TeamStatusCard({Key? key, required this.team}) : super(key: key);

  Color _statusColor(bool status) => status ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(team.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusCircle('Checkin', team.checkin),
                _buildStatusCircle('Lunch', team.lunch),
                _buildStatusCircle('Dinner', team.dinner),
                _buildStatusCircle('Checkout', team.checkout),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCircle(String label, bool status) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: _statusColor(status),
          radius: 10,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12))
      ],
    );
  }
}
