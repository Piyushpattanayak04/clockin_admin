import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageEventScreen extends StatefulWidget {
  final String eventName;

  const ManageEventScreen({super.key, required this.eventName});

  @override
  State<ManageEventScreen> createState() => _ManageEventScreenState();
}

class _ManageEventScreenState extends State<ManageEventScreen> {
  List<String> subEvents = [];
  final TextEditingController _controller = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubEvents();
  }

  Future<void> _loadSubEvents() async {
    final doc = await FirebaseFirestore.instance
        .collection('skeleton')
        .doc(widget.eventName)
        .get();

    if (doc.exists && doc.data()!.containsKey('subEvents')) {
      setState(() {
        subEvents = List<String>.from(doc['subEvents']);
        isLoading = false;
      });
    } else {
      // If no document or subEvents, initialize empty
      await FirebaseFirestore.instance
          .collection('skeleton')
          .doc(widget.eventName)
          .set({'subEvents': []});
      setState(() {
        subEvents = [];
        isLoading = false;
      });
    }
  }

  Future<void> _addSubEvent(String name) async {
    if (name.trim().isEmpty) return;

    setState(() {
      subEvents.add(name);
    });

    await FirebaseFirestore.instance
        .collection('skeleton')
        .doc(widget.eventName)
        .update({'subEvents': subEvents});

    _controller.clear();
  }

  Future<void> _deleteSubEvent(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete SubEvent'),
        content: Text('Are you sure you want to delete "${subEvents[index]}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        subEvents.removeAt(index);
      });

      await FirebaseFirestore.instance
          .collection('skeleton')
          .doc(widget.eventName)
          .update({'subEvents': subEvents});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Event: ${widget.eventName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input to add new subevent
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'New SubEvent',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addSubEvent(_controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of subevents
            Expanded(
              child: ListView.builder(
                itemCount: subEvents.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(subEvents[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSubEvent(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
