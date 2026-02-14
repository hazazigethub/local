import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// استيراد الموديل المشترك من المسار الصحيح في مشروعك
import 'package:app2030/core/models/reel_model.dart';

class ReviewReelsPage extends StatefulWidget {
  // استقبال الموديل كاملاً بدلاً من المتغيرات المنفصلة
  final ReelModel reel;

  const ReviewReelsPage({
    super.key,
    required this.reel,
  });

  @override
  State<ReviewReelsPage> createState() => _ReviewReelsPageState();
}

class _ReviewReelsPageState extends State<ReviewReelsPage> {
  late VideoPlayerController _controller;
  bool _isLiked = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // 1. تهيئة مشغل الفيديو باستخدام الرابط الموجود في الموديل
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _controller.play();
              _controller.setLooping(true);
            }
          });

    // 2. ضبط حالة الإعجاب الأولية بناءً على بيانات الموديل
    _isLiked = widget.reel.isLikedByMe;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء لتجربة سينمائية
      body: Stack(
        children: [
          // عرض الفيديو في كامل الشاشة
          Positioned.fill(
            child: _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),

          // الطبقات العلوية (التدرج، التفاعلات، المعلومات)
          _buildGradientOverlay(),
          _buildTopTabs(),
          _buildRightSidebar(),
          _buildBottomDetails(),

          // زر العودة (Back Button)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تفاصيل الفيديو (اسم التاجر والوصف) من الموديل
  Widget _buildBottomDetails() {
    return Positioned(
      left: 15,
      bottom: 30,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.reel.merchantName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          // عرض الوصف إذا كان موجوداً
          if (widget.reel.description != null &&
              widget.reel.description!.isNotEmpty)
            Text(
              widget.reel.description!,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
        ],
      ),
    );
  }

  // الشريط الجانبي للتفاعل
  Widget _buildRightSidebar() {
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        children: [
          _buildProfileIcon(),
          const SizedBox(height: 20),
          _sidebarIcon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            "${widget.reel.likesCount}",
            color: _isLiked ? Colors.red : Colors.white,
            onTap: () => setState(() => _isLiked = !_isLiked),
          ),
          const SizedBox(height: 15),
          _sidebarIcon(Icons.comment, "${widget.reel.commentsCount}"),
          const SizedBox(height: 15),
          _sidebarIcon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            "حفظ",
            color: _isBookmarked ? Colors.amber : Colors.white,
            onTap: () => setState(() => _isBookmarked = !_isBookmarked),
          ),
        ],
      ),
    );
  }

  // صورة بروفايل التاجر
  Widget _buildProfileIcon() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(widget.reel.merchantProfileImage))),
    ]);
  }

  // الأزرار العلوية (Following / For You)
  Widget _buildTopTabs() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _topTabText("Following", false),
            const SizedBox(width: 15),
            _topTabText("For you", true),
          ],
        ),
      ),
    );
  }

  // تدرج لوني خلف النصوص لزيادة الوضوح
  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.transparent,
              Colors.black.withOpacity(0.5),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت مساعد للنصوص العلوية
  Widget _topTabText(String text, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 17,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 30,
            color: Colors.white,
          ),
      ],
    );
  }

  // ويدجت مساعد لأيقونات الشريط الجانبي
  Widget _sidebarIcon(IconData icon, String label,
          {Color color = Colors.white, VoidCallback? onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Column(children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))
        ]),
      );
}
