import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final String eventName;
  final String code; // teamName

  AttendanceScreen({required this.eventName, required this.code});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, bool> status = {
    'checkin': false,
    'lunch': false,
    'dinner': false,
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
        .doc(widget.code)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        status['checkin'] = data['checkin'] ?? false;
        status['lunch'] = data['lunch'] ?? false;
        status['dinner'] = data['dinner'] ?? false;
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
        .doc(widget.code)
        .set({type: true}, SetOptions(merge: true));

    setState(() {
      status[type] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $type marked')),
    );
  }

  Widget buildButton(String type, String label) {
    return ElevatedButton.icon(
      onPressed: () => markAttendance(type),
      icon: Icon(
        status[type]! ? Icons.check_circle : Icons.qr_code_scanner,
        color: status[type]! ? Colors.green : null,
      ),
      label: Text(status[type]! ? "$label ✅" : label),
      style: ElevatedButton.styleFrom(
        backgroundColor: status[type]! ? Colors.green.shade100 : null,
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
      appBar: AppBar(title: Text('Attendance - ${widget.code}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Team: ${widget.code}', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            buildButton('checkin', 'Check-in'),
            buildButton('lunch', 'Lunch'),
            buildButton('dinner', 'Dinner'),
            buildButton('checkout', 'Checkout'),
          ],
        ),
      ),
    );
  }
}
