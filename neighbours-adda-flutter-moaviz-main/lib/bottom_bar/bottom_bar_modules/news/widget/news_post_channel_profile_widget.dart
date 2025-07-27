import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/screen/channel_overview_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/widget/square_button.dart';
import 'package:snap_local/common/social_media/post/action_dialog/widgets/post_action_3_dot_button_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/update_news_channel_follow_state.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/google_translate/widget/google_translate_text.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsPostChannelProfileWidget extends StatelessWidget {
  final NewsPostModel newsPostModel;
  const NewsPostChannelProfileWidget({
    super.key,
    required this.newsPostModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsLanguageChangeControllerCubit,
        NewsLanguageChangeControllerState>(
      builder: (context, newsLanguageChangeControllerState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        ChannelOverViewScreen.routeName,
                        queryParameters: {
                          'id': newsPostModel.newsChannelInfo.id
                        },
                        extra: context.read<PostDetailsControllerCubit>(),
                      );
                    },
                    child: OctagonWidget(
                      shapeSize: 35,
                      borderWidth: 0,
                      child: CachedNetworkImage(
                        imageUrl: newsPostModel.newsChannelInfo.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            ChannelOverViewScreen.routeName,
                            queryParameters: {
                              'id': newsPostModel.newsChannelInfo.id
                            },
                            extra: context.read<PostDetailsControllerCubit>(),
                          );
                        },
                        child: GoogleTranslateText(
                          text: newsPostModel.newsChannelInfo.name,
                          targetLanguageCode: newsLanguageChangeControllerState
                              .selectedLanguage
                              .languageEnum
                              .locale
                              .languageCode,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          enableTranslation: newsLanguageChangeControllerState
                              .enableTranslation,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color.fromRGBO(215, 244, 254, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SVGAssetsImages.newsReporter,
                                height: 15,
                                width: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                tr(LocaleKeys.newsReporter),
                                style: TextStyle(
                                  color: ApplicationColours.themeBlueColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Visibility(
                    visible: !newsPostModel.isOwnPost,
                    child: BlocBuilder<PostActionCubit, PostActionState>(
                      builder: (context, postActionState) {
                        return SquareButton(
                          buttonText: newsPostModel.newsChannelInfo.isFollowing
                              ? tr(LocaleKeys.followed)
                              : tr(LocaleKeys.follow),
                          buttonTextSize: 11,
                          textColor: Colors.white,
                          decoration: BoxDecoration(
                            color: ApplicationColours.themeBlueColor,
                            border: Border.all(
                              color: ApplicationColours.themeBlueColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onTap: postActionState.isFollowRequestLoading
                              ? null
                              : () {
                                  // update the follow status on UI
                                  context
                                      .read<PostDetailsControllerCubit>()
                                      .postStateUpdate(
                                          UpdateNewsChannelFollowState(
                                        isFollowed: !newsPostModel
                                            .newsChannelInfo.isFollowing,
                                      ));

                                  context
                                      .read<PostActionCubit>()
                                      .newsChannelToggleFollow(
                                        newsPostModel.newsChannelInfo.id,
                                      );
                                },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  SvgButtonWidget(
                    svgImage: SVGAssetsImages.moreDot,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => PostAction3DotButtonWidget()
                            .build(context, newsPostModel),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: GoogleTranslateText(
                  text: newsPostModel.newsChannelInfo.description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  targetLanguageCode: newsLanguageChangeControllerState
                      .selectedLanguage.languageEnum.locale.languageCode,
                  enableTranslation:
                      newsLanguageChangeControllerState.enableTranslation,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
