part of 'poll_type_selector_cubit.dart';

class PollTypeSelectorState extends Equatable {
  final PollTypeEnum selectedType;
  const PollTypeSelectorState(this.selectedType);

  @override
  List<Object> get props => [selectedType];

  PollTypeSelectorState copyWith({PollTypeEnum? selectedType}) {
    return PollTypeSelectorState(selectedType ?? this.selectedType);
  }
}

enum PollTypeEnum {
  text(displayName: LocaleKeys.textPoll, json: "text"),
  photo(displayName: LocaleKeys.photoPoll, json: "photo");

  final String displayName;
  final String json;
  const PollTypeEnum({
    required this.displayName,
    required this.json,
  });

  factory PollTypeEnum.fromString(String data) {
    switch (data) {
      case "text":
        return text;
      case "photo":
        return photo;
      default:
        throw ("Invalid poll type");
    }
  }
}
