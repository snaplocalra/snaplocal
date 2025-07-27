part of 'group_privacy_cubit.dart';

class GroupPrivacyTypeState extends Equatable {
  final bool dataLoading;
  final String? error;
  final CategoryListModel groupPrivacyTypesListModel;
  const GroupPrivacyTypeState({
    this.dataLoading = false,
    this.error,
    required this.groupPrivacyTypesListModel,
  });

  @override
  List<Object?> get props => [groupPrivacyTypesListModel, dataLoading, error];

  GroupPrivacyTypeState copyWith({
    String? error,
    bool? dataLoading,
    CategoryListModel? groupPrivacyTypesListModel,
  }) {
    return GroupPrivacyTypeState(
      dataLoading: dataLoading ?? false,
      error: error,
      groupPrivacyTypesListModel:
          groupPrivacyTypesListModel ?? this.groupPrivacyTypesListModel,
    );
  }
}
