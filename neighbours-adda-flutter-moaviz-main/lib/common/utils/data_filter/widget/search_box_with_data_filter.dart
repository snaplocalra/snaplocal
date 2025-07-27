import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/widgets/cicular_svg_button.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class SearchWithDataFilterWidget extends StatelessWidget {
  const SearchWithDataFilterWidget({
    super.key,
    required this.onQuery,
    this.backColor,
    required this.searchHint,
  });

  final String searchHint;
  final Color? backColor;
  final void Function(String) onQuery;

  @override
  Widget build(BuildContext context) {
    return SearchTextField(
      onQuery: onQuery,
      hint: searchHint,
      extraSuffixIcon: BlocBuilder<DataFilterCubit, DataFilterState>(
        builder: (context, state) {
          final int appliedFilterCount =
              state.dataFilter.where((element) => element.isSelected).length;
          return Badge(
            label: Text("$appliedFilterCount"),
            backgroundColor: ApplicationColours.themePinkColor,
            isLabelVisible: appliedFilterCount > 0,
            offset: const Offset(2, -2),
            child: CircularSvgButton(
              iconSize: 15,
              svgImage: SVGAssetsImages.filter,
              backgroundColor: state.showFilter
                  ? ApplicationColours.themeBlueColor
                  : Colors.grey,
              iconColor: Colors.white,
              onTap: () {
                //unfocus the text field
                FocusManager.instance.primaryFocus?.unfocus();

                //Toggle the filter
                context.read<DataFilterCubit>().toggleShowFilter();

                //Reset the filter
                if (state.showFilter) {
                  context.read<DataFilterCubit>().clearAllFilters();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
