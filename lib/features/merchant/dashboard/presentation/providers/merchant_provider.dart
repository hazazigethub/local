import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app2030/features/customer/home/presentation/providers/orders_provider.dart';

// نموذج بيانات الإحصائيات
class MerchantStats {
  final double totalRevenue; // إجمالي الأرباح
  final int activeOrders; // الطلبات النشطة
  final int completedOrders; // الطلبات المكتملة

  MerchantStats({
    required this.totalRevenue,
    required this.activeOrders,
    required this.completedOrders,
  });
}

// المزود الذي يحسب الإحصائيات بناءً على قائمة الطلبات العامة
final merchantStatsProvider = Provider<MerchantStats>((ref) {
  // مراقبة مزود الطلبات (الذي يضيف فيه العميل طلباته)
  final allOrders = ref.watch(ordersProvider);

  // حساب إجمالي المبالغ من كافة الطلبات
  double revenue = allOrders.fold(0, (sum, item) => sum + item.totalAmount);

  // حساب عدد الطلبات النشطة (التي لم تكتمل بعد)
  int active = allOrders.where((o) => o.status != "مكتمل").length;

  // حساب عدد الطلبات المكتملة
  int completed = allOrders.where((o) => o.status == "مكتمل").length;

  return MerchantStats(
    totalRevenue: revenue,
    activeOrders: active,
    completedOrders: completed,
  );
});
