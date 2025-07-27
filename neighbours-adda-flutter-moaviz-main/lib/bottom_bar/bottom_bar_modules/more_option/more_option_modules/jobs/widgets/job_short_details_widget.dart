import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/screen/jobs_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_additional_short_details_card_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_card_widget.dart';
import 'package:snap_local/common/utils/widgets/strip_widget.dart';

class JobShortDetailsWidget extends StatefulWidget {
  final double? width;
  final void Function(bool status)? onBookMarkChanged;
  final Color? cardColor;
  final Color? skillColor;
  const JobShortDetailsWidget({
    super.key,
    this.width,
    this.onBookMarkChanged,
    this.cardColor,
    this.skillColor,
  });

  @override
  State<JobShortDetailsWidget> createState() => _JobShortDetailsWidgetState();
}

class _JobShortDetailsWidgetState extends State<JobShortDetailsWidget> {
  @override
  void initState() {
    super.initState();
    final jobsShortViewControllerCubit =
        context.read<JobShortViewControllerCubit>();
    if (jobsShortViewControllerCubit.postActionCubit != null) {
      jobsShortViewControllerCubit.postActionCubit!.stream
          .listen((postActionState) {
        if (postActionState.isSaveRequestSuccess) {
          widget.onBookMarkChanged?.call(
            !jobsShortViewControllerCubit.jobShortDetailsModel.isSaved,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(10);
    return BlocBuilder<JobShortViewControllerCubit,
        JobShortViewControllerState>(
      builder: (context, jobShortViewControllerState) {
        final jobShortDetails =
            jobShortViewControllerState.jobShortDetailsModel;
        return Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.cardColor ?? Colors.white,
            borderRadius: const BorderRadius.all(borderRadius),
          ),
          margin: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed(
                      JobDetailsScreen.routeName,
                      queryParameters: {
                        'id': jobShortDetails.id,
                        'job_title': jobShortDetails.jobDesignation,
                      },
                      extra: context.read<JobShortViewControllerCubit>(),
                    );
                  },
                  child: AbsorbPointer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JobCardWidget(
                          jobImage: jobShortDetails.media.isNotEmpty
                              ? jobShortDetails.media.first.mediaUrl
                              : null,
                          companyName: jobShortDetails.companyName,
                          jobDesignation: jobShortDetails.jobDesignation,
                        ),
                        JobAdditionalShortDetailsCardWidget(
                          minWorkExperience: jobShortDetails.minWorkExperience,
                          maxWorkExperience: jobShortDetails.maxWorkExperience,
                          workLocation: jobShortDetails.workLocation,
                          skills: jobShortDetails.mustHaveSkills,
                          skillColor: widget.skillColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //Strip
              if (jobShortDetails.isJobApplied ||
                  jobShortDetails.isPositionClosed)
                Positioned(
                  top: 5,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: StripWidget(
                      reverseAngle: true,
                      type: jobShortDetails.isJobApplied
                          ? StripWidgetType.applied
                          : StripWidgetType.closed,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
