import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lapcoffee/controllers/user_controller.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserController()..fetchUserData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF6F4F37), // Dark coffee color
        ),
        body: Consumer<UserController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.userModel == null) {
              return Center(child: Text('User not found or not logged in.'));
            }

            // TextEditingControllers
            final nameController = TextEditingController(text: controller.userModel!.name);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.updateProfileImage(context), // Menambahkan context di sini
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.userModel!.imagePath.isNotEmpty
                          ? NetworkImage(controller.userModel!.imagePath)
                          : AssetImage('assets/default_avatar.png') as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Color(0xFF6F4F37)), // Coffee color for label
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F4F37)), // Coffee color for focused border
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.black), // Set text color to black
                    onChanged: (value) {
                      controller.updateUserData(
                        name: value,
                        imagePath: controller.userModel!.imagePath,
                        role: controller.userModel!.role,
                        context: context,  // Menambahkan context di sini
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: controller.userModel!.email),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFF6F4F37)), // Coffee color for label
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F4F37)), // Coffee color for border
                      ),
                    ),
                    style: TextStyle(color: Colors.black), // Text color black
                    enabled: false, // Disabled for editing
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: controller.userModel!.role,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: Color(0xFF6F4F37)), // Coffee color for label
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F4F37)), // Coffee color for focused border
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: ['user', 'admin'].map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateUserData(
                          name: controller.userModel!.name,
                          imagePath: controller.userModel!.imagePath,
                          role: value,
                          context: context,  // Menambahkan context di sini
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateUserData(
                        name: nameController.text,
                        imagePath: controller.userModel!.imagePath,
                        role: controller.userModel!.role,
                        context: context,  // Menambahkan context di sini
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6F4F37), // Coffee color for button
                    ),
                    child: Text(
                      'Update Profile',
                      style: TextStyle(color: Colors.white), // White text for button
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
