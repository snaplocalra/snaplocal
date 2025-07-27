// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'winners_cubit.dart';

class WinnersState extends Equatable {
  final bool dataLoading;
  final String? error;
  final WinnersListModel winnersListModel;
  const WinnersState({
    this.dataLoading = false,
    this.error,
    required this.winnersListModel,
  });

  @override
  List<Object?> get props => [winnersListModel, dataLoading, error];

  WinnersState copyWith({
    bool? dataLoading,
    WinnersListModel? winnersListModel,
    String? error,
  }) {
    return WinnersState(
      dataLoading: dataLoading ?? false,
      error: error,
      winnersListModel: winnersListModel ?? this.winnersListModel,
    );
  }
}
