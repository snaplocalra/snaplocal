import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/logic/saved_item_category_type/saved_item_category_type_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips_shimmer_list_builder.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class SavedItemTypeSelectorWidget extends StatefulWidget {
  final void Function(SavedPostTypeEnum newSavedItemCategoryType)
      onSavedItemCategoryTypeSelected;
  final void Function() onFetchData;
  const SavedItemTypeSelectorWidget({
    super.key,
    required this.onSavedItemCategoryTypeSelected,
    required this.onFetchData,
  });

  @override
  State<SavedItemTypeSelectorWidget> createState() =>
      _SavedItemTypeSelectorWidgetState();
}

class _SavedItemTypeSelectorWidgetState
    extends State<SavedItemTypeSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedItemCategoryTypeCubit, SavedItemCategoryTypeState>(
      listener: (context, savedItemCategoryTypeState) {
        if (savedItemCategoryTypeState.error != null) {
          return;
        } else {
          final savedItemsTypes =
              savedItemCategoryTypeState.savedItemTypeListModel;

          if (!savedItemCategoryTypeState.dataLoading &&
              savedItemsTypes.selectedData != null) {
            final savedItemType = savedItemsTypes.selectedData!.savedItemType;

            //Assign the selected salesPostCategoryTypeEnum on the parent
            widget.onSavedItemCategoryTypeSelected.call(savedItemType);

            //Fetch data
            widget.onFetchData.call();
          }
        }
      },
      builder: (context, savedItemCategoryTypeState) {
        final savedItemsCategoryList =
            savedItemCategoryTypeState.savedItemTypeListModel.data;

        return Column(
          children: [
            const ThemeDivider(thickness: 2, height: 2),
            Container(
              color: Colors.white,
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              child: savedItemCategoryTypeState.error != null
                  ? ErrorTextWidget(
                      error: savedItemCategoryTypeState.error!,
                      fontSize: 12,
                    )
                  : savedItemCategoryTypeState.dataLoading
                      ? const CategoryChipsShimmerListBuilder()
                      : savedItemsCategoryList.isEmpty
                          ? const ErrorTextWidget(error: "No type found")
                          : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: savedItemsCategoryList.length,
                              itemBuilder: (context, index) {
                                final savedItemCategory =
                                    savedItemsCategoryList[index];

                                return CategoryChips(
                                  text: tr(savedItemCategory
                                      .savedItemType.displayName),
                                  isSelected: savedItemCategory.isSelected,
                                  unselectedBackgroundColor:
                                      const Color.fromRGBO(229, 228, 228, 1),
                                  horizontalPadding: 15,
                                  onTap: () {
                                    context
                                        .read<SavedItemCategoryTypeCubit>()
                                        .selectType(savedItemCategory);
                                  },
                                );
                              },
                            ),
            ),
            const ThemeDivider(thickness: 2, height: 2),
          ],
        );
      },
    );
  }
}
