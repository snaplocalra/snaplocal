import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

part 'post_details_controller_state.dart';

class PostDetailsControllerCubit extends Cubit<PostDetailsControllerState> {
  final SocialPostModel socialPostModel;

  PostDetailsControllerCubit({required this.socialPostModel})
      : super(PostDetailsControllerState(socialPostModel: socialPostModel));

  void postStateUpdate(PostStateUpdate postStateUpdate) {
    emit(state.copyWith(dataLoading: true));
    postStateUpdate.updateState(socialPostModel);
    emit(state.copyWith());
  }

  void removeItemFromList() {
    emit(state.copyWith(dataLoading: true));
    emit(state.copyWith(removeItemFromList: true));
  }
}
