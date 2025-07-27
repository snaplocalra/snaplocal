import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/svg_button_text_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class SearchIcon extends StatelessWidget {
  final void Function() onTap;
  const SearchIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color.fromRGBO(241, 244, 254, 1),
        child: SvgButtonTextWidget(
          svgImage: SVGAssetsImages.search,
          svgHeight: 24,
          onTap: onTap,
        ),
      ),
    );
  }
}
