import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/profile_details/own_profile/screen/own_profile_screen.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class CreatePostWidget extends StatefulWidget {
  final String searchBoxHint;
  final void Function()? onDataFetchCallBack;
  final void Function() onCreatePost;
  const CreatePostWidget({
    super.key,
    required this.searchBoxHint,
    this.onDataFetchCallBack,
    required this.onCreatePost,
  });

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
          child:
              BlocBuilder<ManageProfileDetailsBloc, ManageProfileDetailsState>(
            builder: (context, profileState) {
              final profileDetails = profileState.profileDetailsModel;
              return (profileState.dataLoading)
                  ? const ShimmerWidget(
                      height: 30,
                      width: 30,
                      shapeBorder: CircleBorder(),
                    )
                  : !profileState.isProfileDetailsAvailable
                      ? const SizedBox(
                          height: 30,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .pushNamed(OwnProfilePostsScreen.routeName)
                                .whenComplete(() {
                              if (mounted) {
                                if (widget.onDataFetchCallBack != null) {
                                  widget.onDataFetchCallBack!.call();
                                }
                              }
                            });
                          },
                          child: NetworkImageCircleAvatar(
                            radius: 18,
                            imageurl: profileDetails!.profileImage,
                          ),
                        );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0XFFf5f5f5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ThemeTextFormField(
                        textFieldPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        style: const TextStyle(fontSize: 12),
                        hint: tr(widget.searchBoxHint),
                        readOnly: true,
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(183, 183, 183, 1),
                        ),
                        onTap: widget.onCreatePost,
                        activeBorderStyle: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        deActiveBorderStyle: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
