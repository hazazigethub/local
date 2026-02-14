class MerchantModel {
  final String id; // نفس معرف الـ User لربطهما معاً
  final String storeName;
  final String description;
  final String logoUrl;
  final String coverImageUrl;
  final String category; // مثلاً: كافيه، ملابس، حلويات
  final String? address;
  final String? whatsapp;
  final String? instagram;
  final double averageRating;
  final int reviewsCount;
  final bool isVerified;

  MerchantModel({
    required this.id,
    required this.storeName,
    required this.description,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.category,
    this.address,
    this.whatsapp,
    this.instagram,
    this.averageRating = 0.0,
    this.reviewsCount = 0,
    this.isVerified = false,
  });

  // تحويل البيانات من Map (JSON) إلى Object
  factory MerchantModel.fromMap(Map<String, dynamic> map) {
    return MerchantModel(
      id: map['id'] ?? '',
      storeName: map['storeName'] ?? '',
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      category: map['category'] ?? '',
      address: map['address'],
      whatsapp: map['whatsapp'],
      instagram: map['instagram'],
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      reviewsCount: map['reviewsCount'] ?? 0,
      isVerified: map['isVerified'] ?? false,
    );
  }

  // تحويل الـ Object إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeName': storeName,
      'description': description,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'category': category,
      'address': address,
      'whatsapp': whatsapp,
      'instagram': instagram,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'isVerified': isVerified,
    };
  }

  // وظيفة التحديث الجزئي للبيانات
  MerchantModel copyWith({
    String? storeName,
    String? description,
    String? logoUrl,
    String? coverImageUrl,
    String? category,
    String? address,
    String? whatsapp,
    String? instagram,
    bool? isVerified,
  }) {
    return MerchantModel(
      id: id,
      storeName: storeName ?? this.storeName,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      category: category ?? this.category,
      address: address ?? this.address,
      whatsapp: whatsapp ?? this.whatsapp,
      instagram: instagram ?? this.instagram,
      averageRating: averageRating,
      reviewsCount: reviewsCount,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
