import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_state.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';
import 'package:snap_local/common/social_media/profile/language_known/repository/language_known_repository.dart';

class LanguageKnownCubit extends Cubit<LanguageKnownState> with HydratedMixin {
  final LanguageKnownRepository languageRepository;
  LanguageKnownCubit(this.languageRepository)
      : super(
          LanguageKnownState(
            languageList: LanguageKnownList(languages: []),
          ),
        );

  Future<void> fetchLanguages() async {
    try {
      //emit loading if the language list is empty
      if (state.languageList.languages.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }
      final languages = await languageRepository.fetchLanguage();
      emit(state.copyWith(languageList: languages));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
      return;
    }
  }

  Future<void> selectLanguageById(List<String> idList) async {
    for (var id in idList) {
      for (var language in state.languageList.languages) {
        if (language.id == id) {
          language.isSelected = true;
        }
      }
    }
    emit(state.copyWith(
        languageList: LanguageKnownList(
      languages: state.languageList.languages,
    )));
    return;
  }

  Future<void> removeLanguageById(String id) async {
    for (var language in state.languageList.languages) {
      if (language.id == id) {
        language.isSelected = false;
      }
    }
    emit(state.copyWith(
        languageList: LanguageKnownList(
      languages: state.languageList.languages,
    )));
    return;
  }

  Future<void> clearSelection() async {
    for (var language in state.languageList.languages) {
      language.isSelected = false;
    }
    emit(state.copyWith(
        languageList: LanguageKnownList(
      languages: state.languageList.languages,
    )));
    return;
  }

  Future<List<LanguageKnownModel>> searchLanguagesByQuery(String query) async {
    final logs = state.languageList.languages;
    try {
      return logs.where((element) {
        final descriptionLower = element.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return (descriptionLower.contains(queryLower) &&
            // if the element is already selected then don't show it again
            !element.isSelected);
      }).toList();
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return [];
    }
  }

  @override
  LanguageKnownState? fromJson(Map<String, dynamic> json) {
    return LanguageKnownState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(LanguageKnownState state) {
    return state.toMap();
  }
}
