// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bottom_bar_navigator_cubit.dart';

class BottomBarNavigatorState extends Equatable {
  final bool isLoading;
  final int currentSelectedScreenIndex;
  const BottomBarNavigatorState({
    this.isLoading = false,
    required this.currentSelectedScreenIndex,
  });

  @override
  List<Object> get props => [currentSelectedScreenIndex, isLoading];

  BottomBarNavigatorState copyWith({
    int? currentSelectedScreenIndex,
    bool? isLoading,
  }) {
    return BottomBarNavigatorState(
      isLoading: isLoading ?? false,
      currentSelectedScreenIndex:
          currentSelectedScreenIndex ?? this.currentSelectedScreenIndex,
    );
  }
}
