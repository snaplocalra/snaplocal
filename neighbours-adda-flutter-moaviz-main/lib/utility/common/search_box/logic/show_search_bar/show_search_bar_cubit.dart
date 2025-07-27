import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_search_bar_state.dart';

class ShowSearchBarCubit extends Cubit<ShowSearchBarState> {
  ShowSearchBarCubit() : super(const ShowSearchBarState());

  void toggleVisible() {
    emit(state.copyWith(visible: !state.visible));
  }
}
