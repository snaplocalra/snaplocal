import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/onboarding/model/on_boarding_model.dart';
import 'package:snap_local/utility/localization/google_translate/widget/google_translate_text.dart';

class OnBoardindPageView extends StatelessWidget {
  final OnboardingModel page;
  const OnBoardindPageView({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: CachedNetworkImage(
            imageUrl: page.image,
            height: mqSize.height * 0.45,
            width: double.infinity,
            fit: BoxFit.scaleDown,
          ),
        ),
        SizedBox(height: mqSize.height * 0.03),
        Column(
          children: [
            GoogleTranslateText(
              text: page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color.fromRGBO(0, 25, 104, 1),
                fontSize: 24,
              ),
            ),
            SizedBox(height: mqSize.height * 0.01),
            GoogleTranslateText(
              text: page.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(58, 54, 54, 1),
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: mqSize.height * 0.02),
      ],
    );
  }
}
