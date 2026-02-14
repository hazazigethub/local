import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
import 'package:app2030/main.dart';
// ✅ استيراد مزود إحصائيات التاجر
import 'package:app2030/features/merchant/dashboard/presentation/providers/merchant_provider.dart';

// الاستيرادات
import 'pages/merchant_reservations_page.dart';
import 'pages/merchant_orders_list_page.dart';
import 'pages/reports_page.dart';
import 'pages/reviews_page.dart';
import 'pages/products_page.dart';
import 'pages/offers_page.dart';
import 'pages/promotions_page.dart';
import 'pages/notifications_page.dart';
import 'pages/store_settings_page.dart';
import 'pages/manage_reels_page.dart';
import 'pages/cost_calculator_page.dart';
import 'useful_links/useful_links_page.dart';
import 'widgets/partners_page.dart';
import 'pages/merchant_bank_account_page.dart';
import 'pages/merchant_subscriptions_page.dart';
import 'pages/merchant_location_page.dart';

class MerchantDashboardScreen extends ConsumerStatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  ConsumerState<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState
    extends ConsumerState<MerchantDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 2;

  // ✅ تحديث الصفحة الرئيسية للتاجر لتشمل الإحصائيات
  Widget _getBottomNavPage(MerchantStats stats, bool isDark) {
    switch (_bottomNavIndex) {
      case 0:
        return const MerchantReservationsPage();
      case 1:
        return const MerchantOrdersListPage();
      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              _buildStatsSection(
                  stats, isDark), // ✅ إضافة قسم الإحصائيات الحقيقية
              const PartnersPage(),
              const SizedBox(height: 30),
            ],
          ),
        );
      default:
        return const Center(child: Text("المحتوى الرئيسي"));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ مراقبة الإحصائيات من المزود
    final stats = ref.watch(merchantStatsProvider);

    Future.microtask(() {
      if (ref.read(appTypeProvider) != AppType.merchant) {
        ref.read(appTypeProvider.notifier).state = AppType.merchant;
      }
    });

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        drawer: _buildSideNavigationMenu(isDark),
        body: Column(
          children: [
            _buildTopHeader(isDark),
            Expanded(
                child: _getBottomNavPage(stats, isDark)), // تمرير الإحصائيات
          ],
        ),
        bottomNavigationBar: _buildBottomBar(isDark),
      ),
    );
  }

  // ✅ بناء قسم الإحصائيات الحقيقية
  Widget _buildStatsSection(MerchantStats stats, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ملخص العمليات اليوم",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildStatCard(
                  "الأرباح",
                  "${stats.totalRevenue.toStringAsFixed(0)} SAR",
                  Icons.account_balance_wallet_rounded,
                  const Color(0xFF4CAF50),
                  isDark),
              const SizedBox(width: 12),
              _buildStatCard("طلبات نشطة", stats.activeOrders.toString(),
                  Icons.pending_actions_rounded, Colors.orange, isDark),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            "طلبات مكتملة",
            stats.completedOrders.toString(),
            Icons.check_circle_rounded,
            Colors.blue,
            isDark,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isDark,
      {bool isFullWidth = false}) {
    return Expanded(
      flex: isFullWidth ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey, fontFamily: 'Cairo')),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(bool isDark) {
    int unreadNotificationsCount = 2;
    final themeMode = ref.watch(merchantThemeModeProvider);

    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          _buildMenuButton(),
          _buildNotificationButton(isDark, unreadNotificationsCount),
          _buildThemeToggleButton(themeMode, isDark),
          const Spacer(),
          _buildWelcomeText(isDark),
          const SizedBox(width: 12),
          _buildProfileAvatar(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.storeSettings),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF4CAF50), width: 1.5)),
        child: const CircleAvatar(
            radius: 18,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?u=merchant')),
      ),
    );
  }

  Widget _buildWelcomeText(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("مرحباً بك،",
            style: TextStyle(fontSize: 11, color: Colors.grey)),
        Text("متجر الرويضة المركزي",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isDark ? Colors.white : const Color(0xFF2D3436))),
      ],
    );
  }

  Widget _buildThemeToggleButton(ThemeMode themeMode, bool isDark) {
    return IconButton(
      onPressed: () {
        ref.read(merchantThemeModeProvider.notifier).state =
            themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
      icon: Icon(
        themeMode == ThemeMode.dark
            ? Icons.light_mode_outlined
            : Icons.dark_mode_outlined,
        size: 24,
        color: isDark ? Colors.white : const Color(0xFF2D3436),
      ),
    );
  }

  Widget _buildNotificationButton(bool isDark, int count) {
    return IconButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NotificationsPage())),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_outlined,
              size: 26, color: isDark ? Colors.white : const Color(0xFF2D3436)),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        width: 1.5)),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text('$count',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      icon: const Icon(Icons.grid_view_rounded,
          size: 28, color: Color(0xFF4CAF50)),
    );
  }

  Widget _buildSideNavigationMenu(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerTile("التقارير", Icons.analytics_rounded,
                    const ReportsPage(), isDark),
                _buildDrawerTile("التقييمات", Icons.star_rounded,
                    const ReviewsPage(), isDark),
                _buildDrawerTile("المنتجات", Icons.inventory_2_rounded,
                    const ProductsPage(), isDark),
                _buildDrawerTile("العروض", Icons.local_offer_rounded,
                    const OffersPage(), isDark),
                _buildDrawerTile("الترويج", Icons.campaign_rounded,
                    const PromotionsPage(), isDark),
                _buildDrawerTile("إدارة الريلز", Icons.play_circle_outline,
                    const ManageReelsPage(), isDark),
                _buildDrawerTile("حاسبة التكاليف", Icons.calculate_outlined,
                    const CostCalculatorPage(), isDark),
                const Divider(height: 30),
                _buildDrawerTile("روابط تهمك", Icons.link_rounded,
                    const UsefulLinksPage(), isDark),
                _buildDrawerTile("موقع المتجر", Icons.location_on_rounded,
                    const MerchantLocationPage(), isDark),
                _buildDrawerTile("الاشتراكات", Icons.card_membership_rounded,
                    const MerchantSubscriptionsPage(), isDark),
                _buildDrawerTile(
                    "الحساب البنكي",
                    Icons.account_balance_wallet_rounded,
                    const MerchantBankAccountPage(),
                    isDark),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildDrawerTile(
                "تسجيل الخروج", Icons.logout_rounded, null, isDark,
                color: Colors.redAccent, isLogout: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 150,
      width: double.infinity,
      color: const Color(0xFF4CAF50),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomRight,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.storefront, color: Color(0xFF4CAF50))),
          SizedBox(height: 10),
          Text("لوحة التحكم",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
      String title, IconData icon, Widget? targetPage, bool isDark,
      {Color? color, bool isLogout = false}) {
    final Color dynamicColor =
        color ?? (isDark ? Colors.white70 : const Color(0xFF2D3436));
    return ListTile(
      leading: Icon(icon, color: dynamicColor, size: 22),
      title: Align(
          alignment: Alignment.centerRight,
          child: Text(title,
              style: TextStyle(
                  color: dynamicColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Cairo'))),
      onTap: () {
        if (isLogout) {
          context.go(RoutePaths.login);
        } else if (targetPage != null) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => targetPage));
        }
      },
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5))
          ]),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: const Color(0xFFB2BEC3),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: "الحجوزات"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded), label: "الطلبات"),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max_rounded), label: "الرئيسية"),
        ],
      ),
    );
  }
}
