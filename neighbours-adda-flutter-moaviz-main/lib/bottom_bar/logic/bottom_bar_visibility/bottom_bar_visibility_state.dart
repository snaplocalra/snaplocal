// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bottom_bar_visibility_cubit.dart';

class BottomBarVisibilityState extends Equatable {
  final bool visible;
  const BottomBarVisibilityState({
    this.visible = true,
  });

  @override
  List<Object> get props => [visible];

  BottomBarVisibilityState copyWith({
    bool? visible,
  }) {
    return BottomBarVisibilityState(visible: visible ?? true);
  }
}
