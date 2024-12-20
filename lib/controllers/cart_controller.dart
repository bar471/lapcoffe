import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CartController {
  final List<CartItemModel> _cartItems = [];
  final ConnectionController = Connectivity();

  List<CartItemModel> getCartItems() {
    return _cartItems;
  }

  // Fungsi untuk menambahkan task ke Firebase
  Future<void> addTaskToFirebase(CartItemModel item) async {
    try {
      // Validasi data sebelum menambahkan ke Firestore
      if (item.name.isEmpty || item.quantity <= 0 || item.price <= 0) {
        throw Exception('Data item tidak valid');
      }

      final task = {
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Menambahkan task ke Firestore collection 'orders'
      await FirebaseFirestore.instance.collection('orders').add(task);
      print('Item berhasil ditambahkan ke Firestore');
    } catch (e) {
      // Menangani kesalahan jika gagal menambahkan ke Firestore
      print('Gagal menambahkan item ke Firestore: $e');
    }
  }

  // Menambahkan item ke dalam keranjang
  void addItem(CartItemModel item) {
    _cartItems.add(item);
    print('Item ditambahkan ke keranjang: ${item.name}');
  }

  // Menghapus item dari keranjang
  void removeItem(CartItemModel item) {
    _cartItems.remove(item);
    print('Item dihapus dari keranjang: ${item.name}');
  }

  // Mengosongkan keranjang
  void clearCart() {
    _cartItems.clear();
    print('Keranjang dikosongkan');
  }

  // Mendapatkan total harga semua item dalam keranjang
  double getTotal() {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Menambahkan beberapa item sekaligus ke keranjang (misalnya saat checkout)
  void addItems(List<CartItemModel> items) {
    _cartItems.addAll(items);
    print('${items.length} item ditambahkan ke keranjang');
  }

  // Mengupdate item di keranjang jika sudah ada
  void updateItem(CartItemModel updatedItem) {
    final index =
        _cartItems.indexWhere((item) => item.name == updatedItem.name);
    if (index != -1) {
      _cartItems[index] = updatedItem;
      print('Item berhasil diupdate: ${updatedItem.name}');
    } else {
      print('Item tidak ditemukan di keranjang');
    }
  }
}
