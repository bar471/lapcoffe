import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Map<String, dynamic>> _users = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get users => _users;

  final RxList<Map<String, dynamic>> _orders = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get orders => _orders;

  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      print("Fetched ${snapshot.docs.length} users");

      _users.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').add(userData);
      fetchAllUsers();
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      fetchAllUsers();
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      fetchAllUsers();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> fetchAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      print("Fetched ${snapshot.docs.length} orders");

      _orders.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add(orderData);
      fetchAllOrders();
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('orders').doc(orderId).update(updatedData);
      fetchAllOrders();
    } catch (e) {
      print("Error updating order: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      fetchAllOrders();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }
}
