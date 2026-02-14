import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ إضافة Riverpod
import 'package:app2030/core/models/product_model.dart';
// ✅ استيراد مزود السلة (سنتأكد من وجوده في الخطوة التالية)
// import 'package:app2030/features/customer/home/presentation/providers/cart_provider.dart';

// ✅ تحويل الصفحة إلى ConsumerStatefulWidget للوصول لـ ref
class ProductDetailsPage extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  bool isDescriptionSelected = true;
  bool isFavorite = false;

  final List<Map<String, dynamic>> _reviews = [
    {
      "name": "عبدالله محمد",
      "rating": 5,
      "date": "منذ يومين",
      "comment": "من أفضل الوجبات التي جربتها، الطعم طازج والخدمة سريعة جداً.",
      "image": "https://i.pravatar.cc/150?u=a"
    },
    {
      "name": "سارة أحمد",
      "rating": 4,
      "date": "منذ أسبوع",
      "comment": "الطعم رائع، تجربة ممتازة وسأكررها بالتأكيد.",
      "image": "https://i.pravatar.cc/150?u=b"
    }
  ];

  void _handleAddToCart() {
    // ✅ منطق السلة الحقيقي: إضافة المنتج للمزود
    // ref.read(cartProvider.notifier).addItem(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text("تمت إضافة ${widget.product.name} إلى السلة",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("تم نسخ رابط المنتج للمشاركة",
            textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Cairo')),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHero(),
                  _buildProductHeader(),
                  _buildProductTitle(),
                  _buildBadgesRow(isDark),
                  _buildTabs(isDark),
                  isDescriptionSelected
                      ? _buildDescription()
                      : _buildReviewsList(isDark),
                  _buildSimilarMealsSection(isDark),
                ],
              ),
            ),
            _buildBottomActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHero() {
    return Stack(
      children: [
        Image.network(
          widget.product.imagesUrl.isNotEmpty
              ? widget.product.imagesUrl[0]
              : 'https://via.placeholder.com/1000',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 50,
          right: 20,
          left: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _handleShare,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: const Icon(Icons.ios_share,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.category_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(widget.product.category,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      fontFamily: 'Cairo')),
            ],
          ),
          Row(
            children: [
              Text("${(widget.product.price * 1.2).toStringAsFixed(0)} SAR",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                      fontFamily: 'Cairo',
                      fontSize: 14)),
              const SizedBox(width: 10),
              Text("${widget.product.price} SAR",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 22)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        widget.product.name,
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.3,
            fontFamily: 'Cairo'),
      ),
    );
  }

  Widget _buildBadgesRow(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoBadge(Icons.star, "4.9", Colors.amber, isDark),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            _buildTabItem("الوصف", isDescriptionSelected, isDark,
                () => setState(() => isDescriptionSelected = true)),
            _buildTabItem("التقييمات", !isDescriptionSelected, isDark,
                () => setState(() => isDescriptionSelected = false)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
      String title, bool isSelected, bool isDark, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo'),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        widget.product.description,
        style: TextStyle(
            color: Colors.grey.shade500,
            height: 1.6,
            fontSize: 15,
            fontFamily: 'Cairo'),
      ),
    );
  }

  Widget _buildReviewsList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(review['image'])),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Cairo')),
                          Text(review['date'],
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontFamily: 'Cairo')),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(
                        5,
                        (i) => Icon(Icons.star,
                            size: 14,
                            color: i < review['rating']
                                ? Colors.amber
                                : Colors.grey.shade300)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(review['comment'],
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                      fontFamily: 'Cairo',
                      height: 1.4)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimilarMealsSection(bool isDark) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("وجبات مشابهة ستظهر بناءً على تصنيف المنتج",
          style:
              TextStyle(fontFamily: 'Cairo', color: Colors.grey, fontSize: 13)),
    );
  }

  Widget _buildBottomActionButton() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: ElevatedButton(
          onPressed: _handleAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Text("إضافة إلى السلة",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.white)),
        ),
      ),
    );
  }
}
