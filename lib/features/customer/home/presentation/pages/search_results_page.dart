import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
import 'package:app2030/core/routing/route_paths.dart'; // ✅ استيراد المسارات
import 'package:app2030/core/models/product_model.dart'; // ✅ استيراد الموديل

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  int activeFiltersCount = 0;

  final List<Map<String, dynamic>> _allMeals = [
    {
      "name": "وهمي برجر دبل",
      "price": "35 SAR",
      "desc": "برجر لحم دبل مع الجبن",
      "rating": 4.8,
      "dist": "1.2 كم",
      "img":
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=200"
    },
    {
      "name": "تشيز برجر كلاسيك",
      "price": "25 SAR",
      "desc": "برجر دجاج مع طبقة جبن شيدر",
      "rating": 4.5,
      "dist": "2.5 كم",
      "img":
          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=200"
    },
    {
      "name": "برجر دجاج حراق",
      "price": "28 SAR",
      "desc": "صدر دجاج مقرمش مع صوص حار",
      "rating": 4.2,
      "dist": "3.1 كم",
      "img":
          "https://images.unsplash.com/photo-1610614819513-58e34989848b?q=80&w=200"
    },
    {
      "name": "ساندوتش كريسبي",
      "price": "22 SAR",
      "desc": "قطع دجاج كريسبي مع الخس",
      "rating": 4.0,
      "dist": "0.5 كم",
      "img":
          "https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=200"
    },
    {
      "name": "وجبة عائلية برجر",
      "price": "120 SAR",
      "desc": "4 برجر مع بطاطس وحجم عائلي بيبسي",
      "rating": 4.9,
      "dist": "4.0 كم",
      "img":
          "https://images.unsplash.com/photo-1551782450-a2132b4ba21d?q=80&w=200"
    },
  ];

  List<Map<String, dynamic>> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _filteredResults = _allMeals;
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allMeals;
    } else {
      results = _allMeals
          .where((meal) =>
              meal["name"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              meal["desc"]
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black),
            onPressed: () => context.pop(), // ✅ تحديث للرجوع عبر GoRouter
          ),
          title: _buildAppBarSearchField(isDark),
          actions: [
            _buildFilterIconBadge(isDark),
          ],
        ),
        body: _buildSearchResultsList(),
      ),
    );
  }

  Widget _buildAppBarSearchField(bool isDark) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) => _runSearch(value),
        style: const TextStyle(fontFamily: 'Cairo'),
        decoration: const InputDecoration(
          hintText: "ابحث عن وجبة...",
          hintStyle: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
          prefixIcon: Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildFilterIconBadge(bool isDark) {
    return IconButton(
      icon: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black),
      onPressed: () => _showFilterBottomSheet(),
    );
  }

  Widget _buildSearchResultsList() {
    return _filteredResults.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredResults.length,
            itemBuilder: (context, index) =>
                _buildSearchCard(_filteredResults[index]),
          )
        : const Center(
            child: Text("لا توجد نتائج تطابق بحثك",
                style: TextStyle(
                    fontSize: 16, color: Colors.grey, fontFamily: 'Cairo')),
          );
  }

  Widget _buildSearchCard(Map<String, dynamic> meal) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        // ✅ تحويل البيانات إلى ProductModel وتمريرها لصفحة التفاصيل
        final product = ProductModel(
          id: "search_${meal['name']}",
          merchantId: "m1",
          name: meal['name'],
          description: meal['desc'],
          price: double.tryParse(meal['price'].toString().split(' ')[0]) ?? 0.0,
          imagesUrl: [meal['img']],
          category: "وجبات",
          createdAt: DateTime.now(),
        );
        context.push(RoutePaths.productDetails, extra: product);
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(meal["img"],
                  width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(meal["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                      Text(meal["price"],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                    ],
                  ),
                  Text(meal["desc"],
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                          fontSize: 11,
                          fontFamily: 'Cairo')),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(" ${meal["rating"]}",
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on,
                          color: Colors.blue, size: 14),
                      Text(" ${meal["dist"]}",
                          style: const TextStyle(fontSize: 12)),
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    ).then((value) {
      if (value != null) {
        setState(() => activeFiltersCount = value);
      }
    });
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedRating = 4;
  String deliveryType = "Free";
  String orderType = "Direct";
  double distance = 50.0;

  final TextEditingController _minPriceController =
      TextEditingController(text: "15");
  final TextEditingController _maxPriceController =
      TextEditingController(text: "200");

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("التقييم"),
                    _buildRatingSelection(isDark),
                    _buildSectionTitle("التوصيل"),
                    _buildDeliveryToggle(isDark),
                    _buildSectionTitle("نوع الطلب"),
                    _buildOrderTypeToggle(isDark),
                    _buildSectionTitle("المبلغ (SAR)"),
                    _buildPriceInputSquares(isDark),
                    _buildSectionTitle("المسافة (${distance.round()} كم)"),
                    Slider(
                      value: distance,
                      min: 0,
                      max: 100,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) => setState(() => distance = v),
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop()), // ✅ تحديث GoRouter
        const Text("الفلاتر",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Cairo')),
      );

  Widget _buildPriceInputSquares(bool isDark) {
    return Row(
      children: [
        Expanded(child: _priceField("من", _minPriceController, isDark)),
        const SizedBox(width: 20),
        Expanded(child: _priceField("إلى", _maxPriceController, isDark)),
      ],
    );
  }

  Widget _priceField(
      String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontFamily: 'Cairo')),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo'),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            fillColor:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1))),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSelection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        int val = index + 1;
        bool isSel = selectedRating == val;
        return InkWell(
          onTap: () => setState(() => selectedRating = val),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSel
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : (isDark ? Colors.white10 : Colors.white),
              border: Border.all(
                  color: isSel
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Text("$val "),
              const Icon(Icons.star, color: Colors.amber, size: 16)
            ]),
          ),
        );
      }),
    );
  }

  Widget _buildDeliveryToggle(bool isDark) {
    return Row(
      children: [
        Expanded(
            child: _buildChoiceChip("مجاني", deliveryType == "Free", isDark,
                () => setState(() => deliveryType = "Free"))),
        const SizedBox(width: 20),
        Expanded(
            child: _buildChoiceChip("مدفوع", deliveryType == "Fee", isDark,
                () => setState(() => deliveryType = "Fee"))),
      ],
    );
  }

  Widget _buildOrderTypeToggle(bool isDark) {
    return Row(
      children: [
        Expanded(
            child: _buildChoiceChip("مباشر", orderType == "Direct", isDark,
                () => setState(() => orderType = "Direct"))),
        const SizedBox(width: 20),
        Expanded(
            child: _buildChoiceChip("حجز", orderType == "Appointment", isDark,
                () => setState(() => orderType = "Appointment"))),
      ],
    );
  }

  Widget _buildChoiceChip(
      String label, bool isSelected, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : (isDark ? Colors.white10 : Colors.white),
          border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : (isDark ? Colors.white70 : Colors.black))),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () => context.pop(4),
                child: const Text("تطبيق",
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Cairo')))),
        const SizedBox(width: 15),
        TextButton(
          onPressed: () {
            setState(() {
              selectedRating = 4;
              deliveryType = "Free";
              distance = 50.0;
            });
            context.pop(0);
          },
          child: const Text("إعادة ضبط",
              style: TextStyle(color: Colors.red, fontFamily: 'Cairo')),
        ),
      ],
    );
  }
}
