import 'package:get/get.dart';

class ReviewController extends GetxController {
  var roomName = ''.obs;
  var roomDescription = ''.obs;
  var roomImage = ''.obs;
  var roomPrice = ''.obs;

  // Method untuk menginisialisasi data dari argument
  void setRoomData(Map<String, dynamic> data) {
    roomName.value = data['room_name'];
    roomDescription.value = data['room_description'];
    roomImage.value = 'assets/Kost2.jpg';
    roomPrice.value = data['room_price'];
  }
}
