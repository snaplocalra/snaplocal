// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:snap_local/common/social_media/post/carousel_view/screen/carousel_view_screen.dart';
// import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
// import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
//
// class PostMediaVerticalViewer extends StatelessWidget {
//   const PostMediaVerticalViewer({
//     super.key,
//     required this.media,
//   });
//
//   final List<NetworkMediaModel> media;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: media.length,
//       itemBuilder: (context, index) => Padding(
//         padding: const EdgeInsets.only(bottom: 2),
//         child: GestureDetector(
//           onTap: () {
//             // showDialog(
//             //   useSafeArea: false,
//             //   context: context,
//             //   builder: (context) => Dialog.fullscreen(
//             //     child: NetworkMediaCarouselView(
//             //       mediaList: media,
//             //       selectedMediaIndex: index,
//             //     ),
//             //   ),
//             // );
//             if(media[index] is NetworkImageMediaModel) {
//               GoRouter.of(context).pushNamed(
//                 CarouselViewScreen.routeName,
//                 queryParameters: {'selected_media_index': index.toString()},
//                 extra: media,
//               );
//             }
//             else {
//               // GoRouter.of(context).pushNamed(
//               //   VideoPlayerScreen.routeName,
//               //   queryParameters: {
//               //     'video_url': media[index].mediaUrl,
//               //   },
//               // );
//             }
//           },
//           child: NetworkMediaWidget(
//             key: ValueKey(media[index].mediaUrl),
//             media: media[index],
//             fit: BoxFit.cover,
//             videoheight: 400,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snap_local/common/social_media/post/carousel_view/screen/carousel_view_screen.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class PostMediaVerticalViewer extends StatefulWidget {

  const PostMediaVerticalViewer({
    super.key,
    required this.media,
    required this.onVideoViewCount,
  });
  final void Function()? onVideoViewCount;
  final List<NetworkMediaModel> media;

  @override
  State<PostMediaVerticalViewer> createState() => _PostMediaVerticalViewerState();
}

class _PostMediaVerticalViewerState extends State<PostMediaVerticalViewer> {
  final PageController _pageController = PageController();

  // // Check if the post has multiple videos
  @override
  Widget build(BuildContext context) {
    //if (hasMultipleVideos) {
      return _buildVideoCarousel(context);
    // } else {
    //   return _buildMediaList(context);
    // }
  }

  Widget _buildVideoCarousel(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height*0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.media.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // showDialog(
                    //   useSafeArea: false,
                    //   context: context,
                    //   builder: (context) => Dialog.fullscreen(
                    //     child: NetworkMediaCarouselView(
                    //       mediaList: media,
                    //       selectedMediaIndex: index,
                    //     ),
                    //   ),
                    // );
                    if(widget.media[index] is NetworkImageMediaModel) {
                      GoRouter.of(context).pushNamed(
                        CarouselViewScreen.routeName,
                        queryParameters: {'selected_media_index': index.toString()},
                        extra: widget.media,
                      );
                    }
                    else {
                      // GoRouter.of(context).pushNamed(
                      //   VideoPlayerScreen.routeName,
                      //   queryParameters: {
                      //     'video_url': media[index].mediaUrl,
                      //   },
                      // );
                    }
                  },
                  child: NetworkMediaWidget(
                        key: ValueKey(widget.media[index].mediaUrl),
                        media: widget.media[index],
                        onVideoViewCount: widget.onVideoViewCount,
                        fit: BoxFit.cover,
                    // height: MediaQuery.sizeOf(context).width*0.7,
                    // videoheight: MediaQuery.sizeOf(context).width*0.7,
                      ),
                ),
              ),
              if(widget.media.length>1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.media.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildMediaList(BuildContext context) {
  void _handleMediaTap(BuildContext context, int index, bool isCarousel) {
    final mediaItem = widget.media[index];

    if (mediaItem is NetworkImageMediaModel) {
      // Always open carousel for images
      GoRouter.of(context).pushNamed(
        CarouselViewScreen.routeName,
        queryParameters: {'selected_media_index': index.toString()},
        extra: widget.media,
      );
    }
    // else if (mediaItem is NetworkVideoMediaModel) {
    //   if (isCarousel || media.length > 1) {
    //     // For carousel items or posts with multiple media
    //     GoRouter.of(context).pushNamed(
    //       CarouselViewScreen.routeName,
    //       queryParameters: {'selected_media_index': index.toString()},
    //       extra: media,
    //     );
    //   } else {
    //     // For single videos
    //     GoRouter.of(context).pushNamed(
    //       VideoPlayerScreen.routeName,
    //       queryParameters: {'video_url': mediaItem.mediaUrl},
    //     );
    //   }
    // }
  }
}

