import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ إضافة ريفربود
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
import 'package:app2030/main.dart'; // ✅ استيراد المزودات

// ✅ تحويل الكلاس إلى ConsumerStatefulWidget
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // وحدات التحكم
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // متغيرات القوائم المنسدلة
  String? _selectedMainActivity;
  String? _selectedActivityType;

  final List<String> _mainActivities = [
    'أنشطة إنتاجية',
    'أنشطة تجارية',
    'أنشطة خدمية'
  ];
  final List<String> _activityTypes = [
    'الملابس والمنسوجات',
    'الأغذية والمشروبات',
    'الإلكترونيات'
  ];

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isMerchant = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _performRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // محاكاة الانتظار
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // التوجيه لصفحة OTP مع تمرير البيانات
        context.push(
          RoutePaths.otp,
          extra: {
            'phone': _phoneController.text,
            'isMerchant': _isMerchant,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ ضمان بقاء الصفحة في وضع الـ Auth (الوضع الفاتح دائماً برمجياً)
    Future.microtask(() {
      if (ref.read(appTypeProvider) != AppType.auth) {
        ref.read(appTypeProvider.notifier).state = AppType.auth;
      }
    });

    const Color brandGreen = Color(0xFF4CAF50);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // ✅ عزل الخلفية: تثبيت اللون الأبيض قسرياً لمنع تأثرها بالوضع الداكن
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white, // ✅ عزل البار العلوي
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text("إنشاء حساب جديد",
              style: TextStyle(
                  color: Colors.black, // ✅ تثبيت لون النص أسود
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- المبدّل (تاجر أولاً ثم عميل) ---
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem("تاجر", _isMerchant, () {
                          setState(() {
                            _isMerchant = true;
                            _formKey.currentState?.reset();
                          });
                        }, brandGreen),
                        _buildTabItem("عميل", !_isMerchant, () {
                          setState(() {
                            _isMerchant = false;
                            _formKey.currentState?.reset();
                          });
                        }, brandGreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // حقول الإدخال الديناميكية
                  if (_isMerchant)
                    ..._buildMerchantFields(brandGreen)
                  else
                    ..._buildCustomerFields(brandGreen),

                  const SizedBox(height: 30),

                  // زر الإنشاء
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _performRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("إنشاء حساب",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo')),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("لديك حساب بالفعل؟",
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Cairo')),
                      TextButton(
                        onPressed: () => context.go(RoutePaths.login),
                        child: const Text("تسجيل الدخول",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: brandGreen,
                                fontFamily: 'Cairo')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // المكون المبدل (Tabs)
  Widget _buildTabItem(
      String title, bool isActive, VoidCallback onTap, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  // حقول التاجر
  List<Widget> _buildMerchantFields(Color brandColor) {
    return [
      _buildTextField(_nameController, "اسم المطعم", Icons.restaurant_menu),
      const SizedBox(height: 16),
      _buildTextField(
          _phoneController, "رقم الهاتف", Icons.phone_android_outlined,
          isPhone: true),
      const SizedBox(height: 16),
      _buildTextField(
          _emailController, "البريد الإلكتروني", Icons.email_outlined,
          isEmail: true),
      const SizedBox(height: 16),
      _buildPasswordField(_passwordController, "كلمة السر", _isPasswordVisible,
          (val) => setState(() => _isPasswordVisible = val)),
      const SizedBox(height: 16),
      _buildPasswordField(
          _confirmPasswordController,
          "تأكيد كلمة السر",
          _isConfirmPasswordVisible,
          (val) => setState(() => _isConfirmPasswordVisible = val),
          isConfirm: true),
      const SizedBox(height: 16),
      _buildDropdown(
          "النشاط الرئيسي للمشروع",
          _selectedMainActivity,
          _mainActivities,
          (val) => setState(() => _selectedMainActivity = val)),
      const SizedBox(height: 16),
      _buildDropdown("تحديد نوع النشاط", _selectedActivityType, _activityTypes,
          (val) => setState(() => _selectedActivityType = val)),
      const SizedBox(height: 20),
      const Text("صورة السجل التجاري",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: Colors.black // ✅ عزل لوني للنص
              )),
      const SizedBox(height: 8),
      _buildFileUploadContainer(),
    ];
  }

  // حقول العميل
  List<Widget> _buildCustomerFields(Color brandColor) {
    return [
      _buildTextField(_nameController, "الاسم الكامل", Icons.person_outline),
      const SizedBox(height: 16),
      _buildTextField(
          _phoneController, "رقم الجوال", Icons.phone_android_outlined,
          isPhone: true),
      const SizedBox(height: 16),
      _buildPasswordField(
          _passwordController,
          "كلمة المرور",
          _isPasswordVisible,
          (val) => setState(() => _isPasswordVisible = val)),
      const SizedBox(height: 16),
      _buildPasswordField(
          _confirmPasswordController,
          "تأكيد كلمة المرور",
          _isConfirmPasswordVisible,
          (val) => setState(() => _isConfirmPasswordVisible = val),
          isConfirm: true),
    ];
  }

  // ✅ تعديل مساعدات بناء الحقول لعزلها لونياً عن الدارك مود
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPhone = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType.phone
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      style: const TextStyle(
          color: Colors.black, fontFamily: 'Cairo'), // ✅ نص أسود دائماً
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey), // ✅ تثبيت لون العنوان
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50, // ✅ خلفية فاتحة للحقل
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      bool isVisible, Function(bool) toggle,
      {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(
          color: Colors.black, fontFamily: 'Cairo'), // ✅ نص أسود دائماً
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
          onPressed: () => toggle(!isVisible),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return "هذا الحقل مطلوب";
        if (isConfirm && value != _passwordController.text)
          return "كلمات المرور غير متطابقة";
        return null;
      },
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white, // ✅ خلفية القائمة المنسدلة بيضاء دائماً
      style: const TextStyle(
          color: Colors.black, fontFamily: 'Cairo'), // ✅ نص الاختيار أسود
      items: items
          .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: Colors.black))))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) => value == null ? "يرجى الاختيار" : null,
    );
  }

  Widget _buildFileUploadContainer() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined,
              size: 32, color: Colors.grey.shade600),
          const SizedBox(height: 8),
          Text("اضغط هنا لرفع الصورة",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'Cairo',
                  fontSize: 12)),
        ],
      ),
    );
  }
}
