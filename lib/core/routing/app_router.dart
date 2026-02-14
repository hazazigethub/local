import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ تصحيح مسار الاستيراد
import 'package:app2030/core/routing/route_paths.dart';

// ✅ استيراد الموديلات
import 'package:app2030/core/models/reel_model.dart';
import 'package:app2030/core/models/merchant_model.dart';
import 'package:app2030/core/models/product_model.dart';

// ✅ استيراد صفحات العميل (Customer Features)
import 'package:app2030/features/splash/presentation/splash_screen.dart';
import 'package:app2030/features/onboarding/presentation/onboarding_shell.dart';
import 'package:app2030/features/auth/presentation/login_screen.dart';
import 'package:app2030/features/auth/presentation/register_screen.dart';
import 'package:app2030/features/auth/presentation/otp_screen.dart';
import 'package:app2030/features/customer/home/presentation/pages/Home_Screen.dart';
import 'package:app2030/features/customer/home/presentation/pages/reels_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/store_details_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/product_details_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/cart_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/customer_order_chat_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/favourites_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/profile_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/orders_list_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/search_results_page.dart';

// ✅ إضافة استيرادات الصفحات الفرعية للبروفايل
import 'package:app2030/features/customer/home/presentation/pages/personal_information_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/faq_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/customer_service_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/privacy_policy_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/terms_conditions_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/delete_account_page.dart'
    as customer;

// ✅ استيراد صفحات التاجر (Merchant Features)
import 'package:app2030/features/merchant/dashboard/presentation/merchant_dashboard_screen.dart';
import 'package:app2030/features/merchant/dashboard/presentation/pages/store_settings_page.dart';
import 'package:app2030/features/merchant/dashboard/presentation/pages/delete_account_page.dart'
    as merchant;
import 'package:app2030/features/merchant/dashboard/presentation/pages/manage_reels_page.dart';
import 'package:app2030/features/merchant/dashboard/presentation/pages/review_reels_page.dart';
import 'package:app2030/features/merchant/dashboard/presentation/pages/cost_calculator_page.dart';
import 'package:app2030/features/merchant/dashboard/presentation/useful_links/useful_links_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      // 1. مسارات البداية
      GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: RoutePaths.onboarding,
          builder: (context, state) => const OnboardingShell()),

      // 2. مسارات المصادقة
      GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: RoutePaths.register,
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            phoneNumber: extra?['phone'] ?? '',
            isMerchant: extra?['isMerchant'] ?? false,
          );
        },
      ),

      // 3. مسارات العميل الأساسية
      GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: RoutePaths.reels,
        builder: (context, state) {
          if (state.extra is List<ReelModel>) {
            return ReelsPage(reels: state.extra as List<ReelModel>);
          }
          return const ReelsPage();
        },
      ),
      GoRoute(
        path: RoutePaths.storeDetails,
        builder: (context, state) =>
            StoreDetailsPage(merchant: state.extra as MerchantModel),
      ),
      GoRoute(
        path: RoutePaths.productDetails,
        builder: (context, state) =>
            ProductDetailsPage(product: state.extra as ProductModel),
      ),

      // 4. مسارات التفاعل والعمليات
      GoRoute(
          path: RoutePaths.cart, builder: (context, state) => const CartPage()),
      GoRoute(
        path: RoutePaths.chat,
        builder: (context, state) => CustomerOrderChatPage(
            chatData: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
          path: RoutePaths.searchResults,
          builder: (context, state) => const SearchResultsPage()),
      GoRoute(
          path: RoutePaths.favourites,
          builder: (context, state) => const FavouritesPage()),
      GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const ProfilePage()),
      GoRoute(
          path: RoutePaths.ordersList,
          builder: (context, state) => const OrdersListPage()),

      // ✅ إضافة مسارات البروفايل الفرعية (Customer)
      GoRoute(
          path: RoutePaths.personalInfo,
          builder: (context, state) => const PersonalInformationPage()),
      GoRoute(
          path: RoutePaths.faq, builder: (context, state) => const FAQPage()),
      GoRoute(
          path: RoutePaths.customerService,
          builder: (context, state) => const CustomerServicePage()),
      GoRoute(
          path: RoutePaths.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyPage()),
      GoRoute(
          path: RoutePaths.termsConditions,
          builder: (context, state) => const TermsConditionsPage()),
      GoRoute(
          path: '/delete-account-customer',
          builder: (context, state) => const customer.DeleteAccountPage()),

      // 5. مسارات التاجر
      GoRoute(
          path: RoutePaths.merchantHome,
          builder: (context, state) => const MerchantDashboardScreen()),
      GoRoute(
          path: RoutePaths.storeSettings,
          builder: (context, state) => const StoreSettingsPage()),
      GoRoute(
          path: RoutePaths.deleteAccount,
          builder: (context, state) => const merchant.DeleteAccountPage()),
      GoRoute(
          path: RoutePaths.manageReels,
          builder: (context, state) => const ManageReelsPage()),
      GoRoute(
        path: RoutePaths.reviewReels,
        builder: (context, state) =>
            ReviewReelsPage(reel: state.extra as ReelModel),
      ),
      GoRoute(
          path: RoutePaths.costCalculator,
          builder: (context, state) => const CostCalculatorPage()),
      GoRoute(
          path: RoutePaths.usefulLinks,
          builder: (context, state) => const UsefulLinksPage()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Error: ${state.error}')),
    ),
  );
});
