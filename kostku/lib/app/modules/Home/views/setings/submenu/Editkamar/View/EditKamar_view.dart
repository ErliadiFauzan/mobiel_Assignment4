import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kostku/app/routes/app_pages.dart';
import '../controller/edit_controller.dart';

class EditKamarView extends StatelessWidget {
  final RoomController controller = Get.put(RoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Edit Kamar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Get.toNamed(Routes.TAMBAHKAMAR);
              },
              child: const Text("Tambah kamar"),
            ),
          ),
          Divider(),
          Expanded(
            child: Obx(() {
              if (controller.rooms.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.rooms.length,
                itemBuilder: (context, index) {
                  var room = controller.rooms[index];
                  return RoomItem(
                    roomName: room['room_name'],
                    onEdit: () {
                      Get.toNamed(Routes.EDITKAMAREDIT, arguments: room.id);
                    },
                    onDelete: () {
                      controller.deleteRoom(room.id);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  final String roomName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoomItem({
    Key? key,
    required this.roomName,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                roomName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
