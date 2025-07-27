import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_preview_view_state.dart';

class PostPreviewViewCubit extends Cubit<PostPreviewViewState> {
  PostPreviewViewCubit() : super(const PostPreviewViewState());

  void toogleVisibility(bool visibility) {
    emit(state.copyWith(visibility: !visibility));
  }
}
