import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/helpline_numbers/model/helpline_number_model.dart';
import 'package:snap_local/common/utils/helpline_numbers/repository/help_line_number_repository.dart';

part 'helpline_controller_state.dart';

class HelplineControllerCubit extends Cubit<HelplineControllerState> {
  final HelpLineNumberRepository _helpLineNumberRepository;
  HelplineControllerCubit(this._helpLineNumberRepository)
      : super(HelplineControllerInitial());

  Future<void> getHelplineNumbers() async {
    try {
      emit(HelplineControllerLoading());
      final helplineNumbers =
          await _helpLineNumberRepository.fetchHelplineNumbers();
      emit(HelplineControllerLoaded(helplineNumbers));
    } catch (e) {
      emit(HelplineControllerError(e.toString()));
    }
  }
}
