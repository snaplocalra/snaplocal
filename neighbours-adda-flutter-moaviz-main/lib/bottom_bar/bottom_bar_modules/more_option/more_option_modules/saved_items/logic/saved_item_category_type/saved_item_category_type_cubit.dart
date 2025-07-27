import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_item_type_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';

part 'saved_item_category_type_state.dart';

class SavedItemCategoryTypeCubit extends Cubit<SavedItemCategoryTypeState> {
  SavedItemCategoryTypeCubit()
      : super(SavedItemCategoryTypeState(
            savedItemTypeListModel: SavedItemTypeListModel(data: _data)));

  static final List<SavedItemType> _data = [
    SavedItemType(savedItemType: SavedPostTypeEnum.all),
    SavedItemType(savedItemType: SavedPostTypeEnum.posts),
    SavedItemType(savedItemType: SavedPostTypeEnum.job),
    SavedItemType(savedItemType: SavedPostTypeEnum.market),
  ];

  void selectFirstElement() {
    if (_data.isNotEmpty) {
      selectType(_data.first);
    } else {
      throw ("SavedItemType list is empty");
    }
  }

  void selectType(SavedItemType selectedSavedItemType) {
    if (state.savedItemTypeListModel.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));
      SavedItemType? selectedData;
      for (var savedItemType in state.savedItemTypeListModel.data) {
        if (savedItemType == selectedSavedItemType) {
          savedItemType.isSelected = true;
          selectedData = savedItemType;
        } else {
          savedItemType.isSelected = false;
        }
      }

      emit(state.copyWith(
        savedItemTypeListModel:
            state.savedItemTypeListModel.copyWith(selectedData: selectedData),
      ));
    }
  }
}
