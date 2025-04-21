import 'package:cloud_firestore/cloud_firestore.dart';

class QRService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getTeamByQRCode(String qrData) async {
    try {
      final querySnapshot = await _firestore.collection('teams').where('qrCode', isEqualTo: qrData).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print('Error fetching team by QR code: $e');
    }
    return null;
  }

  Future<void> updateScanStatus(String teamId, String statusType, bool status) async {
    try {
      await _firestore.collection('teams').doc(teamId).update({
        statusType: status,
      });
    } catch (e) {
      print('Error updating scan status: $e');
    }
  }

  Future<bool> hasAlreadyScanned(String teamId, String statusType) async {
    try {
      final docSnapshot = await _firestore.collection('teams').doc(teamId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?[statusType] == true;
      }
    } catch (e) {
      print('Error checking scan status: $e');
    }
    return false;
  }
}
