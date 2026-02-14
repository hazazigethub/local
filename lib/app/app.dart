import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ استدعاءات Core (التي أنشأناها في الخطوة 2)
import 'package:app2030/core/config/app_theme.dart';
import 'package:app2030/core/routing/app_router.dart';
import 'app_providers.dart';

class LocalApp extends ConsumerWidget {
  const LocalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة المتغيرات
    final isDark = ref.watch(isDarkModeProvider);
    final localeCode = ref.watch(localeProvider);

    // ✅ مراقبة الراوتر
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LOCAL',

      // إعدادات اللغة
      locale: Locale(localeCode),

      // ✅ تفعيل الثيم الذي بنيناه
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      // ✅ تفعيل الراوتر
      routerConfig: router,
    );
  }
}
