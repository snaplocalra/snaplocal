

// class ShopPointsScreen extends StatefulWidget {
//   static const routeName = 'shop-points';
//   const ShopPointsScreen({super.key});

//   @override
//   State<ShopPointsScreen> createState() => _ShopPointsScreenState();
// }

// class _ShopPointsScreenState extends State<ShopPointsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<RewardCouponCubit>().fetchShopPoints();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: ThemeAppBar(
//         backgroundColor: Colors.transparent,
//         title: Text(
//           tr(LocaleKeys.shopWithYourPoints),
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: BlocBuilder<RewardCouponCubit, RewardCouponState>(
//         builder: (context, rewardCouponState) {
//           if (rewardCouponState.error != null) {
//             return ErrorTextWidget(error: rewardCouponState.error!);
//           } else if (rewardCouponState.dataLoading) {
//             return const Center(child: ThemeSpinner());
//           } else if (rewardCouponState.shopPointDataModel != null) {
//             return Stack(
//               children: [
//                 ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount:
//                       rewardCouponState.shopPointDataModel!.couponsList.length,
//                   itemBuilder: (context, index) {
//                     final coupon = rewardCouponState
//                         .shopPointDataModel!.couponsList[index];
//                     return CouponWidget(coupon: coupon);
//                   },
//                 ),

//                 //Show a loading spinner with light background if data is loading
//                 if (rewardCouponState.redeemPointsLoading)
//                   Center(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.5),
//                       child: const ThemeSpinner(),
//                     ),
//                   ),
//               ],
//             );
//           } else {
//             return  Center(child: Text(tr(LocaleKeys.noCouponsAvailable)));
//           }
//         },
//       ),
//     );
//   }
// }
