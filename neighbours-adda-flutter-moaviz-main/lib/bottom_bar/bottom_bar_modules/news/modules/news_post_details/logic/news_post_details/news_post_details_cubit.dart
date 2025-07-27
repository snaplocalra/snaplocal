import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/repository/news_post_details_repository.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';

part 'news_post_details_state.dart';

class NewsPostDetailsCubit extends Cubit<NewsPostDetailsState> {
  final NewsPostDetailsRepository newsPostDetailsRepository;

  NewsPostDetailsCubit(this.newsPostDetailsRepository)
      : super(NewsPostDetailsInitial());

  //load news post details
  void loadNewsPostDetails(String postId) {
    emit(NewsPostDetailsLoading());
    newsPostDetailsRepository.fetchNewsPostDetails(postId).then((newsPost) {
      emit(NewsPostDetailsLoaded(newsPost));
    }).catchError((e) {
      emit(NewsPostDetailsError(e.toString()));
    });
  }
}
