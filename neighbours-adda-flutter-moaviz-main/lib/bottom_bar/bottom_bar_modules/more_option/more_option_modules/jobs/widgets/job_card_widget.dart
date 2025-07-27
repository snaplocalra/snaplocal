import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/text_scroll_widget.dart';

class JobCardWidget extends StatelessWidget {
  final String? jobImage;
  final double imageRadius;
  final String companyName;
  final double companyNameFontSize;
  final String jobDesignation;
  final double jobDesignationFontSize;

  const JobCardWidget({
    super.key,
    required this.jobImage,
    this.imageRadius = 25,
    required this.companyName,
    required this.jobDesignation,
    this.companyNameFontSize = 13,
    this.jobDesignationFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (jobImage != null)
          NetworkImageCircleAvatar(
            radius: imageRadius,
            imageurl: jobImage!,
            backgroundColor: const Color.fromRGBO(80, 74, 74, 0.05),
          ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandedTextScrollWidget(
                text: jobDesignation,
                style: TextStyle(
                  fontSize: jobDesignationFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ExpandedTextScrollWidget(
                text: companyName,
                style: TextStyle(
                  fontSize: companyNameFontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
