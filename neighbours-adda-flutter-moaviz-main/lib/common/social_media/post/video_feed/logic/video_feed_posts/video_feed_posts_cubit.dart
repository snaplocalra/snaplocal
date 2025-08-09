import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';
import 'package:snap_local/utility/storage/cache/logic/cache_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../repository/video_data_repository.dart';

part 'video_feed_posts_state.dart';

class VideoSocialPostsCubit extends Cubit<VideoSocialPostsState>
    with HydratedMixin {
  final VideoDataRepository videoDataRepository;
  VideoSocialPostsCubit(
    this.videoDataRepository,
  ) : super(
    VideoSocialPostsState(
            dataLoading: true,
            feedPosts: SocialPostsList(
              socialPostList: [],
              paginationModel: PaginationModel.initial(),
              postIndexList: [],
            ),
          ),
        );

  Future<void> fetchVideoPosts({bool loadMoreData = false, BuildContext? context}) async {
    try {
      //emit loading if the feed post list is empty
      if (state.error != null || state.feedPosts.socialPostList.isEmpty) {
        emit(state.copyWith(dataLoading: true));
      }

      //Late initial for the feed post
      late SocialPostsList feedPosts;

      if (loadMoreData) {
        //Run the fetch video feed API, if it is not the last page.
        if (!state.feedPosts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.feedPosts.paginationModel.currentPage += 1;

          feedPosts = await videoDataRepository.fetchVideoPosts(
              page: state.feedPosts.paginationModel.currentPage);
          //emit the updated state.
          emit(state.copyWith(
            feedPosts: state.feedPosts.paginationCopyWith(newData: feedPosts),
          ));
          _preloadUpcomingVideos(context, state.feedPosts.socialPostList);
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        feedPosts = await videoDataRepository.fetchVideoPosts(page: 1);
        //Emit the new state if it is the initial load request
        emit(state.copyWith(feedPosts: feedPosts));
        _preloadUpcomingVideos(context, feedPosts.socialPostList);
        
        // Trigger background cache for future use
        if (context != null) {
          context.read<CacheCubit>().triggerBackgroundCache();
        }
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

      if (isClosed) {
        return;
      }
      if (state.feedPosts.socialPostList.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  void _preloadUpcomingVideos(BuildContext? context, List<SocialPostModel> posts) {
    if (context == null) return;
    final urlToThumbnailMap = <String, String?>{};
    for (final post in posts) {
      if (post.media != null && post.media.isNotEmpty) {
        for (final media in post.media) {
          // Use mediaType and thumbnail (not thumbnailUrl)
          if (media.mediaType == 'video' && media.mediaPath.isNotEmpty) {
            urlToThumbnailMap[media.mediaPath] = media.thumbnail;
          }
        }
      }
    }
    if (urlToThumbnailMap.isNotEmpty) {
      context.read<CacheCubit>().preloadUrls(urlToThumbnailMap);
    }
  }

  // ///This method is used to remove the post and quick update the ui, when the user delete the post
  // Future<void> removePost(int index) async {
  //   try {
  //     if (state.feedPosts.socialPostList.isNotEmpty) {
  //       emit(state.copyWith(dataLoading: true));
  //       state.feedPosts.socialPostList.removeAt(index);
  //       emit(state.copyWith());
  //     } else {
  //       throw ("No data available");
  //     }
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     ThemeToast.errorToast(e.toString());
  //   }
  // }

  @override
  VideoSocialPostsState? fromJson(Map<String, dynamic> json) {
    return VideoSocialPostsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(VideoSocialPostsState state) {
    return state.toMap();
  }
}
