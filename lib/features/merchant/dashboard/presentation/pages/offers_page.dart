import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// نموذج بيانات العرض لإدارة الإضافة والحذف برمجياً
class OfferModel {
  String title;
  String type;
  String dateRange;
  String imageUrl;
  IconData icon;
  bool isVisible;
  String description;
  String productsCount;

  OfferModel({
    required this.title,
    required this.type,
    required this.dateRange,
    required this.imageUrl,
    required this.icon,
    this.isVisible = true,
    this.description = "لا يوجد وصف متوفر لهذا العرض حالياً.",
    this.productsCount = "جميع المنتجات",
  });
}

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final List<OfferModel> _offersList = [
    OfferModel(
      title: "توصيل مجاني - اليوم",
      type: "توصيل مجاني",
      dateRange: "25 سبتمبر - 4 أكتوبر",
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3595/3595455.png",
      icon: Icons.directions_bike,
      description:
          "احصل على توصيل مجاني لجميع الطلبات التي تزيد قيمتها عن 100 ريال خلال فترة العرض.",
      productsCount: "15 منتج",
    ),
    OfferModel(
      title: "اشتر 1 واحصل على 1 مجاناً",
      type: "عرض خاص",
      dateRange: "25 سبتمبر - 4 أكتوبر",
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3595/3595455.png",
      icon: Icons.local_offer_outlined,
      description:
          "اشتري أي بيتزا من الحجم الكبير واحصل على الثانية مجاناً من نفس النوع.",
      productsCount: "8 منتجات",
    ),
  ];

  void _addNewOffer(OfferModel newOffer) {
    setState(() => _offersList.add(newOffer));
  }

  void _deleteOffer(int index) {
    setState(() => _offersList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            "إدارة العروض",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                fontSize: 18),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showAddOfferBottomSheet(context),
                child: _buildAddOfferHeaderButton(isDark),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _offersList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildOfferCard(
                      context, index, _offersList[index], isDark);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddOfferBottomSheet(
        onSave: (title, type, dateRange, description, pCount) {
          _addNewOffer(OfferModel(
            title: title,
            type: type,
            dateRange: dateRange,
            description: description,
            productsCount: pCount,
            imageUrl: "https://cdn-icons-png.flaticon.com/512/3595/3595455.png",
            icon: Icons.local_offer_outlined,
          ));
        },
      ),
    );
  }

  void _showOfferDetails(BuildContext context, OfferModel offer) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text("تفاصيل العرض",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: isDark ? Colors.white : Colors.black)),
            const Divider(height: 30),
            _buildDetailItem("اسم العرض", offer.title, Icons.title, isDark),
            _buildDetailItem(
                "الوصف", offer.description, Icons.description_outlined, isDark),
            _buildDetailItem("المنتجات", offer.productsCount,
                Icons.shopping_bag_outlined, isDark),
            _buildDetailItem("الصلاحية", offer.dateRange,
                Icons.calendar_today_outlined, isDark),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () => context.pop(),
                child: const Text("إغلاق",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11, fontFamily: 'Cairo')),
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'Cairo')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("حذف العرض", style: TextStyle(fontFamily: 'Cairo')),
        content: const Text("هل تريد بالتأكيد حذف هذا العرض؟",
            style: TextStyle(fontFamily: 'Cairo')),
        actions: [
          TextButton(
              onPressed: () => context.pop(), child: const Text("إلغاء")),
          TextButton(
              onPressed: () {
                _deleteOffer(index);
                context.pop();
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildAddOfferHeaderButton(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50)),
          SizedBox(width: 8),
          Text("إضافة عرض ترويجي جديد",
              style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
      BuildContext context, int index, OfferModel offer, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(child: Image.network(offer.imageUrl, height: 80)),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Row(
                  children: [
                    _buildIconButton(Icons.delete_outline, Colors.red, isDark,
                        () => _showDeleteConfirmation(context, index)),
                    const SizedBox(width: 8),
                    _buildIconButton(
                        offer.isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        offer.isVisible ? Colors.green : Colors.grey,
                        isDark,
                        () =>
                            setState(() => offer.isVisible = !offer.isVisible)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showOfferDetails(context, offer),
                  child: Text(offer.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: isDark ? Colors.white : Colors.black)),
                ),
                const SizedBox(height: 8),
                Text("${offer.type} • ${offer.dateRange}",
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12, fontFamily: 'Cairo')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, Color color, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)]),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class AddOfferBottomSheet extends StatefulWidget {
  final Function(String, String, String, String, String) onSave;
  const AddOfferBottomSheet({super.key, required this.onSave});

  @override
  State<AddOfferBottomSheet> createState() => _AddOfferBottomSheetState();
}

class _AddOfferBottomSheetState extends State<AddOfferBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String productsText = "اضافة منتجات للعرض";
  String discountType = "خصم نسبة";
  String startDate = "تاريخ البدء";
  String endDate = "تاريخ الانتهاء";

  void _openSelectProducts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectProductsBottomSheet(
        onProductsSelected: (count) {
          setState(() => productsText = "تم اختيار $count منتجات");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("إضافة عرض جديد",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop()),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(_titleController, "عنوان العرض", isDark),
            const SizedBox(height: 15),

            // ✅ استعادة زر إضافة المنتجات في مكانه الصحيح
            const Text("المنتجات المشمولة",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo')),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openSelectProducts(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3))),
                child: Row(children: [
                  const Icon(Icons.add_shopping_cart,
                      size: 18, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 10),
                  Text(productsText,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo'))
                ]),
              ),
            ),
            const SizedBox(height: 20),
            _buildField(_valueController, "قيمة الخصم", isDark,
                keyboardType: TextInputType.number),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  widget.onSave(_titleController.text, discountType, "2024",
                      _descController.text, productsText);
                  context.pop();
                },
                child: const Text("حفظ ونشر العرض",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, bool isDark,
          {TextInputType? keyboardType}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor:
                  isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none)),
        ),
      );
}

