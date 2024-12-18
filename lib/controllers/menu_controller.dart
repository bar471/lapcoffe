import 'package:lapcoffee/models/menu_model.dart';

class MenuController {
  // Daftar menu
  final List<MenuModel> _menuList = [
    // Coffee Menu
    MenuModel(
      name: 'Espresso',
      description: 'Strong coffee shot',
      price: 20000,
      category: 'Coffee',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Cappuccino',
      description: 'Coffee with steamed milk',
      price: 25000,
      category: 'Coffee',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Latte',
      description: 'Smooth coffee with milk',
      price: 27000,
      category: 'Coffee',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Americano',
      description: 'Espresso with hot water',
      price: 22000,
      category: 'Coffee',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Mocha',
      description: 'Coffee with chocolate and milk',
      price: 28000,
      category: 'Coffee',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    // Food Menu
    MenuModel(
      name: 'Croissant',
      description: 'Flaky buttery pastry',
      price: 15000,
      category: 'Food',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Bagel',
      description: 'Chewy dough with a crispy exterior',
      price: 18000,
      category: 'Food',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Chocolate Muffin',
      description: 'Rich chocolate-flavored muffin',
      price: 20000,
      category: 'Food',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Blueberry Muffin',
      description: 'Soft muffin filled with blueberries',
      price: 20000,
      category: 'Food',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
    MenuModel(
      name: 'Sandwich',
      description: 'Classic club sandwich with ham and cheese',
      price: 35000,
      category: 'Food',
      cupSize: '',
      sugarLevel: '',
      additionalNotes: '',
      quantity: 1,
    ),
  ];

  // Mendapatkan semua item dalam daftar menu
  List<MenuModel> getAllMenuItems() {
    return _menuList;
  }

  // Mendapatkan item menu berdasarkan kategori
  List<MenuModel> getMenuItemsByCategory(String category) {
    return _menuList.where((menu) => menu.category == category).toList();
  }

  // Mendapatkan item menu berdasarkan nama
  MenuModel? getMenuItemByName(String name) {
    return _menuList.firstWhere((menu) => menu.name == name, orElse: () => null);
  }

  // Menambahkan item baru ke daftar menu
  void addMenuItem(MenuModel menu) {
    _menuList.add(menu);
    print('Menu item added: ${menu.name}');
  }

  // Menghapus item menu berdasarkan nama
  void removeMenuItem(String name) {
    _menuList.removeWhere((menu) => menu.name == name);
    print('Menu item removed: $name');
  }

  // Memperbarui item menu berdasarkan nama
  void updateMenuItem(String name, MenuModel updatedMenu) {
    final index = _menuList.indexWhere((menu) => menu.name == name);
    if (index != -1) {
      _menuList[index] = updatedMenu;
      print('Menu item updated: $name');
    } else {
      print('Menu item not found: $name');
    }
  }

  // Mendapatkan total harga semua menu dalam kategori tertentu
  double getTotalPriceByCategory(String category) {
    return _menuList
        .where((menu) => menu.category == category)
        .fold(0, (sum, menu) => sum + menu.price);
  }
}
