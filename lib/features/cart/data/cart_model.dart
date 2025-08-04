class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => price * quantity;
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get total => items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({List<CartItem>? items}) {
    return Cart(items: items ?? this.items);
  }

  Cart addItem(CartItem item) {
    final existingIndex = items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      return Cart(items: updatedItems);
    } else {
      return Cart(items: [...items, item]);
    }
  }

  Cart removeItem(String itemId) {
    return Cart(items: items.where((item) => item.id != itemId).toList());
  }

  Cart updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }
    
    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    
    return Cart(items: updatedItems);
  }

  Cart clear() {
    return Cart();
  }
} 