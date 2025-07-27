import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/logic/group_details/group_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_member.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/screen/manage_group_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/widgets/group_connection_action_widgets.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/repository/group_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/widget/group_detail_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_widget.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/follower_list/screen/follower_list_screen.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/constant/names.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

import '../../../../../../tutorial_screens/tutorial_logic/logic.dart';
import '../../../../../../utility/constant/application_colours.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupId;
  final int? groupIndex;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
    this.groupIndex,
  });

  static const routeName = 'group_details';
  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late GroupDetailsCubit groupDetailsCubit =
      GroupDetailsCubit(context.read<GroupDetailsRepository>())
        ..fetchGroupDetails(groupId: widget.groupId, enableLoading: true);
  ShowReactionCubit showReactionCubit = ShowReactionCubit();
  final ReportCubit reportCubit = ReportCubit(ReportRepository());
  final groupPostsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    groupPostsScrollController.addListener(() {
      //When scrolling ensure that, the reaction option is close
      showReactionCubit.closeReactionEmojiOption();

      if (groupPostsScrollController.position.maxScrollExtent ==
          groupPostsScrollController.offset) {
        groupDetailsCubit.fetchGroupDetails(
          groupId: widget.groupId,
          loadMoreData: true,
        );
      }
    });
    //handleGroupDetailsTutorial(context);
  }

  @override
  void dispose() {
    groupPostsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mqSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: groupDetailsCubit),
        BlocProvider.value(value: showReactionCubit),
        BlocProvider.value(value: reportCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<GroupDetailsCubit, GroupDetailsState>(
          listener: (context, groupDetailsState) {
            final groupProfileDetails =
                groupDetailsState.groupDetailsModel?.groupProfileDetailsModel;
            if (groupProfileDetails != null &&
                groupProfileDetails.isGroupAdmin) {
              //If the current user is the group admin, then trigger the
              //private group join request to fetch pending requests list
            }
            if (groupDetailsState.deleteSuccess) {
              context
                  .read<GroupListCubit>()
                  .fetchGroups(groupListType: GroupListType.managedByYou);
              GoRouter.of(context).pop();
            } else if (groupDetailsState.toggleBlockSuccess) {
              groupDetailsCubit.fetchGroupDetails(
                  enableLoading: true, groupId: widget.groupId);
              context
                  .read<GroupListCubit>()
                  .fetchGroups(groupListType: GroupListType.groupsYouJoined);
              // GoRouter.of(context).pop();
            }
          },
          builder: (context, groupDetailsState) {
            if (groupDetailsState.error != null) {
              return ErrorTextWidget(error: groupDetailsState.error!);
            } else if (groupDetailsState.groupDetailsModel == null ||
                groupDetailsState.dataLoading) {
              return const ThemeSpinner();
            } else {
              final groupDetails = groupDetailsState.groupDetailsModel!;
              final groupConnectionDetails =
                  groupDetails.groupConnectionDetailsModel;
              final groupProfileDetails = groupDetails.groupProfileDetailsModel;
              final groupPostsModel = groupDetails.groupPosts;

              return NestedScrollView(
                controller: groupPostsScrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      floating: true,
                      expandedHeight: mqSize.height * 0.5,
                      titleSpacing: 0,
                      leading: const IOSBackButton(),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              if (!groupProfileDetails.isGroupAdmin)
                                Container(
                                  height: 35,
                                  width: 35,
                                  margin: EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: groupDetailsState.favoriteLoading
                                        ? ThemeSpinner(
                                          size: 30,
                                          color: ApplicationColours.themeBlueColor,
                                        )
                                        : IconButton(
                                      padding: EdgeInsets.zero,
                                            onPressed: groupDetailsState
                                                    .favoriteLoading
                                                ? null
                                                : () {
                                                    context
                                                        .read<GroupDetailsCubit>()
                                                        .toggleFavoriteGroup(
                                                            widget.groupId);
                                                  },
                                            icon: groupProfileDetails.isFavorite
                                                ? Icon(
                                                    Icons.star,
                                                    color: ApplicationColours.themeBlueColor,
                                                  )
                                                :  Icon(
                                                    Icons.star_border,
                                                    color: ApplicationColours.themeBlueColor,
                                                  ),
                                          ),
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  margin: EdgeInsets.only(left: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child: InkWell(
                                      onTap: groupDetailsState.deleteLoading
                                          ? null
                                          : () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 10),
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    if (!groupProfileDetails
                                                        .isGroupAdmin)
                                                      Column(
                                                        children: [
                                                          //report page
                                                          ActionDialogOption(
                                                            svgImage:
                                                            SVGAssetsImages
                                                                .report,
                                                            title: tr(
                                                                LocaleKeys
                                                                    .report),
                                                            //you can report this page
                                                            subtitle: tr(
                                                                LocaleKeys
                                                                    .youcanreportthisgroup),
                                                            onTap: () {
                                                              if (groupDetailsState
                                                                  .deleteLoading) {
                                                                return;
                                                              }
                                                              GoRouter.of(
                                                                  context)
                                                                  .pushNamed(
                                                                ReportScreen
                                                                    .routeName,
                                                                extra:
                                                                GroupReportPayload(
                                                                  groupId:
                                                                  groupProfileDetails
                                                                      .id,
                                                                  reportCubit:
                                                                  context
                                                                      .read<ReportCubit>(),
                                                                ),
                                                              );
                                                            },
                                                          ),

                                                          //toggle block
                                                          ActionDialogOption(
                                                            showdivider:
                                                            false,
                                                            svgImage:
                                                            SVGAssetsImages
                                                                .block,
                                                            title: groupProfileDetails
                                                                .blockedByUser
                                                                ? tr(LocaleKeys
                                                                .unBlock)
                                                                : tr(LocaleKeys
                                                                .block),
                                                            //you can block this page
                                                            subtitle: groupProfileDetails
                                                                .blockedByUser
                                                                ? tr(LocaleKeys
                                                                .youcanunblockthisgroup)
                                                                : tr(LocaleKeys
                                                                .youcanblockthisgroup),
                                                            onTap: () {
                                                              if (groupDetailsState
                                                                  .deleteLoading) {
                                                                return;
                                                              }
                                                              showConfirmationDialog(
                                                                context,
                                                                confirmationButtonText: groupProfileDetails
                                                                    .blockedByUser
                                                                    ? tr(LocaleKeys
                                                                    .unBlock)
                                                                    : tr(LocaleKeys
                                                                    .block),
                                                                message:
                                                                'Are you sure you want to ${groupProfileDetails.blockedByUser ? 'unblock' : 'block'} this group?',
                                                              ).then(
                                                                      (allowBlock) {
                                                                    if (allowBlock !=
                                                                        null &&
                                                                        allowBlock &&
                                                                        context
                                                                            .mounted) {
                                                                      context
                                                                          .read<
                                                                          GroupDetailsCubit>()
                                                                          .toggleBlockGroup(
                                                                          widget.groupId);
                                                                    }
                                                                  });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    if (groupProfileDetails
                                                        .isGroupAdmin)
                                                    //Delete post
                                                      ActionDialogOption(
                                                        showdivider: false,
                                                        svgImage:
                                                        SVGAssetsImages
                                                            .delete,
                                                        title: tr(LocaleKeys
                                                            .delete),
                                                        //you can delete your page
                                                        subtitle: tr(LocaleKeys
                                                            .youcandeletethisgroup),
                                                        onTap: () async {
                                                          if (groupDetailsState
                                                              .deleteLoading) {
                                                            return;
                                                          }
                                                          await showConfirmationDialog(
                                                            context,
                                                            confirmationButtonText:
                                                            tr(LocaleKeys
                                                                .delete),
                                                            message:
                                                            'Are you sure you want to permanently remove this group from $applicationName?',
                                                          ).then(
                                                                  (allowDelete) {
                                                                if (allowDelete !=
                                                                    null &&
                                                                    allowDelete) {
                                                                  context
                                                                      .read<
                                                                      GroupDetailsCubit>()
                                                                      .deleteGroup(
                                                                      widget
                                                                          .groupId);
                                                                }
                                                              });
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      },
                                      child: Icon(Icons.more_horiz,size: 24,color: Colors.black,)),
                                ),
                              // SvgButtonWidget(
                              //   svgImage: SVGAssetsImages.moreDot,
                              //   onTap: groupDetailsState.deleteLoading
                              //       ? null
                              //       : () {
                              //           showDialog(
                              //               context: context,
                              //               builder: (_) => Dialog(
                              //                     child: Padding(
                              //                       padding: const EdgeInsets
                              //                           .symmetric(
                              //                           vertical: 10),
                              //                       child: Column(
                              //                         mainAxisSize:
                              //                             MainAxisSize.min,
                              //                         children: [
                              //                           if (!groupProfileDetails
                              //                               .isGroupAdmin)
                              //                             Column(
                              //                               children: [
                              //                                 //report page
                              //                                 ActionDialogOption(
                              //                                   svgImage:
                              //                                       SVGAssetsImages
                              //                                           .report,
                              //                                   title: tr(
                              //                                       LocaleKeys
                              //                                           .report),
                              //                                   //you can report this page
                              //                                   subtitle: tr(
                              //                                       LocaleKeys
                              //                                           .youcanreportthisgroup),
                              //                                   onTap: () {
                              //                                     if (groupDetailsState
                              //                                         .deleteLoading) {
                              //                                       return;
                              //                                     }
                              //                                     GoRouter.of(
                              //                                             context)
                              //                                         .pushNamed(
                              //                                       ReportScreen
                              //                                           .routeName,
                              //                                       extra:
                              //                                           GroupReportPayload(
                              //                                         groupId:
                              //                                             groupProfileDetails
                              //                                                 .id,
                              //                                         reportCubit:
                              //                                             context
                              //                                                 .read<ReportCubit>(),
                              //                                       ),
                              //                                     );
                              //                                   },
                              //                                 ),
                              //
                              //                                 //toggle block
                              //                                 ActionDialogOption(
                              //                                   showdivider:
                              //                                       false,
                              //                                   svgImage:
                              //                                       SVGAssetsImages
                              //                                           .block,
                              //                                   title: groupProfileDetails
                              //                                           .blockedByUser
                              //                                       ? tr(LocaleKeys
                              //                                           .unBlock)
                              //                                       : tr(LocaleKeys
                              //                                           .block),
                              //                                   //you can block this page
                              //                                   subtitle: groupProfileDetails
                              //                                           .blockedByUser
                              //                                       ? tr(LocaleKeys
                              //                                           .youcanunblockthisgroup)
                              //                                       : tr(LocaleKeys
                              //                                           .youcanblockthisgroup),
                              //                                   onTap: () {
                              //                                     if (groupDetailsState
                              //                                         .deleteLoading) {
                              //                                       return;
                              //                                     }
                              //                                     showConfirmationDialog(
                              //                                       context,
                              //                                       confirmationButtonText: groupProfileDetails
                              //                                               .blockedByUser
                              //                                           ? tr(LocaleKeys
                              //                                               .unBlock)
                              //                                           : tr(LocaleKeys
                              //                                               .block),
                              //                                       message:
                              //                                           'Are you sure you want to ${groupProfileDetails.blockedByUser ? 'unblock' : 'block'} this group?',
                              //                                     ).then(
                              //                                         (allowBlock) {
                              //                                       if (allowBlock !=
                              //                                               null &&
                              //                                           allowBlock &&
                              //                                           context
                              //                                               .mounted) {
                              //                                         context
                              //                                             .read<
                              //                                                 GroupDetailsCubit>()
                              //                                             .toggleBlockGroup(
                              //                                                 widget.groupId);
                              //                                       }
                              //                                     });
                              //                                   },
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           if (groupProfileDetails
                              //                               .isGroupAdmin)
                              //                             //Delete post
                              //                             ActionDialogOption(
                              //                               showdivider: false,
                              //                               svgImage:
                              //                                   SVGAssetsImages
                              //                                       .delete,
                              //                               title: tr(LocaleKeys
                              //                                   .delete),
                              //                               //you can delete your page
                              //                               subtitle: tr(LocaleKeys
                              //                                   .youcandeletethisgroup),
                              //                               onTap: () async {
                              //                                 if (groupDetailsState
                              //                                     .deleteLoading) {
                              //                                   return;
                              //                                 }
                              //                                 await showConfirmationDialog(
                              //                                   context,
                              //                                   confirmationButtonText:
                              //                                       tr(LocaleKeys
                              //                                           .delete),
                              //                                   message:
                              //                                       'Are you sure you want to permanently remove this group from $applicationName?',
                              //                                 ).then(
                              //                                     (allowDelete) {
                              //                                   if (allowDelete !=
                              //                                           null &&
                              //                                       allowDelete) {
                              //                                     context
                              //                                         .read<
                              //                                             GroupDetailsCubit>()
                              //                                         .deleteGroup(
                              //                                             widget
                              //                                                 .groupId);
                              //                                   }
                              //                                 });
                              //                               },
                              //                             ),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ));
                              //         },
                              //   svgSize: 28,
                              // ),
                            ],
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: GestureDetector(
                          onTap: () {
                            showImageViewer(
                              context,
                              CachedNetworkImageProvider(
                                  groupProfileDetails.coverImage),
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                              backgroundColor: Colors.black,
                            );
                          },
                          child: CachedNetworkImage(
                            cacheKey: groupProfileDetails.coverImage,
                            imageUrl: groupProfileDetails.coverImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(mqSize.height * 0.14),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Group details
                              GroupDetailWidget(
                                horizontalPadding: 0,
                                isVerified: groupProfileDetails.isVerified,
                                groupName: groupProfileDetails.name,
                                groupPrivacyType: groupProfileDetails
                                    .groupPrivacyType.dsiplayName,
                                category: groupProfileDetails.category
                                    .subCategoryString(),
                                followerCount: groupProfileDetails.totalMembers,
                                description: groupProfileDetails.description,
                                showFollower:
                                    groupProfileDetails.isGroupAdmin ||
                                        groupProfileDetails.showFollower,
                                onTap: () {
                                  final groupMember = GroupMember(
                                    isVerified: groupProfileDetails.isVerified,
                                    profileSettingsModel: context
                                        .read<ProfileSettingsCubit>()
                                        .state
                                        .profileSettingsModel!,
                                    isPageAdmin:
                                        groupProfileDetails.isGroupAdmin,
                                    groupName: groupProfileDetails.name,
                                    groupPrivacyType: groupProfileDetails
                                        .groupPrivacyType.dsiplayName,
                                    category: groupProfileDetails
                                        .category.selectedCategories
                                        .map((e) => e.name)
                                        .join(","),
                                    followerCount:
                                        groupProfileDetails.totalMembers,
                                    descrption: groupProfileDetails.description,
                                    showFollower:
                                        groupProfileDetails.isGroupAdmin ||
                                            groupProfileDetails.showFollower,
                                  );

                                  GoRouter.of(context).pushNamed(
                                    FollowerListScreen.routeName,
                                    extra: groupMember,
                                    queryParameters: {
                                      'id': groupProfileDetails.id,
                                    },
                                  );
                                },
                              ),

                              // Group action button
                              Visibility(
                                visible: !groupProfileDetails.blockedByUser &&
                                    !groupProfileDetails.blockedByAdmin,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GroupConnectionActionWidget(
                                    groupId: widget.groupId,
                                    groupIndex: widget.groupIndex,
                                    isGroupOwner:
                                        groupProfileDetails.isGroupAdmin,
                                    connectionStatus:
                                        groupConnectionDetails.connectionStatus,
                                    groupProfileDetailsModel:
                                        groupProfileDetails,
                                    requestSuccessCallback: () {
                                      context
                                          .read<GroupDetailsCubit>()
                                          .fetchGroupDetails(
                                              groupId: widget.groupId);
                                    },
                                  ),
                                ),
                              ),

                              //Analytics Overview
                              if (groupProfileDetails.isGroupAdmin)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: AnalyticsOverviewButton(
                                    moduleId: widget.groupId,
                                    moduleType: AnalyticsModuleType.group,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: RefreshIndicator.adaptive(
                  onRefresh: () async => context
                      .read<GroupDetailsCubit>()
                      .fetchGroupDetails(groupId: widget.groupId),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const ThemeDivider(height: 2, thickness: 2),
                      Visibility(
                        visible: (groupProfileDetails.isGroupAdmin ||
                                groupConnectionDetails.connectionStatus ==
                                    ConnectionStatus.connected) &&
                            !groupProfileDetails.blockedByAdmin,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: CreatePostWidget(
                                searchBoxHint: LocaleKeys.createANewPost,
                                onCreatePost: () {
                                  GoRouter.of(context).pushNamed(
                                    ManageGroupPostScreen.routeName,
                                    queryParameters: {
                                      'group_id': widget.groupId
                                    },
                                  ).whenComplete(() {
                                    context
                                        .read<GroupDetailsCubit>()
                                        .fetchGroupDetails(
                                            groupId: widget.groupId);
                                  });
                                },
                              ),
                            ),
                            const ThemeDivider(height: 2, thickness: 2),
                          ],
                        ),
                      ),
                      SocialPostListBuilder(
                        enableGroupHeaderView: false,
                        onRemoveItemFromList: (index) {
                          context.read<GroupDetailsCubit>().removePost(index);
                        },
                        socialPostsModel: groupPostsModel,
                        onPaginationDataFetch: () {
                          context.read<GroupDetailsCubit>().fetchGroupDetails(
                              groupId: widget.groupId, loadMoreData: true);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
