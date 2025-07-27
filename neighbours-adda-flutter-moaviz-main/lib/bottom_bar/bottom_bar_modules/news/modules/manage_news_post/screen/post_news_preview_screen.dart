import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/post_news_preview_screen_payload.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/file_media_carousels_widget.dart';
import 'package:snap_local/utility/common/read_more/widget/read_more_text.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PostNewsPreviewScreen extends StatelessWidget {
  final PostNewsPreviewScreenPayload postNewsPreviewScreenPayload;

  static const routeName = 'news_preview';

  const PostNewsPreviewScreen({
    super.key,
    required this.postNewsPreviewScreenPayload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        showBackButton: true,
        backgroundColor: Colors.white,
        titleSpacing: 6,
        appBarHeight: 50,
        title: Text(
          tr(LocaleKeys.newsPreview),
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Post image
                          if (postNewsPreviewScreenPayload
                              .pickedMediaList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: FileMediaCarouselWidget(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  media: postNewsPreviewScreenPayload
                                      .pickedMediaList,
                                ),
                              ),
                            ),

                          // Heading
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                postNewsPreviewScreenPayload
                                    .newsPostModel.newsHeadLine,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Captions
                              ReadMoreText(
                                postNewsPreviewScreenPayload
                                    .newsPostModel.newsDescription,
                                readMoreText: tr(LocaleKeys.readMore),
                                readLessText: tr(LocaleKeys.readLess),
                                style: const TextStyle(
                                  color: Color.fromRGBO(109, 109, 109, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Visibility(
                            visible: postNewsPreviewScreenPayload
                                .newsPostModel.newsReporter.visibility,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color.fromRGBO(215, 244, 254, 1),
                                ),
                                height: 25,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      SVGAssetsImages.writtenBy,
                                      height: 16,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${tr(LocaleKeys.writtenBy)} ~ ${postNewsPreviewScreenPayload.newsPostModel.newsReporter.name}",
                                      style: TextStyle(
                                        color:
                                            ApplicationColours.themeBlueColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 15),
              child: ThemeElevatedButton(
                height: 40,
                width: 125,
                buttonName: tr(LocaleKeys.postNews),
                textFontSize: 13,
                suffix: Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: SvgPicture.asset(
                    SVGAssetsImages.direction,
                    height: 9,
                  ),
                ),
                onPressed: () {
                  //return true in pop
                  GoRouter.of(context).pop(true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
