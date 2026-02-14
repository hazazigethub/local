import 'package:flutter/material.dart';

// نموذج بيانات التقييم الفعلي
class ReviewData {
  final String name;
  final String comment;
  final String imageUrl;
  final double rating;

  ReviewData({
    required this.name,
    required this.comment,
    required this.imageUrl,
    required this.rating,
  });
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // محاكاة استجلاب البيانات الفعلية
    final List<ReviewData> actualReviews = [
      ReviewData(
          name: "بروكلين سيمونز",
          comment: "الجودة ممتازة والتوصيل سريع جداً، أنصح بالتعامل معهم.",
          imageUrl: "https://i.pravatar.cc/150?u=1",
          rating: 5),
      ReviewData(
          name: "أنيت بلاك",
          comment: "المنتج جيد ولكن التغليف كان يحتاج عناية أكثر.",
          imageUrl: "https://i.pravatar.cc/150?u=2",
          rating: 4),
      ReviewData(
          name: "سافانا نجوين",
          comment: "تجربة متوسطة، تأخر الطلب قليلاً عن الموعد المحدد.",
          imageUrl: "https://i.pravatar.cc/150?u=3",
          rating: 3),
      ReviewData(
          name: "جاسم محمد",
          comment: "للأسف لم يكن المنتج كما توقعت.",
          imageUrl: "https://i.pravatar.cc/150?u=4",
          rating: 2),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "تقييمات العملاء",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnalyticsCard(actualReviews, isDark),
              const SizedBox(height: 30),
              Text("أحدث المراجعات",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 15),
              ...actualReviews
                  .map((review) => _buildReviewItem(context, review.name,
                      review.comment, review.imageUrl, review.rating, isDark))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة التحليلات (Analytics Card)
  Widget _buildAnalyticsCard(List<ReviewData> reviews, bool isDark) {
    if (reviews.isEmpty) return const SizedBox();

    double total = reviews.length.toDouble();
    int excellent = reviews.where((r) => r.rating >= 4.5).length;
    int good = reviews.where((r) => r.rating >= 3.5 && r.rating < 4.5).length;
    int average =
        reviews.where((r) => r.rating >= 2.5 && r.rating < 3.5).length;
    int weak = reviews.where((r) => r.rating < 2.5).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
          ],
          border: isDark
              ? Border.all(color: Colors.white.withOpacity(0.05))
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ملخص التقييمات",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusIndicator("ممتاز", Colors.green,
                  "${((excellent / total) * 100).toInt()}%", isDark),
              _buildStatusIndicator("جيد", Colors.blue,
                  "${((good / total) * 100).toInt()}%", isDark),
              _buildStatusIndicator("متوسط", Colors.orange,
                  "${((average / total) * 100).toInt()}%", isDark),
              _buildStatusIndicator("ضعيف", Colors.red,
                  "${((weak / total) * 100).toInt()}%", isDark),
            ],
          ),
          const SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  if (excellent > 0)
                    Expanded(
                        flex: excellent, child: Container(color: Colors.green)),
                  if (good > 0)
                    Expanded(flex: good, child: Container(color: Colors.blue)),
                  if (average > 0)
                    Expanded(
                        flex: average, child: Container(color: Colors.orange)),
                  if (weak > 0)
                    Expanded(flex: weak, child: Container(color: Colors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(
      String label, Color color, String percent, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    fontFamily: 'Cairo')),
          ],
        ),
        const SizedBox(height: 4),
        Text(percent,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // بطاقة المراجعة الفردية
  Widget _buildReviewItem(BuildContext context, String name, String comment,
      String imageUrl, double rating, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Cairo')),
                    Row(
                      children: List.generate(
                          5,
                          (index) => Icon(Icons.star_rounded,
                              color: index < rating
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              size: 16)),
                    ),
                  ],
                ),
              ),
              Text("منذ يومين",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 10, fontFamily: 'Cairo')),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 13,
                  height: 1.5,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _showReplyBottomSheet(
                  context, name, comment, imageUrl, isDark),
              icon: const Icon(Icons.reply_rounded, size: 18),
              label: const Text("رد على التقييم",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  // النافذة المنبثقة للرد
  void _showReplyBottomSheet(BuildContext context, String name, String comment,
      String imageUrl, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 15,
            left: 20,
            right: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text("الرد على $name",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cairo')),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey, fontFamily: 'Cairo')),
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              maxLines: 4,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Cairo'),
              decoration: InputDecoration(
                hintText: "اكتب ردك اللبق هنا...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("تم إرسال ردك بنجاح",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: Colors.green));
                },
                child: const Text("إرسال الرد",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
