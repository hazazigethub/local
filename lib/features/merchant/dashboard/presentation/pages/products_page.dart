import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';

// نموذج البيانات المحلي
class ProductItem {
  String name;
  String category;
  String price;
  String description;
  String stockInfo;
  bool isAvailable;
  String imageUrl;

  ProductItem({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.stockInfo,
    required this.isAvailable,
    required this.imageUrl,
  });
}

class CategoryItem {
  String name;
  bool isAvailable;
  CategoryItem({required this.name, required this.isAvailable});
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _currentView = "المنتجات";

  final List<ProductItem> _productsList = [
    ProductItem(
      name: "برجر لحم فاخر",
      category: "برغر",
      price: "25 ريال",
      description: "برجر محضر من أجود أنواع اللحم البلدي مع إضافاتنا الخاصة.",
      stockInfo: "متوفر في المخزون 50 قطعة",
      isAvailable: true,
      imageUrl: "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
    ),
  ];

  final List<CategoryItem> _categoriesList = [
    CategoryItem(name: "المشروبات الساخنة", isAvailable: false),
    CategoryItem(name: "المشروبات الباردة", isAvailable: true),
    CategoryItem(name: "الوجبات الرئيسية", isAvailable: true),
    CategoryItem(name: "الحلويات", isAvailable: true),
  ];

  void _addNewProductToList(ProductItem newProduct) {
    setState(() => _productsList.add(newProduct));
  }

  void _editProductInList(int index, ProductItem updatedProduct) {
    setState(() => _productsList[index] = updatedProduct);
  }

  void _deleteProduct(int index) {
    setState(() => _productsList.removeAt(index));
  }

  void _editCategoryInList(int index, String newName) {
    setState(() => _categoriesList[index].name = newName);
  }

