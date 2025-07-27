import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/widgets/quiz_banner_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/quiz_banners/quiz_banners_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_banner_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/logic/winners/winners_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/widgets/winners_short_details_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class WinnersWidget extends StatefulWidget {
  const WinnersWidget({super.key});

  @override
  State<WinnersWidget> createState() => _WinnersWidgetState();
}

class _WinnersWidgetState extends State<WinnersWidget>
    with AutomaticKeepAliveClientMixin {
  final winnerScrollController = ScrollController();
  late QuizBannersCubit quizBannersCubit;
  late WinnersCubit winnersCubit;

  @override
  void initState() {
    super.initState();
    final hallOfFameRepository = HallOfFameRepository();
    quizBannersCubit = QuizBannersCubit(hallOfFameRepository);
    //fetch winners banner
    quizBannersCubit.fetchQuizBanners(QuizBannerType.winners);

    winnersCubit = WinnersCubit(hallOfFameRepository);
    winnersCubit.fetchWinners();

    winnerScrollController.addListener(() {
      if (winnerScrollController.position.maxScrollExtent ==
          winnerScrollController.offset) {
        winnersCubit.fetchWinners(loadMoreData: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    winnerScrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: quizBannersCubit),
        BlocProvider.value(value: winnersCubit),
      ],
      child: Column(children: [
        //Winner banner
        BlocBuilder<QuizBannersCubit, QuizBannersState>(
          builder: (context, quizBannersState) {
            if (quizBannersState.bannerImage != null) {
              final bannerImage = quizBannersState.bannerImage!;
              return QuizBannerWidget(bannerImage: bannerImage);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),

        Expanded(
          child: BlocConsumer<WinnersCubit, WinnersState>(
            listener: (context, winnersState) {},
            builder: (context, winnersState) {
              if (winnersState.error != null) {
                return ErrorTextWidget(error: winnersState.error!);
              } else if (winnersState.dataLoading) {
                return const ThemeSpinner(size: 35);
              } else {
                final winnersDataModel = winnersState.winnersListModel;
                final logs = winnersDataModel.data;

                //Winners data
                if (logs.isEmpty) {
                  return const ErrorTextWidget(error: "No winners found");
                } else {
                  return ListView.builder(
                    controller: winnerScrollController,
                    itemCount: logs.length + 1,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemBuilder: (context, index) {
                      if (index < logs.length) {
                        final winnerDetails = logs[index];
                        return WinnersShortDetailsWidget(
                            winnerDetailsModel: winnerDetails);
                      } else {
                        if (winnersDataModel.paginationModel.isLastPage) {
                          return const SizedBox.shrink();
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: ThemeSpinner(size: 30),
                          );
                        }
                      }
                    },
                  );
                }
              }
            },
          ),
        ),
      ]),
    );
  }
}
