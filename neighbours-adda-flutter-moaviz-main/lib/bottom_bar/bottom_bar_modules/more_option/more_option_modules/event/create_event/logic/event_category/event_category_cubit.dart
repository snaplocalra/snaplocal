import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/repository/manage_event_repository.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';

part 'event_category_state.dart';

class EventCategoryCubit extends Cubit<EventCategoryState> {
  final ManageEventRepository manageEventRepository;
  EventCategoryCubit(this.manageEventRepository)
      : super(
            const EventCategoryState(eventTopics: CategoryListModel(data: [])));

  //fetch category list for filter
  void fetchEventCategorysForFilter() async {
    try {
      emit(state.copyWith(dataLoading: true));

      final eventTopicsDropdownList =
          await manageEventRepository.fetchEventCategorys();

      //Add all type to the list
      eventTopicsDropdownList.data.insert(0, CategoryModel.allType());

      //Emit state to store initial data
      emit(state.copyWith(eventTopics: eventTopicsDropdownList));

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

  Future<void> fetchEventCategorys({
    String? targetEventCategoryId,
    bool dataPreSelect = true,
  }) async {
    try {
      late CategoryListModel eventTopicsDropdownList;

      if (state.eventTopics.data.isEmpty) {
        emit(state.copyWith(dataLoading: true));
        eventTopicsDropdownList =
            await manageEventRepository.fetchEventCategorys();
      } else {
        eventTopicsDropdownList = state.eventTopics;
      }

      //Emit state to store initial data
      emit(state.copyWith(eventTopics: eventTopicsDropdownList));

      //Pre select the data and emit
      if (dataPreSelect && eventTopicsDropdownList.data.isNotEmpty) {
        if (targetEventCategoryId != null) {
          //select the given category type by default
          selectEventCategory(targetEventCategoryId);
        } else {
          //select the 1st category type by default
          selectEventCategory(eventTopicsDropdownList.data.first.id);
        }
      }
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

  void selectEventCategory(String eventTopicId) {
    if (state.eventTopics.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));
      for (var salesCategoryType in state.eventTopics.data) {
        if (salesCategoryType.id == eventTopicId) {
          salesCategoryType.isSelected = true;
        } else {
          salesCategoryType.isSelected = false;
        }
      }

      emit(state.copyWith(
        eventTopics: state.eventTopics.copyWith(),
      ));
    }
  }
}
