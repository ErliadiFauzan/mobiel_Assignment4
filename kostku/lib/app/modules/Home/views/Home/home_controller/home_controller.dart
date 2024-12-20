import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsController extends GetxController {
  // Observables
  var rooms = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRooms(); // Load rooms data when controller initializes
  }

  void fetchRooms() async {
    try {
      isLoading.value = true; // Show loading indicator
      var querySnapshot = await FirebaseFirestore.instance.collection('rooms').get();

      // Map Firestore documents to a list of maps
      rooms.value = querySnapshot.docs
          .map((doc) => {
        'id': doc.id, // Include the document ID
        ...doc.data() as Map<String, dynamic>
      })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch rooms: $e');
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }
}
