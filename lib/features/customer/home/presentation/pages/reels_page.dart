import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
// ✅ استيراد الموديلات والمسارات
import 'package:app2030/core/models/reel_model.dart';
import 'package:app2030/core/models/merchant_model.dart';
import 'package:app2030/core/routing/route_paths.dart';

class ReelsPage extends StatefulWidget {
  final List<ReelModel>? reels;

  const ReelsPage({super.key, this.reels});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController();

  // متغيرات الحالة لإستعادة التفاعل اللحظي
  bool _isCommenting = false;
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _isFollowing = false;
  int _tabIndex = 1;

  // القوائم التجريبية (Fallback)
  final List<ReelModel> followingReels = [
    ReelModel(
      id: "f1",
      merchantId: "m1",
      merchantName: "متجر الرويضة",
      merchantProfileImage: "https://randomuser.me/api/portraits/men/32.jpg",
      videoUrl:
          "https://assets.mixkit.co/videos/preview/mixkit-fashion-model-posing-in-the-studio-34444-large.mp4",
      title: "تشكيلة شتوية",
      description: "وصلنا حديثاً! أحدث تشكيلة ملابس شتوية ❄️",
      thumbnailUrl: "",
      likesCount: 120,
      commentsCount: 45,
    ),
  ];

  final List<ReelModel> forYouReels = [
    ReelModel(
      id: "fy1",
      merchantId: "m2",
      merchantName: "وهمي برجر",
      merchantProfileImage: "https://randomuser.me/api/portraits/women/44.jpg",
      videoUrl:
          "https://assets.mixkit.co/videos/preview/mixkit-serving-a-delicious-hamburger-with-fries-34313-large.mp4",
      title: "أفضل برجر",
      description: "تجربة أفضل برجر في المدينة! 🍔",
      thumbnailUrl: "",
      likesCount: 250,
      commentsCount: 1200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<ReelModel> currentList =
        (widget.reels != null && widget.reels!.isNotEmpty)
            ? widget.reels!
            : (_tabIndex == 0 ? followingReels : forYouReels);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: currentList.length,
              itemBuilder: (context, index) =>
                  _buildReelItem(currentList[index]),
            ),
            _buildTopTabs(),
            if (_isCommenting) _buildDirectCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildReelItem(ReelModel reel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayerWidget(videoUrl: reel.videoUrl),
        _buildBottomGradient(),
        _buildRightSidebar(reel),
        _buildBottomInfo(reel),
      ],
    );
  }

  Widget _buildBottomGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
    );
  }

  // ✅ استعادة شريط الأيقونات الجانبي التفاعلي
  Widget _buildRightSidebar(ReelModel reel) {
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        children: [
          _buildProfileIcon(reel.merchantProfileImage),
          const SizedBox(height: 20),
          _buildActionItem(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            reel.likesCount.toString(),
            _isLiked ? Colors.pink : Colors.white,
            () => setState(() => _isLiked = !_isLiked),
          ),
          _buildActionItem(
            Icons.comment,
            reel.commentsCount.toString(),
            Colors.white,
            () => _showComments(),
          ),
          _buildActionItem(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            "حفظ",
            _isBookmarked ? Colors.amber : Colors.white,
            () => setState(() => _isBookmarked = !_isBookmarked),
          ),
          _buildActionItem(
            Icons.reply,
            "مشاركة",
            Colors.white,
            () => _showShareMenu(),
          ),
          _buildActionItem(
            Icons.edit_note,
            "علق",
            Colors.white,
            () => setState(() => _isCommenting = !_isCommenting),
          ),
        ],
      ),
    );
  }

  // ✅ استعادة زر المتابعة (+) التفاعلي
  Widget _buildProfileIcon(String imgUrl) {
    return GestureDetector(
      onTap: () => setState(() => _isFollowing = !_isFollowing),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child:
                CircleAvatar(radius: 25, backgroundImage: NetworkImage(imgUrl)),
          ),
          if (!_isFollowing)
            Positioned(
              bottom: -8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.pink, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(ReelModel reel) {
    return Positioned(
      left: 20,
      bottom: 30,
      right: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _navigateToMerchant(reel),
            child: Text("@${reel.merchantName}",
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
          ),
          const SizedBox(height: 10),
          Text(reel.description ?? "",
              style: GoogleFonts.cairo(
                  color: Colors.white, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  // ✅ استعادة وظائف التبويبات العلوية
  Widget _buildTopTabs() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabText("Following", 0),
          const SizedBox(width: 8),
          const Text("|", style: TextStyle(color: Colors.white24)),
          const SizedBox(width: 8),
          _tabText("For you", 1),
        ],
      ),
    );
  }

  Widget _tabText(String title, int index) {
    bool isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _tabIndex = index;
        _pageController.jumpToPage(0);
      }),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: GoogleFonts.cairo(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: isActive ? 18 : 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              )),
          if (isActive)
            Container(
                margin: const EdgeInsets.only(top: 4),
                width: 30,
                height: 2,
                color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 5),
            Text(label,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectCommentInput() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            top: 15,
            left: 15,
            right: 15),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _commentController,
              autofocus: true,
              style: GoogleFonts.cairo(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "اكتب تعليقك هنا...",
                  hintStyle: GoogleFonts.cairo(color: Colors.white54),
                  fillColor: Colors.white10,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none)),
            )),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF4CAF50)),
              onPressed: () {
                setState(() => _isCommenting = false);
                _commentController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMerchant(ReelModel reel) {
    final selectedMerchant = MerchantModel(
      id: reel.merchantId,
      storeName: reel.merchantName,
      description: "مرحباً بكم في متجر ${reel.merchantName}",
      logoUrl: reel.merchantProfileImage,
      coverImageUrl:
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
      category: "تصنيف المتجر",
      isVerified: true,
    );
    context.push(RoutePaths.storeDetails, extra: selectedMerchant);
  }

  // ✅ استعادة نوافذ التعليقات والمشاركة
  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        height: 400,
        alignment: Alignment.center,
        child: Text("لا توجد تعليقات بعد",
            style: GoogleFonts.cairo(color: Colors.white70)),
      ),
    );
  }

  void _showShareMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("مشاركة عبر",
                style: GoogleFonts.cairo(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareIcon(Icons.link, "نسخ"),
                _buildShareIcon(Icons.send, "رسالة"),
                _buildShareIcon(Icons.more_horiz, "المزيد"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.white)),
        const SizedBox(height: 8),
        Text(label,
            style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.setLooping(true);
            _controller.play();
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? GestureDetector(
            onTap: () => _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play(),
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator(color: Colors.white24));
  }
}
