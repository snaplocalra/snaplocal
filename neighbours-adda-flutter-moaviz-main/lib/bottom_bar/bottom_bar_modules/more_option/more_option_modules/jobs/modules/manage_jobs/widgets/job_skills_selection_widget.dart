// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/logic/job_skills/job_skills_cubit.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_multiselect_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/text_field_input_length.dart';

class JobSkillsSelectionWidget extends StatefulWidget {
  final void Function(List<String> selectedJobSkills) onJobSkillSelected;
  final String label;
  final String heading;
  final bool showStarMark;
  const JobSkillsSelectionWidget({
    super.key,
    required this.label,
    required this.heading,
    this.showStarMark = false,
    required this.onJobSkillSelected,
  });

  @override
  State<JobSkillsSelectionWidget> createState() =>
      _JobSkillsSelectionWidgetState();
}

class _JobSkillsSelectionWidgetState extends State<JobSkillsSelectionWidget> {
  final _jobSkillController = TextEditingController();

  @override
  dispose() {
    _jobSkillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobSkillsCubit, JobSkillsState>(
      builder: (context, jobSkillsState) {
        final selectedJobSkills = jobSkillsState.selectedJobSkills;

        widget.onJobSkillSelected.call(selectedJobSkills);

        final enableSelection = selectedJobSkills.length < 8;

        return TextFieldWithMultiSelectWidget<String>(
          controller: _jobSkillController,
          enabled: !jobSkillsState.dataLoading && enableSelection,
          showStarMark: widget.showStarMark,
          selectedItems: selectedJobSkills,
          heading: tr(widget.heading),
          maxLength: TextFieldInputLength.skillMaxLength,
          hint: jobSkillsState.dataLoading ? "Loading..." : widget.label,
          inputFormatters: [
            //do not allow space in the skill
            FilteringTextInputFormatter.deny(RegExp(r"\s")),
          ],
          suggestionsCallback: (query) async {
            return context.read<JobSkillsCubit>().searchByQuery(query);
          },
          itemBuilder: (context, snapshot) {
            return enableSelection
                ? ListTile(
                    title: Text(
                      snapshot!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                : const SizedBox.shrink();
          },
          onSuggestionSelected: (selecteditem) {
            context
                .read<JobSkillsCubit>()
                .selectJobSkill(jobSkills: [selecteditem!]);
          },
          custonNoItemsFoundBuilder: (suggestionsBoxController, text) {
            return ListTile(
              onTap: () {
                //Close the suggestions box
                suggestionsBoxController?.close();

                if (text.trim().isEmpty) {
                  return;
                }

                //Add the selected item to the list
                context
                    .read<JobSkillsCubit>()
                    .selectJobSkill(jobSkills: [text]);

                //Clear the text field after adding the selected item
                _jobSkillController.clear();
              },
              title: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            );
          },
          gridItemBuilder: (context, index) {
            return Chip(
              label: Text(
                selectedJobSkills[index],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: ApplicationColours.themeLightPinkColor,
              onDeleted: () {
                context.read<JobSkillsCubit>().removeSkillByIndex(index);
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
