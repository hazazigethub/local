import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showAll = true; // للتحكم في التبديل بين "الكل" و "غير مقروءة"

  // قائمة البيانات المنظمة لتمكين التصفية والحساب
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "تأكيد الطلب",
      "subtitle": "تم تأكيد طلبك # 1245!",
      "time": "منذ 5 دقائق",
      "icon": Icons.inventory_2_outlined,
      "isUnread": true,
    },
    {
      "title": "خارج التوصيل",
      "subtitle": "طلبك في الطريق! الوقت المقدر: 25 دقيقة.",
      "time": "منذ 7 دقائق",
      "icon": Icons.local_shipping_outlined,
      "isUnread": true,
    },
    {
      "title": "عرض حصري لك!",
      "subtitle": "خصم 25% على جميع طلبات البيتزا اليوم فقط.",
      "time": "منذ 1 ساعة",
      "icon": Icons.local_offer_outlined,
      "isUnread": false,
    },
    {
      "title": "تم تحديث التطبيق",
      "subtitle": "ميزات جديدة ودفع أسرع - قم بالتحديث الآن!",
      "time": "منذ 2 ساعة",
      "icon": Icons.settings_suggest_outlined,
      "isUnread": false,
    },
    {
      "title": "تمت إضافة مطاعم جديدة بالقرب منك",
      "subtitle": "تحقق من أحدث أماكن الطعام في الرياض.",
      "time": "اليوم",
      "icon": Icons.restaurant_outlined,
      "isUnread": false,
    },
    {
      "title": "قيم وجبتك الأخيرة",
      "subtitle": "كيف كان طلبك من شاورما إكسبريس؟ اترك تعليقا!",
      "time": "اليوم",
      "icon": Icons.star_border_rounded,
      "isUnread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ اكتشاف وضع الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // تصفية القائمة بناءً على التبويب المختار
    List<Map<String, dynamic>> displayList = showAll
        ? _notifications
        : _notifications.where((n) => n['isUnread'] == true).toList();

    return Scaffold(
      // ✅ خلفية متغيرة
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "الاشعارات",
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // شريط التبديل (Tabs)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                // ✅ لون خلفية الشريط في الوضع الليلي
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildTabItem("الغير مقروءة", !showAll, isDark),
                  _buildTabItem("الكل", showAll, isDark),
                ],
              ),
            ),
          ),
          // قائمة الإشعارات المفلترة
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Text("لا توجد إشعارات غير مقروءة",
                        style: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final item = displayList[index];
                      return _buildNotificationItem(
                        isDark: isDark,
                        title: item['title'],
                        subtitle: item['subtitle'],
                        time: item['time'],
                        icon: item['icon'],
                        isUnread: item['isUnread'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ويدجت لبناء عنصر التبديل العلوي
  Widget _buildTabItem(String title, bool isActive, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => showAll = (title == "الكل")),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            // ✅ لون التبويب النشط
            color: isActive
                ? (isDark ? const Color(0xFF424242) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive && !isDark
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isActive
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء عنصر الإشعار الواحد
  Widget _buildNotificationItem({
    required bool isDark,
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    bool isUnread = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: TextStyle(
                color: isDark ? Colors.white24 : Colors.grey.shade400,
                fontSize: 12),
          ),
          const Spacer(),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isUnread)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 13),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // ✅ أيقونات الإشعارات بلمسة خضراء شفافة تناسب الوضعين
              color: Colors.green.withOpacity(isDark ? 0.15 : 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green.shade400, size: 24),
          ),
        ],
      ),
    );
  }
}
