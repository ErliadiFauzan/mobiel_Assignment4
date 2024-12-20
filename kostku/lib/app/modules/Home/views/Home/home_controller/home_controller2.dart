import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ClaimRoomController extends GetxController {
  var isLoading = true.obs;
  var roomStatus = <String, Color>{}.obs;

  @override
  void onInit() {
    super.onInit();
    checkRoomClaims();
  }

  // Fungsi untuk memeriksa koleksi 'claims'
  void checkRoomClaims() async {
    try {
      var roomsCollection = await FirebaseFirestore.instance.collection('rooms').get();

      for (var doc in roomsCollection.docs) {
        var roomId = doc.id;
        var claimsSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('claims')
            .get();

        // Menentukan status berdasarkan ada tidaknya claim
        roomStatus[roomId] = claimsSnapshot.docs.isEmpty ? Colors.green : Colors.red;
      }
    } catch (e) {
      print("Error checking claims: $e");
    } finally {
      isLoading(false);
    }
  }
}
