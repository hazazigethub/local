import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ✅ نموذج بيانات المكون
class Ingredient {
  String name;
  double totalWeight;
  double totalPrice;
  double usedWeight;

  Ingredient({
    required this.name,
    this.totalWeight = 0,
    this.totalPrice = 0,
    this.usedWeight = 0,
  });

  double get usedCost =>
      (totalWeight > 0) ? (totalPrice / totalWeight) * usedWeight : 0;
}

class CostCalculatorPage extends StatefulWidget {
  const CostCalculatorPage({super.key});

  @override
  State<CostCalculatorPage> createState() => _CostCalculatorPageState();
}

class _CostCalculatorPageState extends State<CostCalculatorPage> {
  final List<Ingredient> _ingredients = [Ingredient(name: "")];

  final _laborCostController = TextEditingController();
  final _packagingController = TextEditingController();
  final _wasteController = TextEditingController(text: "5");
  final _marginController = TextEditingController(text: "30");

  bool _showErrors = false;
  double _totalProductionCost = 0.0;
  double _suggestedSellingPrice = 0.0;

  void _calculateFinal() {
    bool isIngredientsValid = _ingredients.every((ing) =>
        ing.name.isNotEmpty &&
        ing.totalPrice > 0 &&
        ing.totalWeight > 0 &&
        ing.usedWeight > 0);

    bool isOperationalValid = _laborCostController.text.isNotEmpty &&
        _packagingController.text.isNotEmpty &&
        _wasteController.text.isNotEmpty &&
        _marginController.text.isNotEmpty;

    if (!isIngredientsValid || !isOperationalValid) {
      setState(() {
        _showErrors = true;
        _totalProductionCost = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى ملء جميع الخانات المطلوبة بقيم صحيحة",
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _showErrors = false);

    double ingredientsSum =
        _ingredients.fold(0, (sum, item) => sum + item.usedCost);
    double wastePercent = double.tryParse(_wasteController.text) ?? 0;
    double costWithWaste = ingredientsSum * (1 + (wastePercent / 100));
    double labor = double.tryParse(_laborCostController.text) ?? 0;
    double packaging = double.tryParse(_packagingController.text) ?? 0;

    setState(() {
      _totalProductionCost = costWithWaste + labor + packaging;
      double margin = double.tryParse(_marginController.text) ?? 0;
      if (margin < 100) {
        _suggestedSellingPrice = _totalProductionCost / (1 - (margin / 100));
      }
    });
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
          title: const Text("حاسبة التكاليف الذكية",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  fontSize: 18)),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ تم تصحيح kitchen_outlined هنا
              _buildSectionHeader(
                  "المكونات والكميات", Icons.kitchen_outlined, isDark),
              const SizedBox(height: 15),
              ..._ingredients.asMap().entries.map((entry) =>
                  _buildIngredientCard(entry.key, entry.value, isDark)),
              _buildAddButton(),
              const SizedBox(height: 30),
              _buildSectionHeader("المصاريف التشغيلية والربح",
                  Icons.analytics_outlined, isDark),
              const SizedBox(height: 15),
              _buildOperationalFields(isDark),
              const SizedBox(height: 35),
              _buildCalculateButton(),
              if (_totalProductionCost > 0) _buildResultsSummary(isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isDark ? Colors.white70 : Colors.black87)),
      ],
    );
  }

  Widget _buildIngredientCard(int index, Ingredient ingredient, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: _showErrors && ingredient.name.isEmpty
                ? Colors.redAccent
                : (isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'Cairo'),
                  decoration: const InputDecoration(
                      hintText: "اسم المكون",
                      border: InputBorder.none,
                      isDense: true),
                  onChanged: (val) => setState(() => ingredient.name = val),
                ),
              ),
              Text("${ingredient.usedCost.toStringAsFixed(2)} ر.س",
                  style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              if (_ingredients.length > 1)
                IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.redAccent, size: 20),
                    onPressed: () =>
                        setState(() => _ingredients.removeAt(index))),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              _buildMiniInput(
                  "السعر الكلي",
                  ingredient.totalPrice,
                  (val) => setState(
                      () => ingredient.totalPrice = double.tryParse(val) ?? 0),
                  isDark),
              const SizedBox(width: 8),
              _buildMiniInput(
                  "الوزن الكلي",
                  ingredient.totalWeight,
                  (val) => setState(
                      () => ingredient.totalWeight = double.tryParse(val) ?? 0),
                  isDark),
              const SizedBox(width: 8),
              _buildMiniInput(
                  "المستخدم",
                  ingredient.usedWeight,
                  (val) => setState(
                      () => ingredient.usedWeight = double.tryParse(val) ?? 0),
                  isDark,
                  isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInput(
      String label, double value, Function(String) onChanged, bool isDark,
      {bool isHighlight = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: Colors.grey, fontFamily: 'Cairo')),
          const SizedBox(height: 5),
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: TextStyle(
                fontSize: 12, color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.black26 : Colors.grey.shade50,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isHighlight
                          ? const Color(0xFF4CAF50)
                          : Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isHighlight
                          ? const Color(0xFF4CAF50).withOpacity(0.5)
                          : Colors.transparent)),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalFields(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildExpertField(_laborCostController, "تكلفة العمالة",
            Icons.person_outline, isDark),
        _buildExpertField(_packagingController, "تكلفة التغليف",
            Icons.inventory_2_outlined, isDark),
        _buildExpertField(_wasteController, "نسبة الهالك %",
            Icons.delete_sweep_outlined, isDark,
            isPercent: true),
        _buildExpertField(
            _marginController, "هامش الربح %", Icons.trending_up, isDark,
            isPercent: true),
      ],
    );
  }

  Widget _buildExpertField(TextEditingController controller, String label,
      IconData icon, bool isDark,
      {bool isPercent = false}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white : Colors.black,
          fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
        suffixText: isPercent ? "%" : "ر.س",
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildAddButton() {
    return TextButton.icon(
      onPressed: () => setState(() => _ingredients.add(Ingredient(name: ""))),
      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50)),
      label: const Text("إضافة مكون آخر",
          style: TextStyle(
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo')),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _calculateFinal,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text("احسب السعر المقترح",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Cairo')),
      ),
    );
  }

  Widget _buildResultsSummary(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          _resultRow("إجمالي تكلفة الإنتاج:", _totalProductionCost, isDark,
              isMain: false),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          _resultRow("سعر البيع المقترح:", _suggestedSellingPrice, isDark,
              isMain: true),
          const SizedBox(height: 10),
          Text(
              "صافي الربح المتوقع: ${(_suggestedSellingPrice - _totalProductionCost).toStringAsFixed(2)} ر.س",
              style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _resultRow(String label, double value, bool isDark,
      {required bool isMain}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isMain ? 16 : 14,
                fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Cairo')),
        Text("${value.toStringAsFixed(2)} ر.س",
            style: TextStyle(
                fontSize: isMain ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: isMain
                    ? const Color(0xFF4CAF50)
                    : (isDark ? Colors.white : Colors.black))),
      ],
    );
  }
}