  void _deleteCategory(int index) {
    setState(() => _categoriesList.removeAt(index));
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
          actions: [
            IconButton(
                icon: Icon(Icons.search,
                    color: isDark ? Colors.white70 : Colors.grey),
                onPressed: () {}),
            const SizedBox(width: 8),
            _buildAddNewButton(context, isDark),
            const SizedBox(width: 16),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
          title: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              value: _currentView,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white : Colors.black, size: 20),
              onChanged: (String? newValue) {
                setState(() => _currentView = newValue!);
              },
              items: <String>['المنتجات', 'التصنيفات']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          fontSize: 16)),
                );
              }).toList(),
            ),
          ),
          centerTitle: true,
        ),
        body: _currentView == "المنتجات"
            ? _buildProductsView(isDark)
            : _buildCategoriesView(isDark),
      ),
    );
  }

  Widget _buildProductsView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: _productsList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildProductCard(
              context: context,
              index: index,
              product: _productsList[index],
              isDark: isDark),
        );
      },
    );
  }

  Widget _buildCategoriesView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: _categoriesList.length,
      itemBuilder: (context, index) {
        final cat = _categoriesList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
            ],
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100),
          ),
          child: Row(
            children: [
              PopupMenuButton<String>(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.3))),
                  child: const Icon(Icons.more_horiz,
                      color: Color(0xFF4CAF50), size: 20),
                ),
                onSelected: (value) {
                  if (value == "delete") {
                    _deleteCategory(index);
                  } else if (value == "edit") {
                    _showAddCategoryBottomSheet(context, editIndex: index);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: "edit",
                      child: Row(children: [
                        const Icon(Icons.edit_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text("تعديل",
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'Cairo'))
                      ])),
                  PopupMenuItem(
                      value: "delete",
                      child: Row(children: [
                        const Icon(Icons.delete_outline,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text("حذف",
                            style: TextStyle(
                                color: Colors.red, fontFamily: 'Cairo'))
                      ])),
                ],
              ),
              const SizedBox(width: 8),
              Switch(
                value: cat.isAvailable,
                activeColor: const Color(0xFF4CAF50),
                onChanged: (val) {
                  setState(() => cat.isAvailable = val);
                },
              ),
              const Spacer(),
              Text(cat.name,
                  style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddNewButton(BuildContext context, bool isDark) {
    return PopupMenuButton<String>(
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onSelected: (value) {
        if (value == "product") {
          _showAddProductBottomSheet(context);
        } else if (value == "category") {
          _showAddCategoryBottomSheet(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: const [
            Text("أضف جديد",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 13)),
            SizedBox(width: 6),
            Icon(Icons.add, color: Colors.white, size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: "product",
            child: Row(children: [
              const Icon(Icons.fastfood_outlined, size: 18),
              const SizedBox(width: 8),
              Text("منتج جديد",
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'Cairo'))
            ])),
        PopupMenuItem(
            value: "category",
            child: Row(children: [
              const Icon(Icons.category_outlined, size: 18),
              const SizedBox(width: 8),
              Text("تصنيف جديد",
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'Cairo'))
            ])),
      ],
    );
  }

  void _showAddProductBottomSheet(BuildContext context, {int? editIndex}) {
    ProductItem? productToEdit =
        editIndex != null ? _productsList[editIndex] : null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductBottomSheet(
        isEditing: editIndex != null,
        initialProduct: productToEdit,
        onSave: (name, price, desc, category, qty) {
          final newProduct = ProductItem(
            name: name,
            category: category,
            price: price.contains("ريال") ? price : "$price ريال",
            description: desc,
            stockInfo: "متوفر في المخزون $qty قطعة",
            isAvailable: productToEdit?.isAvailable ?? true,
            imageUrl: productToEdit?.imageUrl ??
                "https://cdn-icons-png.flaticon.com/512/3075/3075977.png",
          );
          if (editIndex != null) {
            _editProductInList(editIndex, newProduct);
          } else {
            _addNewProductToList(newProduct);
          }
        },
      ),
    );
  }

  void _showAddCategoryBottomSheet(BuildContext context, {int? editIndex}) {
    TextEditingController _categoryController = TextEditingController(
        text: editIndex != null ? _categoriesList[editIndex].name : "");
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 25,
            left: 24,
            right: 24),
        decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(editIndex != null ? "تعديل التصنيف" : "إنشاء تصنيف جديد",
                style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Text("إسم التصنيف الرئيسي",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: isDark ? Colors.white70 : Colors.black87)),
            const SizedBox(height: 10),
            TextField(
                controller: _categoryController,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'Cairo'),
                decoration: InputDecoration(
                    hintText: "مثلاً: سندوتشات، حلويات، مشروبات...",
                    hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey,
                        fontSize: 13),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none))),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (_categoryController.text.isNotEmpty) {
                    if (editIndex != null) {
                      _editCategoryInList(editIndex, _categoryController.text);
                    } else {
                      setState(() {
                        _categoriesList.add(CategoryItem(
                            name: _categoryController.text, isAvailable: true));
                      });
                    }
                    context.pop();
                  }
                },
                child: Text(
                    editIndex != null ? "حفظ التغييرات" : "نشر التصنيف الآن",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      {required BuildContext context,
      required int index,
      required ProductItem product,
      required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
          ],
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade100)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                    height: 180,
                    width: double.infinity,
                    color: isDark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.grey.shade50,
                    child: Center(
                        child: Image.network(product.imageUrl, height: 120))),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: PopupMenuButton<String>(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1E1E).withOpacity(0.8)
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.5))),
                    child: const Icon(Icons.more_horiz,
                        color: Color(0xFF4CAF50), size: 20),
                  ),
                  onSelected: (value) {
                    if (value == "delete") {
                      _deleteProduct(index);
                    } else if (value == "edit") {
                      _showAddProductBottomSheet(context, editIndex: index);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "edit",
                        child: Row(children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text("تعديل المنتج",
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: 'Cairo'))
                        ])),
                    PopupMenuItem(
                        value: "delete",
                        child: Row(children: [
                          const Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text("حذف نهائي",
                              style: TextStyle(
                                  color: Colors.red, fontFamily: 'Cairo'))
                        ])),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 17,
                              color: isDark ? Colors.white : Colors.black)),
                      Text(product.price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              color: Color(0xFF4CAF50))),
                    ]),
                Text(product.category,
                    style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        height: 1.5)),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider()),
                Row(
                  children: [
                    Switch(
                        value: product.isAvailable,
                        activeColor: const Color(0xFF4CAF50),
                        onChanged: (val) =>
                            setState(() => product.isAvailable = val)),
                    const SizedBox(width: 4),
                    Text(product.isAvailable ? "متاح للطلب" : "غير متاح حالياً",
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black45,
                            fontSize: 12,
                            fontFamily: 'Cairo')),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: product.isAvailable
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                          product.isAvailable
                              ? product.stockInfo
                              : "خارج المخزون",
                          style: TextStyle(
                              color: product.isAvailable
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddProductBottomSheet extends StatefulWidget {
  final Function(String, String, String, String, int) onSave;
  final bool isEditing;
  final ProductItem? initialProduct;

  const AddProductBottomSheet({
    super.key,
    required this.onSave,
    this.isEditing = false,
    this.initialProduct,
  });

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late String _selectedCategory;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialProduct?.name ?? "");
    _priceController = TextEditingController(
        text: widget.initialProduct?.price.replaceAll(" ريال", "") ?? "");
    _descController =
        TextEditingController(text: widget.initialProduct?.description ?? "");
    _selectedCategory = widget.initialProduct?.category ?? "برغر";
    String stockText = widget.initialProduct?.stockInfo ?? "1";
    _quantity = int.tryParse(RegExp(r'\d+').stringMatch(stockText) ?? "1") ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 25,
          left: 24,
          right: 24),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.isEditing
                        ? "تعديل تفاصيل المنتج"
                        : "إضافة منتج جديد للمتجر",
                    style: TextStyle(
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold)),
                IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: isDark ? Colors.white70 : Colors.black),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel("اسم المنتج", isDark),
            _buildInput(_nameController, "مثلاً: بيتزا بيبروني وسط", isDark),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildLabel("السعر (ريال)", isDark),
                      _buildInput(_priceController, "25", isDark,
                          keyboardType: TextInputType.number)
                    ])),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      _buildLabel("التصنيف", isDark),
                      _buildDropdown(isDark)
                    ])),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel("وصف المنتج (اختياري)", isDark),
            _buildInput(
                _descController, "أضف تفاصيل المكونات ليرتها العميل...", isDark,
                maxLines: 3),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("الكمية المتوفرة حالياً", isDark),
                Row(
                  children: [
                    _buildCounterBtn(
                        Icons.add, () => setState(() => _quantity++), isDark),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("$_quantity",
                            style: TextStyle(
                                fontSize: 18,
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold))),
                    _buildCounterBtn(Icons.remove, () {
                      if (_quantity > 1) setState(() => _quantity--);
                    }, isDark),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    widget.onSave(_nameController.text, _priceController.text,
                        _descController.text, _selectedCategory, _quantity);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                    widget.isEditing ? "تحديث المنتج" : "إضافة للمتجر الآن",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo')),
      );

  Widget _buildInput(TextEditingController controller, String hint, bool isDark,
          {int maxLines = 1, TextInputType? keyboardType}) =>
      TextField(
          controller: controller,
          maxLines: maxLines,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontFamily: 'Cairo',
              fontSize: 14),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey, fontSize: 13),
              filled: true,
              fillColor:
                  isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none)));

  Widget _buildDropdown(bool isDark) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            value: _selectedCategory,
            items: [
              "برغر",
              "بيتزا",
              "المشروبات الباردة",
              "الوجبات الرئيسية",
              "الحلويات"
            ]
                .map((String val) => DropdownMenuItem(
                    value: val,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(val,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontFamily: 'Cairo',
                              fontSize: 13)),
                    )))
                .toList(),
            onChanged: (val) => setState(() => _selectedCategory = val!),
          ),
        ),
      );

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap, bool isDark) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 22)),
      );
}
