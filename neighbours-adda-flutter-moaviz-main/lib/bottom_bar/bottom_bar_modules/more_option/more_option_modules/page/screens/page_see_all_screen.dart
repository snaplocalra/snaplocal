import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/widgets/search_with_filter_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../../../utility/constant/assets_images.dart';
import '../../../../groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import '../../../../groups/models/search_filter_type.dart';
import '../logic/page_home_data/page_home_data_cubit.dart';
import '../logic/page_list/page_list_cubit.dart';
import '../models/page_list_type.dart';
import '../modules/page_details/screen/page_details.dart';
import 'search_page_screen.dart';

class SeeAllAscreenPages extends StatefulWidget {
  final ScrollController? controller;
  static const routeName = 'see_all_screen';

  const SeeAllAscreenPages({
    super.key,
    this.controller,
  });

  @override
  State<SeeAllAscreenPages> createState() => _SeeAllAscreenPagesState();
}

class _SeeAllAscreenPagesState extends State<SeeAllAscreenPages> {
  final GlobalKey _addressWithLocateMeKey = GlobalKey();
  GlobalKey pageSearchIconKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        appBarHeight: 60,
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.pages),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          SearchBoxWidget(
            key: pageSearchIconKey,
            searchHint: tr(LocaleKeys.searchPages),
            onSearchTap: () {
              GoRouter.of(context).pushNamed(SearchPageScreen.routeName);
            },
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            child: BlocBuilder<PageHomeDataCubit, PageHomeDataState>(
              builder: (context, pageHomeDataState) {
                if (pageHomeDataState is PageHomeDataError) {
                  return ErrorTextWidget(error: pageHomeDataState.error);
                } else if (pageHomeDataState is PageHomeDataLoaded) {
                  final logs = pageHomeDataState.data;

                  if (logs.isEmpty) {
                    return const Center(
                      child: EmptyDataPlaceHolder(
                        emptyDataType: EmptyDataType.group,
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: widget.controller,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: logs.length,
                    itemBuilder: (BuildContext context, index) {
                      final pageDetails = logs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(pageDetails.pageImage),
                            radius: 25,
                          ),
                          title: Row(
                            children: [
                              Text(
                                pageDetails.pageName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if(pageDetails.isVerified==true)...[
                                const SizedBox(width: 2),
                                SvgPicture.asset(
                                  SVGAssetsImages.greenTick,
                                  height: 12,
                                  width: 12,
                                ),
                              ],
                            ],
                          ),
                          subtitle: pageDetails.pageMemberCount > 0
                              ? Text(
                                  "${pageDetails.pageMemberCount.formatNumber()} ${pageDetails.pageMemberCount > 1 ? 'Members' : 'Member'}",
                                )
                              : null,
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            print(
                                "Navigating to Page ID: ${pageDetails.pageId}");
                            GoRouter.of(context).pushNamed(
                              PageDetailsScreen.routeName,
                              queryParameters: {'id': pageDetails.pageId},
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                else {
                  return const CircleCardShimmerListBuilder(
                    padding: EdgeInsets.symmetric(vertical: 20),
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
