import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/main.dart';
import 'package:app2030/core/routing/route_paths.dart';

// استيراد الموديلات الأساسية للربط
import 'package:app2030/core/models/merchant_model.dart';
import 'package:app2030/core/models/product_model.dart';
import 'package:app2030/core/models/reel_model.dart';

// استيراد الصفحات
import 'package:app2030/features/customer/home/presentation/pages/reels_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/profile_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/favourites_page.dart';
import 'package:app2030/features/customer/home/presentation/pages/orders_list_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _bottomNavIndex = 4;
  final Set<String> _likedItems = {};

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      if (ref.read(appTypeProvider) != AppType.customer) {
        ref.read(appTypeProvider.notifier).state = AppType.customer;
      }
    });

    final bool isReelsPage = _bottomNavIndex == 2;
    final bool isGlobalDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isReelsPage
            ? Colors.black
            : Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          top: !isReelsPage,
          child: _buildCurrentPage(),
        ),
        bottomNavigationBar: _buildBottomNavBar(isReelsPage, isGlobalDark),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_bottomNavIndex) {
      case 4:
        return _buildHomeContent();
      case 3:
        return const FavouritesPage();
      case 2:
        return const ReelsPage();
      case 1:
        return const OrdersListPage();
      case 0:
        return const ProfilePage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildPromoBanner(), // ✅ تم استعادة القسم
                _buildSectionHeader("اكتشف حسب التصنيف", false),
                _buildCategories(), // ✅ تم استعادة القسم
                _buildSectionHeader("اكتشف أطباق المناطق", false),
                _buildRegionsSection(), // ✅ تم استعادة القسم
                _buildSectionHeader("متجر بالقرب منك", false),
                _buildNearbyLogos(),
                _buildSectionHeader("عروض اليوم", true),
                _buildFoodList("عروض اليوم"),
                _buildSectionHeader("الأكثر شعبية", true),
                _buildFoodList("الأكثر شعبية"),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 1. ✅ استعادة بنر العروض (Carousel-like Banner)
  Widget _buildPromoBanner() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1000'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("خصم يصل إلى 50%",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Cairo')),
                  Text("على أول طلب لك من تطبيقنا",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Cairo')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 2. ✅ استعادة التصنيفات (Horizontal Categories)
  Widget _buildCategories() {
    final categories = [
      {"name": "برجر", "icon": Icons.lunch_dining},
      {"name": "بيتزا", "icon": Icons.local_pizza},
      {"name": "حلويات", "icon": Icons.cake},
      {"name": "قهوة", "icon": Icons.coffee},
      {"name": "شاورما", "icon": Icons.kebab_dining},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categories[index]["icon"] as IconData,
                      color: Theme.of(context).colorScheme.primary, size: 28),
                ),
                const SizedBox(height: 8),
                Text(categories[index]["name"] as String,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ],
            ),
          );
        },
      ),
    );
  }

  // 3. ✅ استعادة أطباق المناطق (Regions Section)
  Widget _buildRegionsSection() {
    final regions = ["نجدية", "حجازية", "جنوبية", "شمالية"];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1541544741938-0af808891447?q=80&w=500'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.3),
              ),
              alignment: Alignment.center,
              child: Text(regions[index],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Cairo')),
            ),
          );
        },
      ),
    );
  }

  // 4. ✅ رأس الأقسام (Section Header) المنقح
  Widget _buildSectionHeader(String title, bool showAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
          if (showAll)
            TextButton(
              onPressed: () {},
              child: Text("عرض الكل",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                      fontFamily: 'Cairo')),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on,
                  color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 5),
              const Text("السعودية، الرويضة",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Cairo')),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          IconButton(
            onPressed: () => context.push(RoutePaths.cart),
            icon: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).iconTheme.color),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () => context.push(RoutePaths.searchResults),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Expanded(
                  child: Text("ابحث عن متجر أو أطباق",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontFamily: 'Cairo'))),
              Icon(Icons.tune, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyLogos() {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                final merchant = MerchantModel(
                  id: "m$index",
                  storeName: "متجر النخبة $index",
                  description: "أفضل المأكولات الشعبية في منطقتك",
                  logoUrl: "https://via.placeholder.com/150",
                  coverImageUrl:
                      "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
                  category: "مطعم شعبي",
                  isVerified: true,
                );
                context.push(RoutePaths.storeDetails, extra: merchant);
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(Icons.storefront, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 5),
                  const Text("اسم المتجر",
                      style: TextStyle(fontSize: 10, fontFamily: 'Cairo')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodList(String sectionTitle) {
    return SizedBox(
      height: 285,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final String itemKey = "$sectionTitle-$index";
          final bool isLiked = _likedItems.contains(itemKey);

          return InkWell(
            onTap: () {
              final product = ProductModel(
                id: "p-$sectionTitle-$index",
                merchantId: "m1",
                name: sectionTitle == "عروض اليوم"
                    ? "برجر دبل تشيز"
                    : "ساندوتش دجاج",
                description: "وجبة طازجة محضرة بأفضل المكونات المحلية.",
                price: 99.0,
                imagesUrl: [
                  "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500"
                ],
                category: "وجبات",
                createdAt: DateTime.now(),
              );
              context.push(RoutePaths.productDetails, extra: product);
            },
            child: Container(
              width: 250,
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.network(
                            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: IconButton(
                            icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 20),
                            onPressed: () => setState(() => isLiked
                                ? _likedItems.remove(itemKey)
                                : _likedItems.add(itemKey)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                sectionTitle == "عروض اليوم"
                                    ? "برجر دبل تشيز"
                                    : "ساندوتش دجاج",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo')),
                            Text("99 SAR",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const Text(" 4.9",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            _buildBadge(Icons.delivery_dining, "مجاني",
                                Colors.green.withOpacity(0.1), Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadge(
      IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: iconColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isReels, bool isGlobalDark) {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) => setState(() => _bottomNavIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: isReels
          ? Colors.black
          : Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: const Color(0xFF4CAF50),
      unselectedItemColor:
          isReels || isGlobalDark ? Colors.white60 : Colors.grey,
      selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "الحساب"),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined), label: "الطلبات"),
        BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline), label: "ريلز"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "المفضلة"),
        BottomNavigationBarItem(
            icon: Icon(Icons.home_filled), label: "الرئيسية"),
      ],
    );
  }
}
