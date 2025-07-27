import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/social_media_map_list_view_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/logic/category_wise_feed_post/category_wise_feed_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/repository/categorywise_feed_post_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/lost_found_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/safety_alerts_post_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/safety_post_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/common/post_heading_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/date_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/filter_data.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/helpline_numbers/screen/helpline_numbers_screen.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/common/utils/share/model/share_type.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/manage_post_action_button.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/search_box/logic/search/search_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../../../common/utils/location/model/location_type_enum.dart';
import '../../../../../../tutorial_screens/tutorial_logic/logic.dart';

class CategoryWiseFeedPostsScreen extends StatefulWidget {
  final FeedPostCategoryType categoryType;
  const CategoryWiseFeedPostsScreen({
    super.key,
    required this.categoryType,
  });

  static const routeName = 'category_wise_feed_posts';
  @override
  State<CategoryWiseFeedPostsScreen> createState() =>
      _CategoryWiseFeedPostsScreenState();
}

class _CategoryWiseFeedPostsScreenState
    extends State<CategoryWiseFeedPostsScreen> {
  late CategoryWiseFeedPostCubit categoryWiseSocialPostCubit =
      CategoryWiseFeedPostCubit(CateegoryWiseFeedPostRepository());

  final dataOnMapViewControllerCubit = DataOnMapViewControllerCubit();

  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  void _fetchData({bool loadMoreData = false}) {
    categoryWiseSocialPostCubit.fetchCategoryWiseFeedPosts(
      categoryType: widget.categoryType,
      loadMoreData: loadMoreData,

      //Filter data
      filterJson: dataFilterCubit.state.filterJson,
      searchKeyword: searchKeyword,
    );
  }

  String searchKeyword = "";

  //Filter initialization
  DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.sort),
      sortFilterOptions: FilterData().socialSortFilter,
    ),

    //Date range filter
    DateRangeFilter(filterName: "Date"),
  ]);

  @override
  void initState() {
    super.initState();

    //Initial call the method to fetch category wise posts
    _fetchData();

    final profileSettingsModel =
        context.read<ProfileSettingsCubit>().state.profileSettingsModel!;

    final socialMediaSearchRadius =
        profileSettingsModel.feedRadiusModel.socialMediaSearchRadius;

    //range filter
    final distanceRangeFilter = DistanceRangeFilter(
      filterName: tr(LocaleKeys.distance),
      allowedMaxDistance: socialMediaSearchRadius,
      selectedMaxDistance: socialMediaSearchRadius,
    );

    //Add the distance filter to the data filter
    dataFilterCubit.insertOrUpdateFilter(distanceRangeFilter);

    //Listen for the profile setting changes
    context.read<ProfileSettingsCubit>().stream.listen((state) {
      if (state.isProfileSettingModelAvailable) {
        //Initial call the method to fetch category wise posts
        _fetchData();
      }
    });
    //handleLostFoundTutorial(context);
  }

  void _onCreatePost() {
    late String screenName;

    if (widget.categoryType == FeedPostCategoryType.lostFound) {
      screenName = LostFoundPostScreen.routeName;
    } else if (widget.categoryType == FeedPostCategoryType.safety) {
      screenName = SafetyAlertPostScreen.routeName;
    } else {
      throw ("Invalid type");
    }

    GoRouter.of(context).pushNamed(screenName).whenComplete(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: categoryWiseSocialPostCubit),
        BlocProvider.value(value: showReactionCubit),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider.value(value: dataOnMapViewControllerCubit),
        BlocProvider.value(value: dataFilterCubit),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: ThemeAppBar(
            backgroundColor: Colors.white,
            appBarHeight: 60,
            title: Container(
              color: Colors.white,
              child: PageHeading(
                heading: widget.categoryType.heading,
                subHeading: widget.categoryType.subHeading,
                svgPath: widget.categoryType.svgImagePath,
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  //Filter
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchWithDataFilterWidget(
                          searchHint: "Search posts",
                          onQuery: (query) {
                            searchKeyword = query;
                            _fetchData();
                          },
                        ),
                        const SizedBox(height: 5),
                        //Data filter
                        DataFilterMenu(
                          onFilterApply: () {
                            _fetchData();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: AddressWithLocateMe(
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
                  ),

                  Expanded(
                    child: BlocBuilder<CategoryWiseFeedPostCubit,
                        CategoryWiseFeedPostState>(
                      builder: (context, categoryWiseSocialPostState) {
                        if (categoryWiseSocialPostState.error != null) {
                          return ErrorTextWidget(
                              error: categoryWiseSocialPostState.error!);
                        } else if (categoryWiseSocialPostState.dataLoading) {
                          return const PostListShimmer();
                        } else {
                          final profileSettingsModel = context
                              .read<ProfileSettingsCubit>()
                              .state
                              .profileSettingsModel!;

                          final LatLng? socialMediaLocation =
                              profileSettingsModel.socialMediaLocation == null
                                  ? null
                                  : LatLng(
                                      profileSettingsModel
                                          .socialMediaLocation!.latitude,
                                      profileSettingsModel
                                          .socialMediaLocation!.longitude,
                                    );

                          final socialMediaCoveredAreaRadius =
                              profileSettingsModel
                                  .feedRadiusModel.socialMediaSearchRadius;

                          return SocialMediaMapListViewWidget(
                            socialPosts: categoryWiseSocialPostState
                                .categoryWiseFeedPosts.socialPostList,
                            customMarker: widget.categoryType ==
                                    FeedPostCategoryType.lostFound
                                ? PNGAssetsImages.lostFoundMapMarker
                                : PNGAssetsImages.safetyMapMarker,
                            initialLocation: socialMediaLocation,
                            coveredAreaRadius: socialMediaCoveredAreaRadius,
                            onRefresh: () async => _fetchData(),
                            child: Column(
                              children: [

                                if (widget.categoryType == FeedPostCategoryType.safety)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0,bottom: 5),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: FloatingActionButton(
                                        mini: true,
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          GoRouter.of(context)
                                              .pushNamed(HelplineNumbersScreen.routeName);
                                        },
                                        backgroundColor: ApplicationColours.themeBlueColor,
                                        child: SvgPicture.asset(
                                          SVGAssetsImages.helpline,
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                CategoryWiseFeedPostListView(
                                  socialPostList: categoryWiseSocialPostState
                                      .categoryWiseFeedPosts,
                                  onPagination: () {
                                    //Load more data
                                    _fetchData(loadMoreData: true);
                                  },
                                  refreshParentData: () {
                                    //Refresh the data on the screen
                                    _fetchData();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
          floatingActionButton: ManagePostActionButton(
            onPressed: () {
              _onCreatePost();
            },
            text: widget.categoryType == FeedPostCategoryType.safety
                ? tr(LocaleKeys.postSafety)
                : tr(LocaleKeys.createPost),
          ),
        );
      }),
    );
  }
}

class CategoryWisePostViewOnMapData extends StatelessWidget {
  const CategoryWisePostViewOnMapData({
    super.key,
    required this.postDetails,
  });

  final SocialPostModel postDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigate to the shared post details screen to
        //load the post details with new state
        final sharePostLinkData = SharedPostDataModel(
          postId: postDetails.id,
          postType: postDetails.postType,
          postFrom: postDetails.postFrom,
          shareType: ShareType.general,
        );

        GoRouter.of(context).pushNamed(
          GeneralSharedSocialPostDetails.routeName,
          extra: sharePostLinkData,
        );
      },
      child: AbsorbPointer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostHeadingWidget(
              postPrivacy: postDetails.postVisibilityPermission,
              title: postDetails.postUserInfo.userName,
              isVerified: postDetails.postUserInfo.isVerified,
              address: postDetails.postLocation.address,
              imageUrl: postDetails.postUserInfo.userImage,
              postType: postDetails.postType.displayText,
              userType: postDetails.postUserInfo.userType,
              createdAt: postDetails.createdAt,
              levelBadgeModel: postDetails.postUserInfo.levelBadgeModel,
            ),
            CategoryWisePostViewOnMapDataContent(socialPostModel: postDetails),
          ],
        ),
      ),
    );
  }
}

class CategoryWisePostViewOnMapDataContent extends StatelessWidget {
  final SocialPostModel socialPostModel;
  const CategoryWisePostViewOnMapDataContent({
    super.key,
    required this.socialPostModel,
  });

  Widget content({
    LocationAddressWithLatLng? tagLocation,
    required String title,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tagLocation != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: AddressWithLocationIconWidget(
                iconSize: 14,
                iconTopPadding: 1,
                fontSize: 11,
                iconColour: ApplicationColours.themePinkColor,
                textColour: ApplicationColours.themeBlueColor,
                address: tagLocation.address,
                latitude: tagLocation.latitude,
                longitude: tagLocation.longitude,
                enableOpeningMap: false,
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    switch (socialPostModel.runtimeType) {
      case const (LostFoundPostModel):
        final postDetails = socialPostModel as LostFoundPostModel;
        return content(
          title:
              "${postDetails.lostFoundType.displayName}: ${postDetails.title}",
          tagLocation: postDetails.taggedlocation,
        );

      case const (SafetyPostModel):
        final postDetails = socialPostModel as SafetyPostModel;
        return content(
          title: postDetails.title,
          tagLocation: postDetails.taggedlocation,
        );
      default:
        throw ("Invalid post view format");
    }
  }
}

class CategoryWiseFeedPostListView extends StatelessWidget {
  final SocialPostsList socialPostList;
  final void Function() onPagination;
  final void Function() refreshParentData;

  const CategoryWiseFeedPostListView({
    super.key,
    required this.socialPostList,
    required this.onPagination,
    required this.refreshParentData,
  });

  @override
  Widget build(BuildContext context) {
    return SocialPostListBuilder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      socialPostsModel: socialPostList,
      onRemoveItemFromList: (index) {
        context.read<CategoryWiseFeedPostCubit>().removePost(index);
      },
      onPaginationDataFetch: onPagination,
      enableVisibilityPaginationDataCallBack: true,
      visibilityDetectorKeyValue: "category_wise_feed_posts",
      refreshParentData: refreshParentData,
    );
  }
}
