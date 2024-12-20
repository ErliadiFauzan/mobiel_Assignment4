import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kostku/app/routes/app_pages.dart';

class EditKamarController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Controllers untuk text fields
  var roomNameController = TextEditingController();
  var roomDescriptionController = TextEditingController();
  var roomPriceController = TextEditingController();

  RxBool isLoading = false.obs;

  // Method untuk mengambil data kamar dari Firestore
  Future<void> fetchRoomData(String roomId) async {
    try {
      DocumentSnapshot roomDoc = await _firebaseFirestore
          .collection('rooms')
          .doc(roomId)
          .get();

      if (roomDoc.exists) {
        roomNameController.text = roomDoc['room_name'];
        roomDescriptionController.text = roomDoc['room_description'];
        roomPriceController.text = roomDoc['room_price'].toString();
      }
    } catch (e) {
      print("Error fetching room data: $e");
    }
  }

  // Method untuk memperbarui data kamar
  Future<void> updateRoom(String roomId) async {

    try {
      isLoading.value = true;

      await _firebaseFirestore
          .collection('rooms')
          .doc(roomId)
          .update({
        'room_name': roomNameController.text,
        'room_description': roomDescriptionController.text,
        'room_price': roomPriceController.text,
        'updated_at': Timestamp.now(),
      });

      isLoading.value = false;
      Get.snackbar('Success', 'Room updated successfully');
      Get.offNamed(Routes.SETINGS);
    } catch (e) {
      isLoading.value = false;
      print("Error updating room: $e");
      Get.snackbar('Error', 'Failed to update room');
    }
  }
}
