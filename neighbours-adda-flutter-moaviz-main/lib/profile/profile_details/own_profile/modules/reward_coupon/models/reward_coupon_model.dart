class RewardCouponDataModel {
  final List<RewardCouponModel> couponsList;

  RewardCouponDataModel({
    required this.couponsList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coupons_list': couponsList.map((x) => x.toMap()).toList(),
    };
  }

  factory RewardCouponDataModel.fromMap(Map<String, dynamic> map) {
    return RewardCouponDataModel(
      couponsList: List<RewardCouponModel>.from(
        (map['coupons_list']).map<RewardCouponModel>(
          (x) => RewardCouponModel.fromMap(x),
        ),
      ),
    );
  }
}

class RewardCouponModel {
  final String id;
  final String title;
  final String description;
  final int requiredRewardPoints;
  final String? couponImage;
  final bool redeemByCurrentUser;

  RewardCouponModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredRewardPoints,
    required this.couponImage,
    required this.redeemByCurrentUser,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'required_reward_points': requiredRewardPoints.toString(),
      'coupon_image': couponImage,
      'redeem_by_current_user': redeemByCurrentUser,
    };
  }

  factory RewardCouponModel.fromMap(Map<String, dynamic> map) {
    return RewardCouponModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      requiredRewardPoints: map['required_reward_points'],
      couponImage: map['coupon_image'],
      redeemByCurrentUser: map['redeem_by_current_user'],
    );
  }
}
