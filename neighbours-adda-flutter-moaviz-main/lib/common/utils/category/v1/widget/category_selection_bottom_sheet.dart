import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v1/logic/category_controller_v1/category_controller_v1_cubit.dart';
import 'package:snap_local/common/utils/widgets/custom_bottom_sheet.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class CategorySelectionBottomSheet extends StatelessWidget {
  const CategorySelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryControllerV1Cubit, CategoryControllerV1State>(
      builder: (context, categoryControllerState) {
        final categories = categoryControllerState.categoriesListModel.data;
        return CustomBottomSheet(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: categoryControllerState.dataLoading
                ? const Center(child: ThemeSpinner())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SearchTextField(
                          hint: tr(LocaleKeys.searchCategory),
                          onQuery: (query) {
                            context
                                .read<CategoryControllerV1Cubit>()
                                .searchCategory(query);
                          },
                        ),
                      ),
                      Expanded(
                        child: categories.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tr(LocaleKeys.noCategoryFound),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CategoryControllerV1Cubit>()
                                          .selectCategory(category.id);

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: category.isSelected
                                          ? Colors.blue.shade300
                                          : null,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
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
  }
}
