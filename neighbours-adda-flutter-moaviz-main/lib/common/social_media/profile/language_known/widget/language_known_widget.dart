import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_cubit.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_state.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_multiselect_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class LanguageKnownWidget extends StatelessWidget {
  final void Function(List<LanguageKnownModel> selectedLanguages)
      onLanguageSelected;
  const LanguageKnownWidget({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageKnownCubit, LanguageKnownState>(
      builder: (context, languageKnownState) {
        final logs = languageKnownState.languageList.languages;
        final List<LanguageKnownModel> selectedLanguages = [];
        for (var language in logs) {
          if (language.isSelected) {
            selectedLanguages.add(language);
          }
        }

        onLanguageSelected.call(selectedLanguages);

        final enableSelection = selectedLanguages.length < 2;

        return TextFieldWithMultiSelectWidget(
          controller: TextEditingController(),
          showOptional: true,
          heading: tr(LocaleKeys.languagesKnown),
          enabled: enableSelection,
          hint: selectedLanguages.length == 2
              ? "You can only select up to 2 languages"
              : tr(LocaleKeys.searchForLanguage),
          suggestionsCallback: (query) async {
            return context
                .read<LanguageKnownCubit>()
                .searchLanguagesByQuery(query);
          },
          itemBuilder: (context, snapshot) {
            return enableSelection
                ? ListTile(
                    title: Text(
                      snapshot!.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                : const SizedBox.shrink();
          },
          onSuggestionSelected: (selecteditem) {
            context
                .read<LanguageKnownCubit>()
                .selectLanguageById([selecteditem!.id]);
          },
          selectedItems: selectedLanguages,
          noItemFoundText: 'No language found',
          gridItemBuilder: (context, index) {
            return Chip(
              label: Text(
                selectedLanguages[index].name,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: ApplicationColours.themeLightPinkColor,
              onDeleted: () {
                context
                    .read<LanguageKnownCubit>()
                    .removeLanguageById(selectedLanguages[index].id);
              },
              deleteIcon: const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}
