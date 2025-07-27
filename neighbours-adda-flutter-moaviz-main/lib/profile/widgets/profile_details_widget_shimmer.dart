// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class ProfileDetailsWidgetShimmer extends StatelessWidget {
  final double circleSize;
  const ProfileDetailsWidgetShimmer({
    super.key,
    required this.circleSize,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(
          height: circleSize,
          width: circleSize,
          shapeBorder: const CircleBorder(),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(
              height: 24,
              width: mqSize.width * 0.50,
              shapeBorder: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 8),
            ShimmerWidget(
              height: 10,
              width: mqSize.width * 0.40,
              shapeBorder: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 8),
            ShimmerWidget(
              height: 10,
              width: mqSize.width * 0.50,
              shapeBorder: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(height: 8),
            ShimmerWidget(
              height: 10,
              width: mqSize.width * 0.45,
              shapeBorder: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
