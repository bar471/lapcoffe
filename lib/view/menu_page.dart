import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/menu_model.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';
import 'package:lapcoffee/view/review_page.dart'; // Import file ReviewPage
import 'package:lapcoffee/view/takeaway_view.dart'; // Import file TakeAwayPage
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuController _menuController = MenuController();
  final CartController _cartController = CartController();
  final AuthController _authController = Get.find<AuthController>();

  String selectedCategory = "All"; // Default kategori
  String searchQuery = ""; // Untuk menyimpan query pencarian
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan menu berdasarkan kategori dan pencarian
    List<MenuModel> menuList = selectedCategory == "All"
        ? _menuController.searchMenu(searchQuery) // Menerapkan filter pencarian
        : _menuController.getMenuByCategory(selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Foto Profil
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Obx(() {
                final user = _authController.user.value;
                return CircleAvatar(
                  backgroundImage: user?.imagePath != null && user!.imagePath.isNotEmpty
                      ? NetworkImage(user.imagePath)
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                );
              }),
            ),
            const Text('Coffee Menu'),
          ],
        ),
        backgroundColor: const Color(0xFF6B4226),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartController: _cartController),
                ),
              );
            },
          ),
          // Ikon untuk Take Away
          IconButton(
            icon: const Icon(Icons.fastfood),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>   const TakeawayPage()), // Navigate to TakeAwayPage
              );
            },
          ),
          // Ikon Review
          IconButton(
            icon: const Icon(Icons.rate_review),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewPage()), // Navigate to ReviewPage
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown untuk memilih kategori
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              items: ["All", ..._menuController.categories]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              isExpanded: true,
              underline: Container(
                height: 2,
                color: const Color(0xFF6B4226),
              ),
            ),
          ),
          // Search Bar dan Ikon Mikrofon
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: searchQuery),
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search menu...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isListening
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.mic),
                  onPressed: () async {
                    if (_isListening) {
                      await _speech.stop();
                    } else {
                      bool available = await _speech.initialize();
                      if (available) {
                        setState(() {
                          _isListening = true;
                        });
                        _speech.listen(onResult: (result) {
                          setState(() {
                            searchQuery = result.recognizedWords;
                          });
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menu = menuList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListTile(
                   
                    title: Text(menu.name),
                    subtitle: Text(menu.description),
                    trailing: Text('Rp ${menu.price}'),
                    onTap: () {
                      _cartController.addItem(
                        CartItemModel(name: menu.name, price: menu.price),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${menu.name} added to cart')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFBEEC1),
    );
  }
}
