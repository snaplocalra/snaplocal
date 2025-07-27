import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class TextVerifiedView extends StatelessWidget {
  final String textKey;

  const TextVerifiedView({super.key, required this.textKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check,
              color: Color.fromRGBO(17, 174, 0, 1),
              size: 15,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                tr(textKey),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
