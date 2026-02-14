import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ إضافة GoRouter
import 'package:app2030/core/routing/route_paths.dart'; // ✅ استيراد المسارات

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _confirmDeletion = false;

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
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(), // ✅ الرجوع عبر GoRouter
          ),
          title: const Text("حذف الحساب",
              style:
                  TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 100, color: Colors.red),
                      const SizedBox(height: 30),
                      const Text(
                        "هل أنت متأكد من حذف حسابك؟",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "بمجرد تأكيد الحذف، سيتم مسح كافة بياناتك، طلباتك السابقة، ونقاط الولاء بشكل نهائي. لا يمكن التراجع عن هذه الخطوة لاحقاً.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            fontFamily: 'Cairo',
                            color: isDark ? Colors.white70 : Colors.grey[700]),
                      ),
                      const SizedBox(height: 40),
                      CheckboxListTile(
                        value: _confirmDeletion,
                        onChanged: (val) =>
                            setState(() => _confirmDeletion = val!),
                        activeColor: Colors.red,
                        title: const Text(
                          "أدرك أن هذا الإجراء نهائي ولا يمكن استعادة البيانات.",
                          style: TextStyle(fontSize: 13, fontFamily: 'Cairo'),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _confirmDeletion
              ? () {
                  // هنا يتم وضع منطق الحذف من السيرفر مستقبلاً
                  context.go(RoutePaths.login); // ✅ العودة لصفحة الدخول
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Text("تأكيد الحذف النهائي",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo')),
        ),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("إلغاء، العودة للملف الشخصي",
              style: TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
        ),
      ],
    );
  }
}
