// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/poll_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_service/poll_service_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/poll_post_model.dart';

part 'poll_vote_manage_state.dart';

// Enum for representing actions on a poll
enum PollAnswer { add, remove }

class PollVoteManageCubit extends Cubit<PollVoteManageState> {
  final PollServiceCubit pollServiceCubit;
  final PollPostModel pollPostModel;
  PollVoteManageCubit({
    required this.pollServiceCubit,
    required this.pollPostModel,
  }) : super(PollVoteManageState(pollPostModel: pollPostModel));

  // Get the existing poll option details
  PollOptionModel get pollOptionDetails =>
      state.pollPostModel.pollsModel.pollOptionDetails;

  void _modifyOption(
    int optionIndex,
    PollAnswer pollAnswer,
  ) {
    // Update voting count for the specified option
    pollOptionDetails.options[optionIndex].voteCount =
        pollAnswer == PollAnswer.add
            ? pollOptionDetails.options[optionIndex].voteCount + 1
            : pollOptionDetails.options[optionIndex].voteCount - 1;
  }

// // This function is used to mark the user's vote submission as completed for the current poll.
// // It updates the state to indicate that the user has successfully submitted their vote.
//   void markUserVoteSubmitted() {
//     emit(
//       state.copyWith(
//         refreshData: true,
//         pollPostModel: state.pollPostModel.copyWith(
//           pollsModel: state.pollPostModel.pollsModel.copyWith(
//             answerSubmitted: true,
//           ),
//         ),
//       ),
//     );
//   }

// This function is used to update the user's vote for a specific option in the poll.
// It takes an `optionId` as input to identify the selected option.
// The `allowAnswerChange` parameter is used to specify whether the user is allowed to change their answer or not.
  void updateVote(String optionId, {bool allowAnswerChange = false}) {
    //If user already given the vote for this poll, then don't allow any change
    if (!allowAnswerChange && state.pollPostModel.pollsModel.answerSubmitted) {
      ThemeToast.errorToast("Answer already submitted");
      return;
    }

    // Set the data loading flag to true to indicate that the update is in progress.
    emit(state.copyWith(dataLoading: true));

    // Retrieve the list of options from the poll option details.
    final options = pollOptionDetails.options;

    // Iterate through each option in the poll.
    for (var optionIndex = 0; optionIndex < options.length; optionIndex++) {
      // Check if the current option is the one selected by the user.
      if (options[optionIndex].userSelectedOption) {
        // If the user selected some answer previously, then remove that selection.
        options[optionIndex].userSelectedOption = false;

        // Here the object from the array is passed as a reference for modification.
        // This will update the voting count for the selected option to decrement it by 1.
        _modifyOption(optionIndex, PollAnswer.remove);
      } else {
        // If the option is selected by the user, mark it as the new selected option.
        if (optionId == options[optionIndex].optionId) {
          options[optionIndex].userSelectedOption = true;

          // Here the object from the array is passed as a reference for modification.
          // This will update the voting count for the selected option to increment it by 1.
          _modifyOption(optionIndex, PollAnswer.add);
        } else {
          // If the option is not selected by the user, mark it as not selected.
          options[optionIndex].userSelectedOption = false;
        }
      }
    }

    //Update the data on the server
    pollServiceCubit.giveVoteOnPoll(
      pollId: state.pollPostModel.id,
      optionId: optionId,
    );

    // Update the state with the modified poll option details, including the new total participant count.
    emit(
      state.copyWith(
        refreshData: true,
        pollPostModel: state.pollPostModel.copyWith(
          pollsModel: state.pollPostModel.pollsModel.copyWith(
            pollOptionDetails: PollOptionModel(
              totalParticipants: pollOptionDetails.totalVotes,
              options: options,
            ),
          ),
        ),
      ),
    );
  }
}
