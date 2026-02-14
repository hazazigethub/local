import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';

class StoreSettingsPage extends StatefulWidget {
  const StoreSettingsPage({super.key});

  @override
  State<StoreSettingsPage> createState() => _StoreSettingsPageState();
}

class _StoreSettingsPageState extends State<StoreSettingsPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✅ تحديث خلفية الصفحة لتناسب هوية التاجر
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => context.pop(), // ✅ استخدام GoRouter للرجوع
        ),
        title: Text(
          "إعدادات المتجر",
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeaderImages(isDark),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        children: [
                          Text("متجر الرويضة المركزي",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  color: isDark ? Colors.white : Colors.black)),
                          Text("merchant@app2030.com",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  color:
                                      isDark ? Colors.white60 : Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        _buildSectionIcon(Icons.person_outline, isDark),
                        const SizedBox(width: 12),
                        Text("المعلومات الأساسية",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: isDark ? Colors.white : Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _buildLabel("اسم المطعم / المتجر", isDark),
                    _buildTextField(
                        hint: "متجر الرويضة المركزي", isDark: isDark),
                    _buildLabel("الاسم الأول للمالك", isDark),
                    _buildTextField(hint: "عبدالله", isDark: isDark),
                    _buildLabel("اسم العائلة", isDark),
                    _buildTextField(hint: "العتيبي", isDark: isDark),
                    _buildLabel("البريد الإلكتروني الرسمي", isDark),
                    _buildTextField(
                        hint: "merchant@app2030.com", isDark: isDark),
                    _buildLabel("رقم التواصل", isDark),
                    _buildTextField(hint: "+966 50 123 4567", isDark: isDark),
                    _buildLabel("تغيير كلمة المرور", isDark),
                    _buildTextField(
                      isDark: isDark,
                      hint: "**************",
                      isPassword: true,
                      obscure: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _buildSectionIcon(Icons.verified_user_outlined, isDark),
                        const SizedBox(width: 12),
                        Text("التراخيص والوثائق",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: isDark ? Colors.white : Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLabel("رقم السجل التجاري", isDark),
                    _buildTextField(hint: "1010123456789", isDark: isDark),
                    const SizedBox(height: 20),
                    _buildLabel("صورة السجل التجاري (محدثة)", isDark),
                    _buildUploadArea(isDark),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("تم حفظ الإعدادات بنجاح",
                                      style: TextStyle(fontFamily: 'Cairo'))));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("حفظ التغييرات",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo')),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push(RoutePaths.deleteAccount),
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                        label: const Text(
                          "حذف الحساب نهائياً",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImages(bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: _buildEditIcon(isDark, isWhite: true),
        ),
        Positioned(
          bottom: -55,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 10)
                    ]),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?u=merchant_logo'),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: _buildEditIcon(isDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditIcon(bool isDark, {bool isWhite = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.white.withOpacity(0.8)
            : (isDark ? const Color(0xFF2C2C2C) : Colors.white),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
      ),
      child: const Icon(Icons.camera_alt_outlined,
          size: 18, color: Color(0xFF4CAF50)),
    );
  }

  Widget _buildSectionIcon(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 15),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87)),
    );
  }

  Widget _buildTextField(
      {required String hint,
      required bool isDark,
      bool isPassword = false,
      bool? obscure,
      VoidCallback? onToggle}) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: TextField(
        obscureText: obscure ?? false,
        textAlign: TextAlign.right,
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black, fontFamily: 'Cairo'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          prefixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscure!
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: onToggle,
                  color: const Color(0xFF4CAF50),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildUploadArea(bool isDark) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
            style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_upload_outlined,
              color: Color(0xFF4CAF50), size: 40),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontFamily: 'Cairo'),
              children: [
                const TextSpan(text: "اضغط هنا لرفع الملف ، "),
                const TextSpan(
                    text: "أو تصفح",
                    style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text("يدعم بصيغة PDF, PNG, JPG بحد أقصى 5MB",
              style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Cairo',
                  color: isDark ? Colors.white38 : Colors.grey)),
        ],
      ),
    );
  }
}
