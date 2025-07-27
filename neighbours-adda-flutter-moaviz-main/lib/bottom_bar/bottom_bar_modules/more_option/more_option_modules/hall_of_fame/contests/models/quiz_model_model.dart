import 'dart:convert';

class QuizDataModel {
  bool quizCompleted;
  String? quizStatusMessage;
  QuizData? quizData;

  QuizDataModel({
    required this.quizCompleted,
    required this.quizStatusMessage,
    required this.quizData,
  });

  factory QuizDataModel.fromJson(Map<String, dynamic> json) {
    return QuizDataModel(
      quizCompleted: json['quiz_completed'],
      quizStatusMessage: json['quiz_status_message'],
      quizData: json['quiz_data'] == null
          ? null
          : QuizData.fromJson(json['quiz_data']),
    );
  }

  String toRequiredJson() {
    return jsonEncode(quizData?.data
        .map(
          (e) => {
            "question_id": e.questionId,
            "user_selected_option_id": e.userSelectedAnswerId,
          },
        )
        .toList());
  }

  QuizDataModel copyWith({
    bool? quizCompleted,
    String? quizStatusMessage,
    QuizData? quizData,
  }) {
    return QuizDataModel(
      quizCompleted: quizCompleted ?? this.quizCompleted,
      quizStatusMessage: quizStatusMessage ?? this.quizStatusMessage,
      quizData: quizData ?? this.quizData,
    );
  }
}

class QuizData {
  String id;
  List<QuizQuestion> data;

  QuizData({
    required this.id,
    required this.data,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    var questionList = json['data'] as List<dynamic>;
    List<QuizQuestion> questions =
        questionList.map((item) => QuizQuestion.fromJson(item)).toList();

    return QuizData(
      id: json['id'],
      data: questions,
    );
  }

  QuizData copyWith({String? id, List<QuizQuestion>? data}) {
    return QuizData(id: id ?? this.id, data: data ?? this.data);
  }
}

class QuizQuestion {
  String questionId;
  String correctOptionId;
  String question;
  List<QuizOption> options;
  String? userSelectedAnswerId;

  QuizQuestion({
    required this.questionId,
    required this.correctOptionId,
    required this.question,
    required this.options,
    this.userSelectedAnswerId,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var optionList = json['options'] as List<dynamic>;
    List<QuizOption> questionOptions =
        optionList.map((item) => QuizOption.fromJson(item)).toList();

    return QuizQuestion(
      questionId: json['question_id'],
      correctOptionId: json['correct_option_id'],
      question: json['question'],
      options: questionOptions,
    );
  }
}

class QuizOption {
  String optionName;
  String optionId;

  QuizOption({
    required this.optionName,
    required this.optionId,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      optionName: json['option_name'],
      optionId: json['option_id'],
    );
  }
}
