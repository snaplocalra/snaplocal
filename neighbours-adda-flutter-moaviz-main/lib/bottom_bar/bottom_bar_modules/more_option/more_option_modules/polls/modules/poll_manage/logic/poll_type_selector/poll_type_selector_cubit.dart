// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'poll_type_selector_state.dart';

class PollTypeSelectorCubit extends Cubit<PollTypeSelectorState> {
  final PollTypeEnum preSelectedType;

  PollTypeSelectorCubit(this.preSelectedType)
      : super(PollTypeSelectorState(preSelectedType));

  void switchType(PollTypeEnum selectedType) {
    emit(state.copyWith(selectedType: selectedType));
  }
}
