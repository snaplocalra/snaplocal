import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';

class SavedItemTypeListModel extends Equatable {
  final List<SavedItemType> data;
  final SavedItemType? selectedData;

  const SavedItemTypeListModel({required this.data, this.selectedData});

  @override
  List<Object?> get props => [data, selectedData];

  SavedItemTypeListModel copyWith({
    final List<SavedItemType>? data,
    final SavedItemType? selectedData,
  }) {
    return SavedItemTypeListModel(
      data: data ?? this.data,
      selectedData: selectedData ?? selectedData,
    );
  }
}

class SavedItemType {
  final SavedPostTypeEnum savedItemType;
  bool isSelected;

  SavedItemType({
    required this.savedItemType,
    this.isSelected = false,
  });
}
