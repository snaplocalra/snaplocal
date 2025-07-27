import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_item_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/repository/saved_items_repository.dart';

part 'saved_item_state.dart';

class SavedItemCubit extends Cubit<SavedItemState> {
  final SavedItemsRepository savedItemsRepository;
  SavedItemCubit(this.savedItemsRepository) : super(const SavedItemState());

  Future<void> fetchSavedItems({
    SavedPostTypeEnum? savedPostTypeEnum,
    String? query,
  }) async {
    try {
      emit(state.copyWith(dataLoading: true));
      final savedItems = await savedItemsRepository.fetchSavedItems(
        savedPostTypeEnum: savedPostTypeEnum,
        query: query,
      );
      emit(state.copyWith(savedItemModel: savedItems));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user remove the bookmark
  Future<void> removePost(int index) async {
    try {
      if (state.savedItemModelAvailable &&
          state.savedItemModel!.postsList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.savedItemModel!.postsList.removeAt(index);
        emit(state.copyWith());
      } else {
        throw ("No data available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  ///This method is used to remove the job post and quick update the ui, when the user remove the bookmark
  Future<void> removeJob(int index) async {
    try {
      if (state.savedItemModelAvailable &&
          state.savedItemModel!.jobsShortDetailsList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.savedItemModel!.jobsShortDetailsList.removeAt(index);
        emit(state.copyWith());
      } else {
        throw ("No data available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }

  ///This method is used to remove the sale post and quick update the ui, when the user remove the bookmark
  Future<void> removeSalePost(int index) async {
    try {
      if (state.savedItemModelAvailable &&
          state.savedItemModel!.salesPostShortDetailsList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.savedItemModel!.salesPostShortDetailsList.removeAt(index);
        emit(state.copyWith());
      } else {
        throw ("No data available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }
}
