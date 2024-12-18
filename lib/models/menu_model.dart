class MenuModel {
  final String name;
  final String description;
  final double price;
  final String category; // Kategori menu
  final String cupSize; // Ukuran cup
  final String sugarLevel; // Tingkat gula
  final String additionalNotes; // Catatan tambahan
  final int quantity; // Jumlah
  final DateTime? timestamp; // Waktu pemesanan

  MenuModel({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.cupSize,
    required this.sugarLevel,
    required this.additionalNotes,
    required this.quantity,
    this.timestamp,
  });

  // Factory method untuk membuat objek dari Firestore document
  factory MenuModel.fromFirestore(Map<String, dynamic> data) {
    return MenuModel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      cupSize: data['cupSize'] ?? '',
      sugarLevel: data['sugarLevel'] ?? '',
      additionalNotes: data['additionalNotes'] ?? '',
      quantity: data['quantity'] ?? 0,

    );
  }

  // Method untuk mengonversi objek ke format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'cupSize': cupSize,
      'sugarLevel': sugarLevel,
      'additionalNotes': additionalNotes,
      'quantity': quantity,
      
    };
  }
}
