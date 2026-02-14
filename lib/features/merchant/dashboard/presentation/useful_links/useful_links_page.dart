import 'package:flutter/material.dart';
import 'about_us_page.dart';
import 'contact_us_page.dart';
import 'faq_page.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import 'acceptable_use_page.dart';

class UsefulLinksPage extends StatelessWidget {
  const UsefulLinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> links = [
      {
        'title': 'من نحن',
        'icon': Icons.info_outline,
        'color': Colors.blue,
        'page': const AboutUsPage()
      },
      {
        'title': 'تواصل معنا',
        'icon': Icons.headset_mic_outlined,
        'color': Colors.orange,
        'page': const ContactUsPage()
      },
      {
        'title': 'الأسئلة الشائعة',
        'icon': Icons.help_outline,
        'color': Colors.purple,
        'page': const FaqPage()
      },
      {
        'title': 'الخصوصية',
        'icon': Icons.lock_outline,
        'color': Colors.teal,
        'page': const PrivacyPolicyPage()
      },
      {
        'title': 'الشروط',
        'icon': Icons.description_outlined,
        'color': Colors.brown,
        'page': const TermsConditionsPage()
      },
      {
        'title': 'الاستخدام',
        'icon': Icons.verified_user_outlined,
        'color': Colors.green,
        'page': const AcceptableUsePage()
      },
    ];

    return Scaffold(
      // ✅ تحديث لون الخلفية بناءً على الوضع
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "روابط تهمك",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo', // ضمان تناسق الخط
          ),
        ),
        centerTitle: true,
        // ✅ تحديث لون شريط التطبيق
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: links.length,
            itemBuilder: (context, index) {
              return _buildLinkItem(
                context,
                links[index]['title'],
                links[index]['icon'],
                links[index]['color'],
                links[index]['page'],
                isDark, // تمرير حالة الثيم
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title, IconData icon,
      Color color, Widget page, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ✅ تحديث لون خلفية الأيقونة في الوضع الليلي
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                if (!isDark) // إظهار الظلال فقط في الوضع الفاتح
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
              ],
              border: isDark
                  ? Border.all(color: Colors.white.withOpacity(0.05))
                  : null, // إضافة حدود خفيفة في الوضع الداكن
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                // ✅ تحديث لون النص
                color: isDark ? Colors.white70 : const Color(0xFF2D3436)),
          ),
        ],
      ),
    );
  }
}
