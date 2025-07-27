// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_controller_cubit.dart';

class SplashControllerState extends Equatable {
  final bool loadSplash;
  final bool showSplash;
  final bool isRegularOpen;
  const SplashControllerState({
    this.loadSplash = true,
    this.showSplash = false,
    this.isRegularOpen = false,
  });

  @override
  List<Object> get props => [loadSplash, showSplash, isRegularOpen];

  SplashControllerState copyWith({
    bool? loadSplash,
    bool? showSplash,
    bool? isRegularOpen,
  }) {
    return SplashControllerState(
      loadSplash: loadSplash ?? false,
      showSplash: showSplash ?? false,
      isRegularOpen: isRegularOpen ?? false,
    );
  }
}
