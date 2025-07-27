

// class CouponWidget extends StatelessWidget {
//   final RewardCouponModel coupon;
//   const CouponWidget({
//     super.key,
//     required this.coupon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: ApplicationColours.themeBlueColor,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Color(0xfff5f7ff),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         coupon.title,
//                         style: TextStyle(
//                           color: ApplicationColours.themeBlueColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 5),
//                         child: Text(
//                           coupon.description,
//                           style: TextStyle(
//                             color: ApplicationColours.themeBlueColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       //If coupon is redeemed by user, show view coupon button
//                       coupon.redeemByCurrentUser
//                           ? Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 5),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (coupon.redeemByCurrentUser &&
//                                       coupon.couponImage != null) {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => ImageDialog(
//                                         imageUrl: coupon.couponImage!,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: DottedBorder(
//                                   borderType: BorderType.RRect,
//                                   dashPattern: const [3, 1],
//                                   color: ApplicationColours.themePinkColor,
//                                   strokeWidth: 1,
//                                   padding: const EdgeInsets.all(4),
//                                   child: Text(
//                                     tr(LocaleKeys.viewCoupon),
//                                     style: TextStyle(
//                                       color: ApplicationColours.themePinkColor,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : InkWell(
//                               onTap: () {
//                                 HapticFeedback.lightImpact();
//                                 showDialog(
//                                   context: context,
//                                   builder: (dialogContext) => CustomAlertDialog(
//                                     svgImagePath: SVGAssetsImages.connect,
//                                     title: tr(LocaleKeys.redeemCoupon),
//                                     description:
//                                         tr(LocaleKeys.redeemDescription),
//                                     action: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         ThemeElevatedButton(
//                                           buttonName:
//                                               tr(LocaleKeys.redeemButton),
//                                           textFontSize: 12,
//                                           padding: EdgeInsets.zero,
//                                           width: 128,
//                                           height: 33,
//                                           onPressed: () {
//                                             context
//                                                 .read<RewardCouponCubit>()
//                                                 .redeemPoints(coupon.id);
//                                             Navigator.pop(dialogContext);
//                                           },
//                                           foregroundColor: Colors.white,
//                                           backgroundColor:
//                                               ApplicationColours.themeBlueColor,
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(dialogContext);
//                                           },
//                                           style: ButtonStyle(
//                                             foregroundColor:
//                                                 WidgetStatePropertyAll(
//                                                     ApplicationColours
//                                                         .themePinkColor),
//                                           ),
//                                           child: Text(
//                                             tr(LocaleKeys.cancel),
//                                             textAlign: TextAlign.center,
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: ApplicationColours.themePinkColor,
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 margin: const EdgeInsets.symmetric(vertical: 5),
//                                 child: Text(
//                                   tr(LocaleKeys.getItNow),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     coupon.requiredRewardPoints.toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     tr(LocaleKeys.rewardPoints),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ImageDialog extends StatelessWidget {
//   final String imageUrl;
//   const ImageDialog({
//     super.key,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               tr(LocaleKeys.yourCoupon),
//               style: TextStyle(
//                 color: ApplicationColours.themeBlueColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 200,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: CachedNetworkImageProvider(imageUrl),
//                   fit: BoxFit.scaleDown,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
