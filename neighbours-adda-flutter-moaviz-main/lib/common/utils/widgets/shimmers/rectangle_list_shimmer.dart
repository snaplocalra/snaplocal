import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/shimmers/default_shimmer.dart';

class ReactangleListShimmerBuilder extends StatelessWidget {
  const ReactangleListShimmerBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(5),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, _) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 120,
          child: DefaultShimmer(),
        ),
      ),
    );
  }
}
