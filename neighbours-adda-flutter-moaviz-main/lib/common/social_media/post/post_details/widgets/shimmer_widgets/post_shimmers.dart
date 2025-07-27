import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_media_layout_shimmer.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class PostDetailsShimmer extends StatelessWidget {
  const PostDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerWidget(
                height: 40,
                width: 40,
                shapeBorder: CircleBorder(),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    height: 16,
                    width: mqSize.width * 0.28,
                    shapeBorder: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ShimmerWidget(
                    height: 10,
                    width: mqSize.width * 0.68,
                    shapeBorder: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1)),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          ShimmerWidget(
            height: 10,
            width: mqSize.width * 0.68,
            shapeBorder: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
          const SizedBox(height: 4),
          ShimmerWidget(
            height: 10,
            width: mqSize.width * 0.88,
            shapeBorder: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
          const SizedBox(height: 4),
          ShimmerWidget(
            height: 10,
            width: mqSize.width * 0.58,
            shapeBorder: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
          const SizedBox(height: 10),
          const PostMediaLayoutShimmerBuilder(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class PostListShimmer extends StatelessWidget {
  final bool scrollable;
  const PostListShimmer({
    super.key,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          child: const Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: PostDetailsShimmer(),
              ),
              ThemeDivider(height: 4),
            ],
          ),
        );
      },
    );
  }
}
