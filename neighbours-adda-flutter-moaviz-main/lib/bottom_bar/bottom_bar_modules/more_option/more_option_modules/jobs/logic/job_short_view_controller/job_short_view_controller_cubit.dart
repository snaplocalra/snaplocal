import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';

part 'job_short_view_controller_state.dart';

class JobShortViewControllerCubit extends Cubit<JobShortViewControllerState> {
  final JobShortDetailsModel jobShortDetailsModel;
  final PostActionCubit? postActionCubit;
  JobShortViewControllerCubit({
    required this.jobShortDetailsModel,
    this.postActionCubit,
  }) : super(JobShortViewControllerState(
          jobShortDetailsModel: jobShortDetailsModel,
          postActionCubit: postActionCubit,
        ));

  void updatePostSaveStatus(bool newStatus) {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith(
      jobShortDetailsModel:
          state.jobShortDetailsModel.copyWith(isSaved: newStatus),
    ));
  }
}
