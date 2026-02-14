import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color brandGreen = Color(0xFF4CAF50);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("خدمة العملاء",
              style:
                  TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeaderIcon(brandGreen),
              const SizedBox(height: 30),

              // بطاقات التواصل السريع
              _buildContactCard(
                  context, "واتساب", Icons.chat_bubble_outline, Colors.green,
                  fullWidth: true),

              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerRight,
                child: Text("أرسل لنا رسالة",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
              const SizedBox(height: 20),

              // نموذج التواصل
              _buildTextField("الموضوع", Icons.subject),
              const SizedBox(height: 15),
              _buildTextField("نص الرسالة", Icons.message_outlined,
                  maxLines: 5),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("إرسال الآن",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.headset_mic_rounded, size: 60, color: color),
    );
  }

  Widget _buildContactCard(
      BuildContext context, String title, IconData icon, Color color,
      {bool fullWidth = false}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );

    return fullWidth ? cardContent : Expanded(flex: 1, child: cardContent);
  }

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
      ),
    );
  }
}
