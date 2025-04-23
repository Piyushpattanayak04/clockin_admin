import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final String eventName;
  final String teamName;
  final String memberName;

  const AttendanceScreen({
    required this.eventName,
    required this.teamName,
    required this.memberName,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, bool> status = {
    'checkin': false,
    'lunch': false,
    'snacks': false,
    'dinner': false,
    'midNi8Snacks': false,
    'attendance': false,
    'breakfast': false,
    'lunch2': false,
    'checkout': false,
  };

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventName)
        .collection('teams')
        .doc(widget.teamName)
        .collection('members')
        .doc(widget.memberName)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        status['checkin'] = data['checkin'] ?? false;
        status['lunch'] = data['lunch'] ?? false;
        status['snacks'] = data['snacks'] ?? false;
        status['dinner'] = data['dinner'] ?? false;
        status['midNi8Snacks'] = data['midNi8Snacks'] ?? false;
        status['attendance'] = data['attendance'] ?? false;
        status['breakfast'] = data['breakfast'] ?? false;
        status['lunch2'] = data['lunch2'] ?? false;
        status['checkout'] = data['checkout'] ?? false;
        loading = false;
      });
    }
  }

  Future<void> markAttendance(String type) async {
    if (status[type] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Already marked $type')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventName)
        .collection('teams')
        .doc(widget.teamName)
        .collection('members')
        .doc(widget.memberName)
        .set({type: true}, SetOptions(merge: true));

    setState(() {
      status[type] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $type marked')),
    );
  }

  Widget buildButton(String type, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton.icon(
          onPressed: () => markAttendance(type),
          icon: Icon(
            status[type]! ? Icons.check_circle : Icons.qr_code_scanner,
            color: status[type]! ? Colors.green : null,
            size: 20,
          ),
          label: Text(
            status[type]! ? "$label ✅" : label,
            style: const TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: status[type]! ? Colors.grey.shade800 : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.memberName} - Attendance'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.memberName}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Team: ${widget.teamName}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    buildButton('checkin', 'Check-in'),
                    buildButton('lunch', 'Lunch'),
                    buildButton('snacks', 'Snacks'),
                    buildButton('dinner', 'Dinner'),
                    buildButton('midNi8Snacks', 'Midnight Snacks'),
                    buildButton('attendance', 'Night Attendance'),
                    buildButton('breakfast', 'Breakfast'),
                    buildButton('lunch2', 'Lunch II'),
                    buildButton('checkout', 'Check-out'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
