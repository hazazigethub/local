import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// سيتم تفعيله في الخطوة 2
// import '../core/services/storage_service.dart';

class AppBootstrap {
  /// دالة لتهيئة كل شيء قبل إطلاق التطبيق
  static Future<ProviderContainer> createContainer() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. تهيئة SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // 2. إنشاء حاوية Riverpod مع التعديلات (Overrides)
    final container = ProviderContainer(
      overrides: [
        // سنقوم بربط خدمة التخزين هنا في الخطوة القادمة
        // storageServiceProvider.overrideWithValue(StorageService(prefs)),
      ],
    );

    // 3. قراءة الإعدادات المحفوظة (سنضيفها لاحقاً)

    return container;
  }
}
