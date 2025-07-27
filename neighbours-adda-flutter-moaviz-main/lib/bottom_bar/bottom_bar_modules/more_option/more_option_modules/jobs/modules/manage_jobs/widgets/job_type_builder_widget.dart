import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/logic/job_type/job_type_cubit.dart';
import 'package:snap_local/common/utils/widgets/type_selection_option.dart';

class JobTypeBuilderWidget extends StatelessWidget {
  final JobType jobType;
  final Function(JobType selectedJobType) onJobTypeSelected;
  const JobTypeBuilderWidget({
    super.key,
    required this.jobType,
    required this.onJobTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobTypeCubit()..selectJobType(jobType),
      child: BlocBuilder<JobTypeCubit, JobTypeState>(
        builder: (context, jobTypeState) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr(LocaleKeys.jobType)),
              const SizedBox(width: 5),
              //Job type options
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: jobTypeState.jobTypeOptions.length,
                    itemBuilder: (context, index) {
                      final jobTypeOption = jobTypeState.jobTypeOptions[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<JobTypeCubit>()
                              .selectJobType(jobTypeOption.jobType);
                          onJobTypeSelected.call(jobTypeOption.jobType);
                        },
                        child: TypeSelectionOption(
                          title: jobTypeOption.jobType.displayValue,
                          isSelected: jobTypeOption.isSelected,
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
