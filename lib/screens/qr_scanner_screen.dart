import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'attendance_screen.dart';
import '../widgets/scanner_overlay.dart';

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
    scannerController.stop();

    try {
      final parts = code.split('_');
      if (parts.length < 4) throw 'Invalid QR format';
      final eventName = parts[0];
      final memberName = parts[1];
      final teamName = parts[2];
      final collegeName = parts[3];

      final snapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('qrCode', isEqualTo: code)
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Ticket not found')),
        );
        scannerController.start();
        return;
      }

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
