import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'attendance_screen.dart';
import '../widgets/scanner_overlay.dart';

class QRScannerScreen extends StatefulWidget {
  final String eventName;

  const QRScannerScreen({super.key, required this.eventName});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isProcessing = false;
  final MobileScannerController scannerController = MobileScannerController();

  void handleScan(String code) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);
    scannerController.stop();

    try {
      final parts = code.split('_');
      if (parts.length < 4) throw 'Invalid QR format';

      final eventName = parts[0];
      final memberName = parts[1];
      final teamName = parts[2];
      final collegeName = parts[3];

      final memberDoc = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(eventName)
          .collection('teams')
          .doc(teamName)
          .collection('members')
          .doc(memberName)
          .get();

      if (!memberDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Ticket not found')),
        );
        scannerController.start();
        return;
      }

      final data = memberDoc.data();
      if (data == null || data['qrCode'] != code) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Ticket mismatch')),
        );
        scannerController.start();
        return;
      }

      // Create attendance structure if it doesn't exist
      final attendanceMemberRef = FirebaseFirestore.instance
          .collection('events')
          .doc(eventName)
          .collection('teams')
          .doc(teamName)
          .collection('members')
          .doc(memberName);

      final attendanceDoc = await attendanceMemberRef.get();
      if (!attendanceDoc.exists) {
        // Create event document with field
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventName)
            .set({'eventName': eventName}, SetOptions(merge: true));

        // Create team document with field
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventName)
            .collection('teams')
            .doc(teamName)
            .set({'teamName': teamName}, SetOptions(merge: true));

        // Create member attendance fields
        await attendanceMemberRef.set({
          'checkin': false,
          'lunch': false,
          'snacks': false,
          'dinner': false,
          'midNi8Snacks': false,
          'attendance': false,
          'breakfast': false,
          'lunch2': false,
          'checkout': false,
        });
      }

      // Go to attendance screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttendanceScreen(
            eventName: eventName,
            teamName: teamName,
            memberName: memberName,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      scannerController.start();
    } finally {
      setState(() => isProcessing = false);
    }
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
              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null) {
                  handleScan(code);
                  break;
                }
              }
            },
          ),
          const ScannerOverlay(),
        ],
      ),
    );
  }
}
