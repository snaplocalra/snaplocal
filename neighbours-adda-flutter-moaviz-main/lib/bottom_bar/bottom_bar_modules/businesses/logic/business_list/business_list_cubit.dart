import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/repository/business_list_repository.dart';

part 'business_list_state.dart';

class BusinessListCubit extends Cubit<BusinessListState> {
  final BusinessListRepository businessListRepository;

  BusinessListCubit(this.businessListRepository)
      : super(const BusinessListState());

  Future<void> fetchBusiness({
    bool loadMoreData = false,
    required String? filterJson,
    required String searchKeyword,
    required BusinessViewType businessViewType,
  }) async {
    try {
      emit(state.copyWith(dataLoading: !loadMoreData));

      if (loadMoreData && state.businessListModel != null) {
        //Run the fetch conenction API, if it is not the last page.
        if (!state.businessListModel!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.businessListModel!.paginationModel.currentPage += 1;
          final moreData = await businessListRepository.fetchBusiness(
            page: state.businessListModel!.paginationModel.currentPage,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
            businessViewType: businessViewType,
          );

          emit(
            state.copyWith(
              businessListModel: state.businessListModel!
                  .paginationCopyWith(newData: moreData),
            ),
          );
          return;
        }
      } else {
        final businessList = await businessListRepository.fetchBusiness(
          filterJson: filterJson,
          searchKeyword: searchKeyword,
          businessViewType: businessViewType,
        );
        emit(state.copyWith(businessListModel: businessList));
      }

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.businessListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }
}
