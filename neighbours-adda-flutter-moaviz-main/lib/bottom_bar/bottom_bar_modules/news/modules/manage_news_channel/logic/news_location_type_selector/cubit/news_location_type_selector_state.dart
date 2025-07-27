import 'package:equatable/equatable.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsLocationTypeSelectorState extends Equatable {
  final NewsLocationTypeEnum selectedLocationType;
  const NewsLocationTypeSelectorState(this.selectedLocationType);

  @override
  List<Object> get props => [selectedLocationType];

  NewsLocationTypeSelectorState copyWith(
      {NewsLocationTypeEnum? selectedLocationType}) {
    return NewsLocationTypeSelectorState(
      selectedLocationType ?? this.selectedLocationType,
    );
  }
}

enum NewsLocationTypeEnum {
  local(displayName: LocaleKeys.local),
  global(displayName: LocaleKeys.globalOthers);

  final String displayName;
  const NewsLocationTypeEnum({required this.displayName});
}
