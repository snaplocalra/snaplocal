import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';

class ApplicationNameHeader extends StatelessWidget {
  const ApplicationNameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isTelugu =
        EasyLocalization.of(context)!.currentLocale?.languageCode ==
            LocaleManager.telugu.languageCode;
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.asset(
            isTelugu
                ? SVGAssetsImages.snapLocalTextTelugu
                : SVGAssetsImages.snapLocalText,
            height: isTelugu ? 30 : 20,
          ),
        ),
      ),
    );
  }
}
