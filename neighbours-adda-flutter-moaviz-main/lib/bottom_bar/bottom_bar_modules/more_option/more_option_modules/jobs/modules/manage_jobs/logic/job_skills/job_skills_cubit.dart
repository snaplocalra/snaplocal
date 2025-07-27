import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/repository/manage_jobs_repository.dart';

part 'job_skills_state.dart';

class JobSkillsCubit extends Cubit<JobSkillsState> {
  final ManageJobRepository manageJobRepository;
  JobSkillsCubit(this.manageJobRepository)
      : super(const JobSkillsState(jobsSkillList: [], selectedJobSkills: []));

  Future<void> fetchJobSkillsCategories() async {
    try {
      final jobsSkillList = await manageJobRepository.fetchJobSkills();

      //Emit state to store initial data
      emit(state.copyWith(jobsSkillList: jobsSkillList));

      // emit the state with the updated data
      emit(state.copyWith(jobsSkillList: jobsSkillList));

      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
      return;
    }
  }

  void selectJobSkill({required List<String> jobSkills}) {
    emit(state.copyWith(dataLoading: true));
    //Create a new list and add the job skills to it
    final newSelectedJobSkills = List<String>.from(state.selectedJobSkills);

    // Add only those jobSkills which are not already present in the selectedJobSkills
    for (var jobSkill in jobSkills) {
      if (!newSelectedJobSkills.contains(jobSkill)) {
        newSelectedJobSkills.add(jobSkill);
      }
    }

    //Emit the state with the new list
    emit(state.copyWith(selectedJobSkills: newSelectedJobSkills));
  }

  Future<List<String>> searchByQuery(String query) async {
    final logs = state.jobsSkillList;
    try {
      return logs.where((element) {
        final descriptionLower = element.toLowerCase();
        final queryLower = query.toLowerCase();
        return (descriptionLower.contains(queryLower));
      }).toList();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<void> removeSkillByIndex(int index) async {
    try {
      emit(state.copyWith(dataLoading: true));
      final selectedSkills = state.selectedJobSkills;
      selectedSkills.removeAt(index);
      emit(state.copyWith(selectedJobSkills: selectedSkills));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return;
    }
  }
}
