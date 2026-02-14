import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app2030/main.dart'; // تأكد من وجود تعريف merchantBalanceProvider
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter للملاحة

class PromotionsPage extends ConsumerStatefulWidget {
  const PromotionsPage({super.key});

  @override
  ConsumerState<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends ConsumerState<PromotionsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String _targetGroup = "المتابعين فقط";
  double _distance = 1.0;
  final int _followersCount = 1250;
  int _reachCount = 1250;

  final double _pricePerPerson = 0.03;
  double get _totalCost => _reachCount * _pricePerPerson;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double currentBalance = ref.watch(merchantBalanceProvider);
    final bool hasEnoughBalance = currentBalance >= _totalCost;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text("إرسال ترويج",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Cairo')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("تفاصيل الحملة الترويجية", isDark),
              const SizedBox(height: 15),
              _buildNotificationForm(hasEnoughBalance, isDark),
              const SizedBox(height: 25),
              _buildSectionHeader("ملخص الحملة والوصول", isDark),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildCostSummaryCard(isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTargetSummaryCard(isDark)),
                ],
              ),
              const SizedBox(height: 20),
              _buildBalanceInfo(currentBalance, isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            fontFamily: 'Cairo'));
  }

  Widget _buildNotificationForm(bool hasEnoughBalance, bool isDark) {
    String distanceLabel = _distance <= 3.0
        ? "${(_distance * 1000).toInt()} متر"
        : "${_distance.toInt()} كم";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("عنوان الإشعار", isDark),
          _buildTextField(
              _titleController, "مثال: خصم 20% لفترة محدودة!", isDark),
          const SizedBox(height: 20),
          _buildLabel("نص الرسالة الترويجية", isDark),
          _buildTextField(_bodyController,
              "اكتب هنا ما تود قوله لعملائك المستهدفين...", isDark,
              maxLines: 3),
          const SizedBox(height: 20),
          _buildLabel("تحديد الجمهور", isDark),
          _buildTargetDropdown(isDark),
          if (_targetGroup != "المتابعين فقط") ...[
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("نطاق الوصول الجغرافي", isDark),
                Text(distanceLabel,
                    style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
            Slider(
              value: _distance <= 3.0 ? _distance * 10 : _distance + 27,
              min: 1,
              max: 77,
              divisions: 76,
              activeColor: const Color(0xFF4CAF50),
              onChanged: (val) {
                setState(() {
                  if (val <= 30) {
                    _distance = val / 10.0;
                  } else {
                    _distance = (val - 27);
                  }
                  _reachCount = _followersCount + (_distance * 500).toInt();
                });
              },
            ),
          ],
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hasEnoughBalance
                    ? const Color(0xFF4CAF50)
                    : Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: hasEnoughBalance
                  ? () => _showPaymentConfirmation(isDark)
                  : null,
              child: Text(
                hasEnoughBalance ? "إرسال الحملة الآن" : "الرصيد غير كافٍ",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("تأكيد الدفع والارسال",
              style:
                  TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          content: Text(
              "سيتم خصم مبلغ ${_totalCost.toStringAsFixed(2)} ريال من محفظة متجرك لتمويل هذه الحملة. هل أنت موافق؟",
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14)),
          actions: [
            TextButton(
                onPressed: () => context.pop(),
                child: const Text("إلغاء",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                ref
                    .read(merchantBalanceProvider.notifier)
                    .update((state) => state - _totalCost);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("تم إطلاق الحملة بنجاح ✅",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Cairo')),
                      backgroundColor: Colors.green),
                );
              },
              child: const Text("تأكيد وإرسال",
                  style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostSummaryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isDark
              ? Colors.orange.withOpacity(0.05)
              : const Color(0xFFFFF9C4).withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange.withOpacity(0.2))),
      child: Column(children: [
        const Icon(Icons.account_balance_wallet_outlined,
            color: Colors.orange, size: 28),
        const SizedBox(height: 10),
        const Text("التكلفة المقدرة",
            style: TextStyle(
                fontSize: 11, color: Colors.grey, fontFamily: 'Cairo')),
        Text("${_totalCost.toStringAsFixed(2)} ريال",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange)),
      ]),
    );
  }

  Widget _buildTargetSummaryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isDark
              ? Colors.green.withOpacity(0.05)
              : const Color(0xFFE8F5E9).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2))),
      child: Column(children: [
        const Icon(Icons.track_changes_outlined,
            color: Color(0xFF4CAF50), size: 28),
        const SizedBox(height: 10),
        const Text("الوصول المتوقع",
            style: TextStyle(
                fontSize: 11, color: Colors.grey, fontFamily: 'Cairo')),
        Text("$_reachCount عميل",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50))),
      ]),
    );
  }

  Widget _buildBalanceInfo(double currentBalance, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.blue),
          const SizedBox(width: 10),
          Text("رصيدك الحالي: ${currentBalance.toStringAsFixed(2)} ريال",
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildTargetDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _targetGroup,
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          isExpanded: true,
          items: ["المتابعين فقط", "المتابعين وغير المتابعين (الباقة الذهبية)"]
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'Cairo'))))
              .toList(),
          onChanged: (val) {
            setState(() {
              _targetGroup = val!;
              _reachCount = val == "المتابعين فقط"
                  ? _followersCount
                  : _followersCount + (_distance * 500).toInt();
            });
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
              fontFamily: 'Cairo')));

  Widget _buildTextField(
          TextEditingController controller, String hint, bool isDark,
          {int maxLines = 1}) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: isDark ? Colors.white24 : Colors.grey, fontSize: 13),
          filled: true,
          fillColor: isDark ? Colors.black26 : Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200)),
        ),
      );
}
