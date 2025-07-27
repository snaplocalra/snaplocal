import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QuizBannerWidget extends StatelessWidget {
  const QuizBannerWidget({
    super.key,
    required this.bannerImage,
  });

  final String bannerImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          cacheKey: bannerImage,
          imageUrl: bannerImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
