import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_group_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_groups_response_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

part 'home_local_groups_state.dart';

class HomeLocalGroupsCubit extends Cubit<HomeLocalGroupsState> with HydratedMixin {
  final HomeDataRepository homeDataRepository;
  HomeLocalGroupsCubit(
    this.homeDataRepository,
  ) : super(
          const HomeLocalGroupsState(
            dataLoading: true,
            localGroups: [],
          ),
        );

  Future<void> fetchHomeLocalGroups() async {
    try {
      if (state.localGroups.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      final localGroupsResponse = await homeDataRepository.fetchHomeLocalGroups();
      
      // Convert the response data to List<LocalGroupModel>
      final List<LocalGroupModel> groups = localGroupsResponse.data;

      emit(state.copyWith(
        localGroups: groups,
        dataLoading: false,
      ));
      return;
    } catch (e) {
      print(e.toString());
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.localGroups.isEmpty) {
        emit(state.copyWith(
          error: e.toString(),
          dataLoading: false,
        ));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  @override
  HomeLocalGroupsState? fromJson(Map<String, dynamic> json) {
    return HomeLocalGroupsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeLocalGroupsState state) {
    return state.toMap();
  }
} 