import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/screen/jobs_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_card_widget.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class JobSearchShortDetailsWidget extends StatelessWidget {
  final String jobId;
  final String companyName;
  final String jobDesignation;
  final List<String> skills;
  final String jobImageUrl;

  const JobSearchShortDetailsWidget({
    super.key,
    required this.jobId,
    required this.companyName,
    required this.jobDesignation,
    required this.skills,
    required this.jobImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    const borderRadius = Radius.circular(10);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          JobDetailsScreen.routeName,
          queryParameters: {
            'id': jobId,
            'job_title': jobDesignation,
          },
        );
      },
      child: AbsorbPointer(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: JobCardWidget(
                      jobImage: jobImageUrl,
                      companyName: companyName,
                      jobDesignation: jobDesignation,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: mqSize.width * 0.1),
                child: const ThemeDivider(thickness: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
