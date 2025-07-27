import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class AmbassadorWidget extends StatelessWidget {
  const AmbassadorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            AssetsImages.ambassador,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
         Center(
          child: Text(
            tr(LocaleKeys.ambassador),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
