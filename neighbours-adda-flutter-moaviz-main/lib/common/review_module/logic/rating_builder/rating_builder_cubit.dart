import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rating_builder_state.dart';

class RatingBuilderCubit extends Cubit<RatingBuilderState> {
  RatingBuilderCubit() : super(const RatingBuilderState());

  void giveRating(double givenRating) {
    emit(state.copyWith(givenRating: givenRating));
  }

  void resetRating() {
    emit(state.copyWith(givenRating: 0));
  }
}
