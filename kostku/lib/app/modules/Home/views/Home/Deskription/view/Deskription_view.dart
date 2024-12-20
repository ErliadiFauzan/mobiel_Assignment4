import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/Deskripsi_controller.dart';
import '../controller/dekripsi_controller2.dart'; // Import the new controller

class KosDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan room_id yang dikirim melalui arguments
    final String roomId = Get.arguments['room_id'];

    // Inisialisasi controller
    final KosDetailController controller = Get.put(KosDetailController());
    final ClaimController claimController = Get.put(ClaimController()); // Initialize ClaimController

    // Mengambil data kamar setelah controller siap
    controller.fetchRoomDetail(roomId);

    // Cek status klaim kamar
    claimController.checkClaimStatus(roomId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("BUDIKOST"),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: Obx(() {
        // Menunggu data kamar dari controller
        if (controller.roomData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Ambil data kamar dari controller
        var room = controller.roomData;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Menampilkan gambar kamar dengan menyesuaikan lebar layar
              Container(
                width: double.infinity, // Memastikan gambar memenuhi lebar layar
                height: 250, // Sesuaikan tinggi gambar sesuai kebutuhan
                child: Image.asset(
                  'assets/Kost2.jpg', // Langsung mengganti gambar menjadi Kost2.jpg
                  fit: BoxFit.cover, // Agar gambar terpotong sesuai ukuran
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan nama kamar dan tombol chat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room['room_name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Conditionally show/hide chat button
                        Obx(() {
                          if (claimController.isClaimed.value) {
                            return InkWell(
                              onTap: () {
                                // Navigate to the chat page only if the room is claimed
                                if (claimController.claimedByUserId.value == FirebaseAuth.instance.currentUser?.uid) {
                                  Get.toNamed(
                                    '/chat',
                                    arguments: {
                                      'room_id': room['id'],
                                      'room_name': room['room_name'],
                                      'room_description': room['room_description'],
                                      'room_price': room['room_price'],
                                      'room_image': 'assets/Kost2.jpg',
                                    },
                                  );
                                } else {
                                  Get.snackbar('Access Denied', 'You must claim the room before accessing the chat.');
                                }
                              },
                              child: Icon(Icons.chat_bubble_outline),
                            );
                          } else {
                            return SizedBox(); // Hide chat button if not claimed
                          }
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Menampilkan deskripsi kamar dalam tabel yang fleksibel
                    Container(
                      width: double.infinity, // Lebar tabel mengikuti lebar layar
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Deskripsi kamar yang akan menyesuaikan panjang
                          Text(
                            room['room_description'],
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Menampilkan harga kamar
                    Text(
                      'Harga: ${room['room_price']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tombol untuk claim atau unclaim kamar
                    Obx(() {
                      return ElevatedButton(
                        onPressed: claimController.isClaimed.value
                            ? () {
                          claimController.toggleClaim(roomId); // Unclaim room
                        }
                            : () {
                          claimController.toggleClaim(roomId); // Claim room
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: claimController.isClaimed.value
                              ? Colors.red // Unclaim (if already claimed)
                              : Colors.green, // Claim (if not claimed)
                        ),
                        child: Text(claimController.isClaimed.value
                            ? 'Unclaim' // Change text to "Unclaim"
                            : 'Claim'), // Change text to "Claim"
                      );
                    }),
                    SizedBox(height: 20),
                    // Tombol untuk melihat review
                    ElevatedButton(
                      onPressed: () {
                        // Mengirimkan seluruh data kamar (termasuk room_id) ke halaman review
                        Get.toNamed('/review', arguments: {
                          'room_id': room['id'],
                          'room_name': room['room_name'],
                          'room_description': room['room_description'],
                          'room_price': room['room_price'],
                          'room_image': 'assets/Kost2.jpg',
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Review'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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
        currentIndex: 0, // Set this dynamically to reflect the selected tab
        onTap: (index) {
          if (index == 0) {
            Get.offNamed('/home'); // Navigasi ke halaman Home
          } else if (index == 1) {
            Get.offNamed('/setings'); // Navigasi ke halaman Profile/Register
          }
        },
      ),
    );
  }
}
