// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

part 'poll_location_type_selector_state.dart';

class PollLocationTypeSelectorCubit extends Cubit<PollLocationTypeSelectorState> {
  final PollLocationTypeEnum preSelectedType;

  PollLocationTypeSelectorCubit(this.preSelectedType)
      : super(PollLocationTypeSelectorState(preSelectedType));

  void switchType(PollLocationTypeEnum selectedLocationType) {
    emit(state.copyWith(selectedLocationType: selectedLocationType));
  }
}
