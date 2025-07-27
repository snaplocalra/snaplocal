part of 'locale_from_location_cubit.dart';

sealed class LocaleFromLocationState extends Equatable {
  const LocaleFromLocationState();

  @override
  List<Object> get props => [];
}

final class LocaleFromLocationInitial extends LocaleFromLocationState {}

//Loading
final class LoadingLocaleFromLocation extends LocaleFromLocationState {}

//Success
final class LocaleFromLocationLoaded extends LocaleFromLocationState {
  final Locale locale;

  const LocaleFromLocationLoaded({required this.locale});

  @override
  List<Object> get props => [locale];
}

//Error
final class LocaleFromLocationError extends LocaleFromLocationState {
  final String errorMessage;

  const LocaleFromLocationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
