import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/logic/poll_type_selector/poll_type_selector_cubit.dart';
import 'package:snap_local/common/market_places/models/post_owner_details.dart';

class PollModel {
  final String pollQuestion;
  final String categoryId;
  final String? otherCategoryName;
  final PollTypeEnum pollType;
  final bool hideResultUntilPollEnds;
  final bool allowEdit;
  final bool isPollAdmin;
  final String distance;
  final DateTime createdAt;
  final DateTime pollEndDate;
  final PostOwnerDetailsModel userDetails;
  PollOptionModel pollOptionDetails;
  bool disablePoll;
  final bool isGlobalLocation;
  bool answerSubmitted;

  PollModel({
    required this.categoryId,
    required this.pollType,
    required this.allowEdit,
    required this.distance,
    required this.createdAt,
    required this.isPollAdmin,
    required this.userDetails,
    required this.disablePoll,
    required this.pollEndDate,
    required this.pollQuestion,
    required this.isGlobalLocation,
    required this.pollOptionDetails,
    required this.otherCategoryName,
    required this.hideResultUntilPollEnds,
    this.answerSubmitted = false,
  });

  bool get isUserVoted =>
      pollOptionDetails.options.any((element) => element.userSelectedOption);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'poll_question': pollQuestion,
      'poll_type': pollType.json,
      'allow_edit': allowEdit,
      'is_poll_admin': isPollAdmin,
      'created_at': createdAt.millisecondsSinceEpoch,
      'end_date': pollEndDate.millisecondsSinceEpoch,
      'hide_result_until_poll_ends': hideResultUntilPollEnds,
      'distance': distance,
      'disable_poll': disablePoll,
      'user_details': userDetails.toMap(),
      'poll_option_details': pollOptionDetails.toMap(),
      'answer_submitted': answerSubmitted,
      'is_global_location': isGlobalLocation,
      'category_id': categoryId,
      'other_category_name': otherCategoryName,
    };
  }

  factory PollModel.fromMap(Map<String, dynamic> json) => PollModel(
        pollQuestion: json["poll_question"],
        categoryId: json["category_id"],
        pollType: PollTypeEnum.fromString(json["poll_type"]),
        allowEdit: json["allow_edit"] ?? true,
        isPollAdmin: json["is_poll_admin"] ?? true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        pollEndDate: DateTime.fromMillisecondsSinceEpoch(json["end_date"]),
        hideResultUntilPollEnds: json["hide_result_until_poll_ends"],
        distance: json["distance"],
        disablePoll: json["disable_poll"],
        userDetails: PostOwnerDetailsModel.fromJson(json["user_details"]),
        pollOptionDetails: PollOptionModel.fromMap(json["poll_option_details"]),
        answerSubmitted: json["answer_submitted"] ?? false,
        isGlobalLocation: json["is_global_location"],
        otherCategoryName: json["other_category_name"],
      );

  PollModel copyWith({
    String? pollQuestion,
    bool? hideResultUntilPollEnds,
    bool? allowEdit,
    bool? isPollAdmin,
    String? distance,
    DateTime? createdAt,
    DateTime? pollEndDate,
    PostOwnerDetailsModel? userDetails,
    PollOptionModel? pollOptionDetails,
    bool? disablePoll,
    bool? answerSubmitted,
    bool? isGlobalLocation,
    String? categoryId,
    String? otherCategoryName,
  }) {
    return PollModel(
      pollType: pollType,
      pollQuestion: pollQuestion ?? this.pollQuestion,
      hideResultUntilPollEnds:
          hideResultUntilPollEnds ?? this.hideResultUntilPollEnds,
      allowEdit: allowEdit ?? this.allowEdit,
      isPollAdmin: isPollAdmin ?? this.isPollAdmin,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
      pollEndDate: pollEndDate ?? this.pollEndDate,
      userDetails: userDetails ?? this.userDetails,
      pollOptionDetails: pollOptionDetails ?? this.pollOptionDetails,
      disablePoll: disablePoll ?? this.disablePoll,
      answerSubmitted: answerSubmitted ?? this.answerSubmitted,
      isGlobalLocation: isGlobalLocation ?? this.isGlobalLocation,
      categoryId: categoryId ?? this.categoryId,
      otherCategoryName: otherCategoryName ?? this.otherCategoryName,
    );
  }
}

class PollOptionModel {
  int totalParticipants;
  final List<PollQuestionOption> options;

  PollOptionModel({
    required this.totalParticipants,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_participants': totalParticipants,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  //total vote count
  int get totalVotes {
    return options.fold<int>(
      0,
      (previousValue, element) => previousValue + element.voteCount,
    );
  }

  factory PollOptionModel.fromMap(Map<String, dynamic> json) => PollOptionModel(
        totalParticipants: int.parse(json["total_participants"].toString()),
        options: List<PollQuestionOption>.from(
          json["options"].map((x) => PollQuestionOption.fromMap(x)),
        ),
      );
}

class PollQuestionOption {
  final String? optionImage;
  final String optionName;
  final String optionId;
  int voteCount;
  bool userSelectedOption;

  PollQuestionOption({
    this.optionImage,
    required this.optionName,
    required this.optionId,
    required this.voteCount,
    required this.userSelectedOption,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'option_image': optionImage,
      'option_name': optionName,
      'option_id': optionId,
      'vote_count': voteCount,
      'user_selected_option': userSelectedOption,
    };
  }

  factory PollQuestionOption.fromMap(Map<String, dynamic> json) =>
      PollQuestionOption(
        optionImage: json["option_image"],
        optionName: json["option_name"],
        optionId: json["option_id"],
        voteCount: json["vote_count"],
        userSelectedOption: json["user_selected_option"],
      );
}
