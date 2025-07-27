import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/model/news_dashboard_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/repository/news_dashboard_repository.dart';

part 'news_dashboard_news_list_state.dart';

class NewsDashboardNewsListCubit extends Cubit<NewsDashboardNewsListState> {
  final NewsDashboardRepository newsDashboardRepository;

  NewsDashboardNewsListCubit(this.newsDashboardRepository)
      : super(NewsDashboardNewsListInitial());

  //Fetch the news dashboard news list
  Future<void> fetchNewsDashboardNewsList() async {
    try {
      emit(NewsDashboardNewsListLoading());
      final newsDashboardNewsList =
          await newsDashboardRepository.getNewsDashboardNewsList();
      emit(NewsDashboardNewsListLoaded(newsDashboardNewsList));
    } catch (e) {
      emit(NewsDashboardNewsListLoadFailed(errorMessage: e.toString()));
    }
  }

  //Remove the news post from the top performing news and my approved news
  void removeNewsPostFromTopPerformingNews(int index) {
    if (state is NewsDashboardNewsListLoaded) {
      final newsDashboardNewsListModel =
          (state as NewsDashboardNewsListLoaded).newsDashboardNewsListModel;
      final topPerformingNews = newsDashboardNewsListModel.topPerformingNews;
      final removedPost = topPerformingNews.socialPostList.removeAt(index);

      //if the removed post id is present in my approved news then remove it from there as well
      newsDashboardNewsListModel.myApprovedNews.socialPostList
          .removeWhere((element) => element.id == removedPost.id);
      emit(NewsDashboardNewsListLoading());
      emit(NewsDashboardNewsListLoaded(newsDashboardNewsListModel));
    }
  }

  void removeNewsPostFromMyApprovedNews(int index) {
    if (state is NewsDashboardNewsListLoaded) {
      final newsDashboardNewsListModel =
          (state as NewsDashboardNewsListLoaded).newsDashboardNewsListModel;
      final myApprovedNews = newsDashboardNewsListModel.myApprovedNews;
      final removedPost = myApprovedNews.socialPostList.removeAt(index);

      //if the removed post id is present in top performing news then remove it from there as well
      newsDashboardNewsListModel.topPerformingNews.socialPostList
          .removeWhere((element) => element.id == removedPost.id);
      emit(NewsDashboardNewsListLoading());
      emit(NewsDashboardNewsListLoaded(newsDashboardNewsListModel));
    }
  }
}
