import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/logic/content_filter_tab/content_filter_tab_cubit.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ContentFilterTabWidget extends StatefulWidget {
  final void Function() onCategorySelected;
  const ContentFilterTabWidget({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<ContentFilterTabWidget> createState() => _ContentFilterTabWidgetState();
}

class _ContentFilterTabWidgetState extends State<ContentFilterTabWidget> {
  final ItemScrollController categoryScrollController = ItemScrollController();

  void scrollToSelectedCategory() {
    final selectedCategoryIndex = context
        .read<CategoryControllerV1Cubit>()
        .state
        .firstSelectedCategoryIndex;

    if (selectedCategoryIndex != null && selectedCategoryIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => categoryScrollController.scrollTo(
          index: selectedCategoryIndex,
          duration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContentFilterTabCubit, ContentFilterTabState>(
      listener: (context, contentFilterState) {
        if (contentFilterState.selectedViewFilter.viewFilterType ==
            ContentFilterTabType.categories) {
          scrollToSelectedCategory();
        } else {
          context.read<CategoryControllerV1Cubit>().clearAllSelectedCategory();
        }
      },
      builder: (context, contentViewFilterState) {
        return Column(
          children: [
            
            
            SizedBox(
              height: 45,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemCount: contentViewFilterState.viewFilters.length,
                itemBuilder: (context, index) {
                  final contentViewFilterCategory =
                      contentViewFilterState.viewFilters[index];
                  return GestureDetector(
                    onTap: () {
                      context
                          .read<ContentFilterTabCubit>()
                          .selectViewFilter(index);
                    },
                    child: AnimatedContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      duration: const Duration(milliseconds: 200),
                      height: contentViewFilterCategory.isSelected ? 45 : 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: contentViewFilterCategory.isSelected
                            ? ApplicationColours.themeBlueColor
                            : Colors.black54,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Text(
                          tr(contentViewFilterCategory
                              .viewFilterType.displayText),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                contentViewFilterCategory.isSelected ? 12 : 10,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //category filter
            AnimatedHideWidget(
              //if view filter is categories then show the category filter
              visible:
                  contentViewFilterState.selectedViewFilter.viewFilterType ==
                      ContentFilterTabType.categories,
              child: BlocConsumer<CategoryControllerV1Cubit,
                  CategoryControllerV1State>(
                listener: (context, categoryControllerV1State) {
                  if (categoryControllerV1State.isAnyCategorySelected) {
                    widget.onCategorySelected.call();
                  }
                },
                builder: (context, categoryControllerV1State) {
                  return SizedBox(
                    height: 45,
                    child: categoryControllerV1State
                            .categoriesListModel.data.isEmpty
                        ? Center(child: Text(tr(LocaleKeys.noCategories)))
                        : ScrollablePositionedList.builder(
                            itemScrollController: categoryScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryControllerV1State
                                .categoriesListModel.data.length,
                            itemBuilder: (context, index) {
                              final category = categoryControllerV1State
                                  .categoriesListModel.data[index];
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .read<CategoryControllerV1Cubit>()
                                      .selectCategory(category.id);
                                },
                                child: CategoryChips(
                                  text: category.name,
                                  isSelected: category.isSelected,
                                  enableborder: true,
                                  unselectedForegroundColor: Colors.grey,
                                  selectedForegroundColor:
                                      ApplicationColours.themeBlueColor,
                                  selectedBackgroundColor: Colors.white,
                                  borderColor: category.isSelected
                                      ? ApplicationColours.themeBlueColor
                                      : Colors.grey,
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
