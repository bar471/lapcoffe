import '../models/menu_model.dart';

class MenuController {
  // Daftar menu
  final List<MenuModel> _menuList = [
    // Coffee Menu
    MenuModel(
      name: 'Espresso',
      description: 'Strong coffee shot',
      price: 20000,
      category: 'Coffee',
    ),
    MenuModel(
      name: 'Cappuccino',
      description: 'Coffee with steamed milk',
      price: 25000,

      category: 'Coffee',
    ),
    MenuModel(
      name: 'Latte',
      description: 'Smooth coffee with milk',
      price: 27000,
     
      category: 'Coffee',
    ),
    MenuModel(
      name: 'Americano',
      description: 'Espresso with hot water',
      price: 22000,
     
      category: 'Coffee',
    ),
    MenuModel(
      name: 'Mocha',
      description: 'Coffee with chocolate and milk',
      price: 28000,
      
      category: 'Coffee',
    ),

    // Food Menu
    MenuModel(
      name: 'Croissant',
      description: 'Flaky buttery pastry',
      price: 15000,
      
      category: 'Food',
    ),
    MenuModel(
      name: 'Bagel',
      description: 'Chewy dough with a crispy exterior',
      price: 18000,
     
      category: 'Food',
    ),
    MenuModel(
      name: 'Chocolate Muffin',
      description: 'Rich chocolate-flavored muffin',
      price: 20000,
  
      category: 'Food',
    ),
    MenuModel(
      name: 'Blueberry Muffin',
      description: 'Soft muffin filled with blueberries',
      price: 20000,
    
      category: 'Food',
    ),
    MenuModel(
      name: 'Sandwich',
      description: 'Classic club sandwich with ham and cheese',
      price: 35000,
     
      category: 'Food',
    ),
  ];

  /// Getter untuk mendapatkan semua menu
  List<MenuModel> get menuList => _menuList;

  /// Getter untuk mendapatkan semua kategori unik
  List<String> get categories {
    return _menuList
        .map((menu) => menu.category.toLowerCase())
        .toSet()
        .toList(); // Menghilangkan kategori duplikat
  }

  /// Mendapatkan menu berdasarkan kategori
  List<MenuModel> getMenuByCategory(String category) {
    if (category.isEmpty) return _menuList;
    return _menuList
        .where((menu) => menu.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Filter menu berdasarkan pencarian
  List<MenuModel> searchMenu(String query) {
    if (query.isEmpty) return _menuList;
    return _menuList
        .where((menu) =>
            menu.name.toLowerCase().contains(query.toLowerCase()) ||
            menu.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
