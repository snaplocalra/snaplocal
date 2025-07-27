import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips_shimmer_list_builder.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class JobShortDetailsShimmer extends StatelessWidget {
  const JobShortDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ShimmerWidget(
            height: 10,
            width: mqSize.width * 0.2,
            shapeBorder: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
          const SizedBox(height: 10),
          ShimmerWidget(
            height: 10,
            width: mqSize.width * 0.3,
            shapeBorder: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            height: 50,
            child: CategoryChipsShimmerListBuilder(itemCount: 3),
          ),
        ],
      ),
    );
  }
}

class JobShortDetailsShimmerListBuilder extends StatelessWidget {
  ///Listview builder padding
  final EdgeInsetsGeometry? padding;
  const JobShortDetailsShimmerListBuilder({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      itemCount: 6,
      itemBuilder: (context, _) => const JobShortDetailsShimmer(),
    );
  }
}
