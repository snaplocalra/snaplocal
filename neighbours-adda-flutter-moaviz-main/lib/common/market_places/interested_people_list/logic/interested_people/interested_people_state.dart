part of 'interested_people_cubit.dart';

class InterestedPeopleState extends Equatable {
  final bool dataLoading;
  final bool isSearchLoading;
  final String? error;
  final InterestedPeopleListModel? interestedPeopleList;

  const InterestedPeopleState({
    this.dataLoading = false,
    this.isSearchLoading = false,
    this.error,
    this.interestedPeopleList,
  });

  bool get interestedPeopleListNotAvailable =>
      interestedPeopleList == null || interestedPeopleList!.data.isEmpty;

  @override
  List<Object?> get props => [
        dataLoading,
        isSearchLoading,
        error,
        interestedPeopleList,
      ];

  InterestedPeopleState copyWith({
    bool? dataLoading,
    bool? isSearchLoading,
    String? error,
    InterestedPeopleListModel? interestedPeopleList,
  }) {
    return InterestedPeopleState(
      dataLoading: dataLoading ?? false,
      isSearchLoading: isSearchLoading ?? false,
      error: error,
      interestedPeopleList: interestedPeopleList ?? this.interestedPeopleList,
    );
  }
}
