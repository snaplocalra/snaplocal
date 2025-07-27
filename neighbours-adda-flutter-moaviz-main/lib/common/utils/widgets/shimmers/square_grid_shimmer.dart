import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/shimmers/default_shimmer.dart';

class SquareGridShimmerBuilder extends StatelessWidget {
  final int gridCount;
  const SquareGridShimmerBuilder({
    super.key,
    this.gridCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5,
        mainAxisSpacing: 8,
        crossAxisCount: gridCount,
        childAspectRatio: 1.1,
      ),
      itemCount: 10,
      itemBuilder: (context, _) => const DefaultShimmer(),
    );
  }
}
