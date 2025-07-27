import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/connections/models/profile_connection_list_model.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'profile_connection_state.dart';

class ProfileConnectionsCubit extends Cubit<ProfileConnectionsState> {
  final ProfileConnectionRepository connectionRepository;
  ProfileConnectionsCubit(this.connectionRepository)
      : super(
          ProfileConnectionsState(
              connectionListModel: ProfileConnectionTypeModel(
            myConnections: ProfileConnectionListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
            requestedConnection: ProfileConnectionListModel(
              data: const [],
              paginationModel: PaginationModel.initial(),
            ),
          )),
        );

//Search query data holder
  String _searchQuery = "";

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  void clearSearchQuery() {
    _searchQuery = "";
  }
//

  Future<void> refreshDataModelOnAction(
      {required ProfileConnectionType connectionType}) async {
    if (state.isDataLoadedBySearch) {
      await searchConenctionByType(
        profileConnectionType: connectionType,
        disableLoading: true,
      );

      //Fetch the connections for the opposite connection type from the search connection type,
      //to refresh
      await fetchConnections(
        disableLoading: true,
        profileConnectionType:
            connectionType == ProfileConnectionType.myConnections
                ? ProfileConnectionType.requests
                : ProfileConnectionType.myConnections,
      );
    } else {
      //Fetch both connections data
      await fetchConnections(disableLoading: true);
    }
  }

