// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'gender_selector_cubit.dart';

class GenderSelectorState extends Equatable {
  final GenderEnum selectedGender;
  const GenderSelectorState(this.selectedGender);

  @override
  List<Object> get props => [selectedGender];

  GenderSelectorState copyWith({
    GenderEnum? gender,
  }) {
    return GenderSelectorState(gender ?? selectedGender);
  }
}
