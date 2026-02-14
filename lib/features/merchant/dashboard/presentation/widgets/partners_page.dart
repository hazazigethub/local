import 'package:flutter/material.dart';

class PartnersPage extends StatelessWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الشعارات المقترحة للتشغيل
    final List<Map<String, String>> partners = [
      {
        'name': 'بنك التنمية',
        'logo': 'https://upload.wikimedia.org/wikipedia/ar/b/b2/Sdb_logo.png'
      },
      {
        'name': 'شركة علم',
        'logo':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Elm_Logo.svg/1200px-Elm_Logo.svg.png'
      },
      {
        'name': 'المحامين',
        'logo': 'https://sba.gov.sa/wp-content/uploads/2022/10/sba-logo.png'
      },
      {
        'name': 'الموارد البشرية',
        'logo':
            'https://upload.wikimedia.org/wikipedia/ar/thumb/2/29/Logo_of_the_Ministry_of_Human_Resources_and_Social_Development.svg/1200px-Logo_of_the_Ministry_of_Human_Resources_and_Social_Development.svg.png'
      },
      {
        'name': 'جمعية إنسان',
        'logo': 'https://ensan.org.sa/sites/default/files/2021-02/logo.png'
      },
      {
        'name': 'جمعية البر',
        'logo':
            'https://berahsaa.org.sa/web/wp-content/uploads/2021/04/logo.png'
      },
      {
        'name': 'مركز التحكيم',
        'logo': 'https://mcca.org.sa/wp-content/uploads/2021/05/logo.png'
      },
      {
        'name': 'مؤسسة الراجحي',
        'logo':
            'https://www.alrajhibank.com.sa/-/media/Project/AlrajhiBank/alrajhibank-sa/Global/Images/logo.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // توسيط المحتوى في العمود
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            // توسيط النص بشكل صريح
            child: Text(
              "شركاؤنا",
              style: TextStyle(
                  fontSize: 22, // تكبير الخط
                  fontWeight: FontWeight.bold,
                  color:
                      Color(0xFF4CAF50)), // ✅ تم تغيير اللون إلى اللون الرسمي
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // ✅ عدد الشعارات 3 في كل سطر
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
            childAspectRatio: 1.0,
          ),
          itemCount: partners.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 5)
                      ],
                    ),
                    child: Center(
                      child: Image.network(
                        partners[index]['logo']!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.business,
                                size: 25, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(partners[index]['name']!,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ],
            );
          },
        ),
      ],
    );
  }
}
