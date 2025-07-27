import 'package:snap_local/common/review_module/model/review_type_enum.dart';

enum OwnerActivityType {
  market(jsonName: "market", ratingType: RatingType.market),
  job(jsonName: "job", ratingType: RatingType.job);

  final String jsonName;
  final RatingType ratingType;
  const OwnerActivityType({
    required this.jsonName,
    required this.ratingType,
  });

  factory OwnerActivityType.fromString(String param) {
    switch (param) {
      case 'job':
        return job;
      case 'market':
        return market;

      default:
        throw Exception("Unknown activity type: $param");
    }
  }
}
