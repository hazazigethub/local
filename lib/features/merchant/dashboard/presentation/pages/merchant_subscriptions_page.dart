import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter للملاحة الموحدة
import 'package:app2030/main.dart';

class MerchantSubscriptionsPage extends StatefulWidget {
  const MerchantSubscriptionsPage({super.key});

  @override
  State<MerchantSubscriptionsPage> createState() =>
      _MerchantSubscriptionsPageState();
}

class _MerchantSubscriptionsPageState extends State<MerchantSubscriptionsPage> {
  int _selectedPlanIndex = 1; // جعل الباقة الاحترافية مختارة افتراضياً

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text("باقات وخطط الاشتراك",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black)),
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                size: 20, color: isDark ? Colors.white : Colors.black),
            onPressed: () => context.pop(), // ✅ استخدام GoRouter
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildPlanCard(
                context,
                isDark: isDark,
                index: 0,
                price: "19",
                title: "Starter (البداية)",
                description: "أطلق العنان لقوة الأتمتة الأساسية في متجرك.",
                features: [
                  "نظام Zaps بخطوات متعددة",
                  "3 تطبيقات مميزة",
                  "فريق عمل من مستخدمين"
                ],
              ),
              const SizedBox(height: 20),
              _buildPlanCard(
                context,
                isDark: isDark,
                index: 1,
                price: "54",
                title: "Professional (الاحترافية)",
                description:
                    "أدوات متقدمة لنقل عملك ومبيعاتك إلى المستوى التالي.",
                features: [
                  "نظام Zaps غير محدود",
                  "تطبيقات Premium غير محدودة",
                  "فريق عمل يصل لـ 50 مستخدم",
                  "مساحة عمل مشتركة للمتجر"
                ],
                isRecommended: true, // تمييز الباقة الأكثر طلباً
              ),
              const SizedBox(height: 20),
              _buildPlanCard(
                context,
                isDark: isDark,
                index: 2,
                price: "99",
                currency: "SAR",
                title: "Company (الشركات)",
                description: "أتمتة كاملة بالإضافة إلى ميزات المؤسسات الكبرى.",
                features: [
                  "دعم فني مخصص 24/7",
                  "تطبيقات مميزة غير محدودة",
                  "عدد مستخدمين غير محدود",
                  "إدارة متقدمة للصلاحيات",
                  "الاحتفاظ المخصص بالبيانات"
                ],
              ),
              const SizedBox(height: 25),
              // ✅ الإضافة المطلوبة: ملحق حدود العروض (لربطها بصفحة العروض)
              _buildOffersLimitInfo(isDark),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت توضح علاقة الاشتراك بحدود العروض التي يتم إنشاؤها
  Widget _buildOffersLimitInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "ترقية الاشتراك تمنحك القدرة على إضافة عروض ترويجية أكثر واستهداف عدد أكبر من المنتجات في حملاتك.",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      {required bool isDark,
      required int index,
      required String price,
      String currency = "\$",
      required String title,
      required String description,
      required List<String> features,
      bool isRecommended = false}) {
    bool isSelected = _selectedPlanIndex == index;
    Color activeColor = const Color(0xFF4CAF50);

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white10 : activeColor.withOpacity(0.3)),
              width: isSelected ? 2 : 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                  color: Colors.green.withOpacity(isDark ? 0.4 : 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(10)),
                child: Text("الأكثر شيوعاً",
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(currency == "SAR" ? price : "\$$price",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black))),
                if (currency == "SAR") const SizedBox(width: 4),
                Text(currency == "SAR" ? "sar" : "",
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black),
                        fontWeight: FontWeight.bold)),
                Text(" / شهرياً",
                    style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Cairo')),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black),
                    fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            Text(description,
                style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white.withOpacity(0.9)
                        : (isDark ? Colors.white60 : Colors.grey[600]),
                    fontFamily: 'Cairo')),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Colors.white24)),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: isSelected ? Colors.white : activeColor,
                          size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(f,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white70
                                          : Colors.black87),
                                  fontSize: 13,
                                  fontFamily: 'Cairo'))),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionPaymentPage(
                        planTitle: title,
                        price: price,
                        currency: currency,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.white : activeColor,
                  foregroundColor: isSelected ? activeColor : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("اختيار وتفعيل الخطة",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPaymentPage extends ConsumerWidget {
  final String planTitle;
  final String price;
  final String currency;

  const SubscriptionPaymentPage({
    super.key,
    required this.planTitle,
    required this.price,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double currentBalance = ref.watch(merchantBalanceProvider);
    final double planPrice = double.tryParse(price) ?? 0.0;
    final bool hasEnoughBalance = currentBalance >= planPrice;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text("تأكيد الاشتراك والدفع",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          leading: IconButton(
              icon: const Icon(Icons.close), onPressed: () => context.pop()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("ملخص الفاتورة", isDark),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInvoiceRow("الباقة المختارة", planTitle, isDark,
                        isBold: true),
                    const Divider(height: 30),
                    _buildInvoiceRow(
                        "قيمة الاشتراك", "$price $currency", isDark,
                        color: const Color(0xFF4CAF50)),
                    _buildInvoiceRow("رصيدك الحالي",
                        "${currentBalance.toStringAsFixed(2)} SAR", isDark),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildSectionTitle("طريقة السداد", isDark),
              const SizedBox(height: 15),
              _buildPaymentOption(context, isDark, Icons.account_balance_wallet,
                  "الخصم من محفظة المتجر",
                  isSelected: true),
              _buildPaymentOption(context, isDark, Icons.credit_card,
                  "بطاقة بنكية (مدى / فيزا)"),
              const Spacer(),
              _buildSubmitButton(
                  context, ref, planPrice, hasEnoughBalance, planTitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) => Text(title,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
          fontFamily: 'Cairo'));

  Widget _buildInvoiceRow(String label, String value, bool isDark,
          {bool isBold = false, Color? color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontFamily: 'Cairo', color: Colors.grey, fontSize: 14)),
            Text(value,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                    color: color ?? (isDark ? Colors.white : Colors.black))),
          ],
        ),
      );

  Widget _buildPaymentOption(
          BuildContext context, bool isDark, IconData icon, String title,
          {bool isSelected = false}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50).withOpacity(0.05)
              : (isDark ? Colors.white.withOpacity(0.02) : Colors.white),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : (isDark ? Colors.white10 : Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey),
            const SizedBox(width: 15),
            Text(title,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isDark ? Colors.white : Colors.black)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF4CAF50), size: 20),
          ],
        ),
      );

  Widget _buildSubmitButton(BuildContext context, WidgetRef ref,
          double planPrice, bool hasEnoughBalance, String title) =>
      SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: hasEnoughBalance
              ? () {
                  ref
                      .read(merchantBalanceProvider.notifier)
                      .update((state) => state - planPrice);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("تهانينا! تم تفعيل باقة $title بنجاح ✅",
                            style: const TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: const Color(0xFF4CAF50),
                        behavior: SnackBarBehavior.floating),
                  );
                  context.pop();
                  context.pop();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                hasEnoughBalance ? const Color(0xFF4CAF50) : Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Text(
              hasEnoughBalance
                  ? "تأكيد والاشتراك الآن"
                  : "عذراً، الرصيد غير كافٍ",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo')),
        ),
      );
}
