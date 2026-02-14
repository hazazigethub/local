import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ إضافة مكتبة الخدمات للتحكم في الإدخال

class MerchantBankAccountPage extends StatefulWidget {
  const MerchantBankAccountPage({super.key});

  @override
  State<MerchantBankAccountPage> createState() =>
      _MerchantBankAccountPageState();
}

class _MerchantBankAccountPageState extends State<MerchantBankAccountPage> {
  final _formKey = GlobalKey<FormState>();

  // وحدات التحكم في النصوص
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  String? _selectedBank;
  bool _isLinked = false; // محاكاة لحالة الربط

  final List<String> _saudiBanks = [
    "مصرف الراجحي",
    "البنك الأهلي السعودي",
    "بنك الرياض",
    "بنك الإنماء",
    "بنك البلاد",
    "البنك العربي الوطني",
    "مصرف الإنماء"
  ];

  void _linkAccount() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLinked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("تم إرسال بيانات الحساب للتحقق والربط بنجاح ✅",
                style: TextStyle(fontFamily: 'Cairo'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // ✅ تحديد لون الخلفية ديناميكياً
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          title: Text("الحساب البنكي",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          centerTitle: true,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildStatusCard(isDark), // بطاقة حالة الحساب
              const SizedBox(height: 30),
              _buildBankForm(isDark), // نموذج إدخال البيانات
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة عرض حالة الحساب الحالية
  Widget _buildStatusCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isLinked
              ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
              : (isDark
                  ? [const Color(0xFF37474F), const Color(0xFF263238)]
                  : [Colors.grey.shade600, Colors.grey.shade800]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white, size: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  _isLinked ? "حساب مفعل" : "غير مرتبط",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("الرصيد الإجمالي",
              style: TextStyle(
                  color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
          const Text("0.00 SAR",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 12),
          const Text("الرصيد القابل للسحب",
              style: TextStyle(
                  color: Colors.white70, fontSize: 13, fontFamily: 'Cairo')),
          const Text("0.00 SAR",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          Text(
            _isLinked
                ? "سيتم تحويل الأموال تلقائياً لحسابك"
                : "يرجى ربط حساب بنكي لاستلام مستحقاتك",
            style: const TextStyle(
                color: Colors.white60, fontSize: 11, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  // نموذج إدخال البيانات البنكية
  Widget _buildBankForm(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("تفاصيل الحساب البنكي",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 20),

          // اختيار البنك
          DropdownButtonFormField<String>(
            dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'Cairo'),
            decoration:
                _inputDecoration("اختر البنك", Icons.account_balance, isDark),
            items: _saudiBanks
                .map((bank) => DropdownMenuItem(
                    value: bank,
                    child: Text(bank,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87))))
                .toList(),
            onChanged: (val) => setState(() => _selectedBank = val),
            validator: (val) => val == null ? "يرجى اختيار البنك" : null,
          ),
          const SizedBox(height: 15),

          // اسم صاحب الحساب
          TextFormField(
            controller: _ownerNameController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: _inputDecoration(
                "اسم صاحب الحساب (كما في البنك)", Icons.person_outline, isDark),
            validator: (val) => val!.isEmpty ? "يرجى إدخال الاسم" : null,
          ),
          const SizedBox(height: 15),

          // رقم الآيبان IBAN
          TextFormField(
            controller: _ibanController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(24),
            ],
            decoration:
                _inputDecoration("رقم الآيبان (IBAN)", Icons.numbers, isDark)
                    .copyWith(
              hintText: "SA00 0000 0000 0000 0000 0000",
              hintStyle:
                  TextStyle(color: isDark ? Colors.white38 : Colors.grey),
              helperText: "يجب أن يبدأ بـ SA ويتكون من 24 خانة",
              helperStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: isDark ? Colors.white54 : Colors.black54),
            ),
            validator: (val) {
              String cleanedVal = val!.replaceAll(' ', '').toUpperCase();
              if (cleanedVal.isEmpty) return "يرجى إدخال الآيبان";
              if (!cleanedVal.startsWith("SA")) return "يجب أن يبدأ بـ SA";
              if (cleanedVal.length != 24)
                return "رقم الآيبان غير مكتمل (24 خانة)";
              return null;
            },
          ),
          const SizedBox(height: 30),

          // زر الحفظ
          ElevatedButton(
            onPressed: _linkAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: const Text("حفظ وربط الحساب الآن",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.black54),
      prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
      filled: true,
      fillColor: isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.grey.withOpacity(0.05),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              BorderSide(color: isDark ? Colors.white10 : Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1)),
    );
  }
}
