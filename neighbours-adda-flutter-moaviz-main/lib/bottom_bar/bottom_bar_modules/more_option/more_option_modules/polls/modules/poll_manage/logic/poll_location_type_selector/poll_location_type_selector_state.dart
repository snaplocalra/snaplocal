part of 'poll_location_type_selector_cubit.dart';

class PollLocationTypeSelectorState extends Equatable {
  final PollLocationTypeEnum selectedLocationType;
  const PollLocationTypeSelectorState(this.selectedLocationType);

  @override
  List<Object> get props => [selectedLocationType];

  PollLocationTypeSelectorState copyWith(
      {PollLocationTypeEnum? selectedLocationType}) {
    return PollLocationTypeSelectorState(
      selectedLocationType ?? this.selectedLocationType,
    );
  }
}

enum PollLocationTypeEnum {
  local(displayName: LocaleKeys.localPoll),
  global(displayName: LocaleKeys.globalOthers);

  final String displayName;
  const PollLocationTypeEnum({required this.displayName});
}
