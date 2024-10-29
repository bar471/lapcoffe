import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';
import 'package:lapcoffee/view/weather_view.dart';

class CartPage extends StatefulWidget {
  final CartController cartController;

  const CartPage({super.key, required this.cartController});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addTaskDetails(CartItemModel item) async {
    TextEditingController cupSizeController = TextEditingController();
    TextEditingController sugarLevelController = TextEditingController();
    TextEditingController additionalNotesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Detail untuk ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cupSizeController,
                decoration: InputDecoration(labelText: 'Ukuran Cup'),
              ),
              TextField(
                controller: sugarLevelController,
                decoration: InputDecoration(labelText: 'Ukuran Gula'),
              ),
              TextField(
                controller: additionalNotesController,
                decoration: InputDecoration(labelText: 'Deskripsi Tambahan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('orders').add({
                  'name': item.name,
                  'quantity': item.quantity,
                  'price': item.price,
                  'cupSize': cupSizeController.text,
                  'sugarLevel': sugarLevelController.text,
                  'additionalNotes': additionalNotesController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detail tambahan telah disimpan ke Firebase')),
                );
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartItemModel> cartItems = widget.cartController.getCartItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color(0xFF6B4226),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text('Rp ${item.price * item.quantity}'),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 1) {
                                item.quantity--;
                              } else {
                                widget.cartController.removeItem(item);
                              }
                            });
                          },
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () => _addTaskDetails(item),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Total: Rp ${widget.cartController.getTotal()}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.cartController.clearCart();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Place Order'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WeatherPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                  ),
                  child: const Text('Lihat Cuaca Terkini'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
