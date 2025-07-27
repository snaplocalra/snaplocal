// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'group_details_cubit.dart';

class GroupDetailsState extends Equatable {
  final GroupDetailsModel? groupDetailsModel;
  final String? error;
  final bool dataLoading;

  //favorite
  final bool favoriteLoading;

  //delete
  final bool deleteLoading;
  final bool deleteSuccess;
  //block
  final bool toggleBlockLoading;
  final bool toggleBlockSuccess;
  const GroupDetailsState({
    this.groupDetailsModel,
    this.error,
    this.favoriteLoading = false,
    this.dataLoading = false,
    this.deleteLoading = false,
    this.deleteSuccess = false,
    this.toggleBlockLoading = false,
    this.toggleBlockSuccess = false,
  });

  @override
  List<Object?> get props => [
        groupDetailsModel,
        error,
        dataLoading,
        deleteLoading,
        deleteSuccess,
        toggleBlockLoading,
        toggleBlockSuccess,
        favoriteLoading,
      ];

  GroupDetailsState copyWith({
    GroupDetailsModel? groupDetailsModel,
    String? error,
    bool? dataLoading,
    bool? deleteLoading,
    bool? deleteSuccess,
    bool? toggleBlockLoading,
    bool? toggleBlockSuccess,
    bool? favoriteLoading,
  }) {
    return GroupDetailsState(
      groupDetailsModel: groupDetailsModel ?? this.groupDetailsModel,
      error: error,
      dataLoading: dataLoading ?? false,
      deleteLoading: deleteLoading ?? false,
      deleteSuccess: deleteSuccess ?? false,
      toggleBlockLoading: toggleBlockLoading ?? false,
      toggleBlockSuccess: toggleBlockSuccess ?? false,
      favoriteLoading: favoriteLoading ?? false,
    );
  }
}
