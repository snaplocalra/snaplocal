import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class PollShimmerListBuilder extends StatelessWidget {
  const PollShimmerListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: PollShimmer(),
      ),
    );
  }
}

class PollShimmer extends StatelessWidget {
  const PollShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  height: 14,
                  width: mqSize.width * 0.28,
                  shapeBorder: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(height: 5),
                ShimmerWidget(
                  height: 10,
                  width: mqSize.width * 0.6,
                  shapeBorder: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                ),
                const SizedBox(height: 5),
                ShimmerWidget(
                  height: 10,
                  width: mqSize.width * 0.4,
                  shapeBorder: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 15),
        ShimmerWidget(
          height: 20,
          width: mqSize.width * 0.4,
          shapeBorder: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        const SizedBox(height: 10),
        ShimmerWidget(
          height: 16,
          width: mqSize.width * 0.2,
          shapeBorder: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        const SizedBox(height: 10),
        ShimmerWidget(
          height: 16,
          width: mqSize.width * 0.2,
          shapeBorder: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ],
    );
  }
}
