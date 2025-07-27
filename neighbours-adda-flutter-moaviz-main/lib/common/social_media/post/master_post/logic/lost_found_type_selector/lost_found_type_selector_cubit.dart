// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/lost_found_post_model.dart';

part 'lost_found_type_selector_state.dart';

class LostFoundTypeSelectorCubit extends Cubit<LostFoundTypeSelectorState> {
  final LostFoundType preSelectedType;

  LostFoundTypeSelectorCubit(this.preSelectedType)
      : super(LostFoundTypeSelectorState(preSelectedType));

  void switchType(LostFoundType selectedType) {
    emit(state.copyWith(lostFoundType: selectedType));
  }
}
