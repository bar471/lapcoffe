import '../models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController {
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> getCartItems() {
    return _cartItems;
  }
  // Fungsi untuk mengambil item di cart

  // Fungsi untuk menambahkan task ke Firebase
  Future<void> addTaskToFirebase(CartItemModel item) async {
    final task = {
      'name': item.name,
      'quantity': item.quantity,
      'price': item.price,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance.collection('tasks').add(task);
  }

  void addItem(CartItemModel item) {
    _cartItems.add(item);
  }

  void removeItem(CartItemModel item) {
    _cartItems.remove(item);
  }

  void clearCart() {
    _cartItems.clear();
  }

  double getTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
