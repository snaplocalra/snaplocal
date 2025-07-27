import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_model_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/widgets/quiz_widgets/quiz_question_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class QuizListWidget extends StatelessWidget {
  final QuizData quizData;

  const QuizListWidget({super.key, required this.quizData});

  @override
  Widget build(BuildContext context) {
    final logs = quizData.data;
    if (logs.isEmpty) {
      return const ErrorTextWidget(error: "No questions found");
    } else {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logs.length,
        itemBuilder: (BuildContext context, index) {
          final quizQuestion = logs[index];
          return QuizQuestionWidget(
            quizQuestion: quizQuestion,
            questionIndex: index,
          );
        },
      );
    }
  }
}
