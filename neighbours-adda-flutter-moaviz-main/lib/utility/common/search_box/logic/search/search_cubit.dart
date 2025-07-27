import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void setSearchQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void clearSearchQuery() {
    emit(state.copyWith());
  }
}
