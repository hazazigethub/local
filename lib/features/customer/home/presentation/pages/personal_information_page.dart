import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter لضمان التوافق

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: "عمر سامي");
  final TextEditingController _phoneController =
      TextEditingController(text: "123456789");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456789");
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).iconTheme.color),
            onPressed: () => context.pop(), // ✅ استخدام GoRouter للرجوع
          ),
          title: const Text(
            "المعلومات الشخصية",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 40),
                    _buildFieldLabel("اسم المستخدم"),
                    _buildTextField(_usernameController, Icons.person_outline),
                    const SizedBox(height: 25),
                    _buildFieldLabel("رقم الهاتف"),
                    _buildPhoneField(_phoneController, isDark),
                    const SizedBox(height: 25),
                    _buildFieldLabel("كلمة المرور"),
                    _buildPasswordField(),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
                Text("تغيير الصورة",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontFamily: 'Cairo'),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key_outlined, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1))),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData prefixIcon) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Cairo'),
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        suffixIcon: Icon(Icons.edit_outlined,
            color: Theme.of(context).colorScheme.primary, size: 20),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1))),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
              color:
                  isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
              border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Text("🇸🇦", style: TextStyle(fontSize: 20)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontFamily: 'Cairo'),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary, size: 20),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("تم حفظ التعديلات بنجاح",
                      style: TextStyle(fontFamily: 'Cairo')))),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0),
          child: const Text("حفظ التغييرات",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo')),
        ),
      ),
    );
  }
}
