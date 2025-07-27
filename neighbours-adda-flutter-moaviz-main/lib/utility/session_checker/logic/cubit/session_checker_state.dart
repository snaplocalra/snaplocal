part of 'session_checker_cubit.dart';

class SessionCheckerState extends Equatable {
  final String? error;
  final bool isLoading;
  final bool isSessionValid;
  const SessionCheckerState({
    this.error,
    required this.isLoading,
    required this.isSessionValid,
  });

  @override
  List<Object?> get props => [error, isLoading, isSessionValid];

  SessionCheckerState copyWith({
    String? error,
    bool? isLoading,
    bool? isSessionValid,
  }) {
    return SessionCheckerState(
      error: error,
      isLoading: isLoading ?? false,
      isSessionValid: isSessionValid ?? false,
    );
  }
}
