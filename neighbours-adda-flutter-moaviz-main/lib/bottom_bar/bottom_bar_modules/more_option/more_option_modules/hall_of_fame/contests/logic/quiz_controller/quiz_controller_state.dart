part of 'quiz_controller_bloc.dart';

class QuizControllerState extends Equatable {
  final QuizDataModel? quizDataModel;
  final String? error;
  final bool dataLoading;
  final bool requestLoading;
  final bool requestSuccess;
  const QuizControllerState({
    this.quizDataModel,
    this.error,
    this.dataLoading = false,
    this.requestLoading = false,
    this.requestSuccess = false,
  });

  bool get quizDataModelAvailable => quizDataModel != null;

  @override
  List<Object?> get props =>
      [quizDataModel, error, dataLoading, requestLoading, requestSuccess];

  QuizControllerState copyWith({
    QuizDataModel? quizDataModel,
    String? error,
    bool? dataLoading,
    bool? requestLoading,
    bool? requestSuccess,
  }) {
    return QuizControllerState(
      quizDataModel: quizDataModel ?? this.quizDataModel,
      error: error,
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
    );
  }
}
