import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/logic/home_search_category_type/home_search_category_type_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/home_search_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/widget/post_view_filter.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips_shimmer_list_builder.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class ExploreTypeSelectorWidget extends StatefulWidget {
  final void Function(ExploreCategoryTypeEnum newExploreCategoryTypeEnum)
      onExploreCategoryTypeEnumSelected;
  final void Function() onFetchData;
  const ExploreTypeSelectorWidget({
    super.key,
    required this.onExploreCategoryTypeEnumSelected,
    required this.onFetchData,
  });

  @override
  State<ExploreTypeSelectorWidget> createState() =>
      _ExploreTypeSelectorWidgetState();
}

class _ExploreTypeSelectorWidgetState extends State<ExploreTypeSelectorWidget> {
  //This will use to avoid the initial data fetch after the category selection
  bool initialDataFetched = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExploreCategoryTypeCubit, ExploreCategoryTypeState>(
      listener: (context, homeSearchTypestate) {
        if (homeSearchTypestate.error != null) {
          return;
        } else {
          final homeSearchTypes = homeSearchTypestate.homeSearchTypeListModel;

          if (!homeSearchTypestate.dataLoading &&
              homeSearchTypes.selectedData != null) {
            final homeSearchTypeEnum =
                homeSearchTypes.selectedData!.homeSearchCategoryTypeEnum;

            //Assign the selected salesPostCategoryTypeEnum on the parent
            widget.onExploreCategoryTypeEnumSelected.call(homeSearchTypeEnum);

            //Fetch data

            //If the initial data fetch completed, then fetch sales post as per category selection
            if (initialDataFetched) {
              widget.onFetchData.call();
            } else {
              //set the initialDataFetched to true, for allow the fetchSalesPost to fetch data on category selection
              initialDataFetched = true;
            }
          }
        }
      },
      builder: (context, homeSearchTypestate) {
        final homeSearchTypeCategoryList =
            homeSearchTypestate.homeSearchTypeListModel.data;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: homeSearchTypestate.error != null
                  ? ErrorTextWidget(
                      error: homeSearchTypestate.error!,
                      fontSize: 12,
                    )
                  : homeSearchTypestate.dataLoading
                      ? const CategoryChipsShimmerListBuilder()
                      : homeSearchTypeCategoryList.isEmpty
                          ? const ErrorTextWidget(error: "No type found")
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        homeSearchTypeCategoryList.length,
                                    itemBuilder:
                                        (context, homeSearchTypeIndex) {
                                      final homeSearchTypeCategory =
                                          homeSearchTypeCategoryList[
                                              homeSearchTypeIndex];

                                      return CategoryChips(
                                        text: tr(
                                          homeSearchTypeCategory
                                              .homeSearchCategoryTypeEnum
                                              .displayName,
                                        ),
                                        isSelected:
                                            homeSearchTypeCategory.isSelected,
                                        unselectedBackgroundColor:
                                            const Color.fromRGBO(
                                                229, 228, 228, 1),
                                        horizontalPadding: 15,
                                        onTap: () {
                                          context
                                              .read<ExploreCategoryTypeCubit>()
                                              .selectType(
                                                  homeSearchTypeCategory);
                                        },
                                      );
                                    },
                                  ),
                                ),

                                //Post category type selector
                                if (homeSearchTypestate
                                        .homeSearchTypeListModel
                                        .selectedData
                                        ?.homeSearchCategoryTypeEnum ==
                                    ExploreCategoryTypeEnum.posts)
                                  const PostViewFilter(),
                              ],
                            ),
            ),
          ],
        );
      },
    );
  }
}
