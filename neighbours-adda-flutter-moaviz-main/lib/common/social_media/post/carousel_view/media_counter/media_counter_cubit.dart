import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'media_counter_state.dart';

class MediaCounterCubit extends Cubit<MediaCounterState> {
  final int curentMediaIndex;
  MediaCounterCubit({required this.curentMediaIndex})
      : super(MediaCounterState(curentMediaIndex: curentMediaIndex));

  void changeMediaIndex(int newIndex) {
    print('Emit Index: $newIndex');
    emit(state.copyWith(curentMediaIndex: newIndex));
    return;
  }
}
