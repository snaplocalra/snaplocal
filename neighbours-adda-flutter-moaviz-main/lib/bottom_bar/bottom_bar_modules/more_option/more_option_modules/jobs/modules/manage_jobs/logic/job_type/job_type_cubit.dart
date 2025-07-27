import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';

part 'job_type_state.dart';

class JobTypeCubit extends Cubit<JobTypeState> {
  JobTypeCubit()
      : super(
          JobTypeState(jobTypeOptions: [
            JobTypeOption(jobType: JobType.freelance),
            JobTypeOption(jobType: JobType.fullTime),
            JobTypeOption(jobType: JobType.contract),
          ]),
        );

  void selectJobType(JobType jobType) {
    final List<JobTypeOption> jobTypeOptions = state.jobTypeOptions
        .map((e) => e.jobType == jobType
            ? e.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();
    emit(JobTypeState(jobTypeOptions: jobTypeOptions));
  }
}
