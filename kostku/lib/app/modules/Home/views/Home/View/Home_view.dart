import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kostku/app/routes/app_pages.dart';
import '../home_controller/home_controller.dart';
import '../home_controller/home_controller2.dart';

class HomeView extends StatelessWidget {
  final RoomsController controller = Get.put(RoomsController());
  final ClaimRoomController claimRoomController = Get.put(ClaimRoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'BUDIKOST',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [SizedBox(width: 48)], // Placeholder to center title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
              () => claimRoomController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : controller.rooms.isEmpty
              ? Center(child: Text('No rooms available'))
              : SingleChildScrollView(
            child: Column(
              children: [
                _buildNewYearEvent(),
                SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth > 600) ? 2 : 1;
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: 1.7,
                      ),
                      itemCount: controller.rooms.length,
                      itemBuilder: (context, index) {
                        final room = controller.rooms[index];
                        final roomId = room['id'];
                        final roomStatus = claimRoomController.roomStatus[roomId] ?? Colors.green;
                        final statusText = roomStatus == Colors.green ? 'Tersedia' : 'Terisi';

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/deskripsi', arguments: {'room_id': room['id']});
                          },
                          child: _buildKosCard(
                            imageUrl: 'assets/Kost2.jpg',
                            title: room['room_name'],
                            address: room['room_description'],
                            price: room['room_price'],
                            status: statusText,
                            statusColor: roomStatus,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
            Get.offNamed('/home');
          } else if (index == 1) {
            Get.offNamed('/setings');
          }
        },
      ),
    );
  }

  Widget _buildNewYearEvent() {
    return Card(
      color: Colors.orange[100],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Tahun Baru 2025!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Diskon spesial 40% untuk semua kos pada tanggal 31 Desember 2024!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.EVENT);
              },
              child: Text('Lihat Promo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosCard({
    required String imageUrl,
    required String title,
    required String address,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Image.asset(
              imageUrl,
              height: 0.25 * 200,  // Set height of image to 25% of the card height (example height 200)
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,  // Membatasi deskripsi hingga 1 baris
                  overflow: TextOverflow.ellipsis,  // Menyembunyikan teks lebih dari 1 baris
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Mulai',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
