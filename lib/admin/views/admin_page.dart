import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/http/http_view.dart';
import '../controllers/admin_controller.dart';
import 'package:lapcoffee/view/music_list_view.dart'; // Pastikan halaman ini sudah ada

class AdminPage extends StatelessWidget {
  final AdminController _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          backgroundColor: Colors.brown,
          actions: [
            // Button for navigating to HTTP View
            IconButton(
              icon: const Icon(Icons.api, color: Colors.white),
              onPressed: () {
                // Navigate to HTTP view page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HttpView()),
                );
              },
            ),
            // Button for navigating to Music List
            IconButton(
              icon: const Icon(Icons.music_note, color: Colors.white),
              onPressed: () {
                // Navigate to Music List page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicListView()),
                );
              },
            ),
            // Button to log out and return to login page
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Navigate back to login page
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(177, 255, 175, 109),
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserManagementTab(),
            _buildOrderManagementTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagementTab() {
    return Obx(() {
      if (_adminController.users.isEmpty) {
        return const Center(
          child: Text(
            'No users available.',
            style: TextStyle(color: Colors.brown),
          ),
        );
      }

      return ListView.builder(
        itemCount: _adminController.users.length,
        itemBuilder: (context, index) {
          final user = _adminController.users[index];
          return Card(
            color: Colors.brown.shade50,
            child: ListTile(
              title: Text(user['name'] ?? 'Unnamed User',
                  style: const TextStyle(color: Colors.brown)),
              subtitle: Text(user['email'] ?? 'No Email',
                  style: const TextStyle(color: Colors.brown)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.brown),
                    onPressed: () {
                      _showEditUserDialog(context, user);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _adminController.deleteUser(user['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOrderManagementTab() {
    return Obx(() {
      if (_adminController.orders.isEmpty) {
        return const Center(
          child: Text(
            'No orders available.',
            style: TextStyle(color: Colors.brown),
          ),
        );
      }

      return ListView.builder(
        itemCount: _adminController.orders.length,
        itemBuilder: (context, index) {
          final order = _adminController.orders[index];
          return Card(
            color: Colors.brown.shade50,
            child: ListTile(
              title: Text(order['name'] ?? 'Unnamed Order',
                  style: const TextStyle(color: Colors.brown)),
              subtitle: Text(
                'Quantity: ${order['quantity']} | Price: \$${order['price']} | Sugar Level: ${order['sugarLevel']} | Cup Size: ${order['cupSize']}',
                style: const TextStyle(color: Colors.brown),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.brown),
                    onPressed: () {
                      _showEditOrderDialog(context, order);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _adminController.deleteOrder(order['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user) {
    final nameController = TextEditingController(text: user['name'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown.shade50,
        title: const Text('Edit User', style: TextStyle(color: Colors.brown)),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {
              _adminController
                  .updateUser(user['id'], {'name': nameController.text});
              Get.back();
            },
            child: const Text('Update', style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  void _showEditOrderDialog(BuildContext context, Map<String, dynamic> order) {
    final nameController = TextEditingController(text: order['name'] ?? '');
    final quantityController =
        TextEditingController(text: order['quantity']?.toString() ?? '');
    final priceController =
        TextEditingController(text: order['price']?.toString() ?? '');
    final sugarLevelController =
        TextEditingController(text: order['sugarLevel']?.toString() ?? '');
    final cupSizeController =
        TextEditingController(text: order['cupSize']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown.shade50,
        title: const Text('Edit Order', style: TextStyle(color: Colors.brown)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                  labelText: 'Quantity', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                  labelText: 'Price', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sugarLevelController,
              decoration: const InputDecoration(
                  labelText: 'Sugar Level', border: OutlineInputBorder()),
            ),
            TextField(
              controller: cupSizeController,
              decoration: const InputDecoration(
                  labelText: 'Cup Size', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {
              _adminController.updateOrder(order['id'], {
                'name': nameController.text,
                'quantity': int.tryParse(quantityController.text) ?? 0,
                'price': double.tryParse(priceController.text) ?? 0.0,
                'sugarLevel': sugarLevelController.text,
                'cupSize': cupSizeController.text,
              });
              Get.back();
            },
            child: const Text('Update', style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }
}
