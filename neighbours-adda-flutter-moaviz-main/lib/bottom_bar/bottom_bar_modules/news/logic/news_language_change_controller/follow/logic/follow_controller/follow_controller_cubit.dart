import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/model/follow_handler.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/follow/repository/follow_handler_repository.dart';

part 'follow_controller_state.dart';

class FollowControllerCubit extends Cubit<FollowControllerState> {
  FollowControllerCubit() : super(FollowRequestInitial());

  void followExcecute(FollowHandler followHandler) async {
    try {
      emit(FollowRequestLoading());
      await FollowHandlerRepositoryImpl().execute(followHandler);
      emit(FollowRequestSuccess());
    } catch (e) {
      emit(const FollowRequestError("Unable to block"));
    }
  }
}
