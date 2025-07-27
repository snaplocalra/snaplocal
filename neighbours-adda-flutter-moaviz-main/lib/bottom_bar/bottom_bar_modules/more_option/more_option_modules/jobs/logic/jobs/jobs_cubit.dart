import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/repository/jobs_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  final JobsRepository jobsRepository;
  JobsCubit(this.jobsRepository)
      : super(
          JobsState(
              jobsDataModel: JobsDataModel(
            jobsByNeighbours: JobsListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            jobsByYou: JobsListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

  Future<JobsListModel> _fetchJobsByType({
    bool loadMoreData = false,
    required JobsListType jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    late JobsListModel jobsListModel;

    if (jobsListType == JobsListType.byNeighbours) {
      jobsListModel = state.jobsDataModel.jobsByNeighbours;
    } else {
      jobsListModel = state.jobsDataModel.jobsByYou;
    }

    try {
      if (loadMoreData) {
        //Run the fetch conenction API, if it is not the last page.
        if (!jobsListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          jobsListModel.paginationModel.currentPage += 1;
          late JobsListModel moreData;
          if (jobsListType == JobsListType.byNeighbours) {
            moreData = await jobsRepository.fetchNeighboursPostedJobs(
              page: jobsListModel.paginationModel.currentPage,
              jobsListType: jobsListType,
              filterJson: filterJson,
              searchKeyword: searchKeyword,
            );
          } else {
            moreData = await jobsRepository.fetchOwnPostedJobs(
              page: jobsListModel.paginationModel.currentPage,
              jobsListType: jobsListType,
              filterJson: filterJson,
              searchKeyword: searchKeyword,
            );
          }
          return jobsListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return jobsListModel;
        }
      } else {
        late JobsListModel moreData;
        if (jobsListType == JobsListType.byNeighbours) {
          moreData = await jobsRepository.fetchNeighboursPostedJobs(
            page: 1,
            jobsListType: jobsListType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
        } else {
          moreData = await jobsRepository.fetchOwnPostedJobs(
            page: 1,
            jobsListType: jobsListType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
        }
        return moreData;
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing connection model
      return jobsListModel;
    }
  }

  Future<void> fetchJobs({
    bool loadMoreData = false,
    bool disableLoading = false,
    JobsListType? jobsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      //If the JobsList Type is not null then fetch the JobsList data as per the type.
      if (jobsListType != null) {
        //Data fetch permission
        final allowjobsByNeighboursDataFetch =
            jobsListType == JobsListType.byNeighbours;

        final allowjobsByYouDataFetch = jobsListType == JobsListType.byYou;

        emit(
          state.copyWith(
            //If the loadMore is true, then don't emit the loading state
            isJobsByNeighboursDataLoading: !disableLoading &&
                    !loadMoreData &&
                    allowjobsByNeighboursDataFetch
                ? true
                : false,
            isJobsByYouDataLoading:
                !disableLoading && !loadMoreData && allowjobsByYouDataFetch
                    ? true
                    : false,
          ),
        );

        //If any of the data fetch permission is true then fetch the data.
        if (allowjobsByNeighboursDataFetch || allowjobsByYouDataFetch) {
          final jobsListModelByType = await _fetchJobsByType(
            jobsListType: jobsListType,
            loadMoreData: loadMoreData,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
          _emitDataByType(
            jobsListType: jobsListType,
            jobsListModel: jobsListModelByType,
          );
        }
        return;
      } else {
        //If the jobsListType type is null then fetch only own posted the Job post data
        if (!disableLoading && state.jobsDataModel.isEmpty) {
          emit(state.copyWith(
            isJobsByNeighboursDataLoading: true,
            isJobsByYouDataLoading: true,
          ));
        }

        final results = await Future.wait([
          _fetchJobsByType(
            jobsListType: JobsListType.byNeighbours,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          ),
          _fetchJobsByType(
            jobsListType: JobsListType.byYou,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          ),
        ]);

        final jobsByNeighbours = results[0];
        final jobsByYou = results[1];

        //Assign the data in a variable
        final jobsDataModel = JobsDataModel(
          jobsByNeighbours: jobsByNeighbours,
          jobsByYou: jobsByYou,
        );
        emit(state.copyWith(jobsDataModel: jobsDataModel));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.jobsDataModel.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  void _emitDataByType({
    required JobsListType jobsListType,
    required JobsListModel jobsListModel,
  }) {
    if (jobsListType == JobsListType.byNeighbours) {
      //emit the updated groupsYouJoined data in the state.
      emit(state.copyWith(
          jobsDataModel:
              state.jobsDataModel.copyWith(jobsByNeighbours: jobsListModel)));
    } else {
      //emit the updated managedByYou data in the state.
      emit(state.copyWith(
          jobsDataModel:
              state.jobsDataModel.copyWith(jobsByYou: jobsListModel)));
    }
  }

  ///This method is used to remove the job post and quick update the ui, when the user delete the post
  Future<void> removeJob(int index) async {
    try {
      if (state.jobsDataModel.jobsByYou.data.isNotEmpty) {
        emit(state.copyWith(isJobsByYouDataLoading: true));
        state.jobsDataModel.jobsByYou.data.removeAt(index);
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
