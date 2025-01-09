import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/menu_model.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';
import 'profile_page.dart'; // Import profile page
import 'package:lapcoffee/view/review_page.dart'; // Import ReviewPage
import 'package:lapcoffee/view/takeaway_view.dart'; // Import TakeAwayPage
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

  String selectedCategory = "All"; // Default category
  String searchQuery = ""; // To store search query
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _searchController = TextEditingController(text: searchQuery);
    print('Speech-to-Text initialized');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch menu based on selected category and search query
    List<MenuModel> menuList = selectedCategory == "All"
        ? _menuController.searchMenu(searchQuery)
        : _menuController.getMenuByCategory(selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Profile Picture
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: _navigateToProfile, // Navigate to Profile on tap
                child: Obx(() {
                  final user = _authController.user.value;
                  print('User Profile: $user');

                  // Check if user exists and has an imagePath (image URL)
                  if (user != null && user.imagePath.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                          user.imagePath), // Use image from Firestore
                    );
                  } else {
                    return const CircleAvatar(
                      backgroundImage: AssetImage('assets/default_profile.png'),
                    );
                  }
                }),
              ),
            ),
            const Text(
              'Coffee Menu',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6B4226),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartPage(cartController: _cartController),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fastfood, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const TakeawayPage()), // Navigate to TakeAwayPage
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.rate_review, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ReviewPage()), // Navigate to ReviewPage
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown for selecting category
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
                  selectedCategory = value!; // Update the selected category
                  print('Selected Category: $selectedCategory');
                });
              },
              isExpanded: true,
              underline: Container(
                height: 2,
                color: const Color(0xFF6B4226),
              ),
            ),
          ),
          // Search bar with microphone button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query; // Update the search query
                        print('Search Query: $searchQuery');
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
                  onPressed: _toggleListening,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  // Function to check login and navigate to Profile
  void _navigateToProfile() async {
    final user = _authController.user.value;

    if (user == null || user.uid.isEmpty) {
      _showLoginDialog(context);
    } else {
      print('Navigating to Profile with user: ${user.uid}');
      // Pastikan data pengguna sudah lengkap sebelum navigasi
      if (user.uid.isNotEmpty) {
        Get.to(() => ProfilePage()); // Corrected parameter name here
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data is incomplete")),
        );
      }
    }
  }

  // Function to show login dialog if the user is not logged in
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text("You need to log in to access the profile page."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to login page (replace with actual navigation)
                // Get.to(() => LoginPage());
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to handle microphone toggle and speech-to-text
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech-to-Text Status: $status');
          if (status == "notListening") {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          setState(() {
            _isListening = false;
          });
          print("Speech Recognition Error: ${error.errorMsg}");
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              searchQuery = result.recognizedWords;
              _searchController.text = searchQuery;
              print('Recognized Words: $searchQuery');
            });
          },
          listenFor: const Duration(seconds: 10),
          cancelOnError: true,
          pauseFor: const Duration(seconds: 3),
        );
      }
    }
  }
}
