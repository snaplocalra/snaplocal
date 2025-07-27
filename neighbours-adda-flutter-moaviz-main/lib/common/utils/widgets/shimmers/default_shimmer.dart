import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class DefaultShimmer extends StatelessWidget {
  const DefaultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // final mqSize = MediaQuery.sizeOf(context);

    return const ShimmerWidget(
      height: double.infinity,
      width: double.infinity,
      shapeBorder: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
