import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class KosDetailController extends GetxController {
  var roomData = {}.obs; // Menggunakan observasi untuk data kamar

  // Fungsi untuk mengambil data kamar berdasarkan ID
  void fetchRoomDetail(String roomId) async {
    try {
      var roomSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();
      if (roomSnapshot.exists) {
        roomData.value = roomSnapshot.data()!;
      }
    } catch (e) {
      print('Error fetching room details: $e');
    }
  }
}
