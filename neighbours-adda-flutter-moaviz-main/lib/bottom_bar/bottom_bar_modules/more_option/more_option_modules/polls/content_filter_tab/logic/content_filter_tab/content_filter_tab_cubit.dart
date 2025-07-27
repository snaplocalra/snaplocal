import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/model/content_filter_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'content_filter_tab_state.dart';

class ContentFilterTabCubit extends Cubit<ContentFilterTabState> {
  final ContentFilterModel contentFilterModel;
  ContentFilterTabCubit(this.contentFilterModel)
      : super(
          ContentFilterTabState(
            viewFilters: contentFilterModel.viewFilters,
          ),
        );

  //select single view filter from the viewFilters based on viewFilter index
  void selectViewFilter(int index) {
    emit(state.copyWith(dataLoading: true));
    ContentFilterTabCategory? selectedViewFilter;
    for (int i = 0; i < state.viewFilters.length; i++) {
      if (i == index) {
        state.viewFilters[i] = state.viewFilters[i].copyWith(isSelected: true);
        selectedViewFilter = state.viewFilters[i];
      } else {
        state.viewFilters[i] = state.viewFilters[i].copyWith(isSelected: false);
      }
    }
    bool showCategoryFilter =
        selectedViewFilter?.viewFilterType == ContentFilterTabType.categories;
    emit(state.copyWith(
      allowFetchData: !showCategoryFilter,
      showCategoryFilter: showCategoryFilter,
    ));
  }
}
