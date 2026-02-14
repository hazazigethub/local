import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
import 'package:app2030/core/routing/route_paths.dart'; // ✅ استيراد المسارات الصحيحة
import 'package:app2030/main.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  // ✅ دالة إظهار نافذة اختيار اللغة (تستخدم الآن context.pop)
  void _showLanguagePicker(
      BuildContext context, bool isDarkMode, Color primaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "اختر اللغة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(
                    context, "العربية", "ar", true, isDarkMode, primaryColor),
                _buildLanguageOption(
                    context, "English", "en", false, isDarkMode, primaryColor),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ ودجت خيار اللغة الفردي (يستخدم الآن context.pop)
  Widget _buildLanguageOption(BuildContext context, String title, String code,
      bool isSelected, bool isDark, Color primaryColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white : Colors.black87),
        ),
      ),
      trailing:
          isSelected ? Icon(Icons.check_circle, color: primaryColor) : null,
      onTap: () {
        context.pop(); // ✅ استخدام GoRouter
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appType = ref.watch(appTypeProvider);
    final customerTheme = ref.watch(customerThemeModeProvider);
    final merchantTheme = ref.watch(merchantThemeModeProvider);

    final currentThemeMode =
        (appType == AppType.customer) ? customerTheme : merchantTheme;

    final bool isDarkMode = currentThemeMode == ThemeMode.dark ||
        (currentThemeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    final Color primaryAppColor = Theme.of(context).colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            appType == AppType.customer ? "ملف العميل" : "ملف التاجر",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildProfileHeader(context, primaryAppColor, isDarkMode),
              const SizedBox(height: 35),
              _buildSectionTitle("الحساب", primaryAppColor),
              _buildListTile(context, Icons.person_outline, "المعلومات الشخصية",
                  onTap: () =>
                      context.push(RoutePaths.personalInfo)), // ✅ GoRouter

              _buildSectionTitle("المساعدة والدعم", primaryAppColor),
              _buildListTile(context, Icons.help_outline, "الأسئلة الشائعة",
                  onTap: () => context.push(RoutePaths.faq)), // ✅ GoRouter

              _buildListTile(
                  context, Icons.headset_mic_outlined, "خدمة العملاء",
                  onTap: () =>
                      context.push(RoutePaths.customerService)), // ✅ GoRouter

              _buildListTile(
                  context, Icons.privacy_tip_outlined, "سياسة الخصوصية",
                  onTap: () =>
                      context.push(RoutePaths.privacyPolicy)), // ✅ GoRouter

              _buildListTile(context, Icons.gavel_outlined, "الشروط والأحكام",
                  onTap: () =>
                      context.push(RoutePaths.termsConditions)), // ✅ GoRouter

              _buildSectionTitle("الإعدادات", primaryAppColor),
              _buildListTile(
                context,
                Icons.language,
                "اللغة",
                trailingText: "العربية",
                onTap: () =>
                    _showLanguagePicker(context, isDarkMode, primaryAppColor),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(thickness: 0.8),
              ),
              const SizedBox(height: 10),

              // ✅ تسجيل الخروج باستخدام context.go للعودة للبداية ومسح السجل
              _buildActionTile(context, Icons.logout_rounded, "تسجيل الخروج",
                  Colors.red.shade600,
                  onTap: () => context.go(RoutePaths.login)),

              _buildActionTile(context, Icons.delete_forever_outlined,
                  "حذف الحساب", Colors.red.shade600, onTap: () {
                context.push(RoutePaths.deleteAccount); // ✅ GoRouter
              }),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets المساعدة ---

  Widget _buildProfileHeader(
      BuildContext context, Color primaryColor, bool isDark) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor.withOpacity(0.2), width: 4),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
            ],
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundColor:
                isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
            child: Icon(Icons.person, size: 50, color: primaryColor),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          "عمر سامي",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Cairo'),
        ),
        const SizedBox(height: 6),
        Text(
          "+96612345678",
          style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 12),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      {String? trailingText, VoidCallback? onTap}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            size: 22, color: isDark ? Colors.white70 : Colors.black87),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
      ),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 13, fontFamily: 'Cairo')),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, IconData icon, String title, Color color,
      {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            fontFamily: 'Cairo'),
      ),
    );
  }
}
