import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class CreatePostAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function() willPop;
  final List<Widget>? actions;
  const CreatePostAppBar({
    super.key,
    required this.willPop,
    this.actions,
  });

  @override
  State<CreatePostAppBar> createState() => _CreatePostAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _CreatePostAppBarState extends State<CreatePostAppBar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      elevation: 0.8,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leadingWidth: 120,
      leading: GestureDetector(
        onTap: widget.willPop,
        child: Row(
          children: [
            const SizedBox(width: 8),
            // Adjust the spacing if needed
            SvgPicture.asset(
              SVGAssetsImages.cancel,
              height: 12,
              colorFilter: ColorFilter.mode(
                ApplicationColours.themeBlueColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                tr(LocaleKeys.cancel),
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: widget.actions,
    );
  }
}
