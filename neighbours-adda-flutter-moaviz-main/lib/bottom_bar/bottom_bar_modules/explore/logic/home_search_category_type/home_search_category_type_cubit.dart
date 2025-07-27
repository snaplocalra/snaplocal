import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type_model.dart';

part 'home_search_category_type_state.dart';

class ExploreCategoryTypeCubit extends Cubit<ExploreCategoryTypeState> {
  ExploreCategoryTypeCubit()
      : super(ExploreCategoryTypeState(
            homeSearchTypeListModel: ExploreTypeListModel(data: _data)));

  static final List<ExploreType> _data = [
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.neighbours),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.connections),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.posts),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.business),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.buyAndsell),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.jobs),
    ExploreType(
        homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.safetyAndAlerts),
    ExploreType(
        homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.lostAndFound),
    ExploreType(homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.event),

    // ExploreType(
    //     homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.pages),
    // ExploreType(
    //     homeSearchCategoryTypeEnum: ExploreCategoryTypeEnum.groups),
  ];

  void selectDefaultType() {
    selectType(_data.first);
  }

  void selectType(ExploreType selectedExploreType) {
    if (state.homeSearchTypeListModel.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));

      for (var homeSearchType in state.homeSearchTypeListModel.data) {
        if (homeSearchType == selectedExploreType) {
          homeSearchType.isSelected = true;
        } else {
          homeSearchType.isSelected = false;
        }
      }

      emit(state.copyWith());
    }
  }
}
