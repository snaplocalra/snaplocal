import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class CategoryChipsShimmer extends StatelessWidget {
  const CategoryChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ShimmerWidget(
        height: 50,
        width: 100,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
