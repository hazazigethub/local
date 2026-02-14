import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ إضافة ريفربود
import 'package:go_router/go_router.dart';
import 'package:app2030/core/routing/route_paths.dart';
import 'package:app2030/main.dart'; // ✅ استيراد المزودات

// ✅ تحويل الكلاس إلى ConsumerStatefulWidget لعزله عن الثيم
class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isMerchant;

  const OtpScreen(
      {super.key, required this.phoneNumber, required this.isMerchant});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    String code = _controllers.map((e) => e.text).join();

    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("الرجاء إدخال الرمز كاملاً",
                style: TextStyle(fontFamily: 'Cairo'))),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);

      // ✅ تحديث الهوية قبل التوجيه لضمان فتح الصفحة التالية بالثيم الصحيح
      if (widget.isMerchant) {
        ref.read(appTypeProvider.notifier).state = AppType.merchant;
        context.go(RoutePaths.merchantHome);
      } else {
        ref.read(appTypeProvider.notifier).state = AppType.customer;
        context.go(RoutePaths.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ قاطع الثيم: إجبار التطبيق على وضع الـ Auth (الوضع الفاتح دائماً)
    Future.microtask(() {
      if (ref.read(appTypeProvider) != AppType.auth) {
        ref.read(appTypeProvider.notifier).state = AppType.auth;
      }
    });

    const Color brandGreen = Color(0xFF4CAF50);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // ✅ عزل لوني قسري للخلفية لضمان عدم تأثرها بالوضع الداكن
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person_outlined,
                  size: 80, color: brandGreen),
              const SizedBox(height: 20),
              const Text(
                "التحقق من الرقم",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 8),
              Text(
                "تم إرسال رمز التحقق إلى الرقم\n${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 40),

              // خانات الإدخال مع عزل لوني
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      autofocus: index == 0,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: brandGreen, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index - 1]);
                        }
                        if (index == 3 && value.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // زر التحقق
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("تحقق",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo')),
                ),
              ),

              const SizedBox(height: 24),

              // عداد إعادة الإرسال
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("لم يصلك الرمز؟ ",
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Cairo')),
                  _secondsRemaining > 0
                      ? Text(
                          "أعد الإرسال بعد $_secondsRemaining ثانية",
                          style: const TextStyle(
                              color: brandGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo'),
                        )
                      : TextButton(
                          onPressed: () {
                            _startTimer();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("تم إعادة إرسال الرمز",
                                      style: TextStyle(fontFamily: 'Cairo'))),
                            );
                          },
                          child: const Text("إعادة الإرسال",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brandGreen,
                                  fontFamily: 'Cairo')),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
