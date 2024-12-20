import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Loading and password visibility observables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // Function for login using Email and Password
  Future<void> signInWithEmailAndPassword() async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Redirect to HOME without back navigation
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function for Google Sign-In (To be implemented as per your requirement)
  Future<void> signInWithGoogle() async {
    // Add your Google Sign-In logic here
    Get.snackbar(
      "Feature Unavailable",
      "Google Sign-In not implemented",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
