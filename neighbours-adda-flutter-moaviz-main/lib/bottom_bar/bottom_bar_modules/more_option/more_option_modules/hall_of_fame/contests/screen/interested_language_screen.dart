import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_languages/interested_languages_cubit.dart';
import 'package:snap_local/common/utils/widgets/tab_type_description.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/widget/language_card_widget.dart';

class InterestedLanguageScreen extends StatelessWidget {
  final InterestedLanguagesCubit interestedLanguagesCubit;
  const InterestedLanguageScreen({
    super.key,
    required this.interestedLanguagesCubit,
  });
  static const routeName = 'interested_language';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: interestedLanguagesCubit,
      child: BlocBuilder<InterestedLanguagesCubit, InterestedLanguagesState>(
          builder: (context, state) {
        final logs = state.interestedLanguagesModel.data;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: ThemeAppBar(
            backgroundColor: Colors.white,
            title: Text(
              tr(LocaleKeys.chooseLanguage),
              style: TextStyle(color: ApplicationColours.themeBlueColor),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              children: [
                Expanded(
                  child: (logs.isEmpty)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              tr(LocaleKeys.noLanguageFound),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            ThemeElevatedButton(
                              buttonName: tr(LocaleKeys.goBack),
                              onPressed: () => GoRouter.of(context).pop(),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const TabTypeDescription(
                              description: LocaleKeys
                                  .chooseInterestedLanguageDescription,
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: logs.length,
                                itemBuilder: (context, index) =>
                                    LanguageCardWidget(
                                  languageModel: logs[index],
                                  onTap: (selectedLanguage) async {
                                    context
                                        .read<InterestedLanguagesCubit>()
                                        .selectSingleLanguage(selectedLanguage);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
