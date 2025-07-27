import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/news_post_type_model.dart';

part 'news_post_type_controller_state.dart';

class NewsPostTypeControllerCubit extends Cubit<NewsPostTypeControllerState> {
  NewsPostTypeControllerCubit()
      : super(NewsPostTypeControllerState(newsPostTypeList: newsPostTypeList));

  //Change the state to the selected news post type based on the index
  void selectNewsPostType(int index) {
    emit(state.copyWith(isNewsPostTypeLoading: true));
    final updatedNewsPostTypeList = newsPostTypeList.map((newsPostType) {
      return newsPostType.copyWith(
        //Set true if the index matches the selected index
        //Or set false if the index does not match the selected index
        isSelected: newsPostType.newsPostType.index == index,
      );
    }).toList();
    emit(state.copyWith(
      isNewsPostTypeLoading: false,
      newsPostTypeList: updatedNewsPostTypeList,
    ));
  }

  ///Get the selected news post type
  ///If no news post type is selected, return null
  NewsPostType? getSelectedNewsPostType() {
    for (var newsPostType in state.newsPostTypeList) {
      if (newsPostType.isSelected) {
        return newsPostType.newsPostType;
      }
    }
    return null;
  }

  //Unselect all the news post types
  void unSelectAllNewsPostType() {
    final updatedNewsPostTypeList = newsPostTypeList.map((newsPostType) {
      return newsPostType.copyWith(isSelected: false);
    }).toList();
    emit(state.copyWith(newsPostTypeList: updatedNewsPostTypeList));
  }
}
