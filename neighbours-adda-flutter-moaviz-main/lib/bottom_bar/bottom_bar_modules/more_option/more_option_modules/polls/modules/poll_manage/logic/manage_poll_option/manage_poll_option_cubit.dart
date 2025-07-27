import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_option_model.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';

part 'manage_poll_option_state.dart';

class ManagePollOptionCubit extends Cubit<ManagePollOptionState> {
  ManagePollOptionCubit()
      : super(ManagePollOptionState(
            managePollOptionList: ManagePollOptionList()));

  void addInitialData(List<ManagePollOptionModel> pollOptions) {
    emit(state.copyWith(
        managePollOptionList: ManagePollOptionList(data: pollOptions)));
  }

  int get maxOptionsLimit => 4;
  bool get isMaximumLimitReached => state.managePollOptionList.data.length >= 4;

  void addOption() {
    final existingOptionList = state.managePollOptionList.data;

    if (!isMaximumLimitReached) {
      emit(state.copyWith(dataLoading: true));

      //The default id will send as 0, to insert in server database
      existingOptionList
          .add(ManagePollOptionModel(optionId: "0", optionName: ""));

      emit(state.copyWith());
    }
  }

  void addTextInOption(String text, int optionIndex) {
    final existingOptionList = state.managePollOptionList.data;
    existingOptionList[optionIndex].optionName = text;
  }

  //add image in option
  void addRemoveImageInOption(MediaFileModel? fileImage, int optionIndex) {
    emit(state.copyWith(dataLoading: true));
    final existingOptionList = state.managePollOptionList.data;
    existingOptionList[optionIndex].fileImage = fileImage;
    emit(state.copyWith(
        managePollOptionList: ManagePollOptionList(
      data: List.from(existingOptionList),
    )));
  }

  void removeOption(int optionIndex) {
    emit(state.copyWith(dataLoading: true));
    state.managePollOptionList.data.removeAt(optionIndex);
    emit(state.copyWith(
        managePollOptionList: ManagePollOptionList(
      data: List.from(state.managePollOptionList.data),
    )));
  }
}
