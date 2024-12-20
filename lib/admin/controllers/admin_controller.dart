import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables untuk pengguna dan pesanan
  final RxList<Map<String, dynamic>> _users = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _orders = <Map<String, dynamic>>[].obs;

  // Getter untuk pengguna dan pesanan
  List<Map<String, dynamic>> get users => _users;
  List<Map<String, dynamic>> get orders => _orders;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
    fetchAllOrders();
  }

  /// Mengambil semua data pengguna dari Firestore
  Future<void> fetchAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      _users.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      print("Fetched ${_users.length} users");
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  /// Menambahkan pengguna baru ke Firestore
  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').add(userData);
      await fetchAllUsers();
      print("User created successfully");
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  /// Memperbarui data pengguna berdasarkan ID pengguna
  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      await fetchAllUsers();
      print("User updated successfully");
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  /// Menghapus pengguna berdasarkan ID pengguna
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      await fetchAllUsers();
      print("User deleted successfully");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  /// Mengambil semua data pesanan dari Firestore
  Future<void> fetchAllOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      _orders.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      print("Fetched ${_orders.length} orders");
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  /// Menambahkan pesanan baru ke Firestore
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add(orderData);
      await fetchAllOrders();
      print("Order created successfully");
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  /// Memperbarui data pesanan berdasarkan ID pesanan
  Future<void> updateOrder(String orderId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('orders').doc(orderId).update(updatedData);
      await fetchAllOrders();
      print("Order updated successfully");
    } catch (e) {
      print("Error updating order: $e");
    }
  }

  /// Menghapus pesanan berdasarkan ID pesanan
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      await fetchAllOrders();
      print("Order deleted successfully");
    } catch (e) {
      print("Error deleting order: $e");
    }
  }
}
