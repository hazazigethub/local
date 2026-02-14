class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String messageType; // 'text', 'image', 'product_link'

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.messageType = 'text',
  });

  // تحويل من Map (JSON)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
      messageType: map['messageType'] ?? 'text',
    );
  }

  // تحويل إلى Map للحفظ في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'messageType': messageType,
    };
  }

  // وظيفة لتحديث حالة الرسالة (مثل تغييرها إلى "مقروءة")
  MessageModel copyWith({
    bool? isRead,
  }) {
    return MessageModel(
      id: id,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      messageType: messageType,
    );
  }
}
