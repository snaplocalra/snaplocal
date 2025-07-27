import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/profile/gender/model/gender_enum.dart';

part 'gender_selector_state.dart';

class GenderSelectorCubit extends Cubit<GenderSelectorState> {
  GenderSelectorCubit() : super(const GenderSelectorState(GenderEnum.none));

  void selectGender(GenderEnum selectedGender) {
    emit(state.copyWith(gender: selectedGender));
  }
}
