import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ProfileEdit_controller/ProfileEdit_controller.dart';

class ProfileEditView extends StatelessWidget {
  // Get the controller instance
  final ProfileEditController controller = Get.put(ProfileEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Akun"),
        actions: [
          // Edit button to toggle between view and edit mode
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Toggle editing mode
              controller.toggleEditMode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              Text(
                "Full Name: ${controller.firstName.value} ${controller.lastName.value}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              // Only show email, role, and createdAt when not editing
              controller.isEditMode.value
                  ? SizedBox.shrink()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email: ${controller.email.value}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Role: ${controller.role.value}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Account Created At: ${controller.createdAt.value}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // When in edit mode, show fields for firstName and lastName
              controller.isEditMode.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("First Name", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller.firstNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "First Name",
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Text("Last Name", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: controller.lastNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Last Name",
                    ),
                  ),
                ],
              )
                  : SizedBox.shrink(),

              SizedBox(height: 32.0),

              // Save Changes button only enabled when in edit mode
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: controller.isEditMode.value
                      ? () {
                    controller.saveUserData(); // Save the changes to Firestore
                  }
                      : null, // Disable button if not in edit mode
                  child: Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
