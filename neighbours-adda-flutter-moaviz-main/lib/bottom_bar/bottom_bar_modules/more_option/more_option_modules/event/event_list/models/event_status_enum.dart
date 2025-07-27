import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum EventStatus {
  upcoming('upcoming', 'Upcoming'),
  ongoing('ongoing', LocaleKeys.ongoing),
  past('past', 'Past');

  final String jsonValue;
  final String displayValue;

  const EventStatus(this.jsonValue, this.displayValue);

  factory EventStatus.fromJson(String jsonValue) {
    //switch case

    switch (jsonValue) {
      case 'upcoming':
        return EventStatus.upcoming;
      case 'ongoing':
        return EventStatus.ongoing;
      case 'past':
        return EventStatus.past;
      default:
        throw Exception('Unknown EventStatus: $jsonValue');
    }
  }
}
