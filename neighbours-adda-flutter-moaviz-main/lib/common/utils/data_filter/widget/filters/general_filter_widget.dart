import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/general_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/general_filter_strategy.dart';

class GeneralFilterWidget extends StatelessWidget {
  const GeneralFilterWidget({
    super.key,
    required this.generalFilter,
    required this.filterIndex,
  });

  final GeneralFilter generalFilter;
  final int filterIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: generalFilter.categories.length,
      itemBuilder: (context, index) {
        final category = generalFilter.categories[index];
        return ListTile(
          tileColor: category.isSelected ? Colors.blue.shade300 : null,
          title: Text(tr(category.name)),
          titleTextStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          onTap: () {
            //update the filter value
            context.read<DataFilterCubit>().updateFilter(
                  filterIndex: filterIndex,
                  strategy: GeneralFilterStrategy(targetCategoryIndex: index),
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
