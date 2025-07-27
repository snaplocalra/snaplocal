import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/profile/profile_details/repository/profile_posts_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'neighbours_posts_state.dart';

class NeighboursPostsCubit extends Cubit<NeighboursPostsState> {
  final ProfilePostsRepository ownPostsRepository;

  NeighboursPostsCubit(this.ownPostsRepository)
      : super(
          NeighboursPostsState(
            posts: SocialPostsList(
              socialPostList: [],
              paginationModel: PaginationModel.initial(),
            ),
          ),
        );

  Future<void> fetchSocialPosts(
    PostViewType postViewType, {
    bool loadMoreData = false,
    bool showLoading = false,
    required String userId,
  }) async {
    try {
      if (state.posts.socialPostList.isEmpty || showLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      //Late initial for the feed post
      late SocialPostsList posts;

      if (loadMoreData) {
        //Run the fetch posts API, if it is not the last page.
        if (!state.posts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.posts.paginationModel.currentPage += 1;

          posts = await ownPostsRepository.fetchProfilePosts(
            page: state.posts.paginationModel.currentPage,
            userId: userId,
            postViewType: postViewType,
          );
          //emit the updated state.
          emit(state.copyWith(
            posts: state.posts.paginationCopyWith(newData: posts),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        posts = await ownPostsRepository.fetchProfilePosts(
          page: 1,
          userId: userId,
          postViewType: postViewType,
        );
        emit(state.copyWith(posts: posts));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.posts.socialPostList.isEmpty) {
        emit(state.copyWith(error: e.toString()));
        return;
      } else {
        ThemeToast.errorToast(e.toString());
        emit(state.copyWith());
        return;
      }
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePost(int index) async {
    try {
      if (state.posts.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.posts.socialPostList.removeAt(index);
        emit(state.copyWith());
      } else {
        throw ("No data available");
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }
}
