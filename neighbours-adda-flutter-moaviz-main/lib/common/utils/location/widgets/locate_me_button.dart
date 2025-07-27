import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class LocateMeButton extends StatelessWidget {
  final void Function()? onLocateMe;
  final Color? backgroundColor;
  const LocateMeButton({
    super.key,
    required this.onLocateMe,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLocateMe,
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                SVGAssetsImages.locateMe,
                height: 12,
                width: 12,
              ),
              const SizedBox(width: 5),
              Text(
                tr(LocaleKeys.locateMe),
                style: const TextStyle(
                  color: Color.fromRGBO(200, 8, 128, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
