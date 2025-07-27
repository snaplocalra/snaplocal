import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/quiz_controller/quiz_controller_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_model_model.dart';

class QuizOptionBuilder extends StatelessWidget {
  final List<QuizOption> options;
  final int questionIndex;
  final String? userSelectedAnswerId;
  const QuizOptionBuilder({
    super.key,
    required this.options,
    required this.questionIndex,
    required this.userSelectedAnswerId,
  });

  @override
  Widget build(BuildContext context) {
    final quizOptions = options;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: quizOptions.length,
      itemBuilder: (context, index) {
        final quizOption = quizOptions[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () {
              context.read<QuizControllerBloc>().add(
                    SelectQuizAnswer(
                      questionIndex: questionIndex,
                      answerIndex: index,
                    ),
                  );
            },
            child: QuizOptionWidget(
              text: quizOption.optionName,
              userSelectedOption: quizOption.optionId == userSelectedAnswerId,
            ),
          ),
        );
      },
    );
  }
}

class QuizOptionWidget extends StatelessWidget {
  final String text;
  final bool userSelectedOption;
  const QuizOptionWidget({
    super.key,
    required this.text,
    required this.userSelectedOption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: userSelectedOption
            ? const Color.fromRGBO(225, 222, 249, 1)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.2, color: Colors.grey),
      ),
      height: 50,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Color.fromRGBO(33, 23, 165, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
