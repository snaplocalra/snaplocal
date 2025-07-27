import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/polls_list/polls_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PollsListWidget extends StatelessWidget {
  final PollsListType pollsListType;
  final PollsListModel pollsListModel;
  final void Function() onPaginationDataFetch;

  const PollsListWidget({
    super.key,
    required this.pollsListType,
    required this.pollsListModel,
    required this.onPaginationDataFetch,
  });

  @override
  Widget build(BuildContext context) {
    final logs = pollsListModel.data;
    if (logs.isEmpty) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const EmptyDataPlaceHolder(
          emptyDataType: EmptyDataType.poll,
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length + 1,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, index) {
          if (index < logs.length) {
            final pollModel = logs[index];

            //Post Action cubit
            final postActionCubit = PostActionCubit(PostActionRepository());

            //Show reaction
            final showReactionCubit = ShowReactionCubit();

            //Post details controller
            final postDetailsControllerCubit =
                PostDetailsControllerCubit(socialPostModel: pollModel);
            final ReportCubit reportCubit = ReportCubit(ReportRepository());

            final HidePostCubit hidePostCubit =
                HidePostCubit(HidePostRepository());

            return MultiBlocProvider(
              key: ValueKey(pollModel.id),
              providers: [
                BlocProvider.value(value: postDetailsControllerCubit),
                BlocProvider.value(value: postActionCubit),
                BlocProvider.value(value: showReactionCubit),
                BlocProvider.value(value: reportCubit),
                BlocProvider.value(value: hidePostCubit),
                BlocProvider(
                  create: (context) => ReportCubit(ReportRepository()),
                ),
                BlocProvider(
                  create: (context) => CommentViewControllerCubit(),
                ),
              ],
              child: BlocListener<ReportCubit, ReportState>(
                listener: (context, reportState) {
                  if (reportState.requestSuccess) {
                    context
                        .read<PollsListCubit>()
                        .fetchPolls(pollsListType: pollsListType);
                  }
                },
                child: BlocListener<PostActionCubit, PostActionState>(
                  listener: (context, postActionState) {
                    if (postActionState.isDeleteRequestLoading) {
                      context.read<PollsListCubit>().removePollPost(
                          index: index, pollsListType: pollsListType);
                    }
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: PostViewWidget(
                          key: ValueKey(pollModel.id),
                          allowNavigation: true,
                          allowPostDetailsOpen: true,
                        ),
                      ),
                      const ThemeDivider(height: 2, thickness: 2),
                    ],
                  ),
                ),
              ),
            );
          } else {
            if (pollsListModel.paginationModel.isLastPage) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: SizedBox.shrink(),
              );
            } else {
              return VisibilityDetector(
                key: Key(pollsListType.name),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  if (visiblePercentage >= 60) {
                    onPaginationDataFetch.call();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: ThemeSpinner(size: 30),
                ),
              );
            }
          }
        },
      );
    }
  }
}
