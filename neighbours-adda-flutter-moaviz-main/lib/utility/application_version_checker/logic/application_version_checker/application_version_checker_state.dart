// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'application_version_checker_cubit.dart';

abstract class ApplicationVersionCheckerState extends Equatable {
  const ApplicationVersionCheckerState();

  @override
  List<Object> get props => [];
}

class ApplicationVersionCheckingLoading
    extends ApplicationVersionCheckerState {}

class NormalUpdateFound extends ApplicationVersionCheckerState {
  final String applicationDownloadLink;

  const NormalUpdateFound({required this.applicationDownloadLink});
  @override
  List<Object> get props => [applicationDownloadLink];
}

class NoUpdateFound extends ApplicationVersionCheckerState {}

class CriticalUpdateFound extends ApplicationVersionCheckerState {
  final String applicationDownloadLink;

  const CriticalUpdateFound({required this.applicationDownloadLink});
  @override
  List<Object> get props => [applicationDownloadLink];
}

class ApplicationVersionCheckError extends ApplicationVersionCheckerState {
  final String error;

  const ApplicationVersionCheckError({required this.error});

  @override
  List<Object> get props => [error];
}
