import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
import 'package:app2030/core/models/product_model.dart';
import 'package:app2030/core/models/merchant_model.dart';
import 'package:app2030/core/routing/route_paths.dart';
import 'package:app2030/main.dart';

// تعريف مزود للملفات المفضلة
final favouritesProvider =
    StateProvider<List<int>>((ref) => List.generate(6, (index) => index));

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteItems = ref.watch(favouritesProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: "المنتجات"),
              Tab(text: "المتاجر"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- التبويب الأول: المنتجات ---
            favouriteItems.isEmpty
                ? const Center(
                    child: Text("قائمة المنتجات المفضلة فارغة",
                        style: TextStyle(fontFamily: 'Cairo')))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: favouriteItems.length,
                    itemBuilder: (context, index) {
                      return _buildFavouriteCard(context, ref, index, isDark);
                    },
                  ),

            // --- التبويب الثاني: المتاجر ---
            _buildFavouriteStores(context, isDark),
          ],
        ),
      ),
    );
  }

  // ✅ بناء بطاقة المنتج المفضلة مع تمرير الموديل المطلوب
  Widget _buildFavouriteCard(
      BuildContext context, WidgetRef ref, int index, bool isDark) {
    return InkWell(
      onTap: () {
        // ✅ إنشاء كائن المنتج (حل مشكلة Required named parameter 'product')
        final product = ProductModel(
          id: "fav_$index",
          merchantId: "m1",
          name: "برجر دبل تشيز المفضل",
          description:
              "برجر مشوي على اللهب مع جبنة شيدر مدخنة، خس طازج وصوص خاص.",
          price: 99.0,
          imagesUrl: [
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500'
          ],
          category: "برجر",
          createdAt: DateTime.now(),
        );

        // ✅ الانتقال باستخدام GoRouter وتمرير الموديل في الـ extra
        context.push(RoutePaths.productDetails, extra: product);
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(favouritesProvider.notifier).update((state) {
                        final list = List<int>.from(state);
                        list.removeAt(index);
                        return list;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite,
                          color: Colors.red, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 6, backgroundColor: Colors.red),
                      const SizedBox(width: 5),
                      Text("Wahmey Burger",
                          style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.grey[400] : Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("99 SAR",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 2),
                  const Text(
                    "Double cheeseburge...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Cairo'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(" 4.9",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black87)),
                      const Spacer(),
                      _buildSmallBadge(
                          Icons.location_on,
                          "2.4 km",
                          isDark
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.blue.shade50,
                          Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ بناء تبويب المتاجر المفضلة مع ربط الانتقال الصحيح
  Widget _buildFavouriteStores(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1))),
          child: ListTile(
            onTap: () {
              // ✅ تمرير موديل التاجر لصفحة تفاصيل المتجر
              final merchant = MerchantModel(
                id: "m1",
                storeName: "وهمي برجر",
                description: "أفضل تجربة برجر في المدينة",
                logoUrl:
                    "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
                coverImageUrl:
                    "https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?q=80&w=1000",
                category: "مطاعم",
                isVerified: true,
              );
              context.push(RoutePaths.storeDetails, extra: merchant);
            },
            leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3075/3075977.png')),
            title: const Text("وهمي برجر",
                style: TextStyle(
                    fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            subtitle: const Text("الرياض، شارع التخصصي",
                style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildSmallBadge(
      IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 11, color: iconColor),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
