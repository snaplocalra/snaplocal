import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';

part 'interested_topics_state.dart';

class InterestedTopicsCategoryCubit
    extends Cubit<InterestedTopicsCategoryState> {
  final HallOfFameRepository hallOfFameRepository;

  InterestedTopicsCategoryCubit(this.hallOfFameRepository)
      : super(const InterestedTopicsCategoryState(
            interestedTopicListModel: CategoryListModel(data: [])));

  // String? interestedTopicCategoryId,
  // bool dataPreSelect = true,
  Future<void> fetchInterestedTopics() async {
    try {
      late CategoryListModel interestedTopicList;

      if (state.interestedTopicListModel.data.isEmpty) {
        emit(state.copyWith(dataLoading: true));
        interestedTopicList =
            await hallOfFameRepository.fetchQuizInterestsTopics();
      } else {
        interestedTopicList = state.interestedTopicListModel;
      }

      //Emit state to store initial data
      emit(state.copyWith(interestedTopicListModel: interestedTopicList));

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }

  void selectInterestedTopic(String interestedTopicCategoryId) {
    emit(state.copyWith(dataLoading: true));
    if (state.interestedTopicListModel.data.isNotEmpty) {
      for (var interestedTopicCategoryType
          in state.interestedTopicListModel.data) {
        if (interestedTopicCategoryType.id == interestedTopicCategoryId) {
          interestedTopicCategoryType.isSelected =
              !interestedTopicCategoryType.isSelected;
        }
      }

      emit(state.copyWith(
        interestedTopicListModel: state.interestedTopicListModel,
      ));
    }
  }
}
