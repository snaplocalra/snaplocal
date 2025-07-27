import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class ProfilePrivacyShimmer extends StatelessWidget {
  const ProfilePrivacyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (context, _) {
        return const ProfilePrivacyShimmerWidget();
      },
    );
  }
}

class ProfilePrivacyShimmerWidget extends StatelessWidget {
  const ProfilePrivacyShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(
            height: mqSize.height * 0.025,
            width: mqSize.width * 0.3,
          ),
          SizedBox(height: mqSize.height * 0.02),
          ShimmerWidget(
            height: mqSize.height * 0.015,
            width: mqSize.width * 0.6,
          ),
          SizedBox(height: mqSize.height * 0.03),
          ShimmerWidget(
            height: mqSize.height * 0.025,
            width: mqSize.width * 0.4,
          ),
          SizedBox(height: mqSize.height * 0.02),
          ShimmerWidget(
            height: mqSize.height * 0.015,
            width: mqSize.width * 0.6,
          ),
        ],
      ),
    );
  }
}
