import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/logic/news_earnings/news_earnings_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/screens/my_wallet_screen.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsEarnings extends StatelessWidget {
  final String channelId;

  const NewsEarnings({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsEarningsCubit, NewsEarningsState>(
      builder: (context, newsEarningsState) {
        if (newsEarningsState is NewsEarningsLoaded) {
          final newsEarnings =
              newsEarningsState.newsEarningsDetailsModel.newsEarnings;
          final maxTransferPoints =
              newsEarningsState.newsEarningsDetailsModel.maxTransferAmount;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    //news earnings
                    Text(
                      tr(LocaleKeys.newsEarnings),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: ApplicationColours.themeBlueColor,
                      ),
                    ),

                    Row(
                      children: [
                        //Coin svg
                        SvgPicture.asset(
                          SVGAssetsImages.coins,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 5),
                        //Price
                        Text(
                          "Rs ${newsEarnings.formatPrice()}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: ApplicationColours.themeLightPinkColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                //Reedeem button
                Column(
                  children: [
                    ThemeElevatedButton(
                      width: 150,
                      height: 40,
                      buttonName: tr(LocaleKeys.myWallet),
                      disableButton: newsEarnings <= maxTransferPoints,
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          MyWalletScreen.routeName,
                          queryParameters: {'id': channelId},
                        );
                      },
                      textFontSize: 12,
                      padding: EdgeInsets.zero,
                      backgroundColor: ApplicationColours.themeBlueColor,
                    ),
                    const SizedBox(height: 5),
                    //maximum transfer points
                    Text(
                      "${tr(LocaleKeys.minimumTransferAmount)} ₹${maxTransferPoints.formatNumber()}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
