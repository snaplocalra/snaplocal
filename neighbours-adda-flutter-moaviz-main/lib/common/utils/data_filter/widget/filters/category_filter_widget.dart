import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/category/widgets/category_selection_bottom_sheet_v2.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/category_filter_strategy.dart';

class CategoryFilterWidget extends StatefulWidget {
  const CategoryFilterWidget({
    super.key,
    required this.categoryFilter,
    required this.filterIndex,
  });

  final CategoryFilter categoryFilter;
  final int filterIndex;

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget> {
  @override
  void initState() {
    super.initState();

    //clear the search if search is applied before
    widget.categoryFilter.categoryControllerCubit.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return CategorySelectionBottomSheetV2(
      categoryControllerCubit: context.read<CategoryControllerCubit>(),
      onCategorySelected: (_) {
        //Update the category filter
        context.read<DataFilterCubit>().updateFilter(
              filterIndex: widget.filterIndex,
              strategy: CategoryFilterStrategy(),
            );
        //Apply the filter
        context.read<DataFilterCubit>().applyFilter();
      },
    );
  }
}
