import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController {
  var reviews = <String>[].obs;  // List of reviews
  var currentlyEditingIndex = Rx<int?>(null);  // Index of the review being edited
  var reviewTextController = TextEditingController();  // Controller for the TextField

  // Method to add a new review
  void addReview(String review) {
    reviews.add(review);
  }

  // Method to update a specific review
  void updateReview(String newReview) {
    if (currentlyEditingIndex.value != null) {
      reviews[currentlyEditingIndex.value!] = newReview;
      currentlyEditingIndex.value = null;  // Clear editing state after update
    }
  }

  // Method to delete a review
  void deleteReview(int index) {
    reviews.removeAt(index);
  }

  // Method to start editing a review
  void startEditing(int index) {
    reviewTextController.text = reviews[index];  // Set the text field to the selected review
    currentlyEditingIndex.value = index;  // Set the index of the review being edited
  }

  // Method to cancel editing
  void cancelEditing() {
    reviewTextController.clear();
    currentlyEditingIndex.value = null;
  }
}
