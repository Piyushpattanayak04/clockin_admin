import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'attendance_screen.dart';
import '../widgets/scanner_overlay.dart'; // make sure this path matches your project structure

class QRScannerScreen extends StatefulWidget {
  final String eventName;

  QRScannerScreen({required this.eventName});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isProcessing = false;
  final MobileScannerController scannerController = MobileScannerController();

  void handleScan(String code) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    // Pause scanning to prevent duplicate reads
    scannerController.stop();

    final snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('qrCode', isEqualTo: code)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final eventName = data['eventName'];
      final teamName = data['teamName'];

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventName)
          .collection('teams')
          .doc(teamName)
          .set({'checkin': true}, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Check-in marked for $teamName')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendanceScreen(
            eventName: eventName,
            code: teamName,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Ticket not found')),
      );
      scannerController.start(); // Resume scanning if ticket not found
    }

    setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR - ${widget.eventName}')),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  handleScan(code);
                  break;
                }
              }
            },
          ),
          const ScannerOverlay(), // 👈 your custom overlay
        ],
      ),
    );
  }
}
