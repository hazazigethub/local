class CartModel {
  final String customerId;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({
    required this.customerId,
    required this.items,
    required this.totalPrice,
  });

  // تحويل من Map (JSON)
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      customerId: map['customerId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromMap(item))
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  // تحويل إلى Map
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  // وظيفة لتحديث السلة عند إضافة أو حذف منتج
  CartModel copyWith({
    List<CartItem>? items,
    double? totalPrice,
  }) {
    return CartModel(
      customerId: customerId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

// موديل فرعي للعناصر داخل السلة
class CartItem {
  final String productId;
  final String productName;
  final String productImageUrl;
  final int quantity;
  final double price;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImageUrl: map['productImageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
      'price': price,
    };
  }
}
