import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kostku/app/routes/app_pages.dart';
import '../Controller/Setings_controller.dart';
import '../Controller/profile_controller.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final SetingController2 controller1 = Get.put(SetingController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Get.offNamed(Routes.HOME);
          } else if (index == 1) {
            Get.offNamed(Routes.SETINGS);
          }
        },
      ),
      body: Column(
        children: [
          // Header with Profile Image, Name, Email, Role
          Container(
            color: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    // Tampilkan dialog untuk memilih antara kamera atau galeri
                    _showImageSourceDialog(context);
                  },
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      backgroundImage: controller1.selectedImagePath.value.isNotEmpty
                          ? FileImage(File(controller1.selectedImagePath.value))
                          : null,
                      child: controller1.selectedImagePath.value.isEmpty
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30.0,
                      )
                          : null, // Tampilkan ikon kamera jika belum ada gambar
                    );
                  }),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        '${controller.firstName.value} ${controller.lastName.value}',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      );
                    }),
                    Obx(() {
                      return Text(
                        controller.email.value,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      );
                    }),
                    Obx(() {
                      return Text(
                        controller.role.value,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          // Menu options
          Expanded(
            child: Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.black),
                    title: Text("Edit Akun"),
                    onTap: () {
                      Get.toNamed(Routes.PROFILEEDIT);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.black),
                    title: Text("Ubah Password"),
                    onTap: () {
                      Get.toNamed(Routes.PASWORDEDIT);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.black),
                    title: Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.toNamed(Routes.LOGIN);
                    },
                  ),
                  Divider(),
                  Obx(() {
                    if (controller.role.value == 'Pemilik') {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit, color: Colors.black),
                            title: Text("Edit Kamar"),
                            onTap: () {
                              Get.toNamed(Routes.EDITKAMAR);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.person_add, color: Colors.black),
                            title: Text("Tambah Akun"),
                            onTap: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                          ),
                        ],
                      );
                    }
                    return Container(); // Hidden for non-'Pemilik' roles
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog pemilihan sumber gambar
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Sumber Gambar"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Gunakan Kamera"),
                onTap: () async {
                  await controller1.pickImage(ImageSource.camera);
                  Navigator.of(context).pop(); // Tutup dialog setelah memilih
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Pilih dari Galeri"),
                onTap: () async {
                  await controller1.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop(); // Tutup dialog setelah memilih
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
