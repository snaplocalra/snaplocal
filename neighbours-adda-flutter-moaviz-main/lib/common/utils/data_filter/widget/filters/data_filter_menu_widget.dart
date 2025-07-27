// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/widget/data_filter_bottom_sheet.dart';

class DataFilterMenu extends StatelessWidget {
  final void Function() onFilterApply;
  final CategoryControllerCubit? categoryControllerCubit;
  const DataFilterMenu({
    super.key,
    required this.onFilterApply,
    this.categoryControllerCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataFilterCubit, DataFilterState>(
      listener: (context, state) {
        if (state.filterApplied) {
          //Apply the filter
          onFilterApply.call();
        }
      },
      builder: (context, dataFilterState) {
        final dataFilter = dataFilterState.dataFilter;
        return Visibility(
          visible: dataFilterState.showFilter,
          child: SizedBox(
            height: 45,
            child: AnimationLimiter(
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    onTap: () {
                      //unfocus the text field
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<DataFilterCubit>().clearAllFilters();

                      //clear all category filters
                      categoryControllerCubit?.clearAllSelection();
                    },
                    child: Chip(
                      backgroundColor: Colors.grey.shade200,
                      label: const Row(
                        children: [
                          Text(
                            "Clear",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 2),
                          //Drop icon
                          Icon(Icons.cancel, size: 15),
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: dataFilter.length,
                  itemBuilder: (context, index) {
                    final filter = dataFilter[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                //unfocus the text field
                                FocusManager.instance.primaryFocus?.unfocus();

                                //open bottom sheet with filter options as per filter type
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  builder: (_) {
                                    return MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                            value: context
                                                .read<DataFilterCubit>()),
                                        if (categoryControllerCubit != null)
                                          BlocProvider.value(
                                            value: categoryControllerCubit!,
                                          )
                                      ],
                                      child: DataFilterBottomSheet(
                                        filter: filter,
                                        filterIndex: index,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Chip(
                                backgroundColor: filter.isSelected
                                    ? Colors.blue.shade300
                                    : Colors.grey.shade200,
                                label: Row(
                                  children: [
                                    // filtser.filterValue != null
                                    //     ? Text(
                                    //         tr(filter.filterValue!),
                                    //         style: const TextStyle(fontSize: 12),
                                    //       )
                                    //     :

                                    Text(
                                      tr(filter.filterName),
                                      style: const TextStyle(fontSize: 12),
                                    ),

                                    //Drop icon
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
