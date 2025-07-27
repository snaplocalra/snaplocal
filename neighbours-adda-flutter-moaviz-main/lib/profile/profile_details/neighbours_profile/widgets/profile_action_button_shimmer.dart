import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class ProfileActionShimmer extends StatelessWidget {
  const ProfileActionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Spacer(),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Expanded(
                  child: ShimmerWidget(
                    height: 35,
                    width: double.infinity,
                    shapeBorder: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ShimmerWidget(
                    height: 35,
                    width: double.infinity,
                    shapeBorder: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
