import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';

part 'page_home_data_state.dart';

class PageHomeDataCubit extends Cubit<PageHomeDataState> {
  final PageListRepository pageRepository;
  PageHomeDataCubit(this.pageRepository) : super(PageHomeDataInitial());

  void fetchGroupHomeData(SearchFilterTypeEnum searchFilterType) async {
    try {
      emit(PageHomeDataLoading());
      final data = await pageRepository.fetchPageHomeData(
          searchFilterType: searchFilterType);
      emit(PageHomeDataLoaded(data));
    } catch (e) {
      emit(const PageHomeDataError('Error fetching pages'));
    }
  }
}
