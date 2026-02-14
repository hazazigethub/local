import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ✅ استيراد الموديل والصفحة الجديدة
import 'package:app2030/core/models/reel_model.dart';
import 'review_reels_page.dart';

class ManageReelsPage extends StatefulWidget {
  const ManageReelsPage({super.key});

  @override
  State<ManageReelsPage> createState() => _ManageReelsPageState();
}

class _ManageReelsPageState extends State<ManageReelsPage> {
  final ImagePicker _picker = ImagePicker();

  // ✅ قائمة الريلز باستخدام ReelModel
  List<ReelModel> _myReels = [
    ReelModel(
      id: "1",
      merchantId: "m1",
      merchantName: "متجر الرويضة",
      merchantProfileImage: "https://i.pravatar.cc/150",
      title: "تحضير قهوة الصباح المختصة ☕",
      description: "استمتع بأفضل نكهات القهوة لدينا كل صباح.",
      thumbnailUrl:
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1000",
      videoUrl:
          "https://assets.mixkit.co/videos/preview/mixkit-coffee-maker-making-a-cup-of-coffee-80-large.mp4",
    ),
  ];

  void _confirmDelete(int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text("تأكيد الحذف",
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Text("هل أنت متأكد من رغبتك في حذف هذا الرييل نهائياً؟",
              style:
                  TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء",
                  style:
                      TextStyle(color: isDark ? Colors.white60 : Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() => _myReels.removeAt(index));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("تم الحذف بنجاح"),
                      backgroundColor: Colors.red),
                );
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _showReelForm({int? index}) {
    // ✅ تهيئة وحدات التحكم بناءً على الحقول الجديدة في الموديل
    final titleController =
        TextEditingController(text: index != null ? _myReels[index].title : "");
    final contentController = TextEditingController(
        text: index != null ? _myReels[index].description : "");

    XFile? selectedVideo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  left: 20,
                  right: 20,
                  top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(index == null ? "إضافة رييل جديد" : "تعديل الرييل",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 20),
                  // ✅ حقل العنوان
                  TextField(
                    controller: titleController,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: const InputDecoration(
                        labelText: "عنوان الرييل",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  // ✅ حقل الوصف
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: const InputDecoration(
                        labelText: "وصف المحتوى", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      final XFile? video =
                          await _picker.pickVideo(source: ImageSource.gallery);
                      if (video != null)
                        setModalState(() => selectedVideo = video);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedVideo == null
                                ? Colors.grey
                                : Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              selectedVideo == null
                                  ? Icons.video_library
                                  : Icons.check_circle,
                              color: selectedVideo == null
                                  ? Colors.grey
                                  : Colors.green),
                          const SizedBox(width: 10),
                          Text(selectedVideo == null
                              ? "اختر مقطع فيديو"
                              : "تم اختيار الفيديو"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          setState(() {
                            if (index == null) {
                              // ✅ إنشاء كائن جديد
                              _myReels.add(ReelModel(
                                id: DateTime.now().toString(),
                                merchantId: "m1",
                                merchantName: "متجر الرويضة",
                                merchantProfileImage:
                                    "https://i.pravatar.cc/150",
                                title: titleController.text,
                                description: contentController.text,
                                thumbnailUrl: "https://via.placeholder.com/150",
                                videoUrl:
                                    "https://assets.mixkit.co/videos/preview/mixkit-coffee-maker-making-a-cup-of-coffee-80-large.mp4",
                              ));
                            } else {
                              // ✅ تحديث الكائن الحالي باستخدام copyWith
                              _myReels[index] = _myReels[index].copyWith(
                                title: titleController.text,
                                description: contentController.text,
                              );
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50)),
                      child: const Text("حفظ",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("إدارة الريلز"),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReelForm(),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.video_call, color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _myReels.length,
          itemBuilder: (context, index) {
            final reel = _myReels[index];
            return Card(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(reel.thumbnailUrl,
                      width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(reel.title ?? "بدون عنوان", // ✅ عرض العنوان المحدث
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black)),
                subtitle: Text(reel.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () => _showReelForm(index: index)),
                    IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(index)),
                  ],
                ),
                onTap: () {
                  // ✅ تمرير الكائن reel كاملاً لصفحة المعاينة
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewReelsPage(reel: reel)));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
