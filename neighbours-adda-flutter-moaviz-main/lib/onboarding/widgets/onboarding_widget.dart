import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snap_local/onboarding/model/on_boarding_model.dart';
import 'package:snap_local/onboarding/widgets/onboarding_page_view.dart';

class OnboardingWidget extends StatefulWidget {
  final List<OnboardingModel> onBoardingModel;
  final void Function() skipClicked;
  final void Function() getStartedClicked;

  const OnboardingWidget({
    super.key,
    required this.onBoardingModel,
    required this.skipClicked,
    required this.getStartedClicked,
  });

  @override
  OnboardingWidgetState createState() => OnboardingWidgetState();
}

class OnboardingWidgetState extends State<OnboardingWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.onBoardingModel.length,
                  effect: const ExpandingDotsEffect(
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 2,
                    radius: 10,
                    spacing: 15,
                    dotHeight: 6,
                    dotWidth: 20,
                    dotColor: Colors.grey,
                    activeDotColor: Color.fromRGBO(0, 25, 104, 1),
                  ),
                ),
                GestureDetector(
                  key: Key(tr(LocaleKeys.skip)),
                  onTap: () {
                    widget.skipClicked();
                  },
                  child: Text(
                    tr(LocaleKeys.skip),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(112, 112, 112, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: List.generate(
                widget.onBoardingModel.length,
                (index) => ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: OnBoardindPageView(
                        page: widget.onBoardingModel[index],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ThemeElevatedButton(
                        key: Key(tr(LocaleKeys.next)),
                        borderRadius: 8,
                        buttonName: tr(LocaleKeys.next),
                        textFontSize: 16,
                        onPressed: () {
                          if (_currentPage ==
                              widget.onBoardingModel.length - 1) {
                            widget.getStartedClicked();
                          } else {
                            _pageController.animateToPage(
                              _currentPage + 1,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
