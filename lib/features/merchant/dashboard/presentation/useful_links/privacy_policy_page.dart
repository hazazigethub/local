import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ تحديث لون خلفية الصفحة
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "سياسة الخصوصية",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo', // الحفاظ على اتساق الخط
          ),
        ),
        centerTitle: true,
        // ✅ تحديث لون شريط التطبيق
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
            "نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. توضح هذه السياسة كيف نقوم بجمع واستخدام وحماية المعلومات التي تزودنا بها عند استخدام تطبيقنا...",
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              fontFamily: 'Cairo',
              // ✅ تغيير لون النص ليكون مريحاً في كلا الوضعين
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
