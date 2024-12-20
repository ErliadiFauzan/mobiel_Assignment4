import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TambahKamarController extends GetxController {
  var selectedImage = Rxn<File>();
  var roomNameController = TextEditingController();
  var roomPriceController = TextEditingController();
  var roomDescriptionController = TextEditingController();

  // Pick image
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // Add room to Firebase
  Future<void> addRoom() async {
    String roomName = roomNameController.text;
    String roomPrice = roomPriceController.text;
    String roomDescription = roomDescriptionController.text;

    if (roomName.isNotEmpty && roomPrice.isNotEmpty && roomDescription.isNotEmpty) {
      try {
        // If no image is selected, use the default image from assets
        String imageUrl;
        if (selectedImage.value == null) {
          imageUrl = 'assets/kost2.jpg';  // Default image
        } else {
          // You can add your logic here to upload image to Firebase Storage
          // imageUrl = await uploadImageToFirebaseStorage(selectedImage.value);
          imageUrl = 'path_to_uploaded_image'; // Update this line if using Firebase Storage
        }

        // Save room data to Firestore (without userId)
        await FirebaseFirestore.instance.collection('rooms').add({
          'room_name': roomName,
          'room_price': roomPrice,
          'room_description': roomDescription,
          'room_image': imageUrl,
        });

        // Clear the form after saving
        roomNameController.clear();
        roomPriceController.clear();
        roomDescriptionController.clear();
        selectedImage.value = null;

        Get.snackbar('Success', 'Kamar berhasil ditambahkan!');
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan kamar: $e');
      }
    } else {
      Get.snackbar('Error', 'Harap lengkapi semua field.');
    }
  }
}
