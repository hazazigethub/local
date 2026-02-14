import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي (داكن أم فاتح)
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ تحديث خلفية الصفحة
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("تواصل معنا",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                fontSize: 17)),
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
            children: [
              _buildContactCard(Icons.phone_android, "رقم الهاتف",
                  "+966 500 000 000", isDark),
              _buildContactCard(Icons.email_outlined, "البريد الإلكتروني",
                  "support@app2030.com", isDark),
              _buildContactCard(Icons.location_on_outlined, "الموقع",
                  "الرياض، المملكة العربية السعودية", isDark),
              const SizedBox(height: 20),
              Text("أو أرسل لنا رسالة مباشرة",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 15),
              // ✅ تحديث حقول الإدخال لتتناسب مع الوضع الليلي
              TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _buildInputDecoration("الموضوع", isDark)),
              const SizedBox(height: 15),
              TextField(
                  maxLines: 4,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _buildInputDecoration("رسالتك", isDark)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("إرسال",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ✅ تحديث بطاقات الاتصال للوضع الليلي
  Widget _buildContactCard(
      IconData icon, String title, String value, bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4CAF50)),
        title: Text(title,
            style: TextStyle(
                fontSize: 12,
                fontFamily: 'Cairo',
                color: isDark ? Colors.white60 : Colors.grey)),
        subtitle: Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isDark ? Colors.white : Colors.black)),
      ),
    );
  }

  // ✅ ويدجت مساعد لتنسيق الحقول في كلا الوضعين
  InputDecoration _buildInputDecoration(String label, bool isDark) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontFamily: 'Cairo'),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50))),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
  }
}
