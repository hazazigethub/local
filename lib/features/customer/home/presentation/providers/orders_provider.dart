import 'package:flutter_riverpod/flutter_riverpod.dart';

// نموذج بسيط للطلب
class OrderModel {
  final String id;
  final String storeName;
  final double totalAmount;
  final String status;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.storeName,
    required this.totalAmount,
    required this.status,
    required this.date,
  });
}

// مدير حالة الطلبات
class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);

  // دالة إضافة طلب جديد عند إتمامه من السلة
  void addOrder(OrderModel order) {
    state = [order, ...state]; // إضافة الطلب الجديد في بداية القائمة
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) {
  return OrdersNotifier();
});
