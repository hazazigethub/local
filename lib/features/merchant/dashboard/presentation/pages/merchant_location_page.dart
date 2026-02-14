import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
import 'package:app2030/main.dart';

class MerchantLocationPage extends ConsumerStatefulWidget {
  const MerchantLocationPage({super.key});

  @override
  ConsumerState<MerchantLocationPage> createState() =>
      _MerchantLocationPageState();
}

class _MerchantLocationPageState extends ConsumerState<MerchantLocationPage> {
  final String _storeAddress =
      "المملكة العربية السعودية، الرويضة، حي النزهة - مبنى 4020";

  @override
  Widget build(BuildContext context) {
    // مراقبة الموقع الحالي من المزود العالمي
    final location = ref.watch(merchantLocationProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0.5,
          title: Text(
            "تحديد نقطة الارتكاز",
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => context.pop(), // ✅ استخدام GoRouter
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopInfoSection(isDark),
              _buildMapPlaceholder(location, isDark),
              const SizedBox(height: 10),
              _buildLocationDetailsCard(location, isDark),
              const SizedBox(height: 30),
              _buildActionButtons(isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 1. قسم المقدمة التعليمي
  Widget _buildTopInfoSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFF4CAF50), size: 20),
              const SizedBox(width: 8),
              Text(
                "أهمية الموقع الجغرافي",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "موقع المتجر هو المركز الأساسي الذي يُحدد ظهورك للعملاء القريبين، ويُستخدم لحساب تكاليف التوصيل وضمان دقة وصول الطلبات.",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.black54,
              height: 1.6,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  // 2. واجهة الخريطة المطورة (Map UI Simulation)
  Widget _buildMapPlaceholder(Map<String, double> location, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
        border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.3), width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // خلفية شبكية تحاكي الخريطة
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.05 : 0.1,
              child: Image.network(
                'https://www.google.com/maps/vt/pb=!1m4!1m3!1i14!2i9033!3i6000!2m3!1e0!2sm!3i420120488!3m8!2sar!3ssa!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!5f2',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // مؤشر الموقع المركزي
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 55, color: Colors.redAccent),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "نقطة الارتكاز الحالية",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      fontFamily: 'Cairo'),
                ),
              ),
            ],
          ),
          // زر تحديد الموقع التلقائي
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {},
              mini: true,
              backgroundColor: const Color(0xFF4CAF50),
              child:
                  const Icon(Icons.my_location, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
    );
  }

  // 3. بطاقة بيانات الموقع
  Widget _buildLocationDetailsCard(Map<String, double> location, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildLocationInfoItem(
            Icons.business_rounded,
            "اسم المتجر المعتمد",
            "متجر الرويضة المركزي",
            isDark,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1)),
          _buildLocationInfoItem(
            Icons.map_outlined,
            "العنوان الوطني",
            _storeAddress,
            isDark,
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1)),
          _buildLocationInfoItem(
            Icons.gps_fixed_rounded,
            "إحداثيات الـ GPS",
            "${location['lat']?.toStringAsFixed(6)} , ${location['lng']?.toStringAsFixed(6)}",
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfoItem(
      IconData icon, String title, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 11, fontFamily: 'Cairo', color: Colors.grey[500]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // 4. أزرار التحكم والعمليات
  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم تثبيت موقع المتجر بنجاح ✅",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text(
                "حفظ وتثبيت النقطة الحالية",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextButton.icon(
            onPressed: () {
              // هنا يمكن إضافة منطق فتح خرائط جوجل للاختيار اليدوي
            },
            icon: const Icon(Icons.edit_location_alt_outlined,
                size: 20, color: Color(0xFF4CAF50)),
            label: const Text(
              "تعديل الموقع يدوياً على الخريطة",
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
