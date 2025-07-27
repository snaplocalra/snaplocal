import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/logic/list_map_view_controller/list_map_view_controller_cubit.dart';
import 'package:snap_local/common/utils/location/data_list_on_map_view/model/neighbours_view_type.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class DataListOrMapViewSwitch extends StatelessWidget {
  final String? leftSvgAsset;
  const DataListOrMapViewSwitch({super.key, this.leftSvgAsset});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataOnMapViewControllerCubit,
        DataOnMapViewControllerState>(
      builder: (context, state) {
        final isListType = state.listMapViewType == ListMapViewType.list;
        return IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: GestureDetector(
              onTap: () {
                context
                    .read<DataOnMapViewControllerCubit>()
                    .toggleListMapViewType();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DataViewOnMapSwitchWidget(
                    svgAsset: SVGAssetsImages.mapView,
                    isListType: !isListType,
                    name: ListMapViewType.map.displayName,
                  ),
                  VerticalDivider(thickness: 0.5, color: Colors.grey.shade300),
                  DataViewOnMapSwitchWidget(
                    svgAsset: leftSvgAsset ?? SVGAssetsImages.listView,
                    isListType: isListType,
                    name: ListMapViewType.list.displayName,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DataListOrMapViewStatusDisplay extends StatelessWidget {
  const DataListOrMapViewStatusDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataOnMapViewControllerCubit,
        DataOnMapViewControllerState>(
      builder: (context, listMapViewControllerState) {
        final listMapViewType = listMapViewControllerState.listMapViewType;
        return Text(
          tr(listMapViewType.displayName),
          style: TextStyle(
            color: ApplicationColours.themePinkColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        );
      },
    );
  }
}

class DataViewOnMapSwitchWidget extends StatelessWidget {
  final String name;
  final String svgAsset;
  final bool isListType;
  const DataViewOnMapSwitchWidget({
    super.key,
    required this.name,
    required this.svgAsset,
    required this.isListType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tr(name),
          style: TextStyle(
            color: isListType
                ? ApplicationColours.themePinkColor
                : ApplicationColours.themeBlueColor,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 5),
        DataViewOnMapSwitchIcon(
          svgAsset: svgAsset,
          isListType: isListType,
        ),
      ],
    );
  }
}

class DataViewOnMapSwitchIcon extends StatelessWidget {
  final String svgAsset;
  final bool isListType;
  const DataViewOnMapSwitchIcon({
    super.key,
    required this.svgAsset,
    required this.isListType,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgAsset,
      height: 18,
      colorFilter: ColorFilter.mode(
        isListType
            ? ApplicationColours.themePinkColor
            : ApplicationColours.themeBlueColor,
        BlendMode.srcIn,
      ),
    );
  }
}
