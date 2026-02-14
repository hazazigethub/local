import 'package:flutter/material.dart';
import 'dart:async';

// ✅ تصحيح المسار: تم استخدام المسار الكامل للوصول لملف العميل من مجلد التاجر
import 'package:app2030/features/customer/home/presentation/pages/customer_reservations_chat_page.dart';

class MerchantReservationsPage extends StatefulWidget {
  const MerchantReservationsPage({super.key});

  @override
  State<MerchantReservationsPage> createState() =>
      _MerchantReservationsPageState();
}

class _MerchantReservationsPageState extends State<MerchantReservationsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredReservations = [];

  // ⚙️ متغيرات إعدادات الحجز
  List<String> _timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "01:00 PM",
    "04:00 PM",
    "08:00 PM"
  ];
  int _maxReservations = 10;
  List<int> _closedDays = [10, 20, 30];

  final List<Map<String, dynamic>> _allReservations = [
    {
      "name": "محمد حسن",
      "status": "مؤكد",
      "statusColor": Colors.green,
      "date": "2025-08-15",
      "id": "#RES-1024",
      "deliveryDateTime": DateTime(2025, 8, 15, 19, 30),
    },
    {
      "name": "أحمد علي",
      "status": "غير مؤكد",
      "statusColor": Colors.orange,
      "date": "2025-12-28",
      "id": "#RES-1025",
      "deliveryDateTime": DateTime(2025, 12, 28, 21, 0),
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredReservations = List.from(_allReservations);
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _filteredReservations = _allReservations;
      } else {
        _filteredReservations = _allReservations.where((res) {
          return res["name"]
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              res["id"].toLowerCase().contains(enteredKeyword.toLowerCase());
        }).toList();
      }
    });
  }

  void _showBookingSettingsModal(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30))),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                    child: Text("إعدادات الحجوزات",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black))),
                Divider(
                    height: 40,
                    color: isDark ? Colors.white10 : Colors.grey.shade300),
                _buildSettingsTitle(
                    Icons.calendar_month, "حالة الحجوزات حسب التاريخ", isDark),
                _buildCustomCalendar(setModalState, isDark),
                const SizedBox(height: 25),
                _buildSettingsTitle(
                    Icons.people_alt, "الحد الأقصى للحجوزات يومياً", isDark),
                _buildMaxReservationsSection(setModalState, isDark),
                const SizedBox(height: 25),
                _buildSettingsTitle(
                    Icons.access_time_filled, "الأوقات المتاحة للطلب", isDark),
                _buildTimeSlotsSection(setModalState, isDark),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("حفظ الإعدادات",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaxReservationsSection(StateSetter setModalState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("عدد الحجوزات المسموح بها:",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          Row(
            children: [
              IconButton(
                  onPressed: () => setModalState(() => _maxReservations++),
                  icon: const Icon(Icons.add_circle, color: Color(0xFF4CAF50))),
              Text("$_maxReservations",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black)),
              IconButton(
                  onPressed: () => setModalState(() {
                        if (_maxReservations > 1) _maxReservations--;
                      }),
                  icon: const Icon(Icons.remove_circle, color: Colors.red)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection(StateSetter setModalState, bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._timeSlots.map((slot) {
          return Chip(
            label: Text(slot,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.green[100] : Colors.green[900])),
            backgroundColor: isDark
                ? Colors.green.withOpacity(0.2)
                : const Color(0xFFE8F5E9),
            deleteIcon: const Icon(Icons.cancel, size: 16, color: Colors.grey),
            onDeleted: () => setModalState(() => _timeSlots.remove(slot)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        }),
        ActionChip(
          avatar: const Icon(Icons.add, size: 16, color: Colors.white),
          label: const Text("إضافة وقت",
              style: TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: const Color(0xFF4CAF50),
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Theme(
                    data: isDark
                        ? ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                                primary: Color(0xFF4CAF50)),
                          )
                        : ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Color(0xFF4CAF50)),
                          ),
                    child: child!,
                  ),
                );
              },
            );

            if (picked != null) {
              setModalState(() {
                final String formattedTime = picked.format(context);
                if (!_timeSlots.contains(formattedTime)) {
                  _timeSlots.add(formattedTime);
                }
              });
            }
          },
        ),
      ],
    );
  }

  void _confirmReservationCompletion(String id) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text("تأكيد تقديم الخدمة",
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Text(
              "هل تم إكمال موعد الحجز بنجاح؟ سيتم قفل المحادثة وطلب التقييم من العميل.",
              style:
                  TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50)),
              onPressed: () {
                setState(() {
                  final index =
                      _allReservations.indexWhere((e) => e["id"] == id);
                  if (index != -1) {
                    _allReservations[index]["status"] = "منتهي";
                    _allReservations[index]["statusColor"] = Colors.grey;
                  }
                  _runFilter(_searchController.text);
                });
                Navigator.pop(context);
              },
              child: const Text("نعم، تم بنجاح",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _buildTopSearch(isDark),
              Expanded(
                child: _filteredReservations.isEmpty
                    ? Center(
                        child: Text("لا توجد حجوزات حالياً",
                            style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        itemCount: _filteredReservations.length,
                        itemBuilder: (context, index) => _buildReservationCard(
                            _filteredReservations[index], isDark),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSearch(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _runFilter(value),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: const InputDecoration(
                    hintText: "بحث باسم العميل أو الرقم",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon:
                  const Icon(Icons.settings_outlined, color: Color(0xFF4CAF50)),
              onPressed: () => _showBookingSettingsModal(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> res, bool isDark) {
    bool isConfirmed = res['status'] == "مؤكد";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          if (isConfirmed && res['deliveryDateTime'] != null)
            DeliveryCountdownTimer(deliveryDateTime: res['deliveryDateTime']),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(res['name'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              _buildStatusBadge(res['status'], res['statusColor']),
            ],
          ),
          Divider(
              height: 25,
              color: isDark ? Colors.white10 : Colors.grey.shade200),
          _buildInfoRow("رقم الحجز", res['id'], isDark),
          _buildInfoRow("تاريخ الموعد", res['date'], isDark),
          if (isConfirmed) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => _confirmReservationCompletion(res['id']),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("إتمام الحجز (للتاجر)",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text("التفاصيل",
                      style: TextStyle(color: Color(0xFF4CAF50))),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerReservationsChatPage(
                        reservationId: res['id'] ?? "",
                        storeName: "متجري",
                        reservationType: "حجز مسبق",
                        reservationTime: res['date'] ?? "",
                        totalAmount: 0.0,
                        reservationStatus: res['status'] ?? "مؤكد",
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.chat_bubble_outline,
                      color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Text(status,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSettingsTitle(IconData icon, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 20),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black)),
      ]),
    );
  }

  Widget _buildCustomCalendar(StateSetter setModalState, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, childAspectRatio: 1.2),
        itemCount: 31,
        itemBuilder: (context, index) {
          int day = index + 1;
          bool isClosed = _closedDays.contains(day);
          return GestureDetector(
            onTap: () => setModalState(() {
              if (isClosed) {
                _closedDays.remove(day);
              } else {
                _closedDays.add(day);
              }
            }),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: isClosed
                      ? Colors.red.withOpacity(0.15)
                      : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isClosed
                          ? Colors.red
                          : (isDark ? Colors.white10 : Colors.grey.shade100))),
              child: Center(
                  child: Text("$day",
                      style: TextStyle(
                          fontSize: 11,
                          color: isClosed
                              ? Colors.red
                              : (isDark ? Colors.white : Colors.black),
                          fontWeight:
                              isClosed ? FontWeight.bold : FontWeight.normal))),
            ),
          );
        },
      ),
    );
  }
}

class DeliveryCountdownTimer extends StatefulWidget {
  final DateTime deliveryDateTime;
  const DeliveryCountdownTimer({super.key, required this.deliveryDateTime});
  @override
  State<DeliveryCountdownTimer> createState() => _DeliveryCountdownTimerState();
}

class _DeliveryCountdownTimerState extends State<DeliveryCountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.deliveryDateTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() =>
            _timeLeft = widget.deliveryDateTime.difference(DateTime.now()));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft.isNegative) return const SizedBox();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isDark ? Colors.green.withOpacity(0.15) : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text(
              "متبقي على الموعد: ${_timeLeft.inDays} يوم و ${_timeLeft.inHours % 24} ساعة",
              style: TextStyle(
                  color: isDark ? Colors.green[300] : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12))),
    );
  }
}
