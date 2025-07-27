import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/manage_poll_option/manage_poll_option_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_option_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/widget/option_text_field.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ManagePollOptionWidget extends StatelessWidget {
  final bool enableOption;
  final Function(ManagePollOptionList updatedListModel) onListModelUpdated;
  const ManagePollOptionWidget({
    super.key,
    required this.onListModelUpdated,
    this.enableOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagePollOptionCubit, ManagePollOptionState>(
      builder: (context, state) {
        final logs = state.managePollOptionList.data;
        onListModelUpdated.call(state.managePollOptionList);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetHeading(title: tr(LocaleKeys.options)),

                //Add more button
                Visibility(
                  visible: enableOption &&
                      !context
                          .read<ManagePollOptionCubit>()
                          .isMaximumLimitReached,
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<ManagePollOptionCubit>().addOption();
                    },
                    child: Text(
                      logs.isEmpty
                          ? "+ ${tr(LocaleKeys.add)}".toUpperCase()
                          : "+ ${tr(LocaleKeys.addMore)}".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: ApplicationColours.themePinkColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            state.dataLoading
                ? const ThemeSpinner(size: 25)
                : BlocBuilder<PollTypeSelectorCubit, PollTypeSelectorState>(
                    builder: (context, pollTypeSelectorState) {
                      final isPhotoMode = pollTypeSelectorState.selectedType ==
                          PollTypeEnum.photo;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final optionDetails = logs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OptionTextField(
                                    key: Key(optionDetails.optionName),
                                    enableOption: enableOption,
                                    isPhotoMode: isPhotoMode,
                                    text: optionDetails.optionName,
                                    hint: "Option ${index + 1}",
                                    onChanged: (value) {
                                      context
                                          .read<ManagePollOptionCubit>()
                                          .addTextInOption(value, index);
                                    },
                                    onImagePicked: (image) {
                                      context
                                          .read<ManagePollOptionCubit>()
                                          .addRemoveImageInOption(image, index);
                                    },
                                    image: optionDetails.optionImage,
                                    fileImage: optionDetails.fileImage,
                                  ),
                                ),
                                const SizedBox(width: 5),

                                //Don't show the remove option for the 1st 2 element,
                                //because for a poll minimum 2 element
                                Visibility(
                                  visible: enableOption &&
                                      //if the options are equal or more than 3
                                      logs.length >= 3,
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<ManagePollOptionCubit>()
                                        .removeOption(index),
                                    child: Icon(
                                      Icons.cancel,
                                      color: ApplicationColours.themeBlueColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 15),
            //   child: Align(
            //     alignment:
            //         logs.isEmpty ? Alignment.centerLeft : Alignment.centerRight,
            //     child: ThemeElevatedButton(
            //       onPressed: () {
            //         context.read<ManagePollOptionCubit>().addOption();
            //       },
            //       buttonName: logs.isEmpty
            //           ? tr(LocaleKeys.add)
            //           : tr(LocaleKeys.addMore),
            //       backgroundColor: ApplicationColours.themeBlueColor,
            //       width: mqSize.width * 0.25,
            //       height: mqSize.height * 0.04,
            //       padding: EdgeInsets.zero,
            //       textFontSize: 12,
            //     ),
            //   ),
            // )
          ],
        );
      },
    );
  }
}
