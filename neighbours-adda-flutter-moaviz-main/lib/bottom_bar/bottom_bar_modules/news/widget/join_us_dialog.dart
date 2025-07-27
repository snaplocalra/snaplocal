import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/screen/join_news_community.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class JoinUsDialog extends StatelessWidget {
  const JoinUsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(33),
            margin: const EdgeInsets.only(top: 35, right: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  SVGAssetsImages.joinUs,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                      GoRouter.of(context)
                          .pushNamed(JoinNewsCommunityScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 25, 104, 1),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: Text(
                      tr(LocaleKeys.becomeANewsReporter),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 5),
                // SizedBox(
                //   height: 40,
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color.fromRGBO(200, 8, 128, 1),
                //       textStyle: const TextStyle(fontSize: 13),
                //     ),
                //     child: Text(tr(LocaleKeys.becomeAnAdvertisingPartner)),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
