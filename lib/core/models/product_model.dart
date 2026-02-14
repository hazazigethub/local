class ProductModel {
  final String id;
  final String merchantId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> imagesUrl;
  final String category;
  final int stock; // الكمية المتوفرة
  final bool isAvailable;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.merchantId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imagesUrl,
    required this.category,
    this.stock = 0,
    this.isAvailable = true,
    required this.createdAt,
  });

  // تحويل من Map (JSON)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      merchantId: map['merchantId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      discountPrice: map['discountPrice']?.toDouble(),
      imagesUrl: List<String>.from(map['imagesUrl'] ?? []),
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // تحويل إلى Map للحفظ
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchantId': merchantId,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'imagesUrl': imagesUrl,
      'category': category,
      'stock': stock,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // تحديث بيانات المنتج
  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    List<String>? imagesUrl,
    int? stock,
    bool? isAvailable,
  }) {
    return ProductModel(
      id: id,
      merchantId: merchantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      category: category,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt,
    );
  }
}
