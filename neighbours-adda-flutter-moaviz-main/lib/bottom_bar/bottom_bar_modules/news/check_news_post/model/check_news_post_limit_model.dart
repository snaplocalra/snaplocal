class CheckNewsPostLimitModel {
  final String message;
  final bool isLimitExceeded;

  CheckNewsPostLimitModel({
    required this.message,
    required this.isLimitExceeded,
  });

  factory CheckNewsPostLimitModel.fromJson(Map<String, dynamic> json) {
    return CheckNewsPostLimitModel(
      message: json['message'],
      isLimitExceeded: json['is_limit_exceeded'],
    );
  }
}
