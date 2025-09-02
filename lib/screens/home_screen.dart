import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_registration_screen.dart';
import 'event_screen.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('skeleton').get();
    setState(() {
      _events = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> _deleteEvent(String eventName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "$eventName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('skeleton').doc(eventName).delete();
      await _loadEvents();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeTab() {
    return _events.isEmpty
        ? const Center(child: Text('No events found.'))
        : ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final eventName = _events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(eventName),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEvent(eventName),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventScreen(eventName: eventName),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return buildHomeTab();
      case 1:
        return const QRScannerScreen(eventName: '');
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clockin Admin')),
      body: getBody(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () async {
          final newEventName = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(eventName: ''),
            ),
          );

          if (newEventName != null && newEventName is String && newEventName.isNotEmpty) {
            setState(() {
              _events.add(newEventName);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR Scanner',
          ),
        ],
      ),
    );
  }
}
