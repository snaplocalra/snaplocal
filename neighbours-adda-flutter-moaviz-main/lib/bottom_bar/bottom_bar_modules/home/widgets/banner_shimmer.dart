// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class BannerShimmer extends StatelessWidget {
  final double bannerShimmerWidth;

  const BannerShimmer({
    super.key,
    required this.bannerShimmerWidth,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return SizedBox(
      height: mqSize.height * 0.18,
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ShimmerWidget(
              height: mqSize.height * 0.22,
              width: mqSize.width * bannerShimmerWidth,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }
}
