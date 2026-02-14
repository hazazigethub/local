import 'package:flutter/material.dart';

// نموذج المنتج
class Product {
  final String name, subName, category, image, description;
  final double price, rating;
  bool isFavorite;

  Product({
    required this.name,
    required this.subName,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.description =
        "هذا المنتج محضر من أجود المكونات الطازجة يومياً لضمان المذاق الرائع والجودة العالية.",
    this.isFavorite = false,
  });
}

class StorePreviewPage extends StatefulWidget {
  const StorePreviewPage({super.key});
  @override
  State<StorePreviewPage> createState() => _StorePreviewPageState();
}

class _StorePreviewPageState extends State<StorePreviewPage> {
  String selectedCategory = "الكل";
  final List<String> categories = ["الكل", "كومبو", "سلايدر", "كلاسيك"];

  final List<Product> allProducts = [
    Product(
        name: "تشيز برجر",
        subName: "ويندي برجر",
        price: 15.0,
        rating: 4.5,
        category: "كلاسيك",
        image: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
    Product(
        name: "هامبرجر فيجي",
        subName: "فيجي برجر",
        price: 20.0,
        rating: 4.8,
        category: "كلاسيك",
        image: 'https://cdn-icons-png.flaticon.com/512/3595/3595455.png'),
    Product(
        name: "وجبة دبل تشيز",
        subName: "دبل برجر",
        price: 30.0,
        rating: 4.7,
        category: "كومبو",
        image: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
    Product(
        name: "سلايدر دجاج",
        subName: "دجاج برجر",
        price: 25.0,
        rating: 4.5,
        category: "سلايدر",
        image: 'https://cdn-icons-png.flaticon.com/512/3595/3595455.png'),
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    List<Product> displayedProducts = selectedCategory == "الكل"
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      // ✅ تحديث خلفية الصفحة
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: 50),
            _buildStoreInfo(isDark),
            const SizedBox(height: 20),
            _buildCategoriesBar(isDark),
            _buildProductsGrid(displayedProducts, isDark),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          // ✅ تحديث خلفية الشاشة المنبثقة
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(child: Image.network(product.image, height: 200)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${product.price} ريال",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        Text(product.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("(${product.rating})",
                            style: const TextStyle(color: Colors.grey)),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 10),
                        Text(product.category,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Divider(
                        height: 40,
                        color: isDark ? Colors.white10 : Colors.grey[200]),
                    Text("الوصف",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 10),
                    Text(product.description,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey,
                            height: 1.5)),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("إغلاق",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
            'https://img.freepik.com/free-photo/delicious-burger-with-fresh-ingredients_23-2150857908.jpg',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover),
        Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
                backgroundColor: isDark ? Colors.black54 : Colors.white,
                child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(context)))),
        Positioned(
            bottom: -40,
            right: 20,
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                    shape: BoxShape.circle),
                child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.red,
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3595/3595455.png')))),
      ],
    );
  }

  Widget _buildStoreInfo(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("وهمي برجر",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black)),
          Text("مطعم برجر مصري • الرياض، شارع التخصصي",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey, fontSize: 14)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _badge("4.9", Icons.star, Colors.amber, isDark),
              _badge("2.4 كم", Icons.map_outlined, Colors.blue, isDark),
              _badge("مجاناً", Icons.delivery_dining, Colors.green, isDark),
              _badge("30 د", Icons.timer_outlined, Colors.red, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesBar(bool isDark) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = categories[index]),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green
                      : (isDark ? Colors.white10 : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected
                          ? Colors.green
                          : (isDark ? Colors.white24 : Colors.grey.shade300))),
              child: Center(
                  child: Text(categories[index],
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black)))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(List<Product> products, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemCount: products.length,
      itemBuilder: (context, index) => _productCard(products[index], isDark),
    );
  }

  Widget _productCard(Product p, bool isDark) {
    return GestureDetector(
      onTap: () => _showProductDetails(context, p, isDark),
      child: Container(
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isDark) BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
            border: isDark
                ? Border.all(color: Colors.white.withOpacity(0.05))
                : null),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Center(child: Image.network(p.image))),
                  Text(p.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black)),
                  Text(p.subName,
                      style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.grey,
                          fontSize: 11)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${p.price} ريال",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        Row(children: [
                          Text("${p.rating}",
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black)),
                          const Icon(Icons.star, color: Colors.amber, size: 14)
                        ])
                      ]),
                ],
              ),
            ),
            Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                    onTap: () => setState(() => p.isFavorite = !p.isFavorite),
                    child: Icon(
                        p.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: p.isFavorite ? Colors.red : Colors.grey,
                        size: 20))),
          ],
        ),
      ),
    );
  }

  Widget _badge(String l, IconData i, Color c, bool isDark) => Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: c.withOpacity(isDark ? 0.2 : 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Text(l,
            style:
                TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)),
        Icon(i, size: 12, color: c)
      ]));
}
