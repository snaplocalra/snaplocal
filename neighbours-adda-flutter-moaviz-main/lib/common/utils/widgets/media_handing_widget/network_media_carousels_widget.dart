import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snap_local/common/social_media/post/carousel_view/widget/carousel_view.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/media_player/video/video_thumbnail_holder.dart';

class NetworkMediaCarouselWidget extends StatefulWidget {
  final List<NetworkMediaModel> media;
  final double dotHeight;
  final double dotWidth;

  const NetworkMediaCarouselWidget({
    super.key,
    required this.media,
    this.dotHeight = 10,
    this.dotWidth = 10,
  });

  @override
  State<NetworkMediaCarouselWidget> createState() =>
      _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<NetworkMediaCarouselWidget> {
  late List<Widget> mediaSlider = [];

  int activeIndex = 0;

  void builtMedia() {
    mediaSlider = List<Widget>.generate(
      widget.media.length,
      (index) {
        final media = widget.media[index];
        return media is NetworkImageMediaModel
            ? GestureDetector(
                onTap: () {
                  print('Hellloooooo');
                  print('Index: $index');
                  print('Media: ${media.mediaUrl
                  }');
                  showDialog(
                    useSafeArea: false,
                    context: context,
                    builder: (context) => Dialog.fullscreen(
                      child: 
                      NetworkMediaCarouselView(
                        mediaList: widget.media,
                        selectedMediaIndex: index,
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: media.mediaUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            : media is NetworkVideoMediaModel
                ? VideoThumbnailHolder(
                    networkVideo: media,
                    fit: BoxFit.contain,
          width: double.infinity,
                  )
                : throw ("Unsupported media type");
      },
    );
  }

  @override
  void initState() {
    builtMedia();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NetworkMediaCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    builtMedia();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Visibility(
      visible: widget.media.isNotEmpty,
      child: Container(
        padding: EdgeInsets.only(bottom: mediaSlider.length > 1 ? 0 : 0),
        color: Colors.transparent,
        child: StatefulBuilder(builder: (context, carouselState) {
          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              FlutterCarousel(
                items: mediaSlider,
                options: FlutterCarouselOptions(
                  initialPage: 0,
                  viewportFraction: 1,
                  aspectRatio: 1,
                  height: mqSize.height * 0.48,
                  enableInfiniteScroll: false,
                  physics: const BouncingScrollPhysics(),
                  enlargeCenterPage: true,
                  showIndicator: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, reason) {
                    carouselState(() {
                      activeIndex = index;
                    });
                  },
                ),
              ),
              if (mediaSlider.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: mediaSlider.length,
                      effect: SlideEffect(
                        dotHeight: widget.dotHeight,
                        dotWidth: widget.dotWidth,
                        activeDotColor: ApplicationColours.themeBlueColor,
                        dotColor: const Color.fromRGBO(112, 104, 104, 0.3),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