// ✅ نافذة اختيار المنتجات مع استعادة خانة التصنيفات
class SelectProductsBottomSheet extends StatefulWidget {
  final Function(int) onProductsSelected;
  const SelectProductsBottomSheet(
      {super.key, required this.onProductsSelected});

  @override
  State<SelectProductsBottomSheet> createState() =>
      _SelectProductsBottomSheetState();
}

class _SelectProductsBottomSheetState extends State<SelectProductsBottomSheet> {
  final Map<String, List<String>> categoriesData = {
    "الكل": ["برجر", "بيتزا", "كولا", "عصير"],
    "سندوتشات": ["برجر لحم", "برجر دجاج"],
    "بيتزا": ["بيتزا خضار", "بيتزا مارجريتا"],
  };
  String activeCategory = "الكل";
  final Set<String> selected = {};

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(20),
              child: Text("اختار المنتجات",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 17))),

          // ✅ شريط التصنيفات المستعاد
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesData.keys.length,
              itemBuilder: (context, index) {
                String cat = categoriesData.keys.elementAt(index);
                bool isActive = activeCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => activeCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: Text(cat,
                        style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey,
                            fontFamily: 'Cairo',
                            fontSize: 12)),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: categoriesData[activeCategory]!.length,
              itemBuilder: (context, index) {
                String prod = categoriesData[activeCategory]![index];
                return CheckboxListTile(
                  title:
                      Text(prod, style: const TextStyle(fontFamily: 'Cairo')),
                  value: selected.contains(prod),
                  activeColor: const Color(0xFF4CAF50),
                  onChanged: (val) => setState(
                      () => val! ? selected.add(prod) : selected.remove(prod)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                widget.onProductsSelected(selected.length);
                context.pop();
              },
              child: const Text("تأكيد",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
            ),
          )
        ],
      ),
    );
  }
}
