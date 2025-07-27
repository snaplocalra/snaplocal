import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/widgets/custom_bottom_sheet.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class CategorySelectionBottomSheetV2 extends StatelessWidget {
  final CategoryControllerCubit categoryControllerCubit;
  final bool closeBottomSheetOnCategorySelected;
  final void Function(CategoryListModelV2 selectedCategoryList)?
      onCategorySelected;
  const CategorySelectionBottomSheetV2({
    super.key,
    required this.categoryControllerCubit,
    this.onCategorySelected,
    this.closeBottomSheetOnCategorySelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: categoryControllerCubit..fetchCategories(),
      child: Builder(
        builder: (context) {
          return CustomBottomSheet(
            maxHeight: MediaQuery.sizeOf(context).height * 0.6,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: Text(
                      categoryControllerCubit.categoryType.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  //search field
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SearchTextField(
                      hint: tr(LocaleKeys.searchCategory),
                      fillColor: const Color.fromRGBO(250, 250, 250, 1),
                      searchIconColor: Colors.black,
                      onQuery: (query) {
                        context
                            .read<CategoryControllerCubit>()
                            .searchSubCategory(query);
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<CategoryControllerCubit,
                        CategoryControllerState>(
                      listener: (context, categoryControllerState) {
                        if (categoryControllerState
                            is CategoryControllerDataLoaded) {
                          if (onCategorySelected != null) {
                            onCategorySelected!(CategoryListModelV2(
                              data: categoryControllerState
                                  .categories.selectedCategories,
                            ));
                          }
                        }
                      },
                      builder: (context, categoryControllerState) {
                        if (categoryControllerState
                            is CategoryControllerDataError) {
                          return ErrorTextWidget(
                              error: categoryControllerState.error);
                        } else if (categoryControllerState
                            is CategoryControllerDataLoaded) {
                          final categories =
                              categoryControllerState.categories.data;

                          return categories.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tr(LocaleKeys.noCategoryFound),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: categories.length,
                                  itemBuilder: (context, categoryIndex) {
                                    final category = categories[categoryIndex];
                                    return Visibility(
                                      visible:
                                          category.subCategories.isNotEmpty,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //category name
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Text(
                                                category.name,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 25, 104, 1),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            // Sub Category will come horizontally and will render in the next line if it exceeds the width
                                            Wrap(
                                              children: List.generate(
                                                category.subCategories.length,
                                                (subCategoryIndex) {
                                                  final subCategory =
                                                      category.subCategories[
                                                          subCategoryIndex];
                                                  return IntrinsicWidth(
                                                    child: CategoryChips(
                                                      text: subCategory.name,
                                                      isSelected: subCategory
                                                          .isSelected,
                                                      horizontalPadding: 6,
                                                      verticalPadding: 5,
                                                      unselectedBackgroundColor:
                                                          const Color.fromRGBO(
                                                              245, 244, 244, 1),
                                                      selectedBackgroundColor:
                                                          const Color.fromRGBO(
                                                              107, 110, 119, 1),
                                                      radius: 4,
                                                      onTap: () async {
                                                        //Check if the sub category is other type or not
                                                        if (categoryControllerCubit
                                                                    .categoryType
                                                                    .categorySelectStrategy
                                                                is OtherTypeSubCategorySelectionStrategy &&
                                                            subCategory
                                                                .isOtherType &&
                                                            //Check that the sub category should be unselected
                                                            !subCategory
                                                                .isSelected) {
                                                          //open a dialog, where user can enter other category name
                                                          await showDialog<
                                                                  String>(
                                                              context: context,
                                                              builder: (context) =>
                                                                  const OtherCategoryDataAddDialog()).then(
                                                              (value) {
                                                            if (value != null &&
                                                                context
                                                                    .mounted) {
                                                              context
                                                                  .read<
                                                                      CategoryControllerCubit>()
                                                                  .selectSubCategory(
                                                                    category.id,
                                                                    subCategory
                                                                        .id,
                                                                    otherTypeName:
                                                                        value,
                                                                  );

                                                              if (closeBottomSheetOnCategorySelected &&
                                                                  context
                                                                      .mounted) {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            }
                                                          });
                                                        } else {
                                                          context
                                                              .read<
                                                                  CategoryControllerCubit>()
                                                              .selectSubCategory(
                                                                category.id,
                                                                subCategory.id,
                                                              );

                                                          if (closeBottomSheetOnCategorySelected &&
                                                              context.mounted) {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                        } else {
                          return const Center(child: ThemeSpinner());
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OtherCategoryDataAddDialog extends StatefulWidget {
  const OtherCategoryDataAddDialog({super.key});

  @override
  State<OtherCategoryDataAddDialog> createState() =>
      _OtherCategoryDataAddDialogState();
}

class _OtherCategoryDataAddDialogState
    extends State<OtherCategoryDataAddDialog> {
  final nameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Add Other Category Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ThemeTextFormField(
            controller: nameTextController,
            hint: 'Enter Sub Category Name',
            hintStyle: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 15,
          ),
          ThemeElevatedButton(
            buttonName: 'Submit',
            textFontSize: 12,
            width: 840,
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            onPressed: () {
              final value = nameTextController.text.trim();

              //Add the category to the list
              Navigator.pop(
                context,
                value.isEmpty ? null : value,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}
