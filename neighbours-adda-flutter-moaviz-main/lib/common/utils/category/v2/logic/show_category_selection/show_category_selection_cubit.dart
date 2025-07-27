import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_category_selection_state.dart';

class ShowCategorySelectionCubit extends Cubit<ShowCategorySelectionState> {
  ShowCategorySelectionCubit() : super(const ShowCategorySelectionState());

  void toggleShowCategorySelection(bool visible) {
    emit(state.copyWith(visible: visible));
  }
}
