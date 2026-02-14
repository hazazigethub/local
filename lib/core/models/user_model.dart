class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImageUrl;
  final String? location;
  final String userType; // 'customer' أو 'merchant'
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImageUrl,
    this.location,
    required this.userType,
    required this.createdAt,
  });

  // 1. تحويل البيانات من Map (القادمة من السيرفر أو Firebase) إلى Object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      location: map['location'],
      userType: map['userType'] ?? 'customer',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // 2. تحويل الـ Object إلى Map (عند رفع البيانات للسيرفر)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'userType': userType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 3. وظيفة لتحديث قيم معينة مع الحفاظ على الباقي ثابت
  UserModel copyWith({
    String? name,
    String? profileImageUrl,
    String? location,
    String? phoneNumber,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      userType: userType,
      createdAt: createdAt,
    );
  }
}
