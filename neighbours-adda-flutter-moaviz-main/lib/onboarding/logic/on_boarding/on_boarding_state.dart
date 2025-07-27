part of 'on_boarding_cubit.dart';

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

class LoadingOnBoardingDetails extends OnBoardingState {}

class OnBoardingDetailsFetched extends OnBoardingState {
  final List<OnboardingModel> onBoardingScreens;
  const OnBoardingDetailsFetched({required this.onBoardingScreens});
  @override
  List<Object> get props => [onBoardingScreens];
}

class OnBoardingError extends OnBoardingState {
  final String error;

  const OnBoardingError({required this.error});

  @override
  List<Object> get props => [error];
}
