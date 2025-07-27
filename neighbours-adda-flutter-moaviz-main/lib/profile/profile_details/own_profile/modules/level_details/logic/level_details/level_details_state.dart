// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'level_details_cubit.dart';

class LevelDetailsState extends Equatable {
  final bool dataLoading;
  final String? error;
  // final RewardDetailsModel? rewardDetailsModel;

  const LevelDetailsState({
    this.dataLoading = false,
    this.error,
    // this.rewardDetailsModel,
  });

  @override
  List<Object?> get props => [dataLoading, error];

  LevelDetailsState copyWith({
    bool? dataLoading,
    String? error,
    // RewardDetailsModel? rewardDetailsModel,
  }) {
    return LevelDetailsState(
      dataLoading: dataLoading ?? false,
      error: error,
      // rewardDetailsModel: rewardDetailsModel ?? this.rewardDetailsModel,
    );
  }
}
