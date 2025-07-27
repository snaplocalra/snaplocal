import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item/saved_item_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item_category_type/saved_item_category_type_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/repository/saved_items_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_item_type_selector_widget.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_jobs_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_market_list_builder.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/widgets/saved_post_list_builder.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/utility/common/search_box/logic/search/search_cubit.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SavedItemScreen extends StatefulWidget {
  const SavedItemScreen({super.key});
  static const routeName = 'saved_items';

  @override
  State<SavedItemScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SavedItemScreen> {
  final pageCategoryScrollController = ScrollController();

  late SavedItemCubit savedItemCubit;
  final savedItemCategoryTypeCubit = SavedItemCategoryTypeCubit();

  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  SavedPostTypeEnum? selectedSavedItemType;

  //To maintain the query keyword string for search purpose
  String? query;

  Future<void> fetchSavedItemsByType() async {
    if (selectedSavedItemType == SavedPostTypeEnum.all) {
      await savedItemCubit.fetchSavedItems(query: query);
      return;
    } else {
      await savedItemCubit.fetchSavedItems(
        savedPostTypeEnum: selectedSavedItemType,
        query: query,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //Wait for the widget tree to render
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Select the 1st element by default
      savedItemCategoryTypeCubit.selectFirstElement();
    });

    savedItemCubit = SavedItemCubit(SavedItemsRepository());
  }

  Widget _postsListBuilder({
    required bool isAllType,
    required List<SocialPostModel> logs,
  }) =>
      SavedPostsListBuilder(
        logs: logs,
        isAllType: isAllType,
        showReactionCubit: showReactionCubit,
      );

  Widget _jobListBuilder({
    required bool isAllType,
    required List<JobShortDetailsModel> logs,
  }) =>
      SavedJobsListBuilder(logs: logs, isAllType: isAllType);

  Widget _marketListBuilder({
    required bool isAllType,
    required List<SalesPostShortDetailsModel> logs,
  }) =>
      SavedMarketListBuilder(logs: logs, isAllType: isAllType);

  Widget dataRender({
    required bool isAllDataEmpty,
    required List<SocialPostModel> postsList,
    required List<JobShortDetailsModel> jobsShortDetailsList,
    required List<SalesPostShortDetailsModel> salesPostShortDetailsList,
  }) {
    final isAllType = selectedSavedItemType == SavedPostTypeEnum.all;
    if (isAllType) {
      if (isAllDataEmpty) {
        return Container(
          height: 40,
          margin: const EdgeInsets.only(top: 10),
          color: Colors.white,
          child: ErrorTextWidget(error: tr(LocaleKeys.noSavedItems)),
        );
      } else {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _postsListBuilder(isAllType: isAllType, logs: postsList),
            _jobListBuilder(isAllType: isAllType, logs: jobsShortDetailsList),
            _marketListBuilder(
              isAllType: isAllType,
              logs: salesPostShortDetailsList,
            ),
          ],
        );
      }
    } else if (selectedSavedItemType == SavedPostTypeEnum.posts) {
      return _postsListBuilder(isAllType: isAllType, logs: postsList);
    } else if (selectedSavedItemType == SavedPostTypeEnum.job) {
      return _jobListBuilder(isAllType: isAllType, logs: jobsShortDetailsList);
    } else if (selectedSavedItemType == SavedPostTypeEnum.market) {
      return _marketListBuilder(
        isAllType: isAllType,
        logs: salesPostShortDetailsList,
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(
      builder: (context, _) {
        return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: savedItemCategoryTypeCubit),
              BlocProvider.value(value: savedItemCubit),
              BlocProvider.value(value: showReactionCubit),
              BlocProvider(create: (context) => SearchCubit()),
            ],
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: NestedScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverAppBar(
                      titleSpacing: 0,
                      elevation: 0,
                      leading: IOSBackButton(enableBackground: false),
                      backgroundColor: Colors.white,
                      floating: true,
                      snap: true,
                    ),
                  ],
                  body: BlocListener<SearchCubit, SearchState>(
                    listener: (context, searchState) {
                      //update the query keyword
                      query = searchState.query;
                      fetchSavedItemsByType();
                    },
                    child: RefreshIndicator.adaptive(
                      onRefresh: () => fetchSavedItemsByType(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          //Heading
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: PageHeading(
                              svgPath: SVGAssetsImages.unSaved,
                              heading: LocaleKeys.savedItems,
                              subHeading: LocaleKeys.savedItemsDescription,
                            ),
                          ),

                          //Sales Category Type Selector
                          SavedItemTypeSelectorWidget(
                            onSavedItemCategoryTypeSelected:
                                (newSavedItemType) {
                              selectedSavedItemType = newSavedItemType;
                            },
                            onFetchData: () {
                              fetchSavedItemsByType();
                            },
                          ),

                          //Search bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: SearchTextField(
                              hint: LocaleKeys.search,
                              onQuery: (query) {
                                if (query.isNotEmpty) {
                                  //Search chats
                                  context
                                      .read<SearchCubit>()
                                      .setSearchQuery(query);
                                } else {
                                  context
                                      .read<SearchCubit>()
                                      .clearSearchQuery();
                                }
                              },
                            ),
                          ),

                          //Post buttons
                          BlocBuilder<SavedItemCubit, SavedItemState>(
                            builder: (context, savedItemState) {
                              final savedItemDataModel =
                                  savedItemState.savedItemModel;
                              if (savedItemState.error != null) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  color: Colors.white,
                                  height: 40,
                                  child: ErrorTextWidget(
                                    error: savedItemState.error!,
                                  ),
                                );
                              } else if (!savedItemState
                                      .savedItemModelAvailable ||
                                  savedItemState.dataLoading) {
                                return const ThemeSpinner(size: 35);
                              } else {
                                final postsList = savedItemDataModel!.postsList;
                                final jobsShortDetailsList =
                                    savedItemDataModel.jobsShortDetailsList;
                                final salesPostShortDetailsList =
                                    savedItemDataModel
                                        .salesPostShortDetailsList;
                                return dataRender(
                                  isAllDataEmpty:
                                      savedItemState.isSavedItemDataEmpty,
                                  postsList: postsList,
                                  jobsShortDetailsList: jobsShortDetailsList,
                                  salesPostShortDetailsList:
                                      salesPostShortDetailsList,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
      },
    );
  }
}
