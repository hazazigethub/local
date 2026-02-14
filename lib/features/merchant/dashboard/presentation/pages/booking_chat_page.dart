import 'package:flutter/material.dart';

class BookingChatPage extends StatefulWidget {
  final String userName;
  final String reservationId;
  final String initialStatus;

  const BookingChatPage({
    super.key,
    required this.userName,
    required this.reservationId,
    required this.initialStatus,
  });

  @override
  State<BookingChatPage> createState() => _BookingChatPageState();
}

class _BookingChatPageState extends State<BookingChatPage> {
  late bool isBookingCompleted;
  double serviceRating = 0;
  double merchantRating = 0;

  @override
  void initState() {
    super.initState();
    isBookingCompleted = widget.initialStatus == "منتهي";
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تعريف متغير التحقق من الوضع الليلي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // ✅ تحديث خلفية الشاشة
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          // ✅ تحديث خلفية شريط العنوان
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userName,
                  style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black)),
              Text("رقم الحجز: ${widget.reservationId}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Center(
                      child: Text("بداية محادثة الحجز",
                          style: TextStyle(color: Colors.grey, fontSize: 12))),
                  const SizedBox(height: 20),
                  if (isBookingCompleted) _buildRatingCard(isDark),
                ],
              ),
            ),
            _buildChatInputArea(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ✅ تحديث خلفية بطاقة التقييم
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Text("تم إكمال الحجز بنجاح! ✅",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black)),
          Divider(
              height: 30,
              color: isDark ? Colors.white10 : Colors.grey.shade200),
          Text("قيم جودة الخدمة المقدمة",
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87)),
          _buildStars((r) => setState(() => serviceRating = r), serviceRating),
          const SizedBox(height: 15),
          Text("قيم تعامل مقدم الخدمة",
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87)),
          _buildStars(
              (r) => setState(() => merchantRating = r), merchantRating),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("تم إرسال تقييمك بنجاح!")));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50), elevation: 0),
                  child: const Text("إرسال التقييم",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {/* منطق الاعتراض */},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text("لم يتم الحجز",
                      style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStars(Function(double) onRating, double currentRating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          5,
          (index) => IconButton(
                icon: Icon(
                    index < currentRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30),
                onPressed: () => onRating(index + 1.0),
              )),
    );
  }

  Widget _buildChatInputArea(bool isDark) {
    if (isBookingCompleted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        // ✅ تحديث لون خلفية منطقة التنبيه
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: const Text(
          "⚠️ المحادثة مغلقة لانتهاء موعد الحجز. يمكنك التقييم أعلاه.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      // ✅ تحديث لون خلفية منطقة الكتابة
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                      hintText: "اكتب رسالتك هنا...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none))),
          IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF4CAF50)),
              onPressed: () {}),
        ],
      ),
    );
  }
}
