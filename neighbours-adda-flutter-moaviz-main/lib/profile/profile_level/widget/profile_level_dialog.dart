// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/profile/profile_level/logic/profile_level/profile_level_cubit.dart';
import 'package:snap_local/profile/profile_level/repository/profile_level_repository.dart';
import 'package:snap_local/profile/profile_level/widget/profile_level_widget.dart';
import 'package:snap_local/profile/profile_level/widget/profile_points_summary.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ProfileLevelDialog extends StatelessWidget {
  final String userId;
  const ProfileLevelDialog({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => ProfileLevelCubit(ProfileLevelRepository())
        ..fetchProfileLevels(userId),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: size.height * 0.8,
            minHeight: size.height * 0.3,
          ),
          child: BlocBuilder<ProfileLevelCubit, ProfileLevelState>(
            builder: (context, profileLevelState) {
              if (profileLevelState is ProfileLevelError) {
                return ErrorTextWidget(error: profileLevelState.message);
              } else if (profileLevelState is ProfileLevelLoaded) {
                return ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    //heading
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Snap Local Levels",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ApplicationColours.themeBlueColor,
                        ),
                      ),
                    ),

                    //Divider
                    const Divider(thickness: 2),

                    //Levels vertical bars
                    Center(
                      child: SvgPicture.asset(
                        SVGAssetsImages.levelVerticalBars,
                        height: 180,
                        width: size.width,
                      ),
                    ),

                    //thick divider
                    const Divider(thickness: 4, height: 25),

                    //Levels
                    ProfileLevelWidget(
                      levels: profileLevelState.profileLevel.levels,
                    ),

                    const Divider(thickness: 4, height: 25),

                    // Points Summary
                    ProfilePointsSummaryWidget(
                      profilePointsSummary:
                          profileLevelState.profileLevel.profilePointsSummary,
                    ),

                    const SizedBox(height: 15),
                  ],
                );
              } else {
                return const ThemeSpinner();
              }
            },
          ),
        ),
      ),
    );
  }
}
