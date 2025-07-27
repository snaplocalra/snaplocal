// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_check/business_check_cubit.dart';
// import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/screen/create_or_update_business_screen.dart';
// import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
// import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
// import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
// import 'package:snap_local/utility/constant/application_colours.dart';
// import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
//
// class ManageBusinessButton extends StatelessWidget {
//   const ManageBusinessButton({
//     super.key,
//     required this.onBusinessFetch,
//   });
//
//   final void Function() onBusinessFetch;
//
//   @override
//   Widget build(BuildContext context) {
//     final mqSize = MediaQuery.sizeOf(context);
//
//     return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
//       builder: (context, profileSettingsState) {
//         bool marketPlaceLocationAvailable = false;
//         if (profileSettingsState.isProfileSettingModelAvailable) {
//           final profileSettingModel =
//               profileSettingsState.profileSettingsModel!;
//
//           marketPlaceLocationAvailable =
//               profileSettingModel.marketPlaceLocation != null;
//         }
//         if (marketPlaceLocationAvailable) {
//           return BlocBuilder<BusinessCheckCubit, BusinessCheckState>(
//             builder: (context, businessCheckState) {
//               if (businessCheckState.dataLoading) {
//                 return Align(
//                   alignment: Alignment.bottomRight,
//                   child: ShimmerWidget(
//                     height: 30,
//                     width: mqSize.width * 0.40,
//                     shapeBorder: const BeveledRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(2)),
//                     ),
//                   ),
//                 );
//               } else {
//                 return businessCheckState.isBusinessDetailsAvailable
//                     ? ManagePostActionButton(
//                         text: tr(LocaleKeys.editBusinessPage),
//                         backgroundColor: ApplicationColours.themeBlueColor,
//                         onPressed: () {
//                           GoRouter.of(context)
//                               .pushNamed(
//                             CreateOrUpdateBusinessScreen.routeName,
//                             extra: businessCheckState.businessDetailsModel,
//                           )
//                               .whenComplete(() {
//                             if (context.mounted) {
//                               //Check business
//                               context
//                                   .read<BusinessCheckCubit>()
//                                   .checkBusinessDetails();
//                             }
//
//                             //Fetch business
//                             onBusinessFetch.call();
//                           });
//                         },
//                       )
//                     : ManagePostActionButton(
//                         text: tr(LocaleKeys.createBusinessPage),
//                         backgroundColor: ApplicationColours.themeLightPinkColor,
//                         onPressed: () {
//                           GoRouter.of(context)
//                               .pushNamed(CreateOrUpdateBusinessScreen.routeName)
//                               .whenComplete(() {
//                             //Check business
//                             context
//                                 .read<BusinessCheckCubit>()
//                                 .checkBusinessDetails();
//
//                             //Fetch business
//                             onBusinessFetch.call();
//                           });
//                         },
//                       );
//               }
//             },
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/logic/business_check/business_check_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/screen/create_or_update_business_screen.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../modules/view_business/screen/business_details_screen.dart';

class ManageBusinessButton extends StatelessWidget {
  const ManageBusinessButton({
    super.key,
    required this.onBusinessFetch,
  });

  final void Function() onBusinessFetch;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
      builder: (context, profileSettingsState) {
        bool marketPlaceLocationAvailable = false;
        if (profileSettingsState.isProfileSettingModelAvailable) {
          final profileSettingModel =
          profileSettingsState.profileSettingsModel!;

          marketPlaceLocationAvailable =
              profileSettingModel.marketPlaceLocation != null;
        }
        if (marketPlaceLocationAvailable) {
          return BlocBuilder<BusinessCheckCubit, BusinessCheckState>(
            builder: (context, businessCheckState) {
              if (businessCheckState.dataLoading) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: ShimmerWidget(
                    height: 30,
                    width: mqSize.width * 0.40,
                    shapeBorder: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                );
              } else {
                return businessCheckState.isBusinessDetailsAvailable
                    ? ManagePostActionButton(
                  text: tr(LocaleKeys.myBusinessPage),
                  backgroundColor: ApplicationColours.themeBlueColor,
                  onPressed: () {
                    GoRouter.of(context).pushNamed(BusinessDetailsScreen.routeName,
                        queryParameters: {'id': businessCheckState.businessDetailsModel?.id});
                  },
                )
                    : ManagePostActionButton(
                  text: tr(LocaleKeys.createBusinessPage),
                  backgroundColor: ApplicationColours.themeLightPinkColor,
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(CreateOrUpdateBusinessScreen.routeName)
                        .whenComplete(() {
                      //Check business
                      context
                          .read<BusinessCheckCubit>()
                          .checkBusinessDetails();

                      //Fetch business
                      onBusinessFetch.call();
                    });
                  },
                );
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
