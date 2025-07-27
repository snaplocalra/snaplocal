import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/master_category_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/visibility_controller/visibility_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/utils/widgets/animated_hide_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class RegularPostHeaderSelector extends StatelessWidget {
  final PostType regularPostType;
  const RegularPostHeaderSelector({
    super.key,
    required this.regularPostType,
  });

  Widget _selectRegularPost() {
    switch (regularPostType) {
      case PostType.general:
        return const MasterCategoryWidget();
      case PostType.askQuestion || PostType.askSuggestion:
        return BlocBuilder<VisibilityControllerCubit,
            VisibilityControllerState>(
          builder: (context, visibilityControllerState) {
            return AnimatedHideWidget(
              visible: visibilityControllerState.isVisible,
              child: RegularPostHeaderWidget(
                regularPostType: regularPostType,
              ),
            );
          },
        );
      default:
        throw ("Invalid regular post type");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisibilityControllerCubit, VisibilityControllerState>(
      builder: (context, visibilityControllerState) {
        return _selectRegularPost();
      },
    );
  }
}

class RegularPostHeaderWidget extends StatelessWidget {
  final PostType regularPostType;
  const RegularPostHeaderWidget({
    super.key,
    required this.regularPostType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.4,
              child: SvgPicture.asset(
                regularPostType.svgPath,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              regularPostType.displayText,
              style: TextStyle(
                fontSize: 24,
                color: ApplicationColours.themeBlueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
