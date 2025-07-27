import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/poll_vote_manage/poll_vote_manage_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_service/poll_service_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/widgets/poll_option_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_poll_option_state.dart';

class PollPostWidget extends StatelessWidget {
  final bool disablePoll;
  final PollPostModel pollPostModel;
  final void Function(PollsListType? targetPollsListType)?
      onDataRefreshCallBack;

  const PollPostWidget({
    super.key,
    this.onDataRefreshCallBack,
    required this.pollPostModel,
    this.disablePoll = false,
  });

  void dataRefreshCallBack({PollsListType? targetPollsListType}) {
    if (onDataRefreshCallBack != null) {
      onDataRefreshCallBack!.call(targetPollsListType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pollModel = pollPostModel.pollsModel;
    return BlocListener<PollServiceCubit, PollServiceState>(
      listener: (context, managePollState) {
        //If request failed then call the api and refresh the data
        if (managePollState.isRequestFailed ||
            managePollState.isDeleteRequestSuccess) {
          dataRefreshCallBack();
        }
      },
      child: BlocListener<PollVoteManageCubit, PollVoteManageState>(
        listener: (context, pollVoteManageState) {
          if (pollVoteManageState.refreshData) {
            context.read<PostDetailsControllerCubit>().postStateUpdate(
                  UpdatePollOptionState(
                    pollVoteManageState
                        .pollPostModel.pollsModel.pollOptionDetails,
                  ),
                );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Poll question
              Text(
                pollModel.pollQuestion,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              //Poll options
              PollOptionBuilder(
                enablePollData: pollModel.isUserVoted,
                pollType: pollModel.pollType,
                pollOptionDetails: pollModel.pollOptionDetails,
                hideResultUntilPollEnds: pollModel.hideResultUntilPollEnds,
                disableOptionSelection: disablePoll || pollModel.disablePoll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
