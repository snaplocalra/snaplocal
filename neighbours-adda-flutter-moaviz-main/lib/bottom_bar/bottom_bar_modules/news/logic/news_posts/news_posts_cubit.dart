import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/repository/news_repository.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

part 'news_posts_state.dart';

class NewsPostsCubit extends Cubit<NewsPostsState> {
  final NewsRepository newsRepository;
  NewsPostsCubit(this.newsRepository)
      : super(
          NewsPostsState(
            dataLoading: true,
            news: SocialPostsList(
              socialPostList: [],
              paginationModel: PaginationModel.initial(),
            ),
          ),
        );

  Future<void> fetchNews({
    bool loadMoreData = false,
    bool enableLoading = false,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      if (enableLoading) {
        emit(state.copyWith(dataLoading: true));
      }

      late SocialPostsList news;
      if (loadMoreData) {
        //Run the fetch PagePosts API, if it is not the last page.
        if (!state.news.paginationModel.isLastPage) {
          //Increase the current page counter
          state.news.paginationModel.currentPage += 1;

          news = await newsRepository.fetchNews(
            page: state.news.paginationModel.currentPage,
            filterJson: filterJson,
            searchKeyword: searchKeyword,
          );
          if (isClosed) {
            return;
          }
          //emit the updated state.
          emit(state.copyWith(
              news: state.news.paginationCopyWith(newData: news)));
        } else {
          if (isClosed) {
            return;
          }
          //Existing state emit
          emit(state.copyWith());
        }
      } else {
        news = await newsRepository.fetchNews(
          page: 1,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
        if (isClosed) {
          return;
        }
        //Emit the new state if it is the initial load request
        emit(state.copyWith(news: news));
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
    }
  }

  ///This method is used to remove the post and quick update the ui, when the user delete the post
  Future<void> removePost(int index) async {
    try {
      if (state.news.socialPostList.isNotEmpty) {
        emit(state.copyWith(dataLoading: true));
        state.news.socialPostList.removeAt(index);
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
