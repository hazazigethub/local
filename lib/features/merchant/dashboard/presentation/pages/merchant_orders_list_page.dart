import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart'; // ✅ مضاف لدعم التنقل الجديد
import 'package:app2030/core/routing/route_paths.dart'; // ✅ مضاف للوصول للمسارات
// ✅ تصحيح مسار الاستيراد للوصول لملف محادثة العميل
import 'package:app2030/features/customer/home/presentation/pages/customer_order_chat_page.dart';

class MerchantOrdersListPage extends StatefulWidget {
  const MerchantOrdersListPage({super.key});

  @override
  State<MerchantOrdersListPage> createState() => _MerchantOrdersListPageState();
}

class _MerchantOrdersListPageState extends State<MerchantOrdersListPage> {
  late List<Map<String, dynamic>> orders;
  Timer? _timer;
  int _instantPrepTime = 30;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    orders = [
      {
        "id": "#R-1024",
        "customerName": "أحمد محمد",
        "status": "فعال",
        "statusColor": Colors.green,
        "date": "29 ديسمبر 2025",
        "acceptedAt": DateTime.now().subtract(const Duration(minutes: 5)),
        "hasActions": false,
        "isReady": false,
        "notes": "الرجاء عدم إضافة بصل، وزيادة صوص الجبن في البرجر.",
      },
      {
        "id": "#R-2050",
        "customerName": "سارة علي",
        "status": "في الانتظار",
        "statusColor": Colors.orange,
        "date": "29 ديسمبر 2025",
        "hasActions": true,
        "isReady": false,
        "notes": "",
      },
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ✅ نافذة تفاصيل الطلب المحدثة مع دعم الوضع الليلي
  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.receipt_long_rounded,
                          color: Color(0xFF4CAF50)),
                    ),
                    const SizedBox(width: 12),
                    Text("تفاصيل الفاتورة",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade200)),
                      child: _buildDetailRow("رقم الطلب", order['id'],
                          isBold: true, isDark: isDark),
                    ),
                    const SizedBox(height: 25),
                    Text("الأصناف المطلوبة",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 12),
                    _buildOrderItemRow("دبل تشيز برجر", "1", "99.0", isDark),
                    _buildOrderItemRow("بطاطس حجم عائلي", "1", "15.0", isDark),
                    if (order['notes'] != null &&
                        order['notes'].toString().isNotEmpty) ...[
                      const SizedBox(height: 25),
                      Row(
                        children: const [
                          Icon(Icons.notes_rounded,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text("ملاحظات الطلب",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Colors.orange.withOpacity(0.2)),
                        ),
                        child: Text(
                          order['notes'],
                          style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black87,
                              height: 1.5),
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252525) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5))
                  ],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("الإجمالي الشامل",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black)),
                        const Text("114.0 SAR",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0),
                      child: const Text("إغلاق",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemRow(
      String name, String qty, String price, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade100)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.fastfood_outlined,
                color: isDark ? Colors.white38 : Colors.grey, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black)),
                Text("الكمية: $qty",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text("$price SAR",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  void _showQuickOrderSettings(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("إعدادات الطلبات الفورية",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black)),
                Divider(
                    height: 40,
                    color: isDark ? Colors.white10 : Colors.grey.shade200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("وقت تجهيز الطلب المتوقع (دقيقة):",
                        style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black)),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                setModalState(() => _instantPrepTime += 5),
                            icon: const Icon(Icons.add_circle,
                                color: Color(0xFF4CAF50))),
                        Text("$_instantPrepTime",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isDark ? Colors.white : Colors.black)),
                        IconButton(
                            onPressed: () => setModalState(() {
                                  if (_instantPrepTime > 5)
                                    _instantPrepTime -= 5;
                                }),
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: const Text("حفظ التحديث",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmCompletion(int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text("تأكيد إتمام وتسليم الطلب",
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Text(
              "هل استلم العميل الطلب بنجاح؟\nسيتم إغلاق الطلب وإرسال صفحة التقييمات للعميل فوراً.",
              style:
                  TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50)),
              onPressed: () {
                setState(() {
                  orders[index]['status'] = "تم التسليم";
                  orders[index]['statusColor'] = Colors.blueGrey;
                  orders[index]['isReady'] = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("تم إغلاق الطلب وإرسال طلب التقييم للعميل ✅")),
                );
              },
              child: const Text("نعم، تم التسليم",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _buildSearchBar(isDark),
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: Text("لا توجد طلبات حالياً",
                            style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        itemCount: orders.length,
                        itemBuilder: (context, index) =>
                            _buildOrderCard(index, isDark),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: const InputDecoration(
                  hintText: "بحث عن طلب...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.timer_outlined, color: Color(0xFF4CAF50)),
              onPressed: () => _showQuickOrderSettings(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(int index, bool isDark) {
    final order = orders[index];
    bool isConfirmed = order['status'] == "فعال";
    bool isReady = order['isReady'] ?? false;
    bool isDelivered = order['status'] == "تم التسليم";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          boxShadow: [
            if (!isDark)
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
          ]),
      child: Column(
        children: [
          if (isConfirmed && !isReady && !isDelivered) ...[
            _buildTimerLogic(order['acceptedAt']),
            const SizedBox(height: 12),
          ],
          _buildDetailRow("العميل", order['customerName'] ?? "غير معروف",
              isDark: isDark),
          _buildDetailRow("رقم الطلب", order['id'], isDark: isDark),
          _buildDetailRow("الحالة", order['status'],
              color: order['statusColor'], isDark: isDark),
          const SizedBox(height: 15),
          if (isConfirmed || isReady) ...[
            if (!isReady && !isDelivered)
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    order['isReady'] = true;
                    order['status'] = "جاهز للاستلام";
                    order['statusColor'] = Colors.blue;
                  }),
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  label: const Text("الطلب جاهز للاستلام",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              )
            else if (isReady && !isDelivered)
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmCompletion(index),
                  icon:
                      const Icon(Icons.handshake_outlined, color: Colors.white),
                  label: const Text("تم التسليم (إغلاق وطلب تقييم)",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
            if (!isDelivered) const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showOrderDetails(context, order),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("تفاصيل الطلب",
                      style: TextStyle(color: Color(0xFF4CAF50))),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // ✅ 1. تجميع البيانات في حقيبة (Map) لحل الخطأ الأحمر
                  final chatData = {
                    'orderId': order['id'],
                    'storeName': "متجري",
                    'orderType': "طلب فوري",
                    'orderTime': order['status'] == "في الانتظار"
                        ? "في انتظار القبول لبدء التنفيذ"
                        : "خلال $_instantPrepTime دقيقة",
                    'totalAmount': 114.0,
                    'orderStatus': order['status'],
                  };

                  // ✅ 2. الانتقال باستخدام GoRouter الموحد
                  context.push(RoutePaths.chat, extra: chatData);
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chat_bubble_outline,
                      color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
          if (order['hasActions']) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      order['status'] = "فعال";
                      order['statusColor'] = Colors.green;
                      order['hasActions'] = false;
                      order['acceptedAt'] = DateTime.now();
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50)),
                    child: const Text("قبول الطلب",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      order['status'] = "مرفوض";
                      order['statusColor'] = Colors.red;
                      order['hasActions'] = false;
                    }),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red)),
                    child:
                        const Text("رفض", style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? color, bool isBold = false, required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:",
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.bold,
                  color: color ?? (isDark ? Colors.white : Colors.black),
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTimerLogic(DateTime? acceptedAt) {
    if (acceptedAt == null) return const SizedBox();
    final deadline = acceptedAt.add(Duration(minutes: _instantPrepTime));
    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative)
      return const Text("⚠️ تجاوز وقت التجهيز",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withOpacity(0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Text("وقت التجهيز المتبقي: $minutes:$seconds",
              style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
