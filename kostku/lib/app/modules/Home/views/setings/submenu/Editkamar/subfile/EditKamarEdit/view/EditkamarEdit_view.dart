import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/editedit_controller.dart';

class EdiEtKamarView extends StatelessWidget {
  final EditKamarController controller = Get.put(EditKamarController());

  // Mengambil roomId dari argument
  final String roomId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // Fetch data kamar saat halaman diinisialisasi
    controller.fetchRoomData(roomId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Edit Kamar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input Nama Kamar
              TextField(
                controller: controller.roomNameController,
                decoration: InputDecoration(
                  labelText: "Nama Kamar",
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input Deskripsi Kamar
              TextField(
                controller: controller.roomDescriptionController,
                decoration: InputDecoration(
                  labelText: "Deskripsi Kamar",
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              // Input Harga Kamar
              TextField(
                controller: controller.roomPriceController,
                decoration: InputDecoration(
                  labelText: "Harga Kamar (Rp)",
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Tombol Update
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  controller.updateRoom(roomId); // Update kamar
                },
                child: const Text("Update Kamar"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
