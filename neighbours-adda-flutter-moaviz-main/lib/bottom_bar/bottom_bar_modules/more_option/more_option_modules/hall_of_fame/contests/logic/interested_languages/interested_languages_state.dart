// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'interested_languages_cubit.dart';

class InterestedLanguagesState extends Equatable {
  final bool dataLoading;
  final InterestedLanguagesModel interestedLanguagesModel;

  const InterestedLanguagesState({
    this.dataLoading = false,
    required this.interestedLanguagesModel,
  });

  @override
  List<Object> get props => [dataLoading, interestedLanguagesModel];

  InterestedLanguagesState copyWith({
    InterestedLanguagesModel? interestedLanguagesModel,
    bool? dataLoading,
  }) {
    return InterestedLanguagesState(
      interestedLanguagesModel:
          interestedLanguagesModel ?? this.interestedLanguagesModel,
      dataLoading: dataLoading ?? false,
    );
  }
}
