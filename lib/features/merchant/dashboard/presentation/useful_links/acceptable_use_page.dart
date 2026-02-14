import 'package:flutter/material.dart';

class AcceptableUsePage extends StatelessWidget {
  const AcceptableUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ تحديث خلفية الصفحة ديناميكياً
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "الاستخدام المقبول",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo', // إضافة الخط المتناسق مع المشروع
          ),
        ),
        centerTitle: true,
        // ✅ تحديث خلفية الـ AppBar
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: isDark ? 0 : 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Text(
            "تهدف هذه السياسة إلى ضمان بيئة آمنة لجميع المستخدمين، ويرجى الالتزام بكافة الشروط المذكورة لضمان استمرارية الخدمة بأفضل جودة ممكنة.",
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              fontFamily: 'Cairo',
              color: isDark
                  ? Colors.white70
                  : Colors.black87, // نص فاتح في الوضع الداكن
            ),
          ),
        ),
      ),
    );
  }
}
