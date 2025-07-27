// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'show_category_selection_cubit.dart';

class ShowCategorySelectionState extends Equatable {
  final bool visible;
  const ShowCategorySelectionState({this.visible = false});

  @override
  List<Object> get props => [visible];

  ShowCategorySelectionState copyWith({
    bool? visible,
  }) {
    return ShowCategorySelectionState(visible: visible ?? false);
  }
}
