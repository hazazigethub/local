import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ إضافة Riverpod
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
// ✅ استيراد مزود الطلبات
import 'package:app2030/features/customer/home/presentation/providers/orders_provider.dart';

class OrdersListPage extends ConsumerWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ مراقبة الطلبات الحقيقية من الـ Provider
    final dynamicOrders = ref.watch(ordersProvider);

    // قائمة الطلبات التجريبية (للمعاينة)
    final List<Map<String, dynamic>> staticOrders = [
      {
        "id": "#12544",
        "storeName": "وهمي برجر",
        "status": "بانتظار قبول الطلب",
        "statusColor": Colors.blue,
        "date": "2024-05-20 | 12:30 م",
        "price": "120 SAR",
        "amount": 120.0,
        "type": "طلب فوري",
        "items": "3 وجبات"
      },
      {
        "id": "#12490",
        "storeName": "شاورما فاكتوري",
        "status": "مكتمل",
        "statusColor": const Color(0xFF4CAF50),
        "date": "2024-05-19 | 09:15 م",
        "price": "45 SAR",
        "amount": 45.0,
        "type": "طلب فوري",
        "items": "2 وجبة"
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.5,
          title: const Text(
            "طلباتي",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Cairo'),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ✅ عرض الطلبات الجديدة (الحقيقية) أولاً
            ...dynamicOrders.map(
                (order) => _buildOrderCardFromModel(context, order, isDark)),

            // عرض الطلبات التجريبية
            ...staticOrders
                .map((order) => _buildOrderCardFromMap(context, order, isDark)),
          ],
        ),
      ),
    );
  }

  // ✅ بناء بطاقة الطلب من الموديل الحقيقي (القادم من السلة)
  Widget _buildOrderCardFromModel(
      BuildContext context, OrderModel order, bool isDark) {
    final data = {
      "id": order.id,
      "storeName": order.storeName,
      "status": order.status,
      "statusColor": Colors.orange, // لون افتراضي للطلبات الجديدة
      "date": "${order.date.year}-${order.date.month}-${order.date.day}",
      "price": "${order.totalAmount} SAR",
      "amount": order.totalAmount,
      "type": "طلب من السلة",
      "items": "منتجات السلة"
    };
    return _buildOrderCardFromMap(context, data, isDark);
  }

  Widget _buildOrderCardFromMap(
      BuildContext context, Map<String, dynamic> order, bool isDark) {
    return InkWell(
      onTap: () {
        final chatData = {
          'orderId': order['id'],
          'storeName': order['storeName'],
          'orderType': order['type'],
          'orderTime': order['date'],
          'totalAmount': order['amount'],
          'orderStatus': order['status'],
        };
        context.push(RoutePaths.chat, extra: chatData);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      child: Icon(Icons.receipt_long,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order['storeName'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Cairo')),
                        Text(order['id'],
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'Cairo')),
                      ],
                    ),
                  ],
                ),
                _buildStatusBadge(order['status'], order['statusColor']),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("${order['items']} | ${order['date']}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Cairo')),
                  ],
                ),
                Text(
                  order['price'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontFamily: 'Cairo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            fontFamily: 'Cairo'),
      ),
    );
  }
}
