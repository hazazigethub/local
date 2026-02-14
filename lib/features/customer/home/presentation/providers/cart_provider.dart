import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app2030/core/models/product_model.dart';

// ✅ 1. تعريف نموذج عنصر السلة (المنتج + الكمية)
class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  // دالة لنسخ العنصر مع تعديل الكمية
  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// ✅ 2. تعريف الـ Notifier لإدارة حالة السلة
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // إضافة منتج للسلة
  void addItem(ProductModel product) {
    // التحقق إذا كان المنتج موجوداً مسبقاً
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // إذا وجدناه، نزيد الكمية فقط
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i]
      ];
    } else {
      // إذا لم نجده، نضيفه كعنصر جديد بكمية 1
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  // تقليل كمية منتج أو حذفه
  void removeItem(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (state[index].quantity > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              state[i].copyWith(quantity: state[index].quantity - 1)
            else
              state[i]
        ];
      } else {
        // إذا كانت الكمية 1، نحذف العنصر تماماً
        state = state.where((item) => item.product.id != productId).toList();
      }
    }
  }

  // مسح السلة بالكامل
  void clearCart() {
    state = [];
  }

  // حساب السعر الإجمالي
  double get totalAmount {
    return state.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // حساب إجمالي عدد القطع
  int get totalItemsCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// ✅ 3. تعريف الـ Provider الذي سنستخدمه في الصفحات
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
