import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class SetingController2 extends GetxController {
  final ImagePicker _picker = ImagePicker(); // Object image picker
  final box = GetStorage(); // GetStorage untuk menyimpan data lokal

  var selectedImagePath = ''.obs; // Variable untuk menyimpan path image
  var isImageLoading = false.obs; // Variable untuk loading state

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication
  String get currentUserId => _auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onReady() {
    super.onReady();
    _loadStoredData();
  }

  // Function Future untuk menggunakan kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && currentUserId.isNotEmpty) {
        selectedImagePath.value = pickedFile.path;
        box.write('${currentUserId}_imagePath',
            pickedFile.path); // Menyimpan image path berdasarkan UID
      } else {
        print('No image selected or user not logged in.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  void _loadStoredData() {
    if (currentUserId.isNotEmpty) {
      selectedImagePath.value =
          box.read('${currentUserId}_imagePath') ?? ''; // Load data berdasarkan UID
    } else {
      print('No user logged in.');
    }
  }
}
