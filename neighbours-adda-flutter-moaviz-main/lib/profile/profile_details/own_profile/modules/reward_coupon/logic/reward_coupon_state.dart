part of 'reward_coupon_cubit.dart';

class RewardCouponState extends Equatable {
  final bool redeemPointsLoading;
  final bool dataLoading;
  final String? error;
  final RewardCouponDataModel? shopPointDataModel;

  const RewardCouponState({
    this.redeemPointsLoading = false,
    this.dataLoading = false,
    this.error,
    this.shopPointDataModel,
  });

  @override
  List<Object?> get props => [
        redeemPointsLoading,
        dataLoading,
        error,
        shopPointDataModel,
      ];

  RewardCouponState copyWith({
    bool? redeemPointsLoading,
    bool? dataLoading,
    String? error,
    RewardCouponDataModel? shopPointDataModel,
  }) {
    return RewardCouponState(
      redeemPointsLoading: redeemPointsLoading ?? false,
      dataLoading: dataLoading ?? false,
      error: error,
      shopPointDataModel: shopPointDataModel ?? this.shopPointDataModel,
    );
  }
}
