import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/screen/manage_bank_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/logic/news_earnings/news_earnings_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class EarningsDetailsWidget extends StatelessWidget {
  const EarningsDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return BlocBuilder<NewsEarningsCubit, NewsEarningsState>(
        builder: (context, newsEarningsState) {
      if (newsEarningsState is NewsEarningsLoaded) {
        final newsEarningsModel = newsEarningsState.newsEarningsDetailsModel;
        final newsEarnings = newsEarningsModel.newsEarnings;
        final maxTransferAmount = newsEarningsModel.maxTransferAmount;
        final totalNewsEarnings = newsEarningsModel.totalNewsEarnings;
        return Column(
          children: [
            // Total news earnings / Available News Earnings
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EarningsDataWidget(
                      heading: tr(LocaleKeys.totalNewsEarnings),
                      amount: totalNewsEarnings,
                    ),
                    //Vertical Divider
                    const VerticalDivider(thickness: 1),
                    EarningsDataWidget(
                      heading: tr(LocaleKeys.availableNewsEarnings),
                      amount: newsEarnings,
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<OwnNewsChannelCubit, OwnNewsChannelState>(
              builder: (context, ownNewsChannelState) {
                if (ownNewsChannelState is OwnNewsChannelLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        //Available for Withdrawal with Transfer Out
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            color: ApplicationColours.themePinkColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              EarningsDataWidget(
                                heading: tr(LocaleKeys.availableForWithdrawal),
                                amount: totalNewsEarnings,
                                foregroundColor: Colors.white,
                              ),
                              //Transfer Out Button
                              if (ownNewsChannelState.ownNewsChannel != null)
                                ThemeElevatedButton(
                                  width: 150,
                                  height: 40,
                                  buttonName: "${tr(LocaleKeys.transferOut)} >",
                                  disableButton:
                                      newsEarnings <= maxTransferAmount,
                                  onPressed: () {
                                    //if the news earnings is lesser than max transfer points
                                    //then return with a message
                                    if (newsEarnings <= maxTransferAmount) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "You can't transfer less than $maxTransferAmount",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    GoRouter.of(context).pushNamed(
                                      ManageBankDetailsScreen.routeName,
                                      queryParameters: {
                                        'id': ownNewsChannelState
                                            .ownNewsChannel!.id
                                      },
                                    );

                                    //Open a bottom sheet to show the bank list, and a button to add a new bank
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   constraints: BoxConstraints(
                                    //     maxHeight: size.height * 0.8,
                                    //   ),
                                    //   backgroundColor: Colors.grey.shade100,
                                    //   builder: (context) {
                                    //     return BankListBottomSheet(
                                    //       transferAmount: newsEarnings,
                                    //     );
                                    //   },
                                    // );
                                  },
                                  textFontSize: 12,
                                  padding: EdgeInsets.zero,
                                  foregroundColor:
                                      ApplicationColours.themeBlueColor,
                                  backgroundColor: Colors.white,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        //Maxium Transfer Amount
                        Text(
                          "${tr(LocaleKeys.maximumTransferAmount)} ₹${maxTransferAmount.formatPrice()}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}

class EarningsDataWidget extends StatelessWidget {
  final String heading;
  final num amount;
  final Color? foregroundColor;
  const EarningsDataWidget({
    super.key,
    required this.heading,
    required this.amount,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: foregroundColor,
          ),
        ),
        FittedBox(
          child: Text(
            "₹${amount.formatPrice()}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: foregroundColor ?? ApplicationColours.themeBlueColor,
            ),
          ),
        ),
      ],
    );
  }
}
