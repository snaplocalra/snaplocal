part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  const ResetPasswordState({
    this.requestLoading = false,
    this.requestSuccess = false,
  });

  @override
  List<Object> get props => [requestLoading, requestSuccess];

  ResetPasswordState copyWith({bool? requestLoading, bool? requestSuccess}) {
    return ResetPasswordState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
    );
  }
}
