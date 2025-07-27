import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/repository/hall_of_fame_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/quiz_model_model.dart';

part 'quiz_controller_event.dart';
part 'quiz_controller_state.dart';

class QuizControllerBloc
    extends Bloc<QuizControllerEvent, QuizControllerState> {
  final HallOfFameRepository hallOfFameRepository;
  QuizControllerBloc(this.hallOfFameRepository)
      : super(const QuizControllerState()) {
    ///Method to check that, for every question, user selected id is available or not
    bool areAllQuestionsAnswered() {
      final quizData = state.quizDataModel!;
      return quizData.quizData!.data
          .every((element) => element.userSelectedAnswerId != null);
    }

    on<QuizControllerEvent>((event, emit) async {
      if (event is FetchQuizData) {
        try {
          emit(state.copyWith(dataLoading: true));
          //fetch data
          final quizData = await hallOfFameRepository.fetchQuizData();
          emit(state.copyWith(quizDataModel: quizData));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          if (state.quizDataModel != null) {
            ThemeToast.errorToast(e.toString());
            return;
          } else {
            emit(state.copyWith(error: e.toString()));
          }
        }
      } else if (event is StartQuiz) {
        try {
          //check that topics available or not
          if (event.topicIdList.isNotEmpty) {
            emit(state.copyWith(requestLoading: true));
            await hallOfFameRepository.startQuiz(
              // languageId: event.languageId,
              topicIdList: event.topicIdList,
            );
            //Need to intgrate submit quiz model
            emit(state.copyWith(requestSuccess: true));
          } else {
            throw ("Need topics to start the quiz");
          }
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          if (state.quizDataModel != null) {
            ThemeToast.errorToast(e.toString());
            return;
          } else {
            emit(state.copyWith(error: e.toString()));
          }
        }
      } else if (event is SelectQuizAnswer) {
        try {
          final quizDataModel = state.quizDataModel;
          if (quizDataModel != null && quizDataModel.quizData != null) {
            quizDataModel
                    .quizData!.data[event.questionIndex].userSelectedAnswerId =
                quizDataModel.quizData!.data[event.questionIndex]
                    .options[event.answerIndex].optionId;
            emit(state.copyWith(
                quizDataModel: quizDataModel.copyWith(
              quizData: quizDataModel.quizData,
            )));
          }
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          if (state.quizDataModel != null) {
            ThemeToast.errorToast(e.toString());
            return;
          } else {
            emit(state.copyWith(error: e.toString()));
          }
        }
      } else if (event is SubmitQuiz) {
        try {
          if (state.quizDataModelAvailable) {
            //1st check that all the questions attended by the user or not
            if (areAllQuestionsAnswered()) {
              emit(state.copyWith(requestLoading: true));
              await Future.delayed(const Duration(seconds: 2));
              await hallOfFameRepository.submitQuiz(state.quizDataModel!);
              //Need to intgrate submit quiz model
              emit(state.copyWith(requestSuccess: true));
            } else {
              throw ("Please answer all the questions to submit");
            }
          } else {
            throw ("Data model not available");
          }
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          if (state.quizDataModel != null) {
            ThemeToast.errorToast(e.toString());
            return;
          } else {
            emit(state.copyWith(error: e.toString()));
          }
        }
      }
    });
  }
}
