import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/widgets/quiz_banner_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_topics/interested_topics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/quiz_banners/quiz_banners_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/quiz_controller/quiz_controller_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/start_quiz_controller/start_quiz_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_banner_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/screen/interested_topics_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/widgets/quiz_widgets/quiz_list_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ContestsWidget extends StatefulWidget {
  final void Function() onWinnerBannerTap;
  const ContestsWidget({
    super.key,
    required this.onWinnerBannerTap,
  });

  @override
  State<ContestsWidget> createState() => _ContestsWidgetState();
}

class _ContestsWidgetState extends State<ContestsWidget>
    with AutomaticKeepAliveClientMixin {
  late QuizBannersCubit quizBannersCubit;
  late StartQuizControllerCubit startQuizControllerCubit;

  // //Initialize Interested Language Cubit
  // final interestedLanguagesCubit = InterestedLanguagesCubit();

  late QuizControllerBloc quizControllerBloc;
  late InterestedTopicsCategoryCubit interestedTopicsCategoryCubit;

  @override
  void initState() {
    super.initState();
    final hallOfFameRepository = HallOfFameRepository();

    quizBannersCubit = QuizBannersCubit(hallOfFameRepository);
    quizBannersCubit.fetchQuizBanners(QuizBannerType.contests);

    quizControllerBloc = QuizControllerBloc(hallOfFameRepository);
    //Fetch initial quiz data
    quizControllerBloc.add(FetchQuizData());

    //Initialize Interested Topics Category Cubit
    interestedTopicsCategoryCubit =
        InterestedTopicsCategoryCubit(hallOfFameRepository);

    //initialize the start quiz controller
    startQuizControllerCubit = StartQuizControllerCubit(
      interestedTopicsCategoryCubit: interestedTopicsCategoryCubit,
      // interestedLanguagesCubit: interestedLanguagesCubit,
      quizControllerBloc: quizControllerBloc,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mqSize = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: quizBannersCubit),
        BlocProvider.value(value: quizControllerBloc),
        BlocProvider.value(value: interestedTopicsCategoryCubit),
        // BlocProvider.value(value: interestedLanguagesCubit),
        BlocProvider.value(value: startQuizControllerCubit),
      ],
      child: ListView(children: [
        //Winner banner
        BlocBuilder<QuizBannersCubit, QuizBannersState>(
          builder: (context, quizBannersState) {
            if (quizBannersState.bannerImage != null) {
              final bannerImage = quizBannersState.bannerImage!;
              return GestureDetector(
                onTap: widget.onWinnerBannerTap,
                child: QuizBannerWidget(bannerImage: bannerImage),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        BlocConsumer<QuizControllerBloc, QuizControllerState>(
          listener: (context, quizControllerState) {
            if (quizControllerState.requestSuccess) {
              context.read<QuizControllerBloc>().add(FetchQuizData());
              return;
            } else if (quizControllerState.quizDataModelAvailable &&
                quizControllerState.quizDataModel!.quizData == null) {
              //Fetch interestes topics
              context
                  .read<InterestedTopicsCategoryCubit>()
                  .fetchInterestedTopics();
              return;
            }
          },
          builder: (context, quizControllerState) {
            if (quizControllerState.error != null) {
              return ErrorTextWidget(error: quizControllerState.error!);
            } else if (quizControllerState.dataLoading ||
                quizControllerState.quizDataModel == null) {
              return const ThemeSpinner(size: 35);
            } else {
              final quizDataModel = quizControllerState.quizDataModel!;
              return quizDataModel.quizStatusMessage != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 150, 10, 0),
                      child: Center(
                          child: Text(
                        quizDataModel.quizStatusMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    )
                  :
                  //Quiz data
                  quizDataModel.quizData != null
                      ? Column(
                          children: [
                            //Quiz lists
                            QuizListWidget(quizData: quizDataModel.quizData!),
                            //Submit button
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10),
                              child: ThemeElevatedButton(
                                showLoadingSpinner:
                                    quizControllerState.requestLoading,
                                buttonName: tr(LocaleKeys.submit),
                                onPressed: () {
                                  context
                                      .read<QuizControllerBloc>()
                                      .add(SubmitQuiz());
                                },
                              ),
                            ),
                          ],
                        )
                      :
                      //Start new quiz
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                tr(LocaleKeys.selectYourInterestsBelowText),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        // Expanded(
                                        //   child: ThemeElevatedButton(
                                        //     buttonName: tr(
                                        //         LocaleKeys.interestedLanguage),
                                        //     disableButton:
                                        //         quizControllerState.dataLoading,
                                        //     textFontSize: 12,
                                        //     padding: EdgeInsets.zero,
                                        //     backgroundColor: ApplicationColours
                                        //         .themeBlueColor,
                                        //     height: mqSize.height * 0.05,
                                        //     onPressed: () {
                                        //       GoRouter.of(context).pushNamed(
                                        //         InterestedLanguageScreen
                                        //             .routeName,
                                        //         extra: context.read<
                                        //             InterestedLanguagesCubit>(),
                                        //       );
                                        //     },
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 10),
                                        Expanded(
                                          child: ThemeElevatedButton(
                                            disableButton:
                                                quizControllerState.dataLoading,
                                            buttonName:
                                                tr(LocaleKeys.interestedTopics),
                                            textFontSize: 12,
                                            padding: EdgeInsets.zero,
                                            backgroundColor: ApplicationColours
                                                .themeBlueColor,
                                            height: mqSize.height * 0.05,
                                            onPressed: () {
                                              GoRouter.of(context).pushNamed(
                                                InterestedTopicsScreen
                                                    .routeName,
                                                extra: context.read<
                                                    InterestedTopicsCategoryCubit>(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ThemeElevatedButton(
                                      showLoadingSpinner:
                                          quizControllerState.requestLoading,
                                      buttonName: tr(LocaleKeys.startQuiz),
                                      textFontSize: 12,
                                      padding: EdgeInsets.zero,
                                      backgroundColor:
                                          ApplicationColours.themeBlueColor,
                                      height: mqSize.height * 0.05,
                                      onPressed: () {
                                        context
                                            .read<StartQuizControllerCubit>()
                                            .startQuiz();
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
            }
          },
        ),
      ]),
    );
  }
}
