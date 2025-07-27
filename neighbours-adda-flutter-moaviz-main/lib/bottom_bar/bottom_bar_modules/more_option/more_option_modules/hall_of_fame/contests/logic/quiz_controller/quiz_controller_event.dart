part of 'quiz_controller_bloc.dart';

abstract class QuizControllerEvent extends Equatable {
  const QuizControllerEvent();

  @override
  List<Object> get props => [];
}

class FetchQuizData extends QuizControllerEvent {}

class SubmitQuiz extends QuizControllerEvent {}

class SelectQuizAnswer extends QuizControllerEvent {
  final int questionIndex;
  final int answerIndex;
  const SelectQuizAnswer({
    required this.questionIndex,
    required this.answerIndex,
  });
}

class StartQuiz extends QuizControllerEvent {
  // final List<String> languageId;
  final List<String> topicIdList;
  const StartQuiz({
    // required this.languageId,
    required this.topicIdList,
  });

  @override
  List<Object> get props => [topicIdList];
}
