import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/config/app_colors.dart'; // تأكد أن المسار صحيح
import 'package:app2030/core/routing/route_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  // دالة الانتقال بعد 3 ثواني
  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // حالياً نذهب دائماً للـ Onboarding (سنضيف فحص التخزين لاحقاً)
      context.go(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // اللون الأخضر #4DAD6E
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة مؤقتة (سنستبدلها بصورة الشعار لاحقاً)
            const Icon(Icons.location_on_outlined,
                size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "LOCAL",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
