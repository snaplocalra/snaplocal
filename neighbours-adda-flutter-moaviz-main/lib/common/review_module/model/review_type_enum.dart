import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum RatingType {
  event(title: LocaleKeys.rateTheEvent),
  job(title: LocaleKeys.rateThisJob),
  market(title: LocaleKeys.rateThisProfile),
  business(title: LocaleKeys.rateTheBusiness);

  final String title;
  const RatingType({required this.title});

  factory RatingType.fromString(String param) {
    switch (param) {
      case 'event':
        return RatingType.event;
      case 'job':
        return RatingType.job;
      case 'market':
        return RatingType.market;
      case 'business':
        return RatingType.business;
      default:
        throw Exception("Unknown post type: $param");
    }
  }
}
