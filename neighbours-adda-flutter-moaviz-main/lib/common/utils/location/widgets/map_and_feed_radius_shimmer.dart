import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class MapAndFeedRadiusWidgetShimmer extends StatelessWidget {
  const MapAndFeedRadiusWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mqSize.height * 0.18,
            child: ShimmerWidget(
              height: mqSize.height * 0.18,
              width: double.infinity,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: ShimmerWidget(height: 15, width: 200),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: ShimmerWidget(
              height: 15,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
