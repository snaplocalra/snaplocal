// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/reward_coupon/models/reward_coupon_model.dart';

part 'reward_coupon_state.dart';

// class RewardCouponCubit extends Cubit<RewardCouponState> {
//   final ManageProfileDetailsBloc profileDetailsBloc;
//   final RewardCouponRepository rewardCouponRepository;
//   final LevelDetailsCubit rewardDetailsCubit;
//   RewardCouponCubit({
//     required this.profileDetailsBloc,
//     required this.rewardCouponRepository,
//     required this.rewardDetailsCubit,
//   }) : super(const RewardCouponState());

//   Future<void> fetchShopPoints() async {
//     try {
//       if (state.shopPointDataModel == null ||
//           state.shopPointDataModel!.couponsList.isEmpty) {
//         emit(state.copyWith(dataLoading: true));
//       }
//       final shopPoints = await rewardCouponRepository.fetchCouponsList();
//       emit(state.copyWith(shopPointDataModel: shopPoints));
//       return;
//     } catch (e) {
//       // Record the error in Firebase Crashlytics
//       FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
//       emit(state.copyWith(error: e.toString()));
//       return;
//     }
//   }

//   void redeemPoints(String couponId) async {
//     try {
//       //Set loading state
//       emit(state.copyWith(redeemPointsLoading: true));

//       //Call redeem points api
//       await rewardCouponRepository.redeemPoints(couponId);

//       //Refresh the coupons list
//       await fetchShopPoints();

//       //Refresh the profile details to update the points
//       profileDetailsBloc.add(FetchProfileDetails());

//       //Refresh the reward details to update the points
//       rewardDetailsCubit.fetchRewardDetails();
//       return;
//     } catch (e) {
//       // Record the error in Firebase Crashlytics
//       FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
//       ThemeToast.errorToast(e.toString());
//       //emit default state
//       emit(state.copyWith());
//       return;
//     }
//   }
// }
