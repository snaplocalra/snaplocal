// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'job_type_cubit.dart';

class JobTypeState extends Equatable {
  final List<JobTypeOption> jobTypeOptions;
  const JobTypeState({
    required this.jobTypeOptions,
  });

  @override
  List<Object> get props => [jobTypeOptions];
}

class JobTypeOption {
  final JobType jobType;
  final bool isSelected;
  JobTypeOption({
    required this.jobType,
    this.isSelected = false,
  });

  JobTypeOption copyWith({
    JobType? jobType,
    bool? isSelected,
  }) {
    return JobTypeOption(
      jobType: jobType ?? this.jobType,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
