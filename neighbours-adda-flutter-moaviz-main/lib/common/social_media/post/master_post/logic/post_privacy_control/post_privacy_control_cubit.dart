import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'post_privacy_control_state.dart';

class PostVisibilityControlCubit extends Cubit<PostVisibilityControlState> {
  final PostVisibilityControlEnum postVisibilityControlEnum;
  PostVisibilityControlCubit(this.postVisibilityControlEnum)
      : super(PostVisibilityControlState(postVisibilityControlEnum));

  void changePostVisibility(
      PostVisibilityControlEnum newPostVisibilityControlEnum) {
    emit(state.copyWith(
        postVisibilityControlEnum: newPostVisibilityControlEnum));
  }
}
