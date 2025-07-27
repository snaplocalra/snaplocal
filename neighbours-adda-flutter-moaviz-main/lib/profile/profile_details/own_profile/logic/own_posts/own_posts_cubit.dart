import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/profile/profile_details/repository/profile_posts_repository.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'own_posts_state.dart';

class OwnPostsCubit extends Cubit<OwnPostsState> with HydratedMixin {
  final ProfilePostsRepository ownPostsRepository;

  OwnPostsCubit(this.ownPostsRepository)
      : super(
          OwnPostsState(
            ownPosts: SocialPostsList(
              socialPostList: [],
              paginationModel: PaginationModel.initial(),
            ),
          ),
        );

  Future<void> fetchOwnSocialPosts(
    PostViewType postViewType, {
    bool loadMoreData = false,
    bool showLoading = false,
  }) async {
    try {
      final userId = await AuthenticationTokenSharedPref().getUserId();
      if (state.ownPosts.socialPostList.isEmpty || showLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      //Late initial for the feed post
      late SocialPostsList ownPosts;

      if (loadMoreData) {
        //Run the fetch ownPosts API, if it is not the last page.
        if (!state.ownPosts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.ownPosts.paginationModel.currentPage += 1;

          ownPosts = await ownPostsRepository.fetchProfilePosts(
            page: state.ownPosts.paginationModel.currentPage,
            userId: userId,
            postViewType: postViewType,
          );
          //emit the updated state.
          emit(state.copyWith(
            ownPosts: state.ownPosts.paginationCopyWith(newData: ownPosts),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        ownPosts = await ownPostsRepository.fetchProfilePosts(
          page: 1,
          userId: userId,
          postViewType: postViewType,
        );
        emit(state.copyWith(ownPosts: ownPosts));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.ownPosts.socialPostList.isEmpty) {
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
      if (state.ownPosts.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.ownPosts.socialPostList.removeAt(index);
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

  @override
  OwnPostsState? fromJson(Map<String, dynamic> json) {
    return OwnPostsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(OwnPostsState state) {
    return state.toMap();
  }
}
