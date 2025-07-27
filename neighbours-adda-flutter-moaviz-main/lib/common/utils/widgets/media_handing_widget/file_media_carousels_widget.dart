import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/media_player/video/video_thumbnail_holder.dart';

class FileMediaCarouselWidget extends StatefulWidget {
  final List<MediaFileModel> media;
  final double dotHeight;
  final double dotWidth;

  const FileMediaCarouselWidget({
    super.key,
    required this.media,
    this.dotHeight = 10,
    this.dotWidth = 10,
  });

  @override
  State<FileMediaCarouselWidget> createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<FileMediaCarouselWidget> {
  late List<Widget> mediaSlider = [];
  int activeIndex = 0;

  void builtMedia() {
    mediaSlider = List<Widget>.generate(
      widget.media.length,
      (index) {
        final mediaFile = widget.media[index];
        return mediaFile is ImageFileMediaModel
            ? Image.file(
                mediaFile.imageFile,
                fit: BoxFit.cover,
              )
            : mediaFile is VideoFileMediaModel
                ? VideoThumbnailHolder(
                    videoFile: mediaFile,
                    fit: BoxFit.cover,
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
  void didUpdateWidget(covariant FileMediaCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    builtMedia();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return Visibility(
      visible: widget.media.isNotEmpty,
      child: Container(
        padding: EdgeInsets.only(bottom: mediaSlider.length > 1 ? 10 : 0),
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
                  height: mqSize.height * 0.48,
                  enableInfiniteScroll: false,
                  showIndicator: false,
                  physics: const BouncingScrollPhysics(),
                  enlargeCenterPage: true,
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
