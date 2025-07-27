part of 'manage_poll_option_cubit.dart';

class ManagePollOptionState extends Equatable {
  final bool dataLoading;
  final ManagePollOptionList managePollOptionList;
  const ManagePollOptionState({
    this.dataLoading = false,
    required this.managePollOptionList,
  });

  @override
  List<Object> get props => [dataLoading, managePollOptionList];

  ManagePollOptionState copyWith({
    bool? dataLoading,
    ManagePollOptionList? managePollOptionList,
  }) {
    return ManagePollOptionState(
      dataLoading: dataLoading ?? false,
      managePollOptionList: managePollOptionList ?? this.managePollOptionList,
    );
  }
}
