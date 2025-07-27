part of 'work_type_cubit.dart';

class WorkTypeState extends Equatable {
  final List<WorkTypeOption> workTypeOptions;
  const WorkTypeState({
    required this.workTypeOptions,
  });

  @override
  List<Object> get props => [workTypeOptions];
}

class WorkTypeOption {
  final WorkType workType;
  bool isSelected;
  WorkTypeOption({
    required this.workType,
    this.isSelected = false,
  });

  WorkTypeOption copyWith({
    WorkType? workType,
    bool? isSelected,
  }) {
    return WorkTypeOption(
      workType: workType ?? this.workType,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
