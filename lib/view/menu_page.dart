import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import 'cart_page.dart';
import 'package:lapcoffee/view/review_page.dart'; // Import file ReviewPage
import '../controllers/microphone_controller.dart'; // Import controller mikrofon
import 'package:lapcoffee/models/menu_model.dart';
import 'package:lapcoffee/models/cart_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuController _menuController = MenuController();
  final CartController _cartController = CartController();
  final AuthController _authController = Get.find<AuthController>();
  late MicrophoneController _microphoneController;

  TextEditingController _searchController = TextEditingController();
  List<MenuModel> _menuList = [];

  @override
  void initState() {
    super.initState();
    _menuList = _menuController.getMenuList();
    _microphoneController = MicrophoneController(_searchController);
  }

  // Fungsi untuk filter menu berdasarkan query
  void _filterMenu(String query) {
    setState(() {
      _menuList = _menuController.getMenuList().where(
            (menu) => menu.name.toLowerCase().contains(query.toLowerCase()),
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Menu'),
        backgroundColor: const Color(0xFF6B4226),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartPage(cartController: _cartController)),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewPage()), // Navigate to ReviewPage
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: const Icon(Icons.rate_review), // Ganti dengan icon review
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewPage()), // Navigate to ReviewPage
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMenu,
              decoration: InputDecoration(
                hintText: 'Search menu...',
                prefixIcon: IconButton(
                  icon: Icon(
                    _microphoneController.isListening
                        ? Icons.mic
                        : Icons.mic_none,
                  ),
                  onPressed: () {
                    if (_microphoneController.isListening) {
                      _microphoneController.stopListening();
                    } else {
                      _microphoneController.startListening(_filterMenu);
                    }
                    setState(() {}); // Refresh UI to update mic icon state.
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _menuList.length,
        itemBuilder: (context, index) {
          final menu = _menuList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(menu.imageUrl),
              ),
              title: Text(menu.name),
              subtitle: Text(menu.description),
              trailing: Text('Rp ${menu.price}'),
              onTap: () {
                _cartController.addItem(CartItemModel(name: menu.name, price: menu.price));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${menu.name} added to cart')),
                );
              },
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 153, 61, 4),
    );
  }
}