  Future<void> searchConenctionByType({
    bool loadMoreData = false,
    bool disableLoading = false,
    required ProfileConnectionType profileConnectionType,
  }) async {
    if (_searchQuery.isNotEmpty) {
      emit(state.copyWith(isSearching: !disableLoading && !loadMoreData));
      late ProfileConnectionListModel connectionListModel;
      if (profileConnectionType == ProfileConnectionType.myConnections) {
        connectionListModel = state.connectionListModel.myConnections;
      } else {
        connectionListModel = state.connectionListModel.requestedConnection;
      }
      try {
        if (loadMoreData) {
          //Run the fetch conenction API, if it is not the last page.
          if (!connectionListModel.paginationModel.isLastPage) {
            //Increase the current page counter
            connectionListModel.paginationModel.currentPage += 1;
            final moreData = await connectionRepository.searchConnections(
              query: _searchQuery,
              page: connectionListModel.paginationModel.currentPage,
              profileConnectionType: profileConnectionType,
            );
            _emitDataByType(
              profileConnectionType: profileConnectionType,
              connectionListModel:
                  connectionListModel.paginationCopyWith(newData: moreData),
              isDataLoadedBySearch: true,
            );
          } else {
            emit(state.copyWith());
          }
        } else {
          final newData = await connectionRepository.searchConnections(
            query: _searchQuery,
            page: 1,
            profileConnectionType: profileConnectionType,
          );

          _emitDataByType(
            profileConnectionType: profileConnectionType,
            connectionListModel: newData,
            isDataLoadedBySearch: true,
          );
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
    } else {
      ThemeToast.errorToast("Unable to search");
    }
  }

  Future<ProfileConnectionListModel> _fetchConenctionByType({
    bool loadMoreData = false,
    required ProfileConnectionType profileConnectionType,
  }) async {
    late ProfileConnectionListModel connectionListModel;

    if (profileConnectionType == ProfileConnectionType.myConnections) {
      connectionListModel = state.connectionListModel.myConnections;
    } else {
      connectionListModel = state.connectionListModel.requestedConnection;
    }
    try {
      if (loadMoreData) {
        //Run the fetch conenction API, if it is not the last page.
        if (!connectionListModel.paginationModel.isLastPage) {
          //Increase the current page counter
          connectionListModel.paginationModel.currentPage += 1;
          final moreData = await connectionRepository.fetchConnections(
            page: connectionListModel.paginationModel.currentPage,
            profileConnectionType: profileConnectionType,
          );
          return connectionListModel.paginationCopyWith(newData: moreData);
        } else {
          //Return the previous model, if there is no page
          return connectionListModel;
        }
      } else {
        return await connectionRepository.fetchConnections(
          page: 1,
          profileConnectionType: profileConnectionType,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      //return the existing connection model
      return connectionListModel;
    }
  }

  Future<void> fetchConnections({
    bool loadMoreData = false,
    bool allowDataFetch = true,
    bool disableLoading = false,
    ProfileConnectionType? profileConnectionType,
  }) async {
    try {
      if (allowDataFetch || state.connectionListModel.isEmpty) {
        //If the connection type is not null then fetch the connection data as per the type.
        if (profileConnectionType != null) {
          //Data fetch permission
          final allowMyConnectionDataFetch = (allowDataFetch ||
                  state.connectionListModel.myConnections.data.isEmpty) &&
              (profileConnectionType == ProfileConnectionType.myConnections);

          final allowRequestedConnectionDataFetch = (allowDataFetch ||
                  state.connectionListModel.requestedConnection.data.isEmpty) &&
              (profileConnectionType == ProfileConnectionType.requests);

          emit(
            state.copyWith(
              //If the loadMore is true, then don't emit the loading state
              isMyConenctionDataLoading:
                  !disableLoading && !loadMoreData && allowMyConnectionDataFetch
                      ? true
                      : false,
              isRequestedConnectionDataLoading: !disableLoading &&
                      !loadMoreData &&
                      allowRequestedConnectionDataFetch
                  ? true
                  : false,
            ),
          );

          //If any of the data fetch permission is true then fetch the data.
          if (allowMyConnectionDataFetch || allowRequestedConnectionDataFetch) {
            final connectionDataByType = await _fetchConenctionByType(
              profileConnectionType: profileConnectionType,
              loadMoreData: loadMoreData,
            );
            _emitDataByType(
              profileConnectionType: profileConnectionType,
              connectionListModel: connectionDataByType,
              isDataLoadedBySearch: false,
            );
          }
          return;
        } else {
          //If the connection type is null then fetch both the connection data
          if (!disableLoading && state.connectionListModel.isEmpty) {
            emit(state.copyWith(
              isMyConenctionDataLoading: true,
              isRequestedConnectionDataLoading: true,
            ));
          }

          final myConnections = await _fetchConenctionByType(
              profileConnectionType: ProfileConnectionType.myConnections);

          final requestedConnections = await _fetchConenctionByType(
              profileConnectionType: ProfileConnectionType.requests);

          //Assign the  data in a variable
          final profileConnectionTypeModel = ProfileConnectionTypeModel(
            myConnections: myConnections,
            requestedConnection: requestedConnections,
          );
          emit(
            state.copyWith(
              connectionListModel: profileConnectionTypeModel,
              isDataLoadedBySearch: false,
            ),
          );
        }
        return;
      } else {
        //Emit previous state
        emit(state.copyWith(isDataLoadedBySearch: false));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.connectionListModel.isEmpty) {
        emit(state.copyWith(error: e.toString(), isDataLoadedBySearch: false));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(isDataLoadedBySearch: false));
        return;
      }
    }
  }

  void _emitDataByType({
    bool isDataLoadedBySearch = false,
    required ProfileConnectionType profileConnectionType,
    required ProfileConnectionListModel connectionListModel,
  }) {
    if (profileConnectionType == ProfileConnectionType.myConnections) {
      //emit the updated myConnections data in the state.
      emit(state.copyWith(
        connectionListModel: state.connectionListModel
            .copyWith(myConnections: connectionListModel),
        isDataLoadedBySearch: isDataLoadedBySearch,
      ));
    } else {
      //emit the updated requestedConnection data in the state.
      emit(state.copyWith(
        connectionListModel: state.connectionListModel.copyWith(
          requestedConnection: connectionListModel,
        ),
        isDataLoadedBySearch: isDataLoadedBySearch,
      ));
    }
  }
}
