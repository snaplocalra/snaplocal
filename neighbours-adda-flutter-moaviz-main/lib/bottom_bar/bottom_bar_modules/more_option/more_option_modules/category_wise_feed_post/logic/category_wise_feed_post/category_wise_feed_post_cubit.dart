import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/repository/categorywise_feed_post_repository.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'category_wise_feed_post_state.dart';

class CategoryWiseFeedPostCubit extends Cubit<CategoryWiseFeedPostState> {
  final CateegoryWiseFeedPostRepository categoryWiseSocialPostRepository;
  CategoryWiseFeedPostCubit(this.categoryWiseSocialPostRepository)
      : super(
          CategoryWiseFeedPostState(
              categoryWiseFeedPosts: SocialPostsList(
            socialPostList: [],
            paginationModel: PaginationModel.initial(),
          )),
        );

  Future<void> fetchCategoryWiseFeedPosts({
    bool loadMoreData = false,
    required FeedPostCategoryType categoryType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      //Show the loading indicator every time except when the pagination api is called
      if (!loadMoreData) {
        emit(state.copyWith(dataLoading: true));
      }

      //Late initial for the feed post
      late SocialPostsList categoryWiseFeedPosts;
      if (loadMoreData) {
        //Run the fetch home feed API, if it is not the last page.
        if (!state.categoryWiseFeedPosts.paginationModel.isLastPage) {
          //Increase the current page counter
          state.categoryWiseFeedPosts.paginationModel.currentPage += 1;

          categoryWiseFeedPosts =
              await categoryWiseSocialPostRepository.fetchCategoryWiseFeedPosts(
            page: state.categoryWiseFeedPosts.paginationModel.currentPage,
            categoryType: categoryType,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
          //emit the updated state.
          emit(state.copyWith(
            categoryWiseFeedPosts: state.categoryWiseFeedPosts
                .paginationCopyWith(newData: categoryWiseFeedPosts),
          ));
        } else {
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        categoryWiseFeedPosts =
            await categoryWiseSocialPostRepository.fetchCategoryWiseFeedPosts(
          page: 1,
          categoryType: categoryType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
        //Emit the new state if it is the initial load request
        emit(state.copyWith(categoryWiseFeedPosts: categoryWiseFeedPosts));
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      if (state.categoryWiseFeedPosts.socialPostList.isEmpty) {
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
      if (state.categoryWiseFeedPosts.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.categoryWiseFeedPosts.socialPostList.removeAt(index);
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
