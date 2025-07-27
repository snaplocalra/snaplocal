import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/logic/work_type/work_type_cubit.dart';
import 'package:snap_local/common/utils/widgets/type_selection_option.dart';

class WorkTypeBuilderWidget extends StatelessWidget {
  final WorkType workType;
  final Function(WorkType selectedWorkType) onWorkTypeSelected;
  const WorkTypeBuilderWidget({
    super.key,
    required this.workType,
    required this.onWorkTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkTypeCubit()..selectWorkType(workType),
      child: BlocBuilder<WorkTypeCubit, WorkTypeState>(
        builder: (context, workTypeState) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr(LocaleKeys.workType)),
              const SizedBox(width: 5),
              //Work type options
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: workTypeState.workTypeOptions.length,
                    itemBuilder: (context, index) {
                      final workTypeOption =
                          workTypeState.workTypeOptions[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<WorkTypeCubit>()
                              .selectWorkType(workTypeOption.workType);
                          onWorkTypeSelected.call(workTypeOption.workType);
                        },
                        child: TypeSelectionOption(
                          title: workTypeOption.workType.displayValue,
                          isSelected: workTypeOption.isSelected,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
