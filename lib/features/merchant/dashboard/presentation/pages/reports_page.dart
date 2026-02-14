import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:go_router/go_router.dart';
import 'package:app2030/features/customer/home/presentation/providers/orders_provider.dart';

// ✅ مزودات البيانات (الإحصائيات الكبيرة من الكود القديم)
final totalVisitsProvider = StateProvider<int>((ref) => 82450);
final totalOrdersProvider = StateProvider<int>((ref) => 10293);
final averageRatingProvider = StateProvider<double>((ref) => 4.8);
final totalReviewsProvider = StateProvider<int>((ref) => 1240);
final totalCustomersProvider = StateProvider<int>((ref) => 2450);

// ✅ إضافة مزودات إحصائيات العروض المفقودة
final activeOffersProvider = StateProvider<int>((ref) => 12);
final offersRevenueProvider = StateProvider<double>((ref) => 15420.0);

final weeklySalesDataProvider =
    Provider<List<double>>((ref) => [90, 25, 15, 80, 40, 55, 20]);

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  String _selectedPeriod = "يوم";
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme:
                      const ColorScheme.dark(primary: Color(0xFF4CAF50)))
              : ThemeData.light().copyWith(
                  colorScheme:
                      const ColorScheme.light(primary: Color(0xFF4CAF50))),
          child:
              Directionality(textDirection: TextDirection.rtl, child: child!),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _selectedPeriod = "مخصص";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final visits = ref.watch(totalVisitsProvider);
    final ordersTotal = ref.watch(totalOrdersProvider);
    final rating = ref.watch(averageRatingProvider);
    final reviews = ref.watch(totalReviewsProvider);
    final customers = ref.watch(totalCustomersProvider);
    final salesData = ref.watch(weeklySalesDataProvider);

    // ✅ جلب بيانات العروض المضافة
    final activeOffers = ref.watch(activeOffersProvider);
    final offersRevenue = ref.watch(offersRevenueProvider);

    final activeOrdersCount =
        ref.watch(ordersProvider).where((o) => o.status != "مكتمل").length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text("التقارير التحليلية",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Cairo')),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildTopFilterBar(
                context, isDark), // ✅ شريط الفلترة المطور مع زر التحديث
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildStatCard("إجمالي الزيارات", visits.toString(), "1.3%",
                        true, Icons.people_outline, Colors.blue, isDark),
                    const SizedBox(height: 12),
                    _buildStatCard(
                        "إجمالي المبيعات",
                        ordersTotal.toString(),
                        "1.3%",
                        true,
                        Icons.inventory_2_outlined,
                        Colors.amber,
                        isDark),
                    const SizedBox(height: 12),
                    _buildStatCard(
                        "الطلبات النشطة (الآن)",
                        activeOrdersCount.toString(),
                        "مباشر",
                        true,
                        Icons.sync,
                        Colors.cyan,
                        isDark),
                    const SizedBox(height: 12),

                    // ✅ خانات العروض المستعادة (المفقودة سابقاً)
                    _buildStatCard(
                        "العروض النشطة",
                        activeOffers.toString(),
                        "8.4%",
                        true,
                        Icons.local_offer_outlined,
                        Colors.pink,
                        isDark),
                    const SizedBox(height: 12),
                    _buildStatCard(
                        "عائدات العروض",
                        "${intl.NumberFormat.compact().format(offersRevenue)} ر.س",
                        "12%",
                        true,
                        Icons.trending_up,
                        Colors.teal,
                        isDark),
                    const SizedBox(height: 12),

                    _buildStatCard("متوسط التقييم", "$rating / 5", "0.5%", true,
                        Icons.star_rounded, Colors.orange, isDark,
                        isRating: true, ratingValue: rating),
                    const SizedBox(height: 12),
                    _buildStatCard(
                        "مجموع المراجعات",
                        reviews.toString(),
                        "2.1%",
                        true,
                        Icons.rate_review_outlined,
                        Colors.purple,
                        isDark),
                    const SizedBox(height: 12),
                    _buildStatCard(
                        "إجمالي العملاء",
                        customers.toString(),
                        "1.3%",
                        false,
                        Icons.group_outlined,
                        Colors.red.shade300,
                        isDark),

                    const SizedBox(height: 24),
                    _buildSalesPerformanceCard(salesData, isDark),
                    const SizedBox(height: 24),
                    _buildPopularityCard(ordersTotal,
                        isDark), // ✅ الرسم البياني الدائري المتداخل
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ شريط الفلترة العلوي الموحد
  Widget _buildTopFilterBar(BuildContext context, bool isDark) {
    String dateDisplay = _selectedDateRange != null
        ? "${intl.DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${intl.DateFormat('MM/dd').format(_selectedDateRange!.end)}"
        : "فلترة حسب التاريخ";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _selectDateRange(context),
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Color(0xFF4CAF50)),
              ),
              Text(
                dateDisplay,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    _buildTopTabItem("شهر", isDark),
                    _buildTopTabItem("أسبوع", isDark),
                    _buildTopTabItem("يوم", isDark),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // منطق التحديث
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text("تحديث نتائج التقرير",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabItem(String label, bool isDark) {
    bool isSelected = _selectedPeriod == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedPeriod = label;
        _selectedDateRange = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white10 : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey)),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String percentage,
      bool isUp, IconData icon, Color color, bool isDark,
      {bool isRating = false, double ratingValue = 0}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(isUp ? Icons.north_east : Icons.south_west,
              color: isUp ? Colors.green : Colors.red, size: 20),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                      Text(
                        "$percentage ${isUp ? 'بزيادة' : 'أقل'} عن الفترة السابقة",
                        style: TextStyle(
                            color: isUp ? Colors.green : Colors.red,
                            fontSize: 10,
                            fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: color, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isRating)
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      child: Row(
                        children: List.generate(
                            5,
                            (index) => Icon(Icons.star_rounded,
                                color: index < ratingValue.floor()
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                                size: 16)),
                      ),
                    ),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesPerformanceCard(List<double> data, bool isDark) {
    final days = [
      "السبت",
      "الأحد",
      "الاثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة"
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("تحليل المبيعات الأسبوعي",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length,
                  (index) => _buildBar(data[index], days[index], isDark)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, String day, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day,
            style: TextStyle(
                fontSize: 9,
                color: isDark ? Colors.white38 : Colors.grey,
                fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildPopularityCard(int totalOrders, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("الأصناف الأكثر طلباً",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                        value: 0.65,
                        strokeWidth: 15,
                        color: Colors.green.shade500,
                        backgroundColor: Colors.transparent)),
                SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                        value: 0.35,
                        strokeWidth: 15,
                        color: Colors.red.shade400,
                        backgroundColor: Colors.transparent)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("إجمالي الطلبات",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Cairo')),
                    Text(totalOrders.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildPopularityLegend("برغر", "60%", Colors.green),
          _buildPopularityLegend("البيتزا", "30%", Colors.red),
          _buildPopularityLegend("شاورما", "10%", Colors.amber),
        ],
      ),
    );
  }

  Widget _buildPopularityLegend(String label, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(percent, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(label,
              style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
          const SizedBox(width: 10),
          Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }
}
