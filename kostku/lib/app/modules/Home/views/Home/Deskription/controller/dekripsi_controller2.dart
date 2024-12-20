import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClaimController extends GetxController {
  RxBool isClaimed = false.obs;  // To track if the room is already claimed
  RxString claimedByUserId = ''.obs;  // Store the userId who claimed the room

  // Function to fetch the claim status of the room
  void checkClaimStatus(String roomId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    DocumentSnapshot roomDoc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('claims')
        .doc(currentUser.uid)  // Check if the user has claimed this room
        .get();

    if (roomDoc.exists) {
      isClaimed.value = true;
      claimedByUserId.value = currentUser.uid; // Store who claimed it
    } else {
      isClaimed.value = false;
      claimedByUserId.value = ''; // No user has claimed it
    }
  }

  // Function to claim or unclaim a room
  void toggleClaim(String roomId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
    final claimsRef = roomRef.collection('claims');

    // Check if room is already claimed by someone else
    QuerySnapshot claimsSnapshot = await claimsRef.get();
    if (claimsSnapshot.docs.isNotEmpty) {
      // If room is already claimed by someone, prevent claiming
      Get.snackbar('Claim Failed', 'This room has already been claimed.');
      return;
    }

    if (isClaimed.value) {
      // Unclaim room (delete claim from Firestore)
      await claimsRef.doc(currentUser.uid).delete();
    } else {
      // Claim room (add claim to Firestore)
      await claimsRef.doc(currentUser.uid).set({
        'claimedAt': FieldValue.serverTimestamp(),
      });
    }

    // Update the local state
    isClaimed.value = !isClaimed.value;
  }
}