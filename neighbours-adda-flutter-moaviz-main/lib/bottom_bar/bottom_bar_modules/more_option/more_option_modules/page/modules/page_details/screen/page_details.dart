import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_followers.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/logic/manage_page/manage_page_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/repository/manage_page_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/logic/page_details/page_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/screen/manage_page_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/widgets/page_connection_action_widgets.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/repository/page_details_repository.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/create_post_widget.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/action_dialog_widget.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/widget/analytics_overview_button.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/page_communication.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/common/utils/follower_list/screen/follower_list_screen.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/widgets/block_status.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/constant/names.dart';
import 'package:snap_local/utility/helper/confirmation_dialog.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

import '../../../../../../../../tutorial_screens/tutorial_logic/logic.dart';
import '../widgets/page_details_widget.dart';

class PageDetailsScreen extends StatefulWidget {
  final String pageId;
  const PageDetailsScreen({
    super.key,
    required this.pageId,
  });

  static const routeName = 'page_details';
  @override
  State<PageDetailsScreen> createState() => _PageDetailsScreenState();
}

class _PageDetailsScreenState extends State<PageDetailsScreen> {
  late PageDetailsCubit pageDetailsCubit;
  ShowReactionCubit showReactionCubit = ShowReactionCubit();
  final pagePostsScrollController = ScrollController();
  final ReportCubit reportCubit = ReportCubit(ReportRepository());
  final ManagePageCubit managePageCubit = ManagePageCubit(
      managePageRepository: ManagePageRepository(),
      mediaUploadRepository: MediaUploadRepository());
  late ChatControllerCubit chatControllerCubit = ChatControllerCubit(
    dataUploadStatusCubit: DataUploadStatusCubit(),
    firebaseChatRepository: context.read<FirebaseChatRepository>(),
  );
  @override
  void initState() {
    super.initState();

    pageDetailsCubit = PageDetailsCubit(PageDetailsRepository());
    pageDetailsCubit.fetchPageDetails(
        pageId: widget.pageId, enableLoading: true);

    pagePostsScrollController.addListener(() {
      //When scrolling ensure that, the reaction option is close
      showReactionCubit.closeReactionEmojiOption();

      if (pagePostsScrollController.position.maxScrollExtent ==
          pagePostsScrollController.offset) {
        pageDetailsCubit.fetchPageDetails(
            pageId: widget.pageId, loadMoreData: true);
      }
    });
    //handlePageDetailsTutorial(context);
  }

