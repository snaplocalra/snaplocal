import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_model_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/widgets/quiz_widgets/quiz_option_widget.dart';

class QuizQuestionWidget extends StatelessWidget {
  final QuizQuestion quizQuestion;
  final int questionIndex;
  const QuizQuestionWidget({
    super.key,
    required this.quizQuestion,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quizQuestion.question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
          QuizOptionBuilder(
            options: quizQuestion.options,
            userSelectedAnswerId: quizQuestion.userSelectedAnswerId,
            questionIndex: questionIndex,
          ),
        ],
      ),
    );
  }
}
