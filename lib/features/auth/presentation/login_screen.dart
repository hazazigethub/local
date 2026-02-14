import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
import 'package:app2030/main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isMerchant = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // محاكاة الاتصال بالسيرفر
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        if (_isMerchant) {
          // ✅ تحديث الهوية لتاجر والانتقال للوحة التحكم
          ref.read(appTypeProvider.notifier).state = AppType.merchant;
          context.go(RoutePaths.merchantHome);
        } else {
          // ✅ تحديث الهوية لعميل والانتقال للرئيسية
          ref.read(appTypeProvider.notifier).state = AppType.customer;
          context.go(RoutePaths.home);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ إجبار التطبيق على وضع "auth" (الوضع الفاتح) أثناء التواجد في هذه الصفحة
    Future.microtask(() {
      if (ref.read(appTypeProvider) != AppType.auth) {
        ref.read(appTypeProvider.notifier).state = AppType.auth;
      }
    });

    const Color brandGreen = Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                    _isMerchant
                        ? Icons.storefront_outlined
                        : Icons.shopping_bag_outlined,
                    size: 80,
                    color: brandGreen),
                const SizedBox(height: 16),
                Text(
                  _isMerchant ? "بوابة التاجر" : "بوابة العميل",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 30),

                // التبديل بين العميل والتاجر
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isMerchant = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isMerchant
                                  ? brandGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "عميل",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    !_isMerchant ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isMerchant = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  _isMerchant ? brandGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "تاجر",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isMerchant ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                _buildLoginTextField(
                  controller: _phoneController,
                  label: "رقم الجوال",
                  icon: Icons.phone_android_outlined,
                  type: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "الرجاء إدخال رقم الجوال";
                    if (value.length < 10) return "تأكد من صحة رقم الجوال";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildLoginTextField(
                  controller: _passwordController,
                  label: "كلمة المرور",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onTogglePassword: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "الرجاء إدخال كلمة المرور";
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("نسيت كلمة المرور؟",
                        style:
                            TextStyle(color: brandGreen, fontFamily: 'Cairo')),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isMerchant ? "دخول كتاجر" : "دخول كعميل",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo')),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ليس لديك حساب؟",
                        style:
                            TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
                    TextButton(
                      onPressed: () {
                        context.push(RoutePaths.register);
                      },
                      child: Text(
                        _isMerchant ? "سجّل متجرك الآن" : "إنشاء حساب جديد",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: brandGreen,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword && !isPasswordVisible,
      style: const TextStyle(color: Colors.black, fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
      validator: validator,
    );
  }
}