  @override
  void dispose() {
    super.dispose();
    pagePostsScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.of(context).size;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: pageDetailsCubit),
        BlocProvider.value(value: showReactionCubit),
        BlocProvider.value(value: reportCubit),
        BlocProvider.value(value: managePageCubit),
        BlocProvider.value(value: chatControllerCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ManagePageCubit, ManagePageState>(
          listener: (context, managePageState) {
            if (managePageState.deleteSuccess) {
              context
                  .read<PageListCubit>()
                  .fetchPages(pageListType: PageListType.managedByYou);
              GoRouter.of(context).pop();
            } else if (managePageState.toggleBlockSuccess) {
              pageDetailsCubit.fetchPageDetails(
                  pageId: widget.pageId, enableLoading: true);
              context
                  .read<PageListCubit>()
                  .fetchPages(pageListType: PageListType.pagesYouFollow);
              // GoRouter.of(context).pop();
            }
          },
          builder: (context, managePageState) {
            return BlocBuilder<PageDetailsCubit, PageDetailsState>(
              builder: (context, pageDetailsState) {
                if (pageDetailsState.error != null) {
                  return ErrorTextWidget(error: pageDetailsState.error!);
                } else if (pageDetailsState.dataLoading) {
                  return const ThemeSpinner();
                } else if (pageDetailsState.pageDetailsModel == null) {
                  return const ErrorTextWidget(
                      error: "Unable to load the Page details");
                } else {
                  final pageDetails = pageDetailsState.pageDetailsModel!;
                  final pageConnectionDetails =
                      pageDetails.pageConnectionDetailsModel;
                  final pageProfileDetails =
                      pageDetails.pageProfileDetailsModel;
                  final pagePostsModel = pageDetails.pagePosts;

                  return Stack(
                    children: [
                      NestedScrollView(
                        controller: pagePostsScrollController,
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
                                      if (!pageProfileDetails.isPageAdmin)
                                        Container(
                                          height: 35,
                                          width: 35,
                                          margin: EdgeInsets.only(right: 6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade200,
                                          ),
                                          child: AnimatedSwitcher(
                                            duration:
                                            const Duration(milliseconds: 500),
                                            child: pageDetailsState
                                                .favoriteLoading
                                                ? ThemeSpinner(
                                                  size: 30,
                                                  color: ApplicationColours.themeBlueColor,
                                                )
                                                : IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                context
                                                    .read<
                                                    PageDetailsCubit>()
                                                    .toggleFavouritePage(
                                                  widget.pageId,
                                                );
                                              },
                                              icon: pageProfileDetails
                                                  .isFavorite
                                                  ?  Icon(
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
                                            onTap: managePageState.deleteLoading
                                                ? null
                                                : () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => Dialog(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10),
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize
                                                            .min,
                                                        children: [
                                                          if (!pageProfileDetails
                                                              .isPageAdmin)
                                                            Column(
                                                              children: [
                                                                //report page
                                                                ActionDialogOption(
                                                                  svgImage:
                                                                  SVGAssetsImages.report,
                                                                  title: tr(
                                                                      LocaleKeys.report),
                                                                  //you can report this page
                                                                  subtitle:
                                                                  tr(LocaleKeys.youcanreportthispage),
                                                                  onTap:
                                                                      () {
                                                                    if (managePageState
                                                                        .deleteLoading) {
                                                                      return;
                                                                    }
                                                                    GoRouter.of(context)
                                                                        .pushNamed(
                                                                      ReportScreen.routeName,
                                                                      extra:
                                                                      PageReportPayload(
                                                                        pageId: pageDetails.pageProfileDetailsModel.id,
                                                                        reportCubit: context.read<ReportCubit>(),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),

                                                                //toggle block
                                                                ActionDialogOption(
                                                                  showdivider:
                                                                  false,
                                                                  svgImage:
                                                                  SVGAssetsImages.block,
                                                                  title: pageProfileDetails.blockedByUser
                                                                      ? tr(LocaleKeys.unBlock)
                                                                      : tr(LocaleKeys.block),
                                                                  //you can block this page
                                                                  subtitle: pageProfileDetails.blockedByUser
                                                                      ? tr(LocaleKeys.youcanunblockthispage)
                                                                      : tr(LocaleKeys.youcanblockthispage),
                                                                  onTap:
                                                                      () {
                                                                    if (managePageState
                                                                        .deleteLoading) {
                                                                      return;
                                                                    }
                                                                    showConfirmationDialog(
                                                                      context,
                                                                      confirmationButtonText: pageProfileDetails.blockedByUser
                                                                          ? tr(LocaleKeys.unBlock)
                                                                          : tr(LocaleKeys.block),
                                                                      message:
                                                                      'Are you sure you want to ${pageProfileDetails.blockedByUser ? 'unblock' : 'block'} this page?',
                                                                    ).then(
                                                                            (allowBlock) {
                                                                          if (allowBlock != null &&
                                                                              allowBlock) {
                                                                            context.read<ManagePageCubit>().toggleBlockPage(widget.pageId);
                                                                          }
                                                                        });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          if (pageProfileDetails
                                                              .isPageAdmin)
                                                          //Delete post
                                                            ActionDialogOption(
                                                              showdivider:
                                                              false,
                                                              svgImage:
                                                              SVGAssetsImages
                                                                  .delete,
                                                              title: tr(
                                                                  LocaleKeys
                                                                      .delete),
                                                              //you can delete your page
                                                              subtitle: tr(
                                                                  LocaleKeys
                                                                      .youcandeleteyourpage),
                                                              onTap:
                                                                  () async {
                                                                if (managePageState
                                                                    .deleteLoading) {
                                                                  return;
                                                                }
                                                                await showConfirmationDialog(
                                                                  context,
                                                                  confirmationButtonText:
                                                                  tr(LocaleKeys.delete),
                                                                  message:
                                                                  'Are you sure you want to permanently remove this page from $applicationName?',
                                                                ).then(
                                                                        (allowDelete) {
                                                                      if (allowDelete !=
                                                                          null &&
                                                                          allowDelete) {
                                                                        context
                                                                            .read<ManagePageCubit>()
                                                                            .deletePage(widget.pageId);
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
                                      //   AnimatedSwitcher(
                                      //     duration:
                                      //         const Duration(milliseconds: 500),
                                      //     child: pageDetailsState
                                      //             .favoriteLoading
                                      //         ? const Padding(
                                      //             padding: EdgeInsets.only(
                                      //                 right: 10),
                                      //             child: ThemeSpinner(
                                      //               size: 25,
                                      //               color: Colors.yellow,
                                      //             ),
                                      //           )
                                      //         : IconButton(
                                      //             onPressed: () {
                                      //               context
                                      //                   .read<
                                      //                       PageDetailsCubit>()
                                      //                   .toggleFavouritePage(
                                      //                     widget.pageId,
                                      //                   );
                                      //             },
                                      //             icon: pageProfileDetails
                                      //                     .isFavorite
                                      //                 ? const Icon(
                                      //                     Icons.star,
                                      //                     color: Colors.yellow,
                                      //                   )
                                      //                 : const Icon(
                                      //                     Icons.star_border,
                                      //                     color: Colors.yellow,
                                      //                   ),
                                      //           ),
                                      //   ),
                                      // SvgButtonWidget(
                                      //   svgImage: SVGAssetsImages.moreDot,
                                      //   onTap: managePageState.deleteLoading
                                      //       ? null
                                      //       : () {
                                      //           showDialog(
                                      //               context: context,
                                      //               builder: (_) => Dialog(
                                      //                     child: Padding(
                                      //                       padding:
                                      //                           const EdgeInsets
                                      //                               .symmetric(
                                      //                               vertical:
                                      //                                   10),
                                      //                       child: Column(
                                      //                         mainAxisSize:
                                      //                             MainAxisSize
                                      //                                 .min,
                                      //                         children: [
                                      //                           if (!pageProfileDetails
                                      //                               .isPageAdmin)
                                      //                             Column(
                                      //                               children: [
                                      //                                 //report page
                                      //                                 ActionDialogOption(
                                      //                                   svgImage:
                                      //                                       SVGAssetsImages.report,
                                      //                                   title: tr(
                                      //                                       LocaleKeys.report),
                                      //                                   //you can report this page
                                      //                                   subtitle:
                                      //                                       tr(LocaleKeys.youcanreportthispage),
                                      //                                   onTap:
                                      //                                       () {
                                      //                                     if (managePageState
                                      //                                         .deleteLoading) {
                                      //                                       return;
                                      //                                     }
                                      //                                     GoRouter.of(context)
                                      //                                         .pushNamed(
                                      //                                       ReportScreen.routeName,
                                      //                                       extra:
                                      //                                           PageReportPayload(
                                      //                                         pageId: pageDetails.pageProfileDetailsModel.id,
                                      //                                         reportCubit: context.read<ReportCubit>(),
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
                                      //                                       SVGAssetsImages.block,
                                      //                                   title: pageProfileDetails.blockedByUser
                                      //                                       ? tr(LocaleKeys.unBlock)
                                      //                                       : tr(LocaleKeys.block),
                                      //                                   //you can block this page
                                      //                                   subtitle: pageProfileDetails.blockedByUser
                                      //                                       ? tr(LocaleKeys.youcanunblockthispage)
                                      //                                       : tr(LocaleKeys.youcanblockthispage),
                                      //                                   onTap:
                                      //                                       () {
                                      //                                     if (managePageState
                                      //                                         .deleteLoading) {
                                      //                                       return;
                                      //                                     }
                                      //                                     showConfirmationDialog(
                                      //                                       context,
                                      //                                       confirmationButtonText: pageProfileDetails.blockedByUser
                                      //                                           ? tr(LocaleKeys.unBlock)
                                      //                                           : tr(LocaleKeys.block),
                                      //                                       message:
                                      //                                           'Are you sure you want to ${pageProfileDetails.blockedByUser ? 'unblock' : 'block'} this page?',
                                      //                                     ).then(
                                      //                                         (allowBlock) {
                                      //                                       if (allowBlock != null &&
                                      //                                           allowBlock) {
                                      //                                         context.read<ManagePageCubit>().toggleBlockPage(widget.pageId);
                                      //                                       }
                                      //                                     });
                                      //                                   },
                                      //                                 ),
                                      //                               ],
                                      //                             ),
                                      //                           if (pageProfileDetails
                                      //                               .isPageAdmin)
                                      //                             //Delete post
                                      //                             ActionDialogOption(
                                      //                               showdivider:
                                      //                                   false,
                                      //                               svgImage:
                                      //                                   SVGAssetsImages
                                      //                                       .delete,
                                      //                               title: tr(
                                      //                                   LocaleKeys
                                      //                                       .delete),
                                      //                               //you can delete your page
                                      //                               subtitle: tr(
                                      //                                   LocaleKeys
                                      //                                       .youcandeleteyourpage),
                                      //                               onTap:
                                      //                                   () async {
                                      //                                 if (managePageState
                                      //                                     .deleteLoading) {
                                      //                                   return;
                                      //                                 }
                                      //                                 await showConfirmationDialog(
                                      //                                   context,
                                      //                                   confirmationButtonText:
                                      //                                       tr(LocaleKeys.delete),
                                      //                                   message:
                                      //                                       'Are you sure you want to permanently remove this page from $applicationName?',
                                      //                                 ).then(
                                      //                                     (allowDelete) {
                                      //                                   if (allowDelete !=
                                      //                                           null &&
                                      //                                       allowDelete) {
                                      //                                     context
                                      //                                         .read<ManagePageCubit>()
                                      //                                         .deletePage(widget.pageId);
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
                                          pageProfileDetails.coverImage),
                                      swipeDismissible: true,
                                      doubleTapZoomable: true,
                                      backgroundColor: Colors.black,
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    cacheKey: pageProfileDetails.coverImage,
                                    imageUrl: pageProfileDetails.coverImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              bottom: PreferredSize(
                                preferredSize:
                                    Size.fromHeight(mqSize.height * 0.15),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Page details
                                            PageDetailWidget(
                                              showFollower: pageProfileDetails
                                                      .isPageAdmin ||
                                                  pageProfileDetails
                                                      .showFollower,
                                              horizontalPadding: 0,
                                              pageName: pageProfileDetails.name,
                                              isVerified: pageProfileDetails.isVerified,
                                              category: pageProfileDetails
                                                  .category
                                                  .subCategoryString(),
                                              followerCount: pageProfileDetails
                                                  .totalFollowers,
                                              description: pageProfileDetails
                                                  .description,
                                              onTap: () {
                                                final pageFollowers =
                                                    PageFollowers(
                                                  profileSettingsModel: context
                                                      .read<
                                                          ProfileSettingsCubit>()
                                                      .state
                                                      .profileSettingsModel!,
                                                  isPageAdmin:
                                                      pageProfileDetails
                                                          .isPageAdmin,
                                                  pageName:
                                                      pageProfileDetails.name,
                                                  isVerified: pageProfileDetails.isVerified,
                                                  category: pageProfileDetails
                                                      .category
                                                      .selectedCategories
                                                      .map((e) => e.name)
                                                      .join(","),
                                                  followerCount:
                                                      pageProfileDetails
                                                          .totalFollowers,
                                                  descrption: pageProfileDetails
                                                      .description,
                                                  showFollower:
                                                      pageProfileDetails
                                                              .showFollower ||
                                                          pageProfileDetails
                                                              .isPageAdmin,
                                                );

                                                GoRouter.of(context).pushNamed(
                                                  FollowerListScreen.routeName,
                                                  extra: pageFollowers,
                                                  queryParameters: {
                                                    'id': pageProfileDetails.id,
                                                  },
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  //Page actions
                                                  SizedBox(
                                                    width: mqSize.width * 0.80,
                                                    child:
                                                        PageConnectionActionWidget(
                                                      pageId: widget.pageId,
                                                      isPageOwner:
                                                          pageProfileDetails
                                                              .isPageAdmin,
                                                      connectionStatus:
                                                          pageConnectionDetails
                                                              .connectionStatus,
                                                      pageProfileDetailsModel:
                                                          pageProfileDetails,
                                                      requestSuccessCallback:
                                                          () {
                                                        context
                                                            .read<
                                                                PageDetailsCubit>()
                                                            .fetchPageDetails(
                                                                pageId: widget
                                                                    .pageId);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Analytics Overview
                                            if (pageDetails
                                                .pageProfileDetailsModel
                                                .isPageAdmin)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: AnalyticsOverviewButton(
                                                  moduleId: widget.pageId,
                                                  moduleType:
                                                      AnalyticsModuleType.page,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      //chat button
                                      Visibility(
                                        visible:
                                            !pageProfileDetails.isPageAdmin &&
                                                pageProfileDetails.enableChat,
                                        child: PageChatButton(
                                          pageProfileDetails:
                                              pageProfileDetails,
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
                              .read<PageDetailsCubit>()
                              .fetchPageDetails(pageId: widget.pageId),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              const ThemeDivider(height: 2, thickness: 2),
                              BlockStatus(
                                //page block status
                                isAdmin: pageProfileDetails.isPageAdmin,
                                blockedByAdmin:
                                    pageProfileDetails.blockedByAdmin,
                                blockedByUser: pageProfileDetails.blockedByUser,

                                //block messages
                                blockedByPageAdminMessage:
                                    LocaleKeys.thispageisnotavailable,
                                blockedByUserMessage:
                                    LocaleKeys.youcantviewthispage,
                              ),
                              Visibility(
                                visible: pageProfileDetails.isPageAdmin,
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: CreatePostWidget(
                                        searchBoxHint:
                                            LocaleKeys.createANewPost,
                                        onCreatePost: () {
                                          GoRouter.of(context).pushNamed(
                                            ManagePagePostScreen.routeName,
                                            queryParameters: {
                                              'page_id': widget.pageId
                                            },
                                          ).whenComplete(() {
                                            context
                                                .read<PageDetailsCubit>()
                                                .fetchPageDetails(
                                                    pageId: widget.pageId);
                                          });
                                        },
                                      ),
                                    ),
                                    const ThemeDivider(height: 2, thickness: 2),
                                  ],
                                ),
                              ),
                              SocialPostListBuilder(
                                allowNavigation: false,
                                onRemoveItemFromList: (index) {
                                  context
                                      .read<PageDetailsCubit>()
                                      .removePost(index);
                                },
                                socialPostsModel: pagePostsModel,
                                onPaginationDataFetch: () {
                                  context
                                      .read<PageDetailsCubit>()
                                      .fetchPageDetails(
                                          pageId: widget.pageId,
                                          loadMoreData: true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      //show loading
                      Visibility(
                        visible: managePageState.deleteLoading ||
                            managePageState.toggleBlockLoading,
                        child: Positioned.fill(
                          child: Container(
                            color: Colors.black38,
                            child: const ThemeSpinner(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class PageChatButton extends StatelessWidget {
  const PageChatButton({
    super.key,
    required this.pageProfileDetails,
  });

  final PageProfileDetailsModel pageProfileDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatControllerCubit, ChatControllerState>(
      builder: (context, chatControllerState) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: chatControllerState.messageSendLoading
              ? const ThemeSpinner(size: 15)
              : Column(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: ApplicationColours.themeBlueColor,
                      child: SvgButtonWidget(
                        svgImage: SVGAssetsImages.homechat,
                        svgColorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        onTap: () async {
                          final otherCommunication = PageCommunicationImpl(
                            id: pageProfileDetails.id,
                            pageAdminId: pageProfileDetails.userId,
                            pageName: pageProfileDetails.name,
                          );

                          //navigate to chat screen
                          GoRouter.of(context).pushNamed(
                            ChatScreen.routeName,
                            queryParameters: {
                              "receiver_user_id": pageProfileDetails.userId,
                            },
                            extra: otherCommunication,
                          );
                        },
                        svgSize: 24,
                      ),
                    ),
                    Text(
                      tr(LocaleKeys.chat),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
