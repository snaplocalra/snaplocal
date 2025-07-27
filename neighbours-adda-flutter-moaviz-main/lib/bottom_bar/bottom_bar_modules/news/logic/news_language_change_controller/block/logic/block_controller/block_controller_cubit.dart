import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/model/block_handler.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/block/repository/block_handler_repository.dart';

part 'block_controller_state.dart';

class BlockControllerCubit extends Cubit<BlockControllerState> {
  BlockControllerCubit() : super(BlockControllerInitial());

  void blockExcecute(BlockHandler blockHandler) async {
    try {
      emit(BlockControllerLoading());
      await BlockHandlerRepositoryImpl().execute(blockHandler);
      emit(BlockControllerSuccess());
    } catch (e) {
      emit(const BlockControllerError("Unable to block"));
    }
  }
}
