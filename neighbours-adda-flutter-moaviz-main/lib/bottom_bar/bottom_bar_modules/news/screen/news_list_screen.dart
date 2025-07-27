import 'dart:convert';

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/logic/content_filter_tab/content_filter_tab_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/model/content_filter_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/widget/content_filter_tab_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/logic/check_news_post_limit/check_news_post_limit_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_posts/news_posts_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/manage_news_post/manage_news_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/screen/manage_post_news.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/screen/my_dashboard_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/repository/news_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/join_us_dialog.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/news_language_change_popup.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/square_button.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/social_post_list_builder.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/category/v1/model/category_type_v1.dart';
import 'package:snap_local/common/utils/category/v1/model/category_v1_selection_strategy.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/tutorial_screens/tutorial_logic/logic.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/scroll_animate.dart';

import '../../../../tutorial_screens/news_tutorial.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});
  static const routeName = 'news';
  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  ScrollController newsScrollController = ScrollController();

  String searchKeyword = "";

  //Filter initialization
  DataFilterCubit dataFilterCubit = DataFilterCubit([
    //Sort filter
    SortFilter(
      filterName: tr(LocaleKeys.filter),
      sortFilterOptions: [
        SortFilterOption(sortType: SortFilterType.today),
        SortFilterOption(sortType: SortFilterType.thisWeek),
        SortFilterOption(sortType: SortFilterType.thisMonth),
      ],
    ),
  ]);

  final newsViewFilterCubit = ContentFilterTabCubit(
    NewsContentFilterModel(),
  )..selectViewFilter(1); //Select the Local news type by default

  //assign the News category cubit instance
  late CategoryControllerV1Cubit newsCategoryCubit = CategoryControllerV1Cubit(
      NewsCategoryTypeV1(MultieCategorySelectionStrategy()))
    ..fetchCategories();

  ShowReactionCubit showReactionCubit = ShowReactionCubit();
  late NewsPostsCubit newsCubit = NewsPostsCubit(NewsRepository())
    ..fetchNews(filterJson: filterJson, enableLoading: true);

  String get filterJson {
    final Map<String, dynamic> filterMap = {
      'type':
          newsViewFilterCubit.state.selectedViewFilter.viewFilterType.jsonValue,
    };

    //Add the data filter json in the filter map
    filterMap.addAll(dataFilterCubit.state.filterMap);

    //Add the category filter
    filterMap.addAll(newsCategoryCubit.state.selectedCategoryMap);

    return jsonEncode(filterMap);
  }

  @override
  initState() {
    super.initState();

    //Fetch own news channel data
    context.read<OwnNewsChannelCubit>().fetchOwnNewsChannel();

    newsScrollController.addListener(() {
      showReactionCubit.closeReactionEmojiOption();

      if (newsScrollController.position.pixels ==
          newsScrollController.position.maxScrollExtent) {
        fetchNews(loadMoreData: true);
      }
    });

    //listen to view filter change
    newsViewFilterCubit.stream.listen((newsViewFilterState) {
      if (newsViewFilterState.allowFetchData) {
        fetchNews(enableLoading: true);
      }
    });

    //Manage the bottom bar visibility on scroll
    ManageBottomBarVisibilityOnScroll(context).init(newsScrollController);
    //handleNewsTutorial(context);
  }

  void fetchNews({
    bool loadMoreData = false,
    bool allowDataFetch = true,
    bool enableLoading = false,
  }) {
    //Fetch the news data
    newsCubit.fetchNews(
      loadMoreData: loadMoreData,
      enableLoading: enableLoading,
      searchKeyword: searchKeyword,
      filterJson: filterJson,
    );
  }

  Future<void> _resetScrollToTop() async {
    await scrollAnimateTo(
      scrollController: newsScrollController,
      offset: 0,
    );
  }

  void willPopScope() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      context.read<BottomBarNavigatorCubit>().goToHome();
    }
  }

  @override
  void dispose() {
    newsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async {
      //   willPopScope();
      //   return false; // Prevent default back behavior since we're handling it manually
      // }
      // ,
      onWillPop: () async {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
          return false;
        } else {
          context.read<BottomBarNavigatorCubit>().goToHome();
          return false;
        }
      },
      child: Scaffold(
        body: BlocListener<BottomBarNavigatorCubit, BottomBarNavigatorState>(
          listener: (context, bottomBarNavigationState) async {
            if (bottomBarNavigationState.isLoading &&
                bottomBarNavigationState.currentSelectedScreenIndex == 1) {
              fetchNews();
              await _resetScrollToTop();
            }
          },
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: dataFilterCubit),
              BlocProvider.value(value: newsViewFilterCubit),
              BlocProvider.value(value: newsCategoryCubit),
              BlocProvider.value(value: newsCubit),
              BlocProvider.value(value: showReactionCubit),
            ],
            child: BlocListener<ManageNewsPostCubit, ManageNewsPostState>(
              listener: (context, manageNewsPostState) {
                if (manageNewsPostState.isRequestSuccess) {
                  //Fetch the news data
                  fetchNews();
                }
              },
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  fetchNews(enableLoading: true);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: newsScrollController,
                  slivers: [
                    //App bar
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      leading: GoRouter.of(context).canPop()
                          ? const IOSBackButton(enableBackground: false)
                          : null,
                      titleSpacing: GoRouter.of(context).canPop() ? 0 : 10,
                      title: Padding(
                        padding: EdgeInsets.only(
                          right: GoRouter.of(context).canPop() ? 10 : 0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              tr(LocaleKeys.news),
                              style: TextStyle(
                                color: ApplicationColours.themeBlueColor,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            //popup menu
                            NewsLanguageChangePopUp(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ApplicationColours.themeBlueColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      SVGAssetsImages.translateIcon,
                                      height: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        tr(LocaleKeys.changeLanguage),
                                        style: TextStyle(
                                          color:
                                              ApplicationColours.themeBlueColor,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      floating: true,
                      snap: true,
                      toolbarHeight: 50,
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          //Search and data filter
                          Container(
                            color: const Color.fromRGBO(230, 230, 230, 1),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchWithDataFilterWidget(
                                  searchHint: tr(LocaleKeys.searchNews),
                                  onQuery: (query) {
                                    searchKeyword = query;
                                    fetchNews();
                                  },
                                ),
                                const SizedBox(height: 5),
                                //Data filter
                                DataFilterMenu(onFilterApply: () {
                                  fetchNews(enableLoading: true);
                                }),
                              ],
                            ),
                          ),

                          //News data view filter
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 4),
                            child: ContentFilterTabWidget(
                              onCategorySelected: () {
                                fetchNews(enableLoading: true);
                              },
                            ),
                          ),

                          //Location Widget
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AddressWithLocateMe(
                              is3D: true,
                              iconSize: 15,
                              iconTopPadding: 0,
                              locationType: LocationType.socialMedia,
                              contentMargin: EdgeInsets.zero,
                              height: 35,
                              decoration: BoxDecoration(
                                color:
                                    ApplicationColours.skyColor.withOpacity(1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: null,
                            ),
                          ),

                          //Join us/ Post news
                          BlocBuilder<OwnNewsChannelCubit, OwnNewsChannelState>(
                            builder: (context, ownNewsChannelState) {
                              if (ownNewsChannelState is OwnNewsChannelLoaded) {
                                final ownNewsChannel =
                                    ownNewsChannelState.ownNewsChannel;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (ownNewsChannel != null)
                                        GestureDetector(
                                          onTap: () {
                                            GoRouter.of(context).pushNamed(
                                                MyDashboardScreen.routeName);
                                          },
                                          child: Text(
                                            tr(LocaleKeys.myDashboard),
                                            style: TextStyle(
                                              color: ApplicationColours
                                                  .themePinkColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ApplicationColours
                                                      .themePinkColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      BlocConsumer<CheckNewsPostLimitCubit,
                                          CheckNewsPostLimitState>(
                                        listener:
                                            (context, checkNewsPostLimitState) {
                                          if (checkNewsPostLimitState
                                              is CheckNewsPostLimitLoaded) {
                                            final newsPostLimit =
                                                checkNewsPostLimitState
                                                    .checkNewsPostLimitModel;

                                            //Show the error dialog if the news post limit is exceeded
                                            if (newsPostLimit.isLimitExceeded) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog.adaptive(
                                                  title: const Text(
                                                    "Error",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    newsPostLimit.message,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  actions: [
                                                    // TextButton(
                                                    //   onPressed: () {
                                                    //     Navigator.of(context)
                                                    //         .pop();
                                                    //   },
                                                    //   child: const Text("OK"),
                                                    // ),
                                                    ThemeElevatedButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        buttonName: "OK",
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                  ],
                                                ),
                                              );
                                              return;
                                            }
                                            //Navigate to the manage news post screen if the news post limit is not exceeded
                                            else {
                                              GoRouter.of(context)
                                                  .pushNamed<bool>(
                                                ManagePostNewsScreen.routeName,
                                              );
                                              return;
                                            }
                                          }
                                        },
                                        builder:
                                            (context, checkNewsPostLimitState) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: checkNewsPostLimitState
                                                    is CheckNewsPostLimitLoading
                                                ? const ThemeSpinner(size: 25)
                                                // ? const Text(
                                                //     "Checking limit...",
                                                //     style: TextStyle(
                                                //       color: Colors.black,
                                                //       fontWeight:
                                                //           FontWeight.w500,
                                                //       fontSize: 12,
                                                //     ),
                                                //   )
                                                : SquareButton(
                                                  svgSize: 12,
                                                  svgColor:
                                                      ApplicationColours
                                                          .themeBlueColor,
                                                  svgAsset: SVGAssetsImages
                                                      .joinChannel,
                                                  buttonText: tr(
                                                      LocaleKeys.postNews),
                                                  textColor:
                                                      ApplicationColours
                                                          .themeBlueColor,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          ApplicationColours
                                                              .themeBlueColor,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                  ),
                                                  onTap: () {
                                                    if (ownNewsChannel ==
                                                        null) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const JoinUsDialog(),
                                                      );
                                                    } else {
                                                      //check for the news post limit
                                                      //as per the response navigate to the manage news post screen from the listener
                                                      context
                                                          .read<
                                                              CheckNewsPostLimitCubit>()
                                                          .checkNewsPostLimit(
                                                            ownNewsChannel
                                                                .id!,
                                                          );
                                                    }
                                                  },
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    //News data
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: BlocBuilder<NewsPostsCubit, NewsPostsState>(
                          builder: (context, newsState) {
                            if (newsState.error != null) {
                              return ErrorTextWidget(error: newsState.error!);
                            } else if (newsState.dataLoading) {
                              return const ThemeSpinner();
                            } else if (newsState.news.socialPostList.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: EmptyDataPlaceHolder(
                                  emptyDataType: EmptyDataType.post,
                                ),
                              );
                            } else {
                              return SocialPostListBuilder(
                                hideBottomBarOnScroll: false,
                                physics: const NeverScrollableScrollPhysics(),
                                visibilityDetectorKeyValue:
                                    "news-post-pagination-loading-key",
                                socialPostsModel: newsState.news,
                                showBottomDivider: false,
                                enableVisibilityPaginationDataCallBack: true,
                                onRemoveItemFromList: (index) {
                                  context
                                      .read<NewsPostsCubit>()
                                      .removePost(index);
                                },
                                onPaginationDataFetch: () {
                                  fetchNews(loadMoreData: true);
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
