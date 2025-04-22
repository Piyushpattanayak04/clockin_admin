import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final String eventName;
  final String teamName;
  final String memberName;

  AttendanceScreen({
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
        .doc(widget.teamName)
        .collection('members')
        .doc(widget.memberName)
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
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () => markAttendance(type),
        icon: Icon(
          status[type]! ? Icons.check_circle : Icons.qr_code_scanner,
          color: status[type]! ? Colors.green : null,
          size: 28,
        ),
        label: Text(
          status[type]! ? "$label ✅" : label,
          style: const TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: status[type]! ? Colors.grey.shade800 : null,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Name: ${widget.memberName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Team: ${widget.teamName}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                buildButton('checkin', 'Check-in'),
                const SizedBox(height: 20),
                buildButton('lunch', 'Lunch'),
                const SizedBox(height: 20),
                buildButton('dinner', 'Dinner'),
                const SizedBox(height: 20),
                buildButton('checkout', 'Checkout'),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

