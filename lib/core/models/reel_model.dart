class ReelModel {
  final String id;
  final String merchantId;
  final String merchantName;
  final String merchantProfileImage;
  final String videoUrl;
  final String? title; // ✅ أضفنا هذا الحقل
  final String? description;
  final String thumbnailUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByMe;

  ReelModel({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.merchantProfileImage,
    required this.videoUrl,
    this.title, // ✅ أضفنا هذا الحقل
    this.description,
    required this.thumbnailUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
  });

  // ✅ تحديث وظيفة copyWith لتشمل كل الحقول
  ReelModel copyWith({
    String? title,
    String? description,
    int? likesCount,
    bool? isLikedByMe,
  }) {
    return ReelModel(
      id: id,
      merchantId: merchantId,
      merchantName: merchantName,
      merchantProfileImage: merchantProfileImage,
      videoUrl: videoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}
