import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
// ✅ استيراد مزود السلة والطلبات والموديلات
import 'package:app2030/features/customer/home/presentation/providers/cart_provider.dart';
import 'package:app2030/features/customer/home/presentation/providers/orders_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  // متغيرات التحكم في اختيار الموعد
  DateTime _selectedReservationDate = DateTime.now();
  final int _merchantInstantPrepTime = 45;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // ✅ مراقبة حالة السلة من المزود
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: const Text("سلة التسوق",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'Cairo')),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).iconTheme.color),
            onPressed: () => context.pop(),
          ),
        ),
        // ✅ عرض حالة فارغة إذا كانت السلة لا تحتوي على منتجات
        body: cartItems.isEmpty
            ? _buildEmptyState(isDark)
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildStoreOrderCard(cartItems, cartNotifier, isDark),
                ],
              ),
      ),
    );
  }

  // ✅ بناء السلة بناءً على البيانات القادمة من الـ Provider
  Widget _buildStoreOrderCard(
      List<CartItem> items, CartNotifier notifier, bool isDark) {
    double subtotal = notifier.totalAmount;
    double deliveryFee = 15.0;
    double total = subtotal + deliveryFee;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.storefront,
                    color: Theme.of(context).colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                const Text("متجر طلباتي",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
          const Divider(height: 1),
          // ✅ عرض العناصر الحقيقية
          ...items.map((cartItem) => _buildCartItem(cartItem, isDark)).toList(),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Column(
              children: [
                _buildPriceRow(
                    context, "الإجمالي", "${total.toStringAsFixed(2)} SAR",
                    isBold: true),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showOrderSelectionMenu(total, isDark),
                    child: const Text("إرسال الطلب",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                  cartItem.product.imagesUrl.isNotEmpty
                      ? cartItem.product.imagesUrl[0]
                      : 'https://via.placeholder.com/150',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                Text("الكمية: ${cartItem.quantity}",
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                        fontSize: 11,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
          Text("${cartItem.product.price * cartItem.quantity} SAR",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  void _showOrderSelectionMenu(double total, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("اختر نوع الخدمة",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
                const SizedBox(height: 20),
                _buildOrderOption(
                  icon: Icons.bolt,
                  color: Colors.orange,
                  title: "طلب فوري",
                  subtitle:
                      "سيتم تجهيز طلبك خلال $_merchantInstantPrepTime دقيقة من قبوله",
                  onTap: () {
                    context.pop();
                    _navigateToChat(total, "طلب فوري",
                        "في انتظار القبول لبدء التنفيذ", "بانتظار قبول الطلب");
                  },
                ),
                const Divider(),
                _buildOrderOption(
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                  title: "حجز مسبق",
                  subtitle: "قم بتحديد تاريخ ووقت محدد لحجزك",
                  onTap: () {
                    context.pop();
                    _navigateToChat(total, "حجز مسبق", "تم تحديد الموعد",
                        "بانتظار قبول الحجز");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ تحديث المنطق: حفظ الطلب، تفريغ السلة، ثم الانتقال للمحادثة
  void _navigateToChat(double total, String type, String time, String status) {
    String id =
        "#ID-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

    // 1. إضافة الطلب إلى مزود الطلبات (OrdersProvider)
    ref.read(ordersProvider.notifier).addOrder(
          OrderModel(
            id: id,
            storeName: "متجر طلباتي",
            totalAmount: total,
            status: status,
            date: DateTime.now(),
          ),
        );

    // 2. تفريغ السلة تماماً بعد تحويلها لطلب
    ref.read(cartProvider.notifier).clearCart();

    // 3. تجهيز بيانات المحادثة
    final chatData = {
      'orderId': id,
      'storeName': "متجر طلباتي",
      'orderType': type,
      'orderTime': time,
      'totalAmount': total,
      'orderStatus': status,
    };

    // 4. الانتقال باستخدام GoRouter
    context.push(RoutePaths.chat, extra: chatData);

    // 5. إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم إرسال طلبك بنجاح وحفظه في سجل الطلبات",
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined,
              size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 20),
          const Text("سلتك فارغة حالياً",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOrderOption(
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color, child: Icon(icon, color: Colors.white)),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, fontFamily: 'Cairo')),
      onTap: onTap,
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value,
      {bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isBold
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo')),
        Text(value,
            style: TextStyle(
                color: isBold
                    ? Theme.of(context).colorScheme.primary
                    : (isDark ? Colors.white : Colors.black),
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo')),
      ],
    );
  }
}
