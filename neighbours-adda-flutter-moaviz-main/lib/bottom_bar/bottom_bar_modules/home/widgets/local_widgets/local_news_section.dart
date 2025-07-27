import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_news/local_news_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_news/local_news_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_news_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/screen/news_post_view_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/screen/news_list_screen.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class LocalNewsSection extends StatefulWidget {
  const LocalNewsSection({super.key});

  @override
  State<LocalNewsSection> createState() => _LocalNewsSectionState();
}

class _LocalNewsSectionState extends State<LocalNewsSection> {
  @override
  void initState() {
    super.initState();
    // Fetch local news when widget initializes
    context.read<LocalNewsCubit>().fetchLocalNews();
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ShimmerWidget(
            width: 100,
            height: 100,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 160,
                  height: 16,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 120,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 140,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerWidget(
                  width: 180,
                  height: 14,
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

  Widget _buildNewsItem(BuildContext context, LocalNewsModel news, bool isLast) {
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).pushNamed(
          NewsPostViewDetailsScreen.routeName,
          queryParameters: {"id": news.id},
          extra: {
            'showReactionCubit': context.read<ShowReactionCubit>(),
            'postActionCubit': context.read<PostActionCubit>(),
            'reportCubit': context.read<ReportCubit>(),
            'commentViewControllerCubit':
            context.read<CommentViewControllerCubit>(),
            'hidePostCubit': context.read<HidePostCubit>(),
          },
        );
      //   GoRouter.of(context).pushNamed(
      //   NewsPostViewDetailsScreen.routeName,
      //   queryParameters: {"id": news.id},
      //   extra: {
      //     'postDetailsControllerCubit':
      //         context.read<PostDetailsControllerCubit>(),
      //     'showReactionCubit': context.read<ShowReactionCubit>(),
      //     'postActionCubit': context.read<PostActionCubit>(),
      //     'reportCubit': context.read<ReportCubit>(),
      //     'commentViewControllerCubit':
      //         context.read<CommentViewControllerCubit>(),
      //     'hidePostCubit': context.read<HidePostCubit>(),
      //   },
      // ).then((value) {
       
      // });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: news.media.isNotEmpty
                  ? Image.network(
                      news.media.first.mediaType == 'video' 
                          ? news.media.first.thumbnail.toString()
                          : news.media.first.mediaPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.article,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.headline,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.pink,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          news.taggedLocation.address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1A237E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news.description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalNewsCubit, LocalNewsState>(
      builder: (context, state) {
        // Return empty widget if loading, has error, or no news
        if(state.error != null){
          return Text(state.error.toString());
        }
        if (state.dataLoading || state.error != null || state.news.isEmpty) {
          return const SizedBox.shrink();
        }

        // Take first 9 news items
        final newsItems = state.news.take(9).toList();
        // Split into 3 groups of 3 items each
        final List<List<LocalNewsModel>> newsGroups = [];
        for (var i = 0; i < newsItems.length; i += 3) {
          newsGroups.add(newsItems.sublist(i, i + 3 > newsItems.length ? newsItems.length : i + 3));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      print('helllo');  
                      context.read<LocalNewsCubit>().fetchLocalNews();
                    },
                    child: const Text(
                      'Local News',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  SeeAllButton(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        NewsListScreen.routeName,
                        extra: state.news,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 365, // Increased height to accommodate 3 news items per card
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                scrollDirection: Axis.horizontal,
                itemCount: newsGroups.length,
                itemBuilder: (context, groupIndex) {
                  final newsGroup = newsGroups[groupIndex];
                  return Container(
                    width: 300, // Width for each card
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: List.generate(
                        newsGroup.length,
                        (index) => _buildNewsItem(
                          context,
                          newsGroup[index],
                          index == newsGroup.length - 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
