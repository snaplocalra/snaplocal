import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/logic/post_view_filter/post_view_filter_cubit.dart';
import 'package:snap_local/common/utils/category/widgets/category_chips.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PostViewFilter extends StatefulWidget {
  final bool visible;
  const PostViewFilter({
    super.key,
    this.visible = true,
  });

  @override
  State<PostViewFilter> createState() => _PostViewFilterState();
}

class _PostViewFilterState extends State<PostViewFilter> {
  final scrollController = ItemScrollController();

  int getSectedIndex() {
    return context
        .read<PostViewFilterCubit>()
        .state
        .postFilters
        .indexWhere((element) => element.isSelected);
  }

  @override
  void initState() {
    super.initState();

    //set the list view
    context.read<DataOnMapViewControllerCubit>().setListView();

    //widget frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //get the selected category index
      final int selectedIndex = getSectedIndex();
      if (selectedIndex != -1) {
        //scroll to the selected category
        scrollController.jumpTo(
          index: selectedIndex,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedHideWidget(
      //if the post category is selected then show the category filter
      visible: widget.visible,

      child: BlocBuilder<PostViewFilterCubit, PostViewFilterState>(
        builder: (context, postViewFilterState) {
          final postFilters = postViewFilterState.postFilters;
          return SizedBox(
            height: 45,
            child: ScrollablePositionedList.builder(
              itemScrollController: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: postFilters.length,
              itemBuilder: (context, index) {
                final filter = postFilters[index];
                return GestureDetector(
                  onTap: () {
                    context.read<PostViewFilterCubit>().selectViewFilter(index);
                  },
                  child: CategoryChips(
                    text: tr(filter.postType.displayText),
                    isSelected: filter.isSelected,
                    enableborder: true,
                    unselectedForegroundColor: Colors.grey,
                    selectedForegroundColor: ApplicationColours.themeBlueColor,
                    selectedBackgroundColor: Colors.white,
                    borderColor: filter.isSelected
                        ? ApplicationColours.themeBlueColor
                        : Colors.grey,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
