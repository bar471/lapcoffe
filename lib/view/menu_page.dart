import 'package:flutter/material.dart' hide MenuController;
import 'package:lapcoffee/view/login_page_view.dart';
import '../controllers/menu_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/menu_model.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuController _menuController = MenuController();
  final CartController _cartController = CartController();

  @override
  Widget build(BuildContext context) {
    List<MenuModel> menuList = _menuController.getMenuList();

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
                MaterialPageRoute(builder: (context) => CartPage(cartController: _cartController)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Kembali ke halaman awal atau halaman login
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),(Route<dynamic>route) => false);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          final menu = menuList[index];
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
      backgroundColor: const Color(0xFFFBEEC1),
    );
  }
}
