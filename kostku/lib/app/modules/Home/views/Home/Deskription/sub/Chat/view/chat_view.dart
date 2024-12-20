import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import '../controller/chatSet_controller.dart';

class ChatView extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final ChatViewController chatController = Get.put(ChatViewController());

  @override
  Widget build(BuildContext context) {
    // Mengambil data kamar yang diteruskan
    final Map<String, dynamic> roomData = Get.arguments;
    controller.setRoomData(roomData);  // Set data kamar ke controller

    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text('BUDIKOST', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Title and Image
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => Text(
                    controller.roomName.value,  // Menampilkan nama kamar dari controller
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ),
                Obx(() => Image.asset(
                  controller.roomImage.value, // Menampilkan gambar kamar
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )),
              ],
            ),
          ),

          // Review Section
          Expanded(
            child: Container(
              color: Colors.green[100],
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      // Display reviews dynamically from the controller
                      return ListView.builder(
                        itemCount: chatController.reviews.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              _showBottomSheet(context, index);
                            },
                            child: ReviewBubble(
                              text: chatController.reviews[index],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.green[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.reviewTextController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    String reviewText = chatController.reviewTextController.text;
                    if (reviewText.isNotEmpty) {
                      if (chatController.currentlyEditingIndex.value != null) {
                        // Update review if editing
                        chatController.updateReview(reviewText);
                      } else {
                        // Add new review
                        chatController.addReview(reviewText);
                      }
                      chatController.reviewTextController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the modal bottom sheet for edit and delete options
  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit'),
                onTap: () {
                  chatController.startEditing(index);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete'),
                onTap: () {
                  chatController.deleteReview(index);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReviewBubble extends StatelessWidget {
  final String text;

  ReviewBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[200],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
