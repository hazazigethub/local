import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> faqs = [
      {
        'q': 'كيف يمكنني إضافة منتج جديد؟',
        'a':
            'من خلال لوحة التحكم، انتقل إلى قسم المنتجات واضغط على زر إضافة منتج.'
      },
      {
        'q': 'هل يمكنني تغيير معلومات المتجر؟',
        'a': 'نعم، من خلال صفحة إعدادات المتجر في القائمة الجانبية.'
      },
      {
        'q': 'كيف يتم سحب الأرباح؟',
        'a':
            'يتم تحويل الأرباح دورياً إلى حسابك البنكي المسجل في النظام بعد مراجعة الطلبات.'
      },
    ];

    return Scaffold(
      // ✅ تحديث خلفية الصفحة ديناميكياً
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("الأسئلة الشائعة",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo', // إضافة الخط المتناسق
                fontSize: 17)),
        centerTitle: true,
        // ✅ تحديث خلفية الـ AppBar
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: isDark ? 0 : 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Theme(
              // ✅ تعديل ثيم الـ ExpansionTile للوضع الليلي
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent, // إخفاء الخط الفاصل الافتراضي
              ),
              child: ExpansionTile(
                iconColor: const Color(0xFF4CAF50), // لون السهم عند الفتح
                collapsedIconColor: isDark
                    ? Colors.white70
                    : Colors.grey, // لون السهم عند الغلق
                title: Text(faqs[index]['q']!,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 14)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(faqs[index]['a']!,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.5)),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
