// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips_shimmer.dart';

class CategoryChipsShimmerListBuilder extends StatelessWidget {
  final int itemCount;
  const CategoryChipsShimmerListBuilder({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, _) {
        return const CategoryChipsShimmer();
      },
    );
  }
}
