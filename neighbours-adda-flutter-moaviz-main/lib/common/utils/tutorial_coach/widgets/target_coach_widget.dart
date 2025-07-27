import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TargetCoachWidget extends StatelessWidget {
  const TargetCoachWidget({
    super.key,
    required this.tutorialCoachMark,
    required this.title,
    required this.onNext,
    required this.nextText,
  });

  final TutorialCoachMark tutorialCoachMark;
  final String title;
  final String nextText;
  final void Function() onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: ThemeElevatedButton(
              buttonName: nextText,
              width: 70,
              height: 30,
              padding: EdgeInsets.zero,
              textFontSize: 12,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
