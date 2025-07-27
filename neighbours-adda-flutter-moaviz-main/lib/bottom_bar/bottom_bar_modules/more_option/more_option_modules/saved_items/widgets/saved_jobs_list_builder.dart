import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_short_details_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item/saved_item_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_item_data_heading.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SavedJobsListBuilder extends StatelessWidget {
  final List<JobShortDetailsModel> logs;
  final bool isAllType;

  const SavedJobsListBuilder({
    super.key,
    required this.logs,
    this.isAllType = false,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return (logs.isEmpty)
        ? isAllType
            ? const SizedBox.shrink()
            : SizedBox(
                height: mqSize.height * 0.6,
                child: const EmptyDataPlaceHolder(
                  emptyDataType: EmptyDataType.job,
                ),
              )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SavedItemDataHeading(
                visible: isAllType,
                text: LocaleKeys.jobReferralFromNeighbours,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (BuildContext context, index) {
                  final jobsDetails = logs[index];
                  return MultiBlocProvider(
                    key: ValueKey(jobsDetails.id),
                    providers: [
                      BlocProvider(
                        create: (context) => JobShortViewControllerCubit(
                          jobShortDetailsModel: jobsDetails,
                          postActionCubit:
                              PostActionCubit(PostActionRepository()),
                        ),
                      ),
                    ],
                    child: JobShortDetailsWidget(
                      cardColor: Colors.grey.shade50,
                      onBookMarkChanged: (isSaved) {
                        if (!isSaved) {
                          context.read<SavedItemCubit>().removeJob(index);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          );
  }
}
