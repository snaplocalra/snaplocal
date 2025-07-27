import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';

part 'post_view_filter_state.dart';

class PostViewFilterCubit extends Cubit<PostViewFilterState> {
  PostViewFilterCubit()
      : super(
          PostViewFilterState(
            postFilters: [
              PostViewFilterCategory(postType: PostType.all),
              PostViewFilterCategory(postType: PostType.general),
              // PostViewFilterCategory(postType: PostType.event),
              PostViewFilterCategory(postType: PostType.poll),
              // PostViewFilterCategory(postType: PostType.safety),
              // PostViewFilterCategory(postType: PostType.lostFound),
              PostViewFilterCategory(postType: PostType.askQuestion),
              PostViewFilterCategory(postType: PostType.askSuggestion),
            ],
          ),
        );

  // select single view filter from the viewFilters based on viewFilter index
  void selectViewFilter(int index) {
    emit(state.copyWith(dataLoading: true));

    for (int i = 0; i < state.postFilters.length; i++) {
      if (i == index) {
        state.postFilters[i] = state.postFilters[i].copyWith(isSelected: true);
      } else {
        state.postFilters[i] = state.postFilters[i].copyWith(isSelected: false);
      }
    }

    emit(state.copyWith(allowFetchData: true));
  }

  //select multiple category from the categoryList based on category index
  // void selectViewFilter(int index) {
  //   emit(state.copyWith(dataLoading: true));
  //   state.postFilters[index] = state.postFilters[index]
  //       .copyWith(isSelected: !state.postFilters[index].isSelected);
  //   emit(state.copyWith(allowFetchData: true));
  // }
}
