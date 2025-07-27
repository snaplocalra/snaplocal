import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/screen/favorite_location_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/circular_svg_button_3d_widget.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/widgets/address_with_locate_me.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class HomeCreatePostWidget extends StatefulWidget {
  final String searchBoxHint;
  final void Function()? onDataFetchCallBack;
  final void Function() onCreatePost;

  const HomeCreatePostWidget({
    super.key,
    required this.searchBoxHint,
    this.onDataFetchCallBack,
    required this.onCreatePost,
  });

  @override
  State<HomeCreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<HomeCreatePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularSvgButton3D(
          svgImage: SVGAssetsImages.homeFavLocate,
          height: 24,
          onTap: () {
            GoRouter.of(context).pushNamed(FavoriteLocationScreen.routeName);
          },
        ),
        const SizedBox(width: 2),
        Expanded(
          child: AddressWithLocateMe(
            is3D: true,
            iconSize: 15,
            iconTopPadding: 0,
            locationType: LocationType.socialMedia,
            contentMargin: EdgeInsets.zero,
            height: 35,
            decoration: BoxDecoration(
              color: ApplicationColours.skyColor.withOpacity(1),
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: const BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(143, 0, 89, 1),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 3), // changes the position of the shadow
                ),
              ],
            ),
            child: ThemeElevatedButton(
              buttonName: tr(LocaleKeys.post),
              textFontSize: 12,
              padding: EdgeInsets.zero,
              width: 80,
              height: 32,
              onPressed: widget.onCreatePost,
              suffix: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SvgPicture.asset(
                  SVGAssetsImages.postIcon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  height: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
