import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_topics/interested_topics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/quiz_controller/quiz_controller_bloc.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';

part 'start_quiz_controller_state.dart';

class StartQuizControllerCubit extends Cubit<StartQuizControllerState> {
  final InterestedTopicsCategoryCubit interestedTopicsCategoryCubit;
  // final InterestedLanguagesCubit interestedLanguagesCubit;
  final QuizControllerBloc quizControllerBloc;
  StartQuizControllerCubit({
    required this.interestedTopicsCategoryCubit,
    // required this.interestedLanguagesCubit,
    required this.quizControllerBloc,
  }) : super(const StartQuizControllerState());

  void startQuiz() {
    try {
      // List<LanguageModel> interestedLanguages = [];
      // interestedLanguages = interestedLanguagesCubit
      //     .state.interestedLanguagesModel.multiSelectedData;
      //check that interested languages are selected by the user or not
      // if (interestedLanguages.isEmpty) {
      //   throw ("Please select a languages to continue");
      // }

      List<CategoryModel> interestedTopics = [];

      //get the selected interested topics
      interestedTopics = interestedTopicsCategoryCubit
          .state.interestedTopicListModel.selectedData;

      //check that interested topics are selected by the user or not
      if (interestedTopics.isEmpty) {
        throw ("Please select minimum 1 interested topic to continue");
      }
      quizControllerBloc.add(StartQuiz(
        // languageId: interestedLanguages
        //     .map((e) => e.languageEnum.locale.languageCode)
        //     .toList(),
        topicIdList: interestedTopics.map((e) => e.id).toList(),
      ));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }
}
