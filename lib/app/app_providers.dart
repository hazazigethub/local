import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Providers الأساسية (سيتم ربطها بالتخزين لاحقاً) ---

// 1. مزود الثيم (Theme Mode)
// false = Light Mode, true = Dark Mode
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// 2. مزود اللغة (Locale)
// القيمة الافتراضية 'ar' (العربية)
final localeProvider = StateProvider<String>((ref) => 'ar');

// 3. حالة المصادقة (Auth State)
// هل المستخدم مسجل دخول أم لا؟
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);
