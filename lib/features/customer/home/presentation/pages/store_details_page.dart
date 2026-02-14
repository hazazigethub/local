import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
// ✅ استيراد الموديلات والمسارات الصحيحة
import 'package:app2030/core/models/merchant_model.dart';
import 'package:app2030/core/models/product_model.dart';
import 'package:app2030/core/routing/route_paths.dart';

class StoreDetailsPage extends StatefulWidget {
  final MerchantModel merchant;

  const StoreDetailsPage({super.key, required this.merchant});

  @override
  State<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  int _selectedCategoryIndex = 0;
  bool _isFollowed = false;
  final List<bool> _likedProducts = List.generate(8, (index) => false);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark),
              _buildStoreInfo(context, isDark),
              _buildBadgesRow(isDark),
              _buildCategories(context, isDark),
              _buildProductsGrid(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  // 1. الهيدر (صورة الغلاف والشعار)
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          widget.merchant.coverImageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey, height: 220),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black54 : Colors.white70,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => context.pop(), // ✅ استخدام GoRouter للرجوع
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(widget.merchant.logoUrl),
            ),
          ),
        ),
      ],
    );
  }

  // 2. معلومات المتجر
  Widget _buildStoreInfo(BuildContext context, bool isDark) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.merchant.storeName,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
                  ),
                  if (widget.merchant.isVerified) ...[
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, color: Colors.blue, size: 22),
                  ],
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isFollowed = !_isFollowed),
                icon: Icon(
                  _isFollowed ? Icons.check : Icons.add,
                  size: 18,
                  color: _isFollowed ? Colors.white : primaryColor,
                ),
                label: Text(
                  _isFollowed ? "متابع" : "متابعة",
                  style: TextStyle(
                    color: _isFollowed ? Colors.white : primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFollowed ? primaryColor : Colors.transparent,
                  elevation: 0,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.grey),
              Text(" ${widget.merchant.address ?? 'موقع غير محدد'}",
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey,
                      fontSize: 13,
                      fontFamily: 'Cairo')),
              const SizedBox(width: 10),
              const Icon(Icons.info_outline, size: 14, color: Colors.grey),
              Text(" ${widget.merchant.category}",
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey,
                      fontSize: 13,
                      fontFamily: 'Cairo')),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.merchant.description,
            style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54,
                fontFamily: 'Cairo',
                fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 3. الأوسمة
  Widget _buildBadgesRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoBadge(Icons.star, widget.merchant.averageRating.toString(),
              Colors.amber, isDark),
          _buildInfoBadge(Icons.location_on, "2.4 كم", Colors.blue, isDark),
          _buildInfoBadge(
              Icons.delivery_dining, "مجاناً", Colors.green, isDark),
          _buildInfoBadge(Icons.access_time, "30 د", Colors.red, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.2 : 0.08),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'Cairo')),
          const SizedBox(width: 4),
          Icon(icon, size: 16, color: color),
        ],
      ),
    );
  }

  // 4. التصنيفات
  Widget _buildCategories(BuildContext context, bool isDark) {
    final cats = ["الكل", "جديد", "عروض", "الأكثر مبيعاً"];
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context).dividerColor.withOpacity(0.1)),
              ),
              child: Text(
                cats[index],
                style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo'),
              ),
            ),
          );
        },
      ),
    );
  }

  // 5. شبكة المنتجات (مع ربط التنقل الفعلي)
  Widget _buildProductsGrid(BuildContext context, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // ✅ 1. إنشاء كائن المنتج (حل مشكلة Required named parameter 'product')
            final product = ProductModel(
              id: "prod_${widget.merchant.id}_$index",
              merchantId: widget.merchant.id,
              name: "منتج مميز $index",
              description:
                  "وصف مفصل لمنتج عالي الجودة من متجر ${widget.merchant.storeName}.",
              price: 120.0,
              imagesUrl: [
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500'
              ],
              category: "وجبات",
              createdAt: DateTime.now(),
            );

            // ✅ 2. الانتقال الموحد وتمرير البيانات في الـ extra
            context.push(RoutePaths.productDetails, extra: product);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
                    blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() =>
                              _likedProducts[index] = !_likedProducts[index]),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: isDark
                                ? Colors.black54
                                : Colors.white.withOpacity(0.8),
                            child: Icon(
                              _likedProducts[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _likedProducts[index]
                                  ? Colors.red
                                  : Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text("منتج متجرنا",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                      Text(widget.merchant.storeName,
                          style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey,
                              fontSize: 11,
                              fontFamily: 'Cairo')),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("120 SAR",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo')),
                          const Row(
                            children: [
                              Text("4.8",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.star, color: Colors.amber, size: 14),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
