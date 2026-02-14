import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app2030/core/routing/app_router.dart';

// ✅ 1. تعريف أنواع التطبيق
enum AppType { customer, merchant, auth }

// ✅ 2. تعريف المزودات (Providers) كمتغيرات عالمية

// مزود الثيم الخاص بالعميل
final customerThemeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.system);

// مزود الثيم الخاص بالتاجر
final merchantThemeModeProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.light);

// 💰 مزود الرصيد الإجمالي للتاجر
final merchantBalanceProvider = StateProvider<double>((ref) => 5000.0);

// 📍 مزود إحداثيات موقع المتجر (نقطة الارتكاز الثابتة)
// تم تعريفه كخريطة تحتوي على خط العرض والطول
final merchantLocationProvider = StateProvider<Map<String, double>>((ref) => {
      'lat': 24.7136,
      'lng': 46.6753,
    });

// المزود المسؤول عن تحديد "أين المستخدم الآن؟"
final appTypeProvider = StateProvider<AppType>((ref) => AppType.auth);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appType = ref.watch(appTypeProvider);

    // 🛡️ منطق الفصل الجذري (The Switcher):
    final ThemeMode activeThemeMode = switch (appType) {
      AppType.customer => ref.watch(customerThemeModeProvider),
      AppType.merchant => ref.watch(merchantThemeModeProvider),
      AppType.auth => ThemeMode.light,
    };

    const Color brandGreen = Color(0xFF4CAF50);

    return MaterialApp.router(
      routerConfig: router,
      title: 'App 2030',
      debugShowCheckedModeBanner: false,
      themeMode: activeThemeMode,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGreen,
          primary: brandGreen,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: _appBarTheme(brandGreen, Brightness.light),
        elevatedButtonTheme: _buttonTheme(brandGreen),
        inputDecorationTheme: _inputTheme(brandGreen, Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        canvasColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGreen,
          primary: brandGreen,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        appBarTheme: _appBarTheme(brandGreen, Brightness.dark),
        elevatedButtonTheme: _buttonTheme(brandGreen),
        inputDecorationTheme: _inputTheme(brandGreen, Brightness.dark),
      ),
    );
  }

  // --- دوال مساعدة للتنسيق الموحد ---

  AppBarTheme _appBarTheme(Color primary, Brightness brightness) {
    bool isLight = brightness == Brightness.light;
    return AppBarTheme(
      backgroundColor: isLight ? Colors.white : const Color(0xFF121212),
      foregroundColor: isLight ? Colors.black : Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isLight ? Colors.black : Colors.white,
      ),
    );
  }

  ElevatedButtonThemeData _buttonTheme(Color color) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        textStyle:
            const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  InputDecorationTheme _inputTheme(Color color, Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? Colors.grey.shade50
          : const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.5),
      ),
      hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
    );
  }
}
