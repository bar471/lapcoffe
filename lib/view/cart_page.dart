import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapcoffee/view/qr_page.dart';
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
                  SnackBar(
                      content:
                          Text('Detail tambahan telah disimpan ke Firebase')),
                );
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTaskDetails(DocumentSnapshot document) async {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    TextEditingController cupSizeController =
        TextEditingController(text: data['cupSize']);
    TextEditingController sugarLevelController =
        TextEditingController(text: data['sugarLevel']);
    TextEditingController additionalNotesController =
        TextEditingController(text: data['additionalNotes']);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Detail untuk ${data['name']}'),
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
                await _firestore.collection('orders').doc(document.id).update({
                  'cupSize': cupSizeController.text,
                  'sugarLevel': sugarLevelController.text,
                  'additionalNotes': additionalNotesController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detail telah diperbarui')),
                );
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(DocumentSnapshot document) async {
    await _firestore.collection('orders').doc(document.id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartItemModel> cartItems = widget.cartController.getCartItems();

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5AB), // Latte Beige
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: const Color(0xFF6B4226), // Coffee Brown
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Task yang Sudah Dibuat',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('orders')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Belum ada task yang dibuat'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ukuran Cup: ${data['cupSize']}'),
                          Text('Ukuran Gula: ${data['sugarLevel']}'),
                          Text(
                              'Deskripsi Tambahan: ${data['additionalNotes']}'),
                          Text('Jumlah: ${data['quantity']}'),
                          Text(
                              'Total Harga: Rp ${data['price'] * data['quantity']}'),
                          Text(
                              'Waktu: ${data['timestamp'] != null ? (data['timestamp'] as Timestamp).toDate().toString() : 'Unknown'}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTaskDetails(document),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTask(document),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226), // Coffee Brown
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    for (var item in cartItems) {
                      await _firestore.collection('orders').add({
                        'name': item.name,
                        'quantity': item.quantity,
                        'price': item.price,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }

                    setState(() {
                      widget.cartController.clearCart();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order placed successfully!')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Pesan Sekarang!'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeatherPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF8D6E63), // Secondary Coffee Brown
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Lihat Cuaca Terkini'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRGeneratorView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4226),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Lihat/Mindai QR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
