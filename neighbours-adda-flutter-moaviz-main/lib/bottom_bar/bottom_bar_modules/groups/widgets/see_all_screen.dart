import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_home_data/group_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/common/utils/widgets/search_with_filter_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../screens/search_group_screen.dart';

class SeeAllAscreen extends StatefulWidget {
  final GroupListType groupListType;
  final ScrollController? controller;
  static const routeName = 'see_all_screen';

  const SeeAllAscreen({
    super.key,
    required this.groupListType,
    this.controller,
  });

  @override
  State<SeeAllAscreen> createState() => _SeeAllAscreenState();
}

class _SeeAllAscreenState extends State<SeeAllAscreen> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();
  GlobalKey groupSearchIconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        appBarHeight: 60,
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.groups),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: PageHeading(
              svgPath: SVGAssetsImages.groupsColored,
              heading: GroupListType.managedByYou.name,
              subHeading: GroupListType.managedByYou.description,
            ),
          ),
          SearchBoxWidget(
            key: groupSearchIconKey,
            searchHint: tr(LocaleKeys.searchGroup),
            onSearchTap: () {
              GoRouter.of(context).pushNamed(SearchGroupScreen.routeName);
            },
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 5),
            child: AddressWithLocateMe(
              key: _addressWithLocateMeKey,
              is3D: true,
              iconSize: 15,
              iconTopPadding: 0,
              locationType: LocationType.socialMedia,
              contentMargin: EdgeInsets.zero,
              height: 35,
              decoration: BoxDecoration(
                color: ApplicationColours.skyColor.withOpacity(1),
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: null,
            ),
          ),
          Expanded(
            child: BlocBuilder<GroupHomeDataCubit, GroupHomeDataState>(
              builder: (context, groupHomeDataState) {
                print("Current State: $groupHomeDataState"); // Debugging State

                if (groupHomeDataState is GroupHomeDataError) {
                  print("Error: ${groupHomeDataState.error}");
                  return ErrorTextWidget(error: groupHomeDataState.error);
                } else if (groupHomeDataState is GroupHomeDataLoaded) {
                  final logs = groupHomeDataState.data;
                  print("Logs length: ${logs.length}"); // Debugging log length

                  final profileSettingsCubit =
                      context.read<ProfileSettingsCubit>();
                  final profileSettingsModel =
                      profileSettingsCubit.state.profileSettingsModel;

                  if (profileSettingsModel == null) {
                    print("Profile Settings Model is NULL");
                    return const Center(
                        child: Text("Failed to load settings."));
                  }

                  if (logs.isEmpty) {
                    return const Center(
                      child: EmptyDataPlaceHolder(
                        emptyDataType: EmptyDataType.group,
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    controller: widget.controller,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: logs.length,
                    itemBuilder: (BuildContext context, index) {
                      final groupDetails = logs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(groupDetails.groupImage),
                            radius: 25,
                          ),
                          title: Row(
                            children: [
                              Text(
                                groupDetails.groupName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if(groupDetails.isVerified==true)...[
                                const SizedBox(width: 2),
                                SvgPicture.asset(
                                  SVGAssetsImages.greenTick,
                                  height: 12,
                                  width: 12,
                                ),
                              ],
                            ],
                          ),
                          subtitle: groupDetails.groupMemberCount > 0
                              ? Text(
                                  "${groupDetails.groupMemberCount.formatNumber()} ${groupDetails.groupMemberCount > 1 ? 'Members' : 'Member'}",
                                )
                              : null,
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            print(
                                "Navigating to Group ID: ${groupDetails.groupId}");
                            GoRouter.of(context).pushNamed(
                              GroupDetailsScreen.routeName,
                              queryParameters: {'id': groupDetails.groupId},
                              extra: index,
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    child: const CircleCardShimmerListBuilder(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
