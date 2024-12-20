import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomController extends GetxController {
  // Firebase instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  RxList<QueryDocumentSnapshot> rooms = RxList<QueryDocumentSnapshot>();

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  // Fetch rooms data from Firestore
  Future<void> fetchRooms() async {
    try {
      var snapshot = await _firebaseFirestore
          .collection('rooms')
          .get();

      rooms.value = snapshot.docs;  // Store the fetched rooms in the RxList
    } catch (e) {
      print("Error fetching rooms: $e");
    }
  }

  // Delete room data from Firestore
  Future<void> deleteRoom(String roomId) async {
    try {
      await _firebaseFirestore
          .collection('rooms')
          .doc(roomId)
          .delete();
      fetchRooms();  // Refresh the room list after deletion
    } catch (e) {
      print("Error deleting room: $e");
    }
  }
}
