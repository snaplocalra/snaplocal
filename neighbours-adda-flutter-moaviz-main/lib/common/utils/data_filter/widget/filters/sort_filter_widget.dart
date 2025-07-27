import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/sort_filter_strategy.dart';

class SortFilterWidget extends StatelessWidget {
  const SortFilterWidget({
    super.key,
    required this.sortFilter,
    required this.filterIndex,
  });

  final SortFilter sortFilter;
  final int filterIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortFilter.sortFilterOptions.length,
      itemBuilder: (context, index) {
        final sortData = sortFilter.sortFilterOptions[index];

        return ListTile(
          tileColor: sortData.isSelected ? Colors.blue.shade300 : null,
          title: Text(tr(sortData.sortType.displayValue)),
          titleTextStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          onTap: () {
            //update the sort filter value
            context.read<DataFilterCubit>().updateFilter(
                  filterIndex: filterIndex,
                  strategy: SortFilterStrategy(targetSortFilterIndex: index),
                );

            //Apply the filter
            context.read<DataFilterCubit>().applyFilter();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
