import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/screen/channel_overview_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/square_button.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/post_action_3_dot_button_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_news_channel_follow_state.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/home_route.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/router/check_current_route.dart';

class NewsPostShortHeading extends StatelessWidget {
  final NewsPostModel newsPostModel;
  final bool enableNewsPostAction;
  const NewsPostShortHeading({
    super.key,
    required this.newsPostModel,
    required this.enableNewsPostAction,
  });

  @override
  Widget build(BuildContext context) {
    final allowPostTypeNavigation = checkRoute(context, HomeRoute.routeName);
    return Row(
      children: [
        OctagonWidget(
          shapeSize: 40,
          borderWidth: 0,
          child: CachedNetworkImage(
            imageUrl: newsPostModel.newsChannelInfo.image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: newsPostModel.isOwnPost
                  ? null
                  : () {
                      GoRouter.of(context).pushNamed(
                        ChannelOverViewScreen.routeName,
                        queryParameters: {
                          'id': newsPostModel.newsChannelInfo.id
                        },
                        extra: context.read<PostDetailsControllerCubit>(),
                      );
                    },
              child: Text(
                newsPostModel.newsChannelInfo.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: allowPostTypeNavigation
                  ? () {
                      newsPostModel.navigateToPostTypeModule(context);
                    }
                  : null,
              child: Text(
                tr(newsPostModel.postType.displayText),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  decoration:
                      allowPostTypeNavigation ? TextDecoration.underline : null,
                  color: allowPostTypeNavigation
                      ? ApplicationColours.themeBlueColor
                      : null,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        if (enableNewsPostAction)
          BlocConsumer<PostActionCubit, PostActionState>(
            listener: (context, postActionState) {
              if (postActionState.isDeleteRequestLoading) {
                context.read<PostDetailsControllerCubit>().removeItemFromList();
              }
            },
            builder: (context, postActionState) {
              return (newsPostModel.isOwnPost)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SquareButton(
                        buttonText: newsPostModel.newsChannelInfo.isFollowing
                            ? tr(LocaleKeys.followed)
                            : tr(LocaleKeys.follow),
                        textColor: newsPostModel.newsChannelInfo.isFollowing
                            ? ApplicationColours.themeBlueColor
                            : ApplicationColours.themeBlueColor,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ApplicationColours.themeBlueColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onTap: postActionState.isFollowRequestLoading
                            ? null
                            : () {
                                context
                                    .read<PostDetailsControllerCubit>()
                                    .postStateUpdate(
                                      UpdateNewsChannelFollowState(
                                        isFollowed: !newsPostModel
                                            .newsChannelInfo.isFollowing,
                                      ),
                                    );
                                context
                                    .read<PostActionCubit>()
                                    .newsChannelToggleFollow(
                                        newsPostModel.newsChannelInfo.id);
                              },
                      ),
                    );
            },
          ),
        if (enableNewsPostAction)
          BlocListener<HidePostCubit, HidePostState>(
            listener: (context, hidePostState) {
              if (hidePostState.requestLoading) {
                context.read<PostDetailsControllerCubit>().removeItemFromList();
              }
            },
            child: BlocListener<ReportCubit, ReportState>(
              listener: (context, reportState) {
                //Remove item from list if report success
                if (reportState.requestSuccess) {
                  context
                      .read<PostDetailsControllerCubit>()
                      .removeItemFromList();
                }
              },
              child: SvgButtonWidget(
                svgImage: SVGAssetsImages.moreDot,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => PostAction3DotButtonWidget()
                        .build(context, newsPostModel),
                  );
                },
              ),
            ),
          )
      ],
    );
  }
}
