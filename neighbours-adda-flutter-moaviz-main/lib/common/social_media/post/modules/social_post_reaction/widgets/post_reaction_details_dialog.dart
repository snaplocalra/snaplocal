import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/post_reaction_details/post_reaction_details_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/text_scroll_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/tools/theme_divider.dart';

class PostReactionDetailsDialog extends StatefulWidget {
  final PostType postType;
  final String postId;
  final PostFrom postFrom;

  const PostReactionDetailsDialog({
    super.key,
    required this.postType,
    required this.postId,
    required this.postFrom,
  });

  @override
  State<PostReactionDetailsDialog> createState() =>
      _PostReactionDetailsDialogState();
}

class _PostReactionDetailsDialogState extends State<PostReactionDetailsDialog> {
  late PostReactionDetailsCubit postReactionDetailsCubit =
      PostReactionDetailsCubit(ReactionRepository());

  @override
  void initState() {
    super.initState();
    postReactionDetailsCubit.fetchPostReactionDetails(
      postId: widget.postId,
      postFrom: widget.postFrom,
      postType: widget.postType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: postReactionDetailsCubit,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: size.height * 0.6,
          child:
              BlocBuilder<PostReactionDetailsCubit, PostReactionDetailsState>(
            builder: (context, postReactionDetailsState) {
              if (postReactionDetailsState.errorMessage != null) {
                return ErrorTextWidget(
                  error: postReactionDetailsState.errorMessage!,
                );
              } else if (postReactionDetailsState.isLoading) {
                return const ThemeSpinner();
              } else {
                final postReactionDetails =
                    postReactionDetailsState.postReactionDetails!;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Text(
                            tr(LocaleKeys.all),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ApplicationColours.themeBlueColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: ApplicationColours.themeBlueColor,
                            child: Text(
                              postReactionDetails
                                  .reactionCountDetails.totalReactions
                                  .formatNumber(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: postReactionDetails
                                        .reactionCountDetails
                                        .individualReactionsCount
                                        .length,
                                    itemBuilder: (context, index) {
                                      final reaction = postReactionDetails
                                          .reactionCountDetails
                                          .individualReactionsCount[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Row(
                                          children: [
                                            SvgPicture.network(
                                              reaction.reactionSvg,
                                              height: 15,
                                              width: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(reaction.reactionCount
                                                .formatNumber()),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ThemeDivider(thickness: 2, height: 0),

                    //Reacted Users List
                    Expanded(
                      child: ListView.builder(
                        itemCount: postReactionDetails.usersReacted.length,
                        itemBuilder: (context, index) {
                          final reactedUser =
                              postReactionDetails.usersReacted[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: _ReactedUserCard(
                              reactedUser: reactedUser,
                              onProfileTap: () {
                                //Profile navigation
                                userProfileNavigation(
                                  context,
                                  userId: reactedUser.userId,
                                  isOwner: reactedUser.isOwnReaction,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ReactedUserCard extends StatelessWidget {
  const _ReactedUserCard({
    required this.reactedUser,
    this.onProfileTap,
  });

  final UserReactedModel reactedUser;
  final void Function()? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 10,
            ),
            child: Row(
              children: [
                NetworkImageCircleAvatar(
                  radius: 25,
                  imageurl: reactedUser.userImage,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reactedUser.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        ExpandedTextScrollWidget(
                          text: reactedUser.userLocation.address,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.network(
                  reactedUser.givenReactionSvg,
                  height: 18,
                  width: 18,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        const ThemeDivider(thickness: 2),
      ],
    );
  }
}
