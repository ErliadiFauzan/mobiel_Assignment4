import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TambahKamar_Controller.dart';

class TambahKamarView extends StatelessWidget {
  final TambahKamarController controller = Get.put(TambahKamarController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Tambah Kamar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Room name input
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
              // Room price input
              TextField(
                controller: controller.roomPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Kamar (Rp)",
                  fillColor: Colors.grey.shade300,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Image upload button and image display
              Obx(() => Container(
                height: 150,
                width: screenWidth - 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: controller.selectedImage.value == null
                    ? Image.asset(
                  'assets/kost2.jpg', // Default image from assets
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    controller.selectedImage.value!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              )),
              const SizedBox(height: 20),
              // Room description input
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
              // Add room button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: controller.addRoom,
                child: const Text("Tambah Kamar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
