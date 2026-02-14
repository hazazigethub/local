import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter

class CustomerOrderChatPage extends StatefulWidget {
  // ✅ التعديل الجوهري: استقبال البيانات كـ Map من الراوتر
  final Map<String, dynamic> chatData;

  const CustomerOrderChatPage({
    super.key,
    required this.chatData,
  });

  @override
  State<CustomerOrderChatPage> createState() => _CustomerOrderChatPageState();
}

class _CustomerOrderChatPageState extends State<CustomerOrderChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // متغيرات محلية لاستخراج البيانات بسهولة
  late String _orderId;
  late String _storeName;
  late String _orderType;
  late String _orderTime;
  late double _totalAmount;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    // ✅ استخراج البيانات من الـ Map مع توفير قيم افتراضية للحماية
    _orderId = widget.chatData['orderId'] ??
        widget.chatData['reservationId'] ??
        "#ID-000";
    _storeName = widget.chatData['storeName'] ?? "المتجر";
    _orderType = widget.chatData['orderType'] ??
        widget.chatData['reservationType'] ??
        "طلب";
    _orderTime = widget.chatData['orderTime'] ??
        widget.chatData['reservationTime'] ??
        "--:--";
    _totalAmount = (widget.chatData['totalAmount'] as num?)?.toDouble() ?? 0.0;
    _currentStatus = widget.chatData['orderStatus'] ??
        widget.chatData['reservationStatus'] ??
        "بانتظار القبول";
  }

  // ✅ منطق إغلاق المحادثة
  bool get _isChatClosed =>
      _currentStatus == "منتهي" ||
      _currentStatus == "مكتمل" ||
      _currentStatus == "تم التسليم" ||
      _currentStatus == "ملغي";

  bool get _shouldShowReviewRequest => _currentStatus == "تم التسليم";

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // نظام الإلغاء
  void _handleCancelOrder() {
    String cancelMessage = "";
    bool hasPenalty = false;

    if (_currentStatus == "بانتظار قبول الطلب" ||
        _currentStatus == "في الانتظار") {
      cancelMessage = "سيتم إلغاء الطلب مجاناً لعدم قبول التاجر له حتى الآن.";
    } else {
      hasPenalty = true;
      double penalty = _totalAmount * 0.20;
      cancelMessage =
          "تنبيه: سيتم خصم 20% ($penalty SAR) لتجاوزك مهلة الـ 5 دقائق.";
    }

    _showCancelConfirmation(cancelMessage, hasPenalty);
  }

  void _showCancelConfirmation(String msg, bool hasPenalty) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("تأكيد إلغاء الطلب",
              style: TextStyle(fontFamily: 'Cairo')),
          content: Text(msg, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
                onPressed: () => context.pop(), // ✅ استخدام GoRouter للغلق
                child:
                    const Text("تراجع", style: TextStyle(fontFamily: 'Cairo'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() => _currentStatus = "ملغي");
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        hasPenalty
                            ? "تم الإلغاء مع خصم النسبة"
                            : "تم الإلغاء بنجاح",
                        style: const TextStyle(fontFamily: 'Cairo'))));
              },
              child: const Text("تأكيد الإلغاء",
                  style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => context.pop()), // ✅ استخدام GoRouter للرجوع
          title: Text(_storeName,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold)),
          actions: [
            if (!_isChatClosed)
              TextButton(
                onPressed: _handleCancelOrder,
                child: const Text("إلغاء الطلب",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                children: [
                  _buildOrderInfoCard(isDark),
                  _buildChatBubble(
                      "مرحباً، لقد أرسلت طلبي للمراجعة.", true, "الآن", isDark),
                  _buildChatBubble("أهلاً بك، تم استلام بيانات الطلب بنجاح.",
                      false, "الآن", isDark),
                  if (_currentStatus == "ملغي")
                    _buildSystemCancelMessage("لقد قمت بإلغاء الطلب", isDark),
                  if (_shouldShowReviewRequest) _buildReviewRequestCard(isDark),
                ],
              ),
            ),
            _buildChatInput(isDark),
          ],
        ),
      ),
    );
  }

  // --- ويدجت المساعدة (UI Helpers) ---

  Widget _buildOrderInfoCard(bool isDark) {
    bool isCanceled = _currentStatus == "ملغي";
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isCanceled
                ? Colors.red.withOpacity(0.5)
                : (isDark ? Colors.white10 : const Color(0xFFE0E0E0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_orderId,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Cairo')),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: isCanceled
                        ? Colors.red.withOpacity(0.1)
                        : (_isChatClosed
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.amber.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(_currentStatus,
                    style: TextStyle(
                        color: isCanceled
                            ? Colors.red
                            : (_isChatClosed ? Colors.grey : Colors.amber),
                        fontSize: 11,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow(
              Icons.category_outlined, "نوع الخدمة", _orderType, isDark),
          _buildInfoRow(
              Icons.access_time_outlined, "وقت التنفيذ", _orderTime, isDark),
          _buildInfoRow(Icons.payments_outlined, "إجمالي المبلغ",
              "${_totalAmount.toStringAsFixed(2)} SAR", isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 10),
          Text("$title: ",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontSize: 13,
                  fontFamily: 'Cairo')),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isMe, String time, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isMe
                ? const Color(0xFF4CAF50)
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFF3F4F6)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(text,
              style: TextStyle(
                  color: isMe
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black87),
                  fontSize: 13,
                  fontFamily: 'Cairo')),
        ),
      ),
    );
  }

  Widget _buildChatInput(bool isDark) {
    if (_isChatClosed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            border: Border(
                top: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey.shade200))),
        child: Text(
            _currentStatus == "ملغي"
                ? "🚫 لقد قمت بإلغاء الطلب. المحادثة مغلقة."
                : "✅ المحادثة مغلقة لإتمام الطلب.",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Cairo')),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: isDark ? const Color(0xFF121212) : Colors.white,
      child: Row(
        children: [
          Icon(Icons.add_circle_outline,
              color: isDark ? Colors.white54 : Colors.grey, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'Cairo'),
                decoration: const InputDecoration(
                    hintText: "اكتب رسالتك هنا...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontFamily: 'Cairo')),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.send, color: Colors.white, size: 18)),
        ],
      ),
    );
  }

  Widget _buildSystemCancelMessage(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.red.withOpacity(0.1) : Colors.red.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color:
                    isDark ? Colors.red.withOpacity(0.2) : Colors.red.shade100),
          ),
          child: Column(
            children: [
              const Icon(Icons.cancel_outlined, color: Colors.red, size: 24),
              const SizedBox(height: 8),
              Text(text,
                  style: TextStyle(
                      color: isDark ? Colors.redAccent : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRequestCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.stars_rounded, color: Colors.amber, size: 50),
          const SizedBox(height: 15),
          const Text("لقد أتم التاجر طلبك بنجاح ✅",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {}, // سيتم ربطه بصفحة التقييم لاحقاً
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text("تقييم الطلب الآن",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
            ),
          ),
        ],
      ),
    );
  }
}
