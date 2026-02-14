import 'package:flutter/material.dart';

class CustomerReservationsChatPage extends StatefulWidget {
  final String reservationId;
  final String storeName;
  final String reservationType;
  final String reservationTime;
  final double totalAmount;
  final String reservationStatus;

  const CustomerReservationsChatPage({
    super.key,
    required this.reservationId,
    required this.storeName,
    required this.reservationType,
    required this.reservationTime,
    required this.totalAmount,
    required this.reservationStatus,
  });

  @override
  State<CustomerReservationsChatPage> createState() =>
      _CustomerReservationsChatPageState();
}

class _CustomerReservationsChatPageState
    extends State<CustomerReservationsChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // ✅ 1. متغير محلي لتحديث الحالة فوراً وضمان تفاعلية الصفحة
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.reservationStatus;
  }

  // ✅ 2. تحديث منطق إغلاق المحادثة (تشمل حالة ملغي)
  bool get _isChatClosed =>
      _currentStatus == "منتهي" ||
      _currentStatus == "مكتمل" ||
      _currentStatus == "ملغي";

  bool get _isReservationFinished => _currentStatus == "منتهي";

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // 🚫 نظام إلغاء الحجز الذكي (قاعدة الـ 24 ساعة)
  void _handleCancelReservation() {
    String cancelMessage = "";
    double penalty = 0.0;

    try {
      // محاولة تحليل تاريخ الحجز
      DateTime resDateTime = DateTime.parse(widget.reservationTime);
      Duration difference = resDateTime.difference(DateTime.now());

      // ✅ فحص إذا كان الموعد متبقي عليه أقل من 24 ساعة
      if (difference.inHours < 24 && !difference.isNegative) {
        penalty = widget.totalAmount * 0.20;
        cancelMessage =
            "تنبيه: متبقي أقل من 24 ساعة على موعد الحجز. سيتم خصم 20% ($penalty SAR) من القيمة كرسوم إلغاء متأخر.";
      } else {
        cancelMessage =
            "هل أنت متأكد من رغبتك في إلغاء الحجز؟ سيتم الإلغاء مجاناً لتوفر أكثر من 24 ساعة على الموعد.";
      }
    } catch (e) {
      cancelMessage = "هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟";
    }

    _showCancelConfirmation(cancelMessage, penalty);
  }

  void _showCancelConfirmation(String msg, double penalty) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text("تأكيد إلغاء الحجز",
              style: TextStyle(fontFamily: 'Cairo')),
          content: Text(msg, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("تراجع", style: TextStyle(fontFamily: 'Cairo'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  _currentStatus = "ملغي"; // ✅ تحديث الحالة فوراً داخل الصفحة
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        penalty > 0
                            ? "تم الإلغاء وخصم رسوم التأخير بنجاح"
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
        // ✅ إزالة اللون الثابت ليعمل الثيم التلقائي
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context)),
          title: Text(widget.storeName,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold)),
          actions: [
            // ✅ زر الإلغاء يظهر فقط إذا كانت المحادثة مفتوحة
            if (!_isChatClosed)
              TextButton(
                onPressed: _handleCancelReservation,
                child: const Text("إلغاء الحجز",
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
                  _buildReservationInfoCard(isDark),
                  _buildChatBubble("مرحباً، لقد أرسلت طلب حجزي للمراجعة.", true,
                      "الآن", isDark),
                  _buildChatBubble("أهلاً بك، تم استلام بيانات الحجز بنجاح.",
                      false, "الآن", isDark),

                  // ✅ 3. رسالة النظام تظهر في وسط المحادثة عند الإلغاء
                  if (_currentStatus == "ملغي")
                    _buildSystemCancelMessage("لقد قمت بإلغاء الحجز", isDark),

                  if (_isReservationFinished) _buildRatingCard(isDark),
                ],
              ),
            ),
            _buildChatInput(isDark),
          ],
        ),
      ),
    );
  }

  // ✅ ويدجت رسالة الإلغاء المركزية
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
              const Icon(Icons.event_busy_rounded, color: Colors.red, size: 24),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                    color: isDark ? Colors.redAccent : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationInfoCard(bool isDark) {
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.reservationId,
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
                            ? (isDark ? Colors.white10 : Colors.grey.shade50)
                            : (isDark
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.orange.shade50)),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  _currentStatus,
                  style: TextStyle(
                      color: isCanceled
                          ? Colors.red
                          : (_isChatClosed ? Colors.grey : Colors.orange),
                      fontSize: 11,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow(Icons.event_note_outlined, "نوع الحجز",
              widget.reservationType, isDark),
          _buildInfoRow(Icons.calendar_today_outlined, "موعد الحجز",
              widget.reservationTime, isDark),
          _buildInfoRow(Icons.payments_outlined, "إجمالي المبلغ",
              "${widget.totalAmount.toStringAsFixed(2)} SAR", isDark),
        ],
      ),
    );
  }

  // ✅ تحديث شريط الإدخال ليغلق عند الإلغاء
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
              ? "🚫 لقد قمت بإلغاء الحجز. المحادثة مغلقة."
              : "✅ المحادثة مغلقة لانتهاء موعد الحجز.",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'Cairo'),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: isDark ? const Color(0xFF121212) : Colors.white,
      child: Row(
        children: [
          GestureDetector(
              onTap: _showAttachmentMenu,
              child: Icon(Icons.add_circle_outline,
                  color: isDark ? Colors.white54 : Colors.grey, size: 28)),
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
            child: Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAttachmentOption(
                    icon: Icons.image,
                    color: Colors.purple,
                    label: "إرسال صورة",
                    onTap: () => Navigator.pop(context)),
                _buildAttachmentOption(
                    icon: Icons.location_on,
                    color: Colors.blue,
                    label: "إرسال الموقع",
                    onTap: () => Navigator.pop(context)),
                _buildAttachmentOption(
                    icon: Icons.phone,
                    color: const Color(0xFF4CAF50),
                    label: "إرسال رقم الهاتف",
                    onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      {required IconData icon,
      required Color color,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color)),
      title: Text(label,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontFamily: 'Cairo')),
      onTap: onTap,
    );
  }

  Widget _buildRatingCard(bool isDark) {
    return const SizedBox(); // سيتم استبدالها بويدجت التقييم لاحقاً
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
              borderRadius: BorderRadius.circular(15)),
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
}
