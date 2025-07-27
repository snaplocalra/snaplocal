import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snap_local/common/utils/widgets/custom_bottom_sheet.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class MapViewDataListBottomSheet extends StatefulWidget {
  final int markersCount;

  final Widget Function(BuildContext context, String? searchQuery) builder;

  const MapViewDataListBottomSheet({
    super.key,
    required this.markersCount,
    required this.builder,
  });

  @override
  State<MapViewDataListBottomSheet> createState() =>
      _MapViewDataListBottomSheetState();
}

class _MapViewDataListBottomSheetState
    extends State<MapViewDataListBottomSheet> {
  String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //if the selectedMarkers is more than 10
          if (widget.markersCount > 10)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SearchTextField(
                hint: tr(LocaleKeys.search),
                onQuery: (text) {
                  setState(
                    () {
                      searchQuery = text;
                    },
                  );
                },
              ),
            ),
          Expanded(child: widget.builder(context, searchQuery)),
        ],
      ),
    );
  }
}
