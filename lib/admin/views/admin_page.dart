import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';

class AdminPage extends StatelessWidget {
  final AdminController _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          bottom: TabBar(
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
        return Center(child: Text('No users available.'));
      }

      return ListView.builder(
        itemCount: _adminController.users.length,
        itemBuilder: (context, index) {
          final user = _adminController.users[index];
          return ListTile(
            title: Text(user['name'] ?? 'Unnamed User'),
            subtitle: Text(user['email'] ?? 'No Email'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditUserDialog(context, user);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _adminController.deleteUser(user['id']);
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildOrderManagementTab() {
    return Obx(() {
      if (_adminController.orders.isEmpty) {
        return Center(child: Text('No orders available.'));
      }

      return ListView.builder(
        itemCount: _adminController.orders.length,
        itemBuilder: (context, index) {
          final order = _adminController.orders[index];
          return ListTile(
            title: Text(order['name'] ?? 'Unnamed Order'),
            subtitle: Text(
                'Quantity: ${order['quantity']} | Price: \$${order['price']} | Sugar Level: ${order['sugarLevel']} | Cup Size: ${order['cupSize']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditOrderDialog(context, order);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _adminController.deleteOrder(order['id']);
                  },
                ),
              ],
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
        title: Text('Edit User'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _adminController.updateUser(user['id'], {'name': nameController.text});
              Get.back();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showEditOrderDialog(BuildContext context, Map<String, dynamic> order) {
    final nameController = TextEditingController(text: order['name'] ?? '');
    final quantityController = TextEditingController(text: order['quantity']?.toString() ?? '');
    final priceController = TextEditingController(text: order['price']?.toString() ?? '');
    final sugarLevelController = TextEditingController(text: order['sugarLevel']?.toString() ?? '');
    final cupSizeController = TextEditingController(text: order['cupSize']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sugarLevelController,
              decoration: InputDecoration(labelText: 'Sugar Level'),
            ),
            TextField(
              controller: cupSizeController,
              decoration: InputDecoration(labelText: 'Cup Size'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
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
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
