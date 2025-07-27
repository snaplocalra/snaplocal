// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lost_found_type_selector_cubit.dart';

class LostFoundTypeSelectorState extends Equatable {
  final LostFoundType lostFoundType;
  const LostFoundTypeSelectorState(this.lostFoundType);

  @override
  List<Object> get props => [lostFoundType];

  LostFoundTypeSelectorState copyWith({LostFoundType? lostFoundType}) {
    return LostFoundTypeSelectorState(lostFoundType ?? this.lostFoundType);
  }
}
