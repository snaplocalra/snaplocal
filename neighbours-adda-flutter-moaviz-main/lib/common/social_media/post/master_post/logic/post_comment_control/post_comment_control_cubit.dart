import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'post_comment_control_state.dart';

class PostCommentControlCubit extends Cubit<PostCommentControlState> {
  final PostCommentPermission postCommentControlEnum;
  PostCommentControlCubit(this.postCommentControlEnum)
      : super(PostCommentControlState(postCommentControlEnum));

  void changeCommentPermission(PostCommentPermission newPostCommentControlEnum) {
    emit(state.copyWith(postCommentControlEnum: newPostCommentControlEnum));
  }
}
