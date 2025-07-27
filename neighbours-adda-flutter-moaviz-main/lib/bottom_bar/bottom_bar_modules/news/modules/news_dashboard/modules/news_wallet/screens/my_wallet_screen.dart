import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/logic/news_wallet_transactions/news_wallet_transactions_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/models/news_wallet_transactions_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/repository/news_earnings_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/widgets/earnings_details_widget.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  static const String routeName = 'my-wallet';

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  late NewsWalletTransactionsCubit newsWalletTransactionsCubit =
      NewsWalletTransactionsCubit(NewsEarningsRepository());

  @override
  void initState() {
    super.initState();
    newsWalletTransactionsCubit.fetchNewsWalletTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: newsWalletTransactionsCubit,
      child: Scaffold(
        appBar: ThemeAppBar(
          title: Text(
            tr(LocaleKeys.myWallet),
            style: TextStyle(color: ApplicationColours.themeBlueColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // Congratulations svg
              SvgPicture.asset(
                SVGAssetsImages.congratulations,
                height: 100,
              ),

              // On your Eanings, {{username}}
              BlocBuilder<ManageProfileDetailsBloc, ManageProfileDetailsState>(
                builder: (context, profileState) {
                  if (profileState.dataLoading ||
                      profileState.isProfileDetailsAvailable) {
                    final userName = profileState.profileDetailsModel!.name;
                    return Text(
                      "${tr(LocaleKeys.onYourEanings)}, $userName",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              // Total news earnings / Available News Earnings
              // Available for Withdrawal with Transfer Out
              // Max transfer out amount
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: EarningsDetailsWidget(),
              ),

              // Transaction History
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transactions title
                    Text(
                      tr(LocaleKeys.transactions),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: BlocBuilder<NewsWalletTransactionsCubit,
                          NewsWalletTransactionsState>(
                        builder: (context, newsWalletTransactionsState) {
                          if (newsWalletTransactionsState.error != null) {
                            return ErrorTextWidget(
                                error: newsWalletTransactionsState.error!);
                          } else if (newsWalletTransactionsState.dataLoading) {
                            return const ThemeSpinner();
                          } else {
                            final logs = newsWalletTransactionsState
                                .newsWalletTransactions.data;
                            if (logs.isEmpty) {
                              return Center(
                                child: Text(
                                  tr(LocaleKeys.noTransactions),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListView.builder(
                                  itemCount: newsWalletTransactionsState
                                          .newsWalletTransactions.data.length +
                                      1,
                                  itemBuilder: (context, index) {
                                    if (index < logs.length) {
                                      final newsWalletTransaction = logs[index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: NewsTransactionDetailsWidget(
                                              newsWalletTransaction:
                                                  newsWalletTransaction,
                                            ),
                                          ),
                                          //If the index is not the last item, show a divider

                                          Visibility(
                                            visible: index !=
                                                newsWalletTransactionsState
                                                        .newsWalletTransactions
                                                        .data
                                                        .length -
                                                    1,
                                            child: const Divider(),
                                          ),
                                        ],
                                      );
                                    } else {
                                      if (newsWalletTransactionsState
                                          .newsWalletTransactions
                                          .paginationModel
                                          .isLastPage) {
                                        return const SizedBox.shrink();
                                      } else {
                                        return VisibilityDetector(
                                          key: const Key(
                                              'newsWalletTransactionSpinner'),
                                          onVisibilityChanged:
                                              (visibilityInfo) {
                                            // Load more data when 20% of the spinner is visible
                                            if (visibilityInfo
                                                    .visibleFraction >=
                                                0.2) {
                                              // Load more data
                                              newsWalletTransactionsCubit
                                                  .fetchNewsWalletTransactions(
                                                      loadMoreData: true);
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            child: ThemeSpinner(size: 30),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewsTransactionDetailsWidget extends StatelessWidget {
  final NewsWalletTransactionsModel newsWalletTransaction;
  const NewsTransactionDetailsWidget({
    super.key,
    required this.newsWalletTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Payment Info
            Text(
              newsWalletTransaction.paymentInfo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            // Transaction Date
            Text(
              FormatDate.formatDateTimeWithTimeOfDay(
                  newsWalletTransaction.timestamp),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Price with rupee symbol
            Text(
              "₹ ${newsWalletTransaction.amount.formatPrice()}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ApplicationColours.themeLightPinkColor,
              ),
            ),
            const SizedBox(height: 5),
            //Transaction Status
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: newsWalletTransaction.transactionStatus.backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                newsWalletTransaction.transactionStatus.name.toUpperCase(),
                style: TextStyle(
                  color:
                      newsWalletTransaction.transactionStatus.foregroundColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
