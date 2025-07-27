import 'package:flutter_bloc/flutter_bloc.dart';

class SearchStateCubit extends Cubit<bool> {
  SearchStateCubit() : super(false);

  void updateSearchState(bool hasText) {
    print('SearchStateCubit: Updating state to $hasText');
    emit(hasText);
  }

  void clearSearch() {
    print('SearchStateCubit: Clearing search state');
    emit(false);
  }
} 