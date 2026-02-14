import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ تحديث خلفية الصفحة ديناميكياً
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("من نحن",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Cairo')),
        centerTitle: true,
        // ✅ تحديث خلفية الـ AppBar
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF4CAF50),
                  child:
                      Icon(Icons.info_outline, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 25),
              const Text("رؤيتنا",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Color(0xFF4CAF50))),
              const SizedBox(height: 10),
              Text(
                "نسعى لأن نكون المنصة الرائدة في تمكين التجار المحليين وتقديم تجربة تسوق رقمية فريدة تخدم المجتمع وتدعم الاقتصاد المحلي وفق رؤية 2030.",
                style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Cairo',
                    color: isDark ? Colors.white70 : const Color(0xFF2D3436)),
              ),
              const SizedBox(height: 20),
              const Text("مهمتنا",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Color(0xFF4CAF50))),
              const SizedBox(height: 10),
              Text(
                "توفير أدوات تقنية متطورة وسهلة الاستخدام للتجار لإدارة أعمالهم بفعالية، وربطهم بالعملاء بطريقة سريعة وآمنة.",
                style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Cairo',
                    color: isDark ? Colors.white70 : const Color(0xFF2D3436)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
