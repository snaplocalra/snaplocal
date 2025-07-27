import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/repository/jobs_repository.dart';

part 'jobs_search_state.dart';

class JobsSearchCubit extends Cubit<JobsSearchState> {
  final JobsRepository jobsRepository;
  JobsSearchCubit({required this.jobsRepository})
      : super(const JobsSearchState());

  //Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }

  Future<void> searchForJobs({
    bool loadMoreData = false,
    bool disableLoading = false,
    bool showSearchLoading = false,
    required String jobsIndustryCategoryId,
  }) async {
    final showDataLoading =
        state.error != null || !disableLoading && !loadMoreData;
    emit(state.copyWith(
      dataLoading: showDataLoading,
      isSearchDataLoading: showSearchLoading,
    ));

    try {
      if (loadMoreData) {
        //Run the search group API, if it is not the last page.
        if (!state.jobsListModel!.paginationModel.isLastPage) {
          //Increase the current page counter
          state.jobsListModel!.paginationModel.currentPage += 1;
          final moreData = await jobsRepository.searchJobs(
            query: _searchQuery,
            page: state.jobsListModel!.paginationModel.currentPage,
            jobsIndustryCategoryId: jobsIndustryCategoryId,
          );
          emit(state.copyWith(
            jobsListModel: state.jobsListModel!.paginationCopyWith(
              newData: moreData,
            ),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        final newData = await jobsRepository.searchJobs(
          query: _searchQuery,
          page: 1,
          jobsIndustryCategoryId: jobsIndustryCategoryId,
        );

        emit(state.copyWith(jobsListModel: newData));
      }
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

  void emitEmptyData() {
    emit(state.copyWith(jobsListModel: JobsListModel.emptyModel()));
  }
}
