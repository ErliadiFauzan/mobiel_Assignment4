import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditController extends GetxController {
  // Observables for user data
  var createdAt = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var role = ''.obs;
  var isEditMode = false.obs; // Observable for edit mode

  // Controllers for the text fields
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data from Firebase Firestore
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        createdAt.value = userDoc['createdAt'].toDate().toString(); // Assuming createdAt is a timestamp
        firstName.value = userDoc['firstName'] ?? '';
        lastName.value = userDoc['lastName'] ?? '';
        email.value = userDoc['email'] ?? '';
        role.value = userDoc['role'] ?? '';

        // Set the controllers with the current values
        firstNameController.text = firstName.value;
        lastNameController.text = lastName.value;
      }
    }
  }

  // Toggle the edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  // Save updated user data to Firestore
  Future<void> saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
      });

      // After saving, update the observables to reflect the changes
      firstName.value = firstNameController.text;
      lastName.value = lastNameController.text;

      // Optionally, toggle off the edit mode
      toggleEditMode();
    }
  }
}
