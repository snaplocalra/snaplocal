import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class OtherCommunicationDetailsDisplay extends StatelessWidget {
  final OtherCommunicationPost otherCommunicationPost;
  const OtherCommunicationDetailsDisplay({
    super.key,
    required this.otherCommunicationPost,
  });

  @override
  Widget build(BuildContext context) {
    return otherCommunicationPost.buildDetails(context);
  }
}

class OtherCommunicationDisplayShimmer extends StatelessWidget {
  final double height;
  const OtherCommunicationDisplayShimmer({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ShimmerWidget(
        height: height,
        width: double.infinity,
      ),
    );
  }
}
