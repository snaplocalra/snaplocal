import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SearchFilterSelectorWidget extends StatelessWidget {
  const SearchFilterSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFilterControllerCubit,
        SearchFilterControllerState>(
      builder: (context, searchFilterControllerState) {
        final logs = searchFilterControllerState.searchFilterTypeCategories;
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final filter = logs[index];
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<SearchFilterControllerCubit>()
                        .selectSearchFilterType(filter.type);
                  },
                  child: SearchFilterTab(searchFilterTypeCategory: filter),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SearchFilterTab extends StatelessWidget {
  final SearchFilterTypeCategory searchFilterTypeCategory;
  const SearchFilterTab({
    super.key,
    required this.searchFilterTypeCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: searchFilterTypeCategory.isSelected
            ? ApplicationColours.themeBlueColor
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: searchFilterTypeCategory.isSelected
                ? ApplicationColours.themeBlueColor.withOpacity(0.8)
                : Colors.blue.shade100,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        searchFilterTypeCategory.type.displayName,
        style: TextStyle(
          color: searchFilterTypeCategory.isSelected
              ? Colors.white
              : ApplicationColours.themeBlueColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
