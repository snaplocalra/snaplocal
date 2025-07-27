// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'show_search_bar_cubit.dart';

class ShowSearchBarState extends Equatable {
  final bool visible;
  const ShowSearchBarState({this.visible=false});

  @override
  List<Object> get props => [visible];

  ShowSearchBarState copyWith({
    bool? visible
  }) {
    return ShowSearchBarState(
      visible: visible ?? false
    );
  }
}
