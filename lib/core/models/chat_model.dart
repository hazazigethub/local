class ChatModel {
  final String id;
  final String merchantId;
  final String customerId;
  final String merchantName;
  final String customerName;
  final String merchantImage;
  final String customerImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.merchantId,
    required this.customerId,
    required this.merchantName,
    required this.customerName,
    required this.merchantImage,
    required this.customerImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  // تحويل من Map (JSON)
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      merchantId: map['merchantId'] ?? '',
      customerId: map['customerId'] ?? '',
      merchantName: map['merchantName'] ?? '',
      customerName: map['customerName'] ?? '',
      merchantImage: map['merchantImage'] ?? '',
      customerImage: map['customerImage'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime'])
          : DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  // تحويل إلى Map للحفظ
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'merchantId': merchantId,
      'customerId': customerId,
      'merchantName': merchantName,
      'customerName': customerName,
      'merchantImage': merchantImage,
      'customerImage': customerImage,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  // تحديث بيانات المحادثة عند وصول رسالة جديدة
  ChatModel copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id,
      merchantId: merchantId,
      customerId: customerId,
      merchantName: merchantName,
      customerName: customerName,
      merchantImage: merchantImage,
      customerImage: customerImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
