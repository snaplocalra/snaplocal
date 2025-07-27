//Bank List Bottom Sheet
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/logic/bank_list_controller/bank_list_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/model/bank_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/repository/bank_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/screen/manage_bank_details_screen.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class BankListBottomSheet extends StatefulWidget {
  final num transferAmount;
  const BankListBottomSheet({
    super.key,
    required this.transferAmount,
  });

  @override
  State<BankListBottomSheet> createState() => _BankListBottomSheetState();
}

class _BankListBottomSheetState extends State<BankListBottomSheet> {
  late BankListControllerCubit bankListControllerCubit =
      BankListControllerCubit(ManageBankRepository());

  // context
  //     .read<NewsEarningsCubit>()
  //     .fetchNewsEarningsDetails(widget.channelId);

  @override
  void initState() {
    super.initState();
    bankListControllerCubit.fetchBankList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bankListControllerCubit,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TransferOutBottomSheetHeading(),

            //Bank List
            Expanded(
              child:
                  BlocBuilder<BankListControllerCubit, BankListControllerState>(
                builder: (context, bankListControllerState) {
                  if (bankListControllerState.requestLoading) {
                    return const ThemeSpinner();
                  } else if (bankListControllerState.errorMessage != null) {
                    return ErrorTextWidget(
                      error: bankListControllerState.errorMessage!,
                    );
                  } else {
                    return ListView.builder(
                      itemCount: bankListControllerState.banklist.length,
                      itemBuilder: (context, index) {
                        final bankDetails =
                            bankListControllerState.banklist[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              //Set the default bank
                              context
                                  .read<BankListControllerCubit>()
                                  .bankListControllerCubit(index);
                            },
                            child: BankDetailsWidget(bankDetails: bankDetails),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            //Add New Bank Button
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: AddNewBankButton(),
            ),

            //Transfer Out Button
            BlocBuilder<BankListControllerCubit, BankListControllerState>(
              builder: (context, bankListControllerState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ThemeElevatedButton(
                    disableButton:
                        !bankListControllerState.isDefaultBankSelected,
                    buttonName: tr(LocaleKeys.transferNow),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransferOutBottomSheetHeading extends StatelessWidget {
  const TransferOutBottomSheetHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Back Button with Transfer Out text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: ApplicationColours.themeBlueColor,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                tr(LocaleKeys.transferOut),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class BankDetailsWidget extends StatelessWidget {
  const BankDetailsWidget({
    super.key,
    required this.bankDetails,
  });

  final BankDetailsModel bankDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        //Change border color based on default bank
        border: Border.all(
          color: bankDetails.isDefault
              ? ApplicationColours.themePinkColor
              : Colors.black54,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Bank Name
              Text(
                bankDetails.bankName,
                style: TextStyle(
                  color: bankDetails.isDefault
                      ? ApplicationColours.themeBlueColor
                      : Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              //Account Number
              //Replace account number with masked XXXX. Only last 3 digits should be visible
              Text(
                bankDetails.accountNumber.length > 3
                    ? "XXXX XXXX XXXX ${bankDetails.accountNumber.substring(bankDetails.accountNumber.length - 3)}"
                    : bankDetails.accountNumber,
                style: TextStyle(
                  color: bankDetails.isDefault
                      ? ApplicationColours.themeBlueColor
                      : Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          //Circular Check Box
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: bankDetails.isDefault
                  ? ApplicationColours.themePinkColor
                  : Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewBankButton extends StatelessWidget {
  const AddNewBankButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .pushNamed(
          ManageBankDetailsScreen.routeName,
        )
            .then(
          (value) {
            //Fetch the bank list after adding a new bank
            if (value != null && value is bool && value && context.mounted) {
              context.read<BankListControllerCubit>().fetchBankList();
            }
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr(LocaleKeys.addBankDetails),
              style: TextStyle(
                color: ApplicationColours.themeBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: ApplicationColours.themePinkColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
