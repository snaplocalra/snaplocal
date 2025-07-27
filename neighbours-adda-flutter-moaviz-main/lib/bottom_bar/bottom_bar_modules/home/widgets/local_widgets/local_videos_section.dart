import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_pages/home_local_pages_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_page_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_see_all_screen.dart';
import 'package:snap_local/common/social_media/post/video_feed/logic/video_feed_posts/video_feed_posts_cubit.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

import '../../../../../common/social_media/post/video_feed/screens/video_screen.dart';
import '../../../../../utility/constant/assets_images.dart';

class LocalVideosSection extends StatefulWidget {
  const LocalVideosSection({super.key});

  @override
  State<LocalVideosSection> createState() => _LocalVideosSectionState();
}

class _LocalVideosSectionState extends State<LocalVideosSection> {
  @override
  void initState() {
    super.initState();
    // Fetch local pages when widget initializes
    context.read<VideoSocialPostsCubit>().fetchVideoPosts();
  }

  Widget _buildShimmerItem() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ShimmerWidget(
            width: 100,
            height: 120,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 70,
                  height: 12,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                ShimmerWidget(
                  width: 50,
                  height: 10,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoSocialPostsCubit, VideoSocialPostsState>(
      builder: (context, state) {
        // Return empty widget if loading, has error, or no pages
        if (state.dataLoading ||
            state.error != null ||
            state.feedPosts.socialPostList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Learn with Experience',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SeeAllButton(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        VideoScreen.routeName,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.feedPosts.socialPostList.length,
                itemBuilder: (context, index) {
                  final post = state.feedPosts.socialPostList[index];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        VideoScreen.routeName,
                        queryParameters: {'id':post.id},
                        extra: index,
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(post.media.first.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(post.postUserInfo.isVerified==true)...[
                                  const SizedBox(width: 2),
                                  SvgPicture.asset(
                                    SVGAssetsImages.greenTick,
                                    height: 12,
                                    width: 12,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.postUserInfo.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  post.caption??"",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(child: Icon(Icons.play_arrow_outlined,size: 33,color: Colors.white.withOpacity(0.8),))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
