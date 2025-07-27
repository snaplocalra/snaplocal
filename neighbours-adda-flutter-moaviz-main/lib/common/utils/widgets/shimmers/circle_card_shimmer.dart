// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class CircleCardShimmer extends StatelessWidget {
  const CircleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerWidget(
            height: 50,
            width: 50,
            shapeBorder: CircleBorder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: 15,
                  width: mqSize.width * 0.20,
                  shapeBorder: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(height: 10),
                ShimmerWidget(
                  height: 10,
                  width: mqSize.width * 0.40,
                  shapeBorder: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ThemeDivider(thickness: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleCardShimmerListBuilder extends StatelessWidget {
  ///Listview builder padding
  final EdgeInsetsGeometry? padding;
  const CircleCardShimmerListBuilder({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      itemCount: 8,
      itemBuilder: (context, _) => const CircleCardShimmer(),
    );
  }
}
