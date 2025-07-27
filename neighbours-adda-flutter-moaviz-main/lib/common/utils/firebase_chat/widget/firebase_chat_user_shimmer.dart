import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class FirebaseUserShimmer extends StatelessWidget {
  const FirebaseUserShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Row(
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
              width: mqSize.width * 0.30,
              shapeBorder: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
