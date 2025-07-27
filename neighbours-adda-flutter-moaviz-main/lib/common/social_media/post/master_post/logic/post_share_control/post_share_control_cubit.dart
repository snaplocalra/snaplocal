import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'post_share_control_state.dart';

class PostShareControlCubit extends Cubit<PostShareControlState> {
  final PostSharePermission postShareControlEnum;
  PostShareControlCubit(this.postShareControlEnum)
      : super(PostShareControlState(postShareControlEnum));

  void changeSharePermission(PostSharePermission newPostShareControlEnum) {
    emit(state.copyWith(postShareControlEnum: newPostShareControlEnum));
  }
}
