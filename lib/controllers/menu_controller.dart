import '../models/menu_model.dart';

class MenuController {
  final List<MenuModel> _menuList = [
    // Coffee Menu
    MenuModel(name: 'Espresso', description: 'Strong coffee shot', price: 20000, imageUrl: 'https://example.com/espresso.jpg'),
    MenuModel(name: 'Cappuccino', description: 'Coffee with steamed milk', price: 25000, imageUrl: 'https://example.com/cappuccino.jpg'),
    MenuModel(name: 'Latte', description: 'Smooth coffee with milk', price: 27000, imageUrl: 'https://example.com/latte.jpg'),
    MenuModel(name: 'Americano', description: 'Espresso with hot water', price: 22000, imageUrl: 'https://example.com/americano.jpg'),
    MenuModel(name: 'Mocha', description: 'Coffee with chocolate and milk', price: 28000, imageUrl: 'https://example.com/mocha.jpg'),
    MenuModel(name: 'Macchiato', description: 'Espresso with a dash of foamed milk', price: 26000, imageUrl: 'https://example.com/macchiato.jpg'),
    MenuModel(name: 'Flat White', description: 'Coffee with microfoam', price: 27000, imageUrl: 'https://example.com/flatwhite.jpg'),
    MenuModel(name: 'Iced Coffee', description: 'Cold brewed coffee', price: 24000, imageUrl: 'https://example.com/icedcoffee.jpg'),
    MenuModel(name: 'Affogato', description: 'Espresso with a scoop of vanilla ice cream', price: 30000, imageUrl: 'https://example.com/affogato.jpg'),
    MenuModel(name: 'Café au Lait', description: 'Brewed coffee with steamed milk', price: 23000, imageUrl: 'https://example.com/cafeaulait.jpg'),

    // Food Menu
    MenuModel(name: 'Croissant', description: 'Flaky buttery pastry', price: 15000, imageUrl: 'https://example.com/croissant.jpg'),
    MenuModel(name: 'Bagel', description: 'Chewy dough with a crispy exterior', price: 18000, imageUrl: 'https://example.com/bagel.jpg'),
    MenuModel(name: 'Chocolate Muffin', description: 'Rich chocolate-flavored muffin', price: 20000, imageUrl: 'https://example.com/chocolatemuffin.jpg'),
    MenuModel(name: 'Blueberry Muffin', description: 'Soft muffin filled with blueberries', price: 20000, imageUrl: 'https://example.com/blueberrymuffin.jpg'),
    MenuModel(name: 'Sandwich', description: 'Classic club sandwich with ham and cheese', price: 35000, imageUrl: 'https://example.com/sandwich.jpg'),
    MenuModel(name: 'Panini', description: 'Grilled sandwich with various fillings', price: 37000, imageUrl: 'https://example.com/panini.jpg'),
    MenuModel(name: 'Cheesecake', description: 'Creamy and smooth cheesecake', price: 30000, imageUrl: 'https://example.com/cheesecake.jpg'),
    MenuModel(name: 'Brownie', description: 'Rich chocolate brownie', price: 25000, imageUrl: 'https://example.com/brownie.jpg'),
    MenuModel(name: 'Tiramisu', description: 'Classic Italian dessert with coffee flavor', price: 35000, imageUrl: 'https://example.com/tiramisu.jpg'),
    MenuModel(name: 'Quiche', description: 'Savory pie with a creamy egg filling', price: 32000, imageUrl: 'https://example.com/quiche.jpg'),
  ];

  List<MenuModel> getMenuList() {
    return _menuList;
  }
}
