import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';

part 'work_type_state.dart';

class WorkTypeCubit extends Cubit<WorkTypeState> {
  WorkTypeCubit()
      : super(
          WorkTypeState(workTypeOptions: [
            WorkTypeOption(workType: WorkType.hybrid),
            WorkTypeOption(workType: WorkType.wfo),
            WorkTypeOption(workType: WorkType.remote),
          ]),
        );

  void selectWorkType(WorkType workType) {
    final List<WorkTypeOption> workTypeOptions = state.workTypeOptions
        .map((e) => e.workType == workType
            ? e.copyWith(isSelected: true)
            : e.copyWith(isSelected: false))
        .toList();
    emit(WorkTypeState(workTypeOptions: workTypeOptions));
  }
}
