import 'package:flutter/material.dart';
import '../controllers/takeaway_controller.dart';
import '../controllers/menu_controller.dart' as custom_menu;
import 'cart_page.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class TakeawayPage extends StatefulWidget {
  const TakeawayPage({super.key});

  @override
  State<TakeawayPage> createState() => _TakeawayPageState();
}

class _TakeawayPageState extends State<TakeawayPage> {
  final LocationController _locationController = LocationController();
  final custom_menu.MenuController _menuController =
      custom_menu.MenuController();
  final CartController _cartController =
      CartController(); // Cart controller instance
  String _locationMessage = "Mencari titik lokasi anda...";
  bool _loading = false;
  bool _locationConfirmed = false;

  Future<void> _fetchLocation() async {
    setState(() {
      _loading = true;
    });

    String result = await _locationController.getCurrentLocation();

    setState(() {
      _loading = false;
      _locationMessage = result;
    });
  }

  void _confirmLocation() {
    if (_locationController.currentPosition != null) {
      setState(() {
        _locationConfirmed = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tentukan lokasi terlebih dahulu!")),
      );
    }
  }

  void _orderMenu(String menuName) {
    // Find the menu item details
    final menu =
        _menuController.menuList.firstWhere((menu) => menu.name == menuName);

    // Add the ordered item to the cart
    setState(() {
      _cartController.addItem(
        CartItemModel(
          name: menu.name,
          price: menu.price,
          quantity: 1,
        ),
      );
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$menuName berhasil ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Takeaway dan Pesan Makanan"),
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: Colors.white, // Coffee brown color for the app bar
        actions: [
          if (!_locationConfirmed)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchLocation,
              color: Colors.white,
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to CartPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartPage(cartController: _cartController),
                ),
              );
            },
          ),
        ],
      ),
      body: _locationConfirmed ? _buildOrderView() : _buildTakeawayView(),
    );
  }

  Widget _buildTakeawayView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Titik Koordinat',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3E2723), // Dark coffee color
            ),
          ),
          Text(
            _locationMessage,
            style: const TextStyle(fontSize: 16, color: Colors.brown),
          ),
          const SizedBox(height: 20),
          _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _fetchLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 255, 255), // Coffee brown color
                  ),
                  child: const Text(
                    'Cari Lokasi Saya',
                    style: TextStyle(
                        color: Color(0xFF3E2723)), // Set text color to white
                  ),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _locationController.openGoogleMaps,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: const Text(
              'Buka Google Maps',
              style: TextStyle(
                  color: Color(0xFF3E2723)), // Set text color to white
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _confirmLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  255, 255, 255, 255), // Lighter brown for confirmation
            ),
            child: const Text(
              'Konfirmasi Lokasi',
              style: TextStyle(
                  color: Color(0xFF3E2723)), // Set text color to white
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _menuController.menuList.length,
      itemBuilder: (context, index) {
        final menu = _menuController.menuList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 5,
          color: Colors.brown[50], // Light brown card background
          child: ListTile(
            title: Text(
              menu.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E2723), // Dark coffee color for text
              ),
            ),
            subtitle: Text(
              '${menu.description}\nRp ${menu.price}',
              style: const TextStyle(color: Colors.brown),
            ),
            isThreeLine: true,
            trailing: ElevatedButton(
              onPressed: () => _orderMenu(menu.name),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF6D4C41), // Lighter brown for buttons
              ),
              child: const Text(
                'Pesan',
                style: TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // Set text color to white
              ),
            ),
          ),
        );
      },
    );
  }
}
