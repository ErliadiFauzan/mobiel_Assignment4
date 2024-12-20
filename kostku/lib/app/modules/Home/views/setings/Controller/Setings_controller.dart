import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsController extends GetxController {
  var role = ''.obs; // To store user role (Pencari/Pemilik)
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  // Fetch user details (name and email) from Firebase based on the logged-in user
  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        firstName.value = userDoc['firstName'] ?? ''; // Set first name
        lastName.value = userDoc['lastName'] ?? ''; // Set last name
        email.value = userDoc['email'] ?? ''; // Set email
        role.value = userDoc['role'] ?? ''; // Set role
      }
    }
  }
}
