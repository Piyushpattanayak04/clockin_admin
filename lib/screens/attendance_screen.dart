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
  List<String> subevents = [];
  Map<String, bool> status = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch from skeleton
    final skeletonDoc = await FirebaseFirestore.instance
        .collection('skeleton')
        .doc(widget.eventName)
        .get();

    // Fetch member
    final memberDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventName)
        .collection('teams')
        .doc(widget.teamName)
        .collection('members')
        .doc(widget.memberName)
        .get();

    if (skeletonDoc.exists && memberDoc.exists) {
      final subeventList = List<String>.from(skeletonDoc.data()?['subEvents'] ?? []);
      final memberData = memberDoc.data()!;

      final fetchedStatus = <String, bool>{};
      for (final sub in subeventList) {
        fetchedStatus[sub] = memberData[sub] ?? false;
      }

      setState(() {
        subevents = subeventList;
        status = fetchedStatus;
        loading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load data.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> markAttendance(String subevent) async {
    if (status[subevent] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Already marked $subevent')),
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
        .set({subevent: true}, SetOptions(merge: true));

    setState(() {
      status[subevent] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $subevent marked')),
    );
  }

  Widget buildButton(String subevent) {
    final attended = status[subevent] == true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton.icon(
          onPressed: () => markAttendance(subevent),
          icon: Icon(
            attended ? Icons.check_circle : Icons.qr_code_scanner,
            color: attended ? Colors.green : null,
            size: 20,
          ),
          label: Text(
            attended ? "${_capitalize(subevent)} ✅" : _capitalize(subevent),
            style: const TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: attended ? Colors.grey.shade800 : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.memberName} - Attendance'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              ...subevents.map(buildButton).toList(),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
}
