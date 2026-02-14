import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerReviewPage extends StatefulWidget {
  final String storeName;
  final List<String> products;

  const CustomerReviewPage({
    super.key,
    required this.storeName,
    required this.products,
  });

  @override
  State<CustomerReviewPage> createState() => _CustomerReviewPageState();
}

class _CustomerReviewPageState extends State<CustomerReviewPage> {
  double _storeRating = 0;
  final Map<String, double> _productRatings = {};
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var product in widget.products) {
      _productRatings[product] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // ✅ إزالة الألوان الثابتة لتعمل خلفية الثيم التلقائية
        appBar: AppBar(
          title: const Text("تقييم الخدمة",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. تقييم المتجر
              _buildSectionTitle("كيف كانت تجربتك مع ${widget.storeName}؟"),
              _buildStarRating(
                currentRating: _storeRating,
                onRatingChanged: (rating) =>
                    setState(() => _storeRating = rating),
              ),
              const SizedBox(height: 30),

              // 2. تقييم المنتجات
              _buildSectionTitle("تقييم المنتجات:"),
              ...widget.products.map((product) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(product,
                            style: TextStyle(
                                fontSize: 15,
                                color: isDark ? Colors.white : Colors.black87,
                                fontFamily: 'Cairo')),
                      ),
                      _buildStarRating(
                        currentRating: _productRatings[product] ?? 0,
                        onRatingChanged: (rating) =>
                            setState(() => _productRatings[product] = rating),
                      ),
                      const Divider(height: 30),
                    ],
                  )),

              // 3. إضافة تعليق
              _buildSectionTitle("أضف تعليقك (اختياري):"),
              TextField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: "اكتب مراجعتك هنا لتعم الفائدة...",
                  hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                  // ✅ استخدام ألوان الحقول من الثيم الموحد
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade50,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white10 : Colors.grey.shade100),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // زر الإرسال
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text("إرسال التقييم",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo')),
    );
  }

  Widget _buildStarRating(
      {required double currentRating,
      required Function(double) onRatingChanged}) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 38, // زيادة الحجم قليلاً لتسهيل الضغط
          ),
          onPressed: () => onRatingChanged(index + 1.0),
        );
      }),
    );
  }

  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("شكراً لك!",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo')),
          content: const Text("تم استلام تقييمك بنجاح.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الدايلوج
                Navigator.pop(context); // العودة من صفحة التقييم
              },
              child: const Center(
                  child: Text("إغلاق",
                      style: TextStyle(
                          fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
