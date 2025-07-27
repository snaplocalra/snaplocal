import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_topics/interested_topics_cubit.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/widgets/tab_type_description.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class InterestedTopicsScreen extends StatelessWidget {
  final InterestedTopicsCategoryCubit interestedTopicsCategoryCubit;

  const InterestedTopicsScreen({
    super.key,
    required this.interestedTopicsCategoryCubit,
  });

  static const routeName = 'interested_topics';
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: interestedTopicsCategoryCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ThemeAppBar(
          backgroundColor: Colors.white,
          title: Text(
            tr(LocaleKeys.chooseInterests),
            style: TextStyle(color: ApplicationColours.themeBlueColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<InterestedTopicsCategoryCubit,
                    InterestedTopicsCategoryState>(
                  builder: (context, interestedTopicsCategoryState) {
                    if (interestedTopicsCategoryState.error != null) {
                      return ErrorTextWidget(
                        error: interestedTopicsCategoryState.error!,
                      );
                    } else if (interestedTopicsCategoryState.dataLoading) {
                      return const ThemeSpinner();
                    } else {
                      final logs = interestedTopicsCategoryState
                          .interestedTopicListModel.data;
                      return (logs.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  tr(LocaleKeys.noTopicsFound),
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
                                  description:
                                      LocaleKeys.chooseInterestsDescription,
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 6,
                                      mainAxisSpacing: 4,
                                      childAspectRatio: 2.5,
                                    ),
                                    itemCount: logs.length,
                                    itemBuilder: (context, index) {
                                      final interestedTopic = logs[index];
                                      return CategoryChips(
                                        text: interestedTopic.name,
                                        expandText: true,
                                        imageUrl: interestedTopic.imageUrl,
                                        isSelected: interestedTopic.isSelected,
                                        onTap: () {
                                          context
                                              .read<
                                                  InterestedTopicsCategoryCubit>()
                                              .selectInterestedTopic(
                                                  interestedTopic.id);
                                        },
                                        enableborder: true,
                                        fontSize: 12,
                                        imageHeight: 20,
                                      );
                                    },
                                  ),
                                ),
                                ThemeElevatedButton(
                                  buttonName: tr(LocaleKeys.close),
                                  onPressed: () {
                                    GoRouter.of(context).pop();
                                  },
                                ),
                              ],
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
