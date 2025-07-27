import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'read_more_controller_state.dart';

class ReadMoreControllerCubit extends Cubit<ReadMoreControllerState> {
  final int readLessLine;
  ReadMoreControllerCubit({required this.readLessLine})
      : super(const ReadMoreControllerState());

  void toggleEnableReadMore(bool enableReadMore) {
    emit(state.copyWith(enableReadMore: enableReadMore));
    if (enableReadMore) {
      readLess();
    }
  }

  void readMore() {
    emit(state.copyWith(
      maxLine: null,
      textOverflow: TextOverflow.visible,
    ));
  }

  void readLess() {
    emit(state.copyWith(
      maxLine: readLessLine,
      textOverflow: TextOverflow.ellipsis,
    ));
  }
}
