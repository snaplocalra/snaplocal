part of 'job_skills_cubit.dart';

class JobSkillsState extends Equatable {
  final bool dataLoading;
  final List<String> jobsSkillList;
  final List<String> selectedJobSkills;
  const JobSkillsState({
    this.dataLoading = false,
    required this.jobsSkillList,
    required this.selectedJobSkills,
  });

  @override
  List<Object> get props => [jobsSkillList, dataLoading, selectedJobSkills];

  JobSkillsState copyWith({
    bool? dataLoading,
    List<String>? jobsSkillList,
    List<String>? selectedJobSkills,
  }) {
    return JobSkillsState(
      dataLoading: dataLoading ?? false,
      jobsSkillList: jobsSkillList ?? this.jobsSkillList,
      selectedJobSkills: selectedJobSkills ?? this.selectedJobSkills,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'dataLoading': dataLoading,
  //     'jobsSkillCategoriesListModel': jobsSkillList,

  //   };
  // }

  factory JobSkillsState.fromMap(Map<String, dynamic> map) {
    return JobSkillsState(
      dataLoading: (map['dataLoading'] ?? false) as bool,
      jobsSkillList: map['jobsSkillCategoriesListModel'],
      selectedJobSkills: map['selectedJobSkills'],
    );
  }
}
