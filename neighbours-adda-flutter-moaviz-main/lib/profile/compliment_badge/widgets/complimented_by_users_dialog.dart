import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/text_scroll_widget.dart';
import 'package:snap_local/profile/compliment_badge/logic/complimented_by_users/complimented_by_users_cubit.dart';
import 'package:snap_local/profile/compliment_badge/models/complimented_user_model.dart';
import 'package:snap_local/profile/compliment_badge/repository/complimented_by_user_repository.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class ComplimentedByUsersDialog extends StatelessWidget {
  final String userId;
  final String badgeId;

  const ComplimentedByUsersDialog(
      {super.key, required this.userId, required this.badgeId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          ComplimentedByUsersCubit(ComplimentedByUserRepository())
            ..fetchComplimentedByUsers(userId: userId, badgeId: badgeId),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: size.height * 0.6,
          child:
              BlocBuilder<ComplimentedByUsersCubit, ComplimentedByUsersState>(
            builder: (context, complimentedByUsersState) {
              if (complimentedByUsersState is ComplimentedByUsersError) {
                return ErrorTextWidget(error: complimentedByUsersState.message);
              } else if (complimentedByUsersState
                  is ComplimentedByUsersLoaded) {
                final logs = complimentedByUsersState.users;

                if (logs.isEmpty) {
                  return Center(
                    child: Text(
                      tr(LocaleKeys.noUserDetailsFound),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final user = logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            //Profile navigation
                            userProfileNavigation(
                              context,
                              userId: user.userId,
                              isOwner: user.isGivenByYou,
                            );
                          },
                          child: _ComplimentedByUserCard(user: user),
                        ),
                      );
                    },
                  );
                }
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

class _ComplimentedByUserCard extends StatelessWidget {
  const _ComplimentedByUserCard({
    required this.user,
  });

  final ComplimentedUserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 10,
          ),
          child: Row(
            children: [
              NetworkImageCircleAvatar(
                radius: 25,
                imageurl: user.userImage,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      ExpandedTextScrollWidget(
                        text: user.userLocation.address,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SvgPicture.network(
                user.givenBadgeSvg,
                height: 25,
                width: 25,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        const ThemeDivider(thickness: 2),
      ],
    );
  }
}
