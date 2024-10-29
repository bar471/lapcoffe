class CartItemModel {
  final String name;
  final double price;
  int quantity;

  CartItemModel({required this.name, required this.price, this.quantity = 1});
}
